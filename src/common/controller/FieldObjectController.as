/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/8/12
 * Time: 11:55 AM
 * To change this template use File | Settings | File Templates.
 */
package common.controller {

import common.event.GameEvent;
import common.model.FieldObject;
import common.model.IsoGrid;
import common.model.IsoTile;
import common.model.ObjectBase;
import common.model.SpawnPoint;
import common.model.TargetPoint;
import common.view.FieldObjectView;
import common.view.window.DialogWindow;
import common.view.window.TargetWindow;

import flash.display.BitmapData;

import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import tr.Tr;

import utils.iso.IsoMathUtil;

public class FieldObjectController extends ControllerBase{

    private var _object:FieldObject;
    private var _view:FieldObjectView = new FieldObjectView();

    public function FieldObjectController() {
        super();
    }

    override public function draw(bd:BitmapData, update_only:Boolean = false, x_offset:Number = 0):void{
        if(!_object)
            throw new Error("FieldObjectController -> draw(): object is null");

        if(!update_only || !_view.bd){
            _view.object = _object;
            _view.draw();
            update_position();
        }

        bd.copyPixels(_view.bd,
                new Rectangle(0, 0, _view.bd.width, _view.bd.height),
                new Point(_view.x + x_offset, _view.y), null, null, true);

        if(should_show_target_window)
            show_target_window();
    }

    private function update_position():void {
        var pnt:Point = IsoMathUtil.isoToScreen(_object.x_px, _object.y_px);
        _view.x = pnt.x;
        _view.y = pnt.y;
    }

    override public function apply_params_to_grid():void{
        var tiles:Array = this.tiles;
        for each(var t:IsoTile in tiles){
            t.is_reachable = object.is_reachable;
            t.add_object(this);
        }
    }

    public function remove_params_from_grid():void{
        var tiles:Array = this.tiles;
        for each(var t:IsoTile in tiles){
            t.is_reachable = true;
            t.remove_object(this);
        }
    }

    private function on_complete_target(e:GameEvent):void {
        Config.field_c.process_target_complete(this);
    }

    public function start_spawn_bots():void{
        var spawn_point:SpawnPoint = _object.spawn_point;
        if(!spawn_point)
            return;

        _can_click = !spawn_point.start_spawn_bots(Config.field_c.add_bot);
    }

    public function stop_spawn_bots():void{
        var spawn_point:SpawnPoint = _object.spawn_point;
        if(!spawn_point)
            return;

        spawn_point.stop_spawn_bots();
        _can_click = true;
    }

    public function contains_px(pnt:Point):Boolean{
        return _view.contains_px(pnt);
    }

    public function process_click(){
        if(!_can_click)
            return;

        if(_object.target_point)
            show_target_window();

        if(_object.spawn_point)
            show_invade_window();
    }

    private function show_target_window():void{
        Config.scene_c.show_window(TargetWindow, _object.target_point, {x:_view.x + Config.scene_c.field_gui_offset.x + 50, y:_view.y, text:_object.target_point.description});
    }

    private function show_invade_window():void{
        Config.scene_c.show_window(DialogWindow, DialogWindow.KEY, {x:_view.x + Config.scene_c.field_gui_offset.x + 50, y:_view.y, text:Tr.invade_building_dialog_window,
            confirm_button:{cb: start_spawn_bots}, cancel_button:{}});
    }

    public function get tiles():Array{
        var grid:IsoGrid = Config.field_c.grid;
        return grid.get_tiles_in_square(object.x, object.y, object.width, object.length);
    }

    override public function get view():Sprite {
        return _view;
    }

    override public function get object():ObjectBase {
        return _object;
    }

    override public function set object(value:ObjectBase):void {
        if(_object)
            _object.removeEventListener(GameEvent.COMPLETE_TARGET, on_complete_target);

        _object = value as FieldObject;

        if(_object.target_point)
            _object.addEventListener(GameEvent.COMPLETE_TARGET, on_complete_target);
    }

    private function get should_show_target_window():Boolean{
        var t_p:TargetPoint = _object.target_point;
        return t_p && !t_p.completed && !Config.scene_c.window_already_shown(t_p);
    }
}
}
