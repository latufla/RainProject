/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 4:35 PM
 * To change this template use File | Settings | File Templates.
 */
package common.controller {
import common.controller.bots.BotController;
import common.controller.constructions.BorderConstructionController;
import common.controller.constructions.MajorConstructionController;
import common.model.Bot;
import common.model.FieldObject;
import common.model.IsoGrid;
import common.model.IsoTile;
import common.model.ObjectBase;
import common.model.TargetPoint;
import common.view.IsoGridView;
import common.view.window.DialogWindow;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.utils.setTimeout;

import tr.Tr;

import utils.ClassHelper;
import utils.creator.BotControllerCreator;

import utils.creator.ConstructionControllerCreator;

import utils.DoubleBuffer;

import utils.ZorderUtils;
import utils.iso.IsoMathUtil;
import utils.ui.CustomMouse;

public class FieldController {
    public static const TILE_WIDTH:uint = Config.TILE_WIDTH;
    public static const TILE_LENGTH:uint = Config.TILE_LENGTH;

    private var _grid:IsoGrid;
    private var _grid_view:IsoGridView = new IsoGridView();

    private var _all_objects:Vector.<ControllerBase> = new Vector.<ControllerBase>();
    private var _objects_view:Sprite = new Sprite(); // constructions and bots

    private var _buildings:Vector.<FieldObjectController> = new Vector.<FieldObjectController>();
    private var _bots:Vector.<BotController> = new Vector.<BotController>();

    private var _service_view:Sprite = new Sprite(); // attack radius etc.

    private var _view:Sprite = new Sprite();
    private var _d_buffer:DoubleBuffer = new DoubleBuffer(1280, 768);

    private var _redraw_grid:Boolean = false;

    public function FieldController() {
        init();
    }

    // TODO: finish before use
    public function destroy(){
        stop_draw();
        remove_listeners();
    }

    private function init():void {
        Config.field_c = this;

        add_listeners();
        _view.addChild(_grid_view);
        _view.addChild(_service_view);
        _view.addChild(_objects_view);
    }

    private function add_listeners():void{
        _view.addEventListener(MouseEvent.CLICK, on_click);
//        _view.addEventListener(MouseEvent.MOUSE_OVER, on_mouse_over);
//        _view.addEventListener(MouseEvent.MOUSE_OUT, on_mouse_out);
        _view.addEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
    }

    private function remove_listeners():void{
        _view.removeEventListener(MouseEvent.CLICK, on_click);
//        _view.removeEventListener(MouseEvent.MOUSE_OVER, on_mouse_over);
//        _view.removeEventListener(MouseEvent.MOUSE_OUT, on_mouse_out);
//        _view.removeEventListener(MouseEvent.MOUSE_MOVE, on_mouse_move);
//
    }

    // GRID
    public function create_grid(w:uint, h:uint):void{
        _grid = new IsoGrid(w, h);
        _grid.create();
        _grid_view.grid = _grid;
    }

    public function add_building(b:FieldObject):Boolean{
        if(!can_add(b))
            return false;

        var b_c:FieldObjectController = ConstructionControllerCreator.create(b);
        b_c.object = b;
        b_c.apply_params_to_grid();

        _buildings.push(b_c);
        _all_objects.push(b_c);
        return true;
    }

    public function remove_building_controller(b_c:FieldObjectController):void{
        var idx:int = _all_objects.indexOf(b_c);
        if(idx != -1)
            _all_objects.splice(idx,  1)

        idx = _buildings.indexOf(b_c);
        if(idx != -1)
            _buildings.splice(idx,  1)

        b_c.remove_params_from_grid();
    }

    // fuck zero here
    private function is_out(o:ObjectBase):Boolean{
        return o.x + o.width > field_width || o.y + o.length > field_length;
    }

    private function can_add(o:ObjectBase):Boolean{
        if(is_out(o))
            return false;

        for each(var p:FieldObjectController in _buildings){
            if(p.object.intersects(o))
                return false;
        }

        return true;
    }

    public function add_bot(b:Bot):Boolean{
        // check if out of borders
        if(!can_add(b))
            return false;

        var b_c:BotController = BotControllerCreator.create(b);
        b_c.object = b;
        b_c.move_to_target();

        _bots.push(b_c);
        _all_objects.push(b_c);

        return true;
    }

    // RENDER
    public function draw():void{
        _redraw_grid = true;
        _view.addEventListener(Event.ENTER_FRAME, on_ef_render);
    }

    private function on_ef_render(e:Event):void {
        if(_redraw_grid)
            draw_grid();

        _all_objects = z_sort();

        _d_buffer.refresh();
        draw_all_objects(_d_buffer, true);
        _d_buffer.draw(_objects_view);
    }

    public function stop_draw():void{
        _view.removeEventListener(Event.ENTER_FRAME, on_ef_render);
    }

    // sort
    private function z_sort():Vector.<ControllerBase>{
        return ZorderUtils.z_sort_multi(_grid);
    }

    public function draw_grid():void{
        _grid_view.draw();
        _redraw_grid = false;
        _grid_view.visible = Config.SHOW_GRID;
    }

    public function draw_all_objects(d_buffer:DoubleBuffer, update_only:Boolean = false):void{
        for each(var p:ControllerBase in _all_objects){
            p.draw(d_buffer.bd, null, update_only, _grid_view.offset.x);
        }
    }
    //RENDER END

    // PROCESS MOUSE EVENTS
    private function on_click(e:MouseEvent):void {
//       process_grid_click(e)
        process_building_click(e);
        //process_bot_click(e);
    }

    private function on_mouse_move(e:MouseEvent):void {
        var mouse:CustomMouse = CustomMouse.instance;
        mouse.x = e.localX - _grid_view.offset.x;
        mouse.y = e.localY;

        var c:FieldObjectController = get_building_by_coords_px(mouse.position);
        var last_obj:FieldObjectController = mouse.last_object_over;

        // если над пустым полем и был над пустым
        if (!c && !last_obj){
            mouse.last_object_over = c;
            return;
        }

        // если был над пустым полем, а стал над объектом
        if(!last_obj && c){
            process_mouse_over_object(c);
        }else if(last_obj && !c){ // был над объектом, стал над пустым полем
            process_mouse_out_object(last_obj);
        }else if(last_obj != c) { //,был над одним объектом, стал над другим
            process_mouse_out_object(last_obj);
            process_mouse_over_object(c);
        }

        mouse.last_object_over = c;
    }

    private function process_mouse_over_object(c:FieldObjectController):void{
        c.process_mouse_over();
        CustomMouse.instance.cursor = MouseCursor.BUTTON;
    }

    private function process_mouse_out_object(c:FieldObjectController):void{
        c.process_mouse_out();
        CustomMouse.instance.cursor = MouseCursor.BUTTON;
    }

    private function process_building_click(e:MouseEvent):void {
        var mouse:CustomMouse = CustomMouse.instance;
        mouse.x = e.localX - _grid_view.offset.x;
        mouse.y = e.localY;

        var c:FieldObjectController = get_building_by_coords_px(mouse.position);
        if(c)
            c.process_click();
    }

    private function get_building_by_coords_px(pnt:Point):FieldObjectController{
        var objs:Vector.<ControllerBase> = _all_objects.filter(function (item:ControllerBase, index:int, vector:Vector.<ControllerBase>):Boolean{
            return item is FieldObjectController;
        });
        objs.reverse();

        for each(var p:FieldObjectController in objs){
            if(p && p.contains_px(pnt))
                return p;
        }
        return null;
    }

    private function process_grid_click(e:MouseEvent):void {
        var coords:Point = IsoMathUtil.screenToIso(e.localX - _grid_view.offset.x, e.localY);  // TODO: resolve 748
        var tiles:Array = _grid.get_tiles_in_square(coords.x / TILE_WIDTH, coords.y / TILE_LENGTH, 1, 1);
        for each(var p:IsoTile in tiles){
            p.is_reachable = !p.is_reachable;
        }
        _redraw_grid = true;
    }
    // END PROCESS MOUSE EVENTS

    // PROCESS GAMEPLAY ACTIONS
    // --
    public function process_target_complete(b_c:FieldObjectController):void {
        switch(ClassHelper.class_from_instance(b_c)){
            case MajorConstructionController:
                process_level_complete();
                return;
            case BorderConstructionController:
                remove_building_controller(b_c);
                break;
            default:
                // do nothing
        }

        find_path_for_bots((b_c.object as FieldObject).target_point);
    }

    private function find_path_for_bots(last_target:TargetPoint):void {
        if(!last_target)
            return;

        var delay_bots:Vector.<ControllerBase> = last_target.tile.bots;
        var bot_c:BotController;
        var n:uint = _bots.length;
        for (var i:uint = 0; i < n; i++) {
            bot_c = _bots[i];
            if(delay_bots.indexOf(bot_c) != -1)
                setTimeout(bot_c.move_to_target, 1000 * i);
            else
                bot_c.move_to_target();
        }
    }

    //--
    public function process_refresh_target_points():void{
        for each(var p:TargetPoint in all_active_target_points){
            p.refresh();
            if(p.goal_completed)
                Config.scene_c.remove_window(p, true);
            else
                Config.scene_c.refresh_window(p, {text: p.description});
        }
    }

    //--
    private function process_level_complete():void {
        Config.scene_c.show_window(DialogWindow, DialogWindow.KEY, {x:500, y:200, text:Tr.level_completed});
    }

    // END PROCESS GAMEPLAY ACTIONS

    // GETTERS/SETTERS
    public function set redraw_grid(value:Boolean):void {
        _redraw_grid = value;
    }

    public function get grid_view():IsoGridView {
        return _grid_view;
    }
    public function get view():Sprite {
        return _view;
    }

    public function get grid():IsoGrid{
        return _grid;
    }

    // field width is same to grid width
    public function get field_width():uint{
        if(!_grid)
            return 0;

        return _grid.width;
    }

    public function get field_length():uint{
        if(!_grid)
            return 0;

        return _grid.length;
    }

    public function get buildings():Vector.<FieldObjectController> {
        return _buildings;
    }

    public function get target_points():Array{
        var res:Array = [];
        var b:FieldObject;
        for each(var b_c:FieldObjectController in _buildings){
            b = b_c.object as FieldObject;
            if(b && b.target_point)
                res.push(b.target_point)
        }
        res.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
        return res;
    }

    public function get_active_target_points_for(bot_type:String = Bot.SIMPLE_ZOMBIE):Array{
        return target_points.filter(function(item:TargetPoint, index:int, array:Array):Boolean{ return !item.goal_completed
                && item.bots_type == bot_type; });
    }

    public function get all_active_target_points():Array{
        return target_points.filter(function(item:TargetPoint, index:int, array:Array):Boolean{ return !item.goal_completed});
    }

    public function get service_view():Sprite {
        return _service_view;
    }
}
}
