package utils.net {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.system.ApplicationDomain;
import flash.utils.Timer;

import utils.download.DownloadEvent;

public class CachedMovie
{

    public function CachedMovie(
            movie_path:String,
            on_movie_present:Function,
            on_movie_loaded:Function,
            on_movie_started_loading:Function,
            get_url:Function,
            class_name:String = null
    ){
        reinit(movie_path,
               on_movie_present,
               on_movie_loaded,
               on_movie_started_loading,
               get_url,
               class_name);
    }

    public function reinit(movie_path:String,
            on_movie_present:Function,
            on_movie_loaded:Function,
            on_movie_started_loading:Function,
            get_url:Function,
            class_name:String):void
    {
        _movie_path = movie_path;
        _on_movie_present = on_movie_present;
        _on_movie_loaded = on_movie_loaded;
        _on_movie_started_loading = on_movie_started_loading;
        _get_url = get_url;
        _downloader = new Config.gamefeed_transport();
        if (class_name != null)
            _class_name = class_name;
    }

    // swf или png для отрисовки элемента
    protected var _movie:MovieClip = null;
    protected var _movie_path:String;

    protected var _on_movie_present:Function;
    protected var _on_movie_loaded:Function;
    private var _on_movie_started_loading:Function;
    private var _get_url:Function;

    protected var _class_name:String = 'ExternalMovie';

    protected static var _movie_classes:Hash = new Hash;

    // загрузка картинки с фоном
    private var _url_loading:String = "";
    private var _downloader:Download;

    //timers for movie loading. one timer for each movie_path
    static private var _movie_timers:Object = new Object;

    public function get movie():MovieClip{
        if(_movie) _movie.stop();
        return _movie;
    }

      public function set movie(m:MovieClip):void{
        _movie = m;
    }

    public function destroy():void {
        remove_movie();
    }

    public function stop():void{
        if(!StringHelper.is_empty(_movie_path))
            remove_movie_load_timer(_movie_path);
        try{
            if(_movie_classes[_movie_path] is LoaderInfo){
                _movie_classes[_movie_path].removeEventListener(Event.COMPLETE, on_movie_complete);
                _movie_classes[_movie_path].removeEventListener(IOErrorEvent.IO_ERROR, on_movie_error);
            }
        }
        catch(e:Error){}
    }

    private function on_movie_load_timer_elapsed_reload(e:TimerEvent):void {
        load();
    }

    //set a timer for reloading a movie by movie_path
    //if the timer exists it is replaced
    //if the timer exists it is replaced
    private function set_movie_load_timer(movie_path:String):void {
        remove_movie_load_timer(movie_path);
        var t:Timer = new Timer(12000);
        _movie_timers[movie_path] = t;
        t.addEventListener(TimerEvent.TIMER, on_movie_load_timer_elapsed_reload);
        t.start();
    }

    //add on_movie_load_timer_elapsed_reload as the movie_path's timer event listener
    //if there is no such timer and  create_if_absent is true, acts as set_movie_load_timer
    private function join_movie_load_timer(movie_path:String, create_if_absent:Boolean = true):Boolean {
        var t:Timer = _movie_timers[movie_path];
        var retval:Boolean = false;
        if (t) {
            t.addEventListener(TimerEvent.TIMER, on_movie_load_timer_elapsed_reload);
            retval = true;
        }
        else if (create_if_absent) set_movie_load_timer(movie_path);
        return retval;
    }

    //remove a movie timer for movie_path
    private function remove_movie_load_timer(movie_path:String):void {
        var t:Timer = _movie_timers[movie_path];
        if (t)
            t.stop();
        _movie_timers[movie_path] = null;
    }

    public function load():void
    {
        if (_movie_path == null) {
            tr(W, "Movie path is null");
            return;
        }

        if (loading_object_present) {
            on_loading_object_present();
            reset_retry_counter(_movie_path);
            return;
        }

        if (!_movie_path) {
            return;
        }

        if (_on_movie_started_loading != null) {
            _on_movie_started_loading();
        }
        
        join_movie_load_timer(_movie_path, false);
        if (_movie_classes[_movie_path] is LoaderInfo){
            _movie_classes[_movie_path].addEventListener(Event.COMPLETE, on_movie_complete);
            _movie_classes[_movie_path].addEventListener(IOErrorEvent.IO_ERROR, on_movie_error_local);
            return;
        }

        if (is_object_already_loaded){
            add_loading_object();
            return;
        }

        function on_movie_error_local(error_event:Event):void {
            trace("===load error", this, _url_loading);
            abort_loading();
            if (_on_movie_started_loading != null) {
                _on_movie_started_loading();
            }

            if (get_retry_counter(_movie_path) < URL_LOAD_RETRIES) {
                //trace("===load error: retrying,", this, _reload_timer_count, error_event);
                if (error_event) {    //there actually was an error, so we wait before retrying
                    if (!join_movie_load_timer(_movie_path, true)) {
                        increase_retry_counter(_movie_path);
                    }
                }
                else {
                    load();      //no error (timeout or something like that), reload immediately
                }
            }
        }

        var url:String = _get_url(_movie_path);
//        downloader.init(url, on_movie_complete, on_movie_error, on_movie_progress);
        _downloader.init(url, on_movie_complete, on_movie_error_local, on_movie_progress); // fix 'Error #2044: Необработанный IOErrorEvent:. text=Error #2036: Загрузка не завершена'
        _downloader.addEventListener(DownloadEvent.LOAD_ABORTED, on_load_aborted);
        _movie_classes[_movie_path] = downloader.loader.contentLoaderInfo;

        _url_loading = url;
        _downloader.start();
    }

    private function on_load_aborted(event:DownloadEvent):void {
        delete _movie_classes[_movie_path];
    }

    protected function get loading_object_present():Boolean {
        return _movie != null;
    }

    protected function on_loading_object_present():void {
        if (_on_movie_present != null) {
            _on_movie_present(_movie);
        }
    }

    protected function get is_object_already_loaded():Boolean {
        return _movie_classes[_movie_path] is ApplicationDomain;
    }

    protected function add_loading_object():void {
        add_movie(get_class(_class_name));
    }

    // установка загруженной картинки на экран
    protected function add_movie(MovieClass:Class):void
    {
        //trace("addMovie", MovieClass,_movie_path)
        _movie = new MovieClass();
        (_movie as MovieClip).stop();
        if (_on_movie_loaded != null) {
            _on_movie_loaded(_movie);
        }
        reset_retry_counter(_movie_path);
    }

     // удаление загруженной картинки с экран
    private function remove_movie():void
    {
        if (_movie){
            //set_user_events(_movie,false);
            if (_movie.parent) {
                _movie.parent.removeChild(_movie);
            }
            _movie = null;
        }
    }


    public function on_movie_complete(load_event:Event):void
    {
        if(load_event.target.content is DisplayObjectContainer || load_event.target.content is DisplayObject) {
            //trace("Stopping movie in cached movie ");
            MovieClipHelper.stop_all(load_event.target.content);
        }
        _movie_classes[_movie_path] = load_event.target.applicationDomain;
        add_loading_object();
    }

    public function on_sync_complete():void
    {
    }

    public function on_movie_progress(progress:ProgressEvent):void
    {
        remove_movie_load_timer(_movie_path);
    }

    private static var _reload_timer_count:Object = new Object;

    private function increase_retry_counter(movie_path:String):void {
        if (!_reload_timer_count[movie_path])
            _reload_timer_count[movie_path] = 1;
        else _reload_timer_count[movie_path] = _reload_timer_count[movie_path] + 1;
    }

    protected function reset_retry_counter(movie_path:String):void {
        _reload_timer_count[movie_path] = null;
    }

    private function get_retry_counter(movie_path:String):int {
        return int(_reload_timer_count[movie_path]);
    }

    private static  const URL_LOAD_RETRIES:int = 8;

    public function on_movie_error(error_event:Event):void {
        //trace("===load error", this, _url_loading);
        abort_loading();
        if (_on_movie_started_loading != null) {
            _on_movie_started_loading();
        }
        
        if (get_retry_counter(_movie_path) < URL_LOAD_RETRIES) {
            //trace("===load error: retrying,", this, _reload_timer_count, error_event);
            if (error_event) {    //there actually was an error, so we wait before retrying
                if (!join_movie_load_timer(_movie_path, true)) {
                    increase_retry_counter(_movie_path);
                }
            }
            else {
                load();      //no error (timeout or something like that), reload immediately
            }
        }
    }

    public function abort_loading():void {
        _downloader.abort_loading();
    }

    public function get_class(class_name:String):Class{
        if(_movie_classes[_movie_path]==null) return null;
        return _movie_classes[_movie_path].getDefinition(class_name);
    }

    public function get downloader():Download
    {
        return _downloader;
    }

}
}