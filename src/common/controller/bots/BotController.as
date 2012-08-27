/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/10/12
 * Time: 4:14 PM
 * To change this template use File | Settings | File Templates.
 */
package common.controller.bots {
import common.controller.*;
import com.greensock.TimelineLite;
import com.greensock.TweenLite;
import com.greensock.easing.Linear;

import common.model.Bot;
import common.model.FieldObject;
import common.model.IsoGrid;
import common.model.IsoTile;
import common.model.ObjectBase;
import common.view.BotView;

import flash.display.BitmapData;
import flash.display.Sprite;

import flash.geom.Point;
import flash.geom.Rectangle;

import utils.iso.IsoMathUtil;

public class BotController extends ControllerBase{

    protected var _object:Bot;
    protected var _view:BotView = new BotView();

    // moving
    private var _moving_queue:TimelineLite = new TimelineLite();

    public function BotController() {
        super();
    }

    override public function draw(bd:BitmapData, service_bd:BitmapData = null, update_only:Boolean = false, x_offset:Number = 0):void{
        if(!_object)
            throw new Error("FieldObjectController -> draw(): object is null");

        if(!update_only || !_view.bd){
            _view.object = _object;
            _view.draw();
        }

        update_position();
        bd.copyPixels(_view.bd,
                new Rectangle(0, 0, int(_view.bd.width), int(_view.bd.height)),
                new Point(int(_view.x + x_offset), int(_view.y)), null, null, true );
    }

    private function update_position():void{
        var pnt:Point = IsoMathUtil.isoToScreen(_object.x_px, _object.y_px);
        _view.x = pnt.x;
        _view.y = pnt.y;
    }

    override public function get view():Sprite{
        return _view;
    }

    override public function get object():ObjectBase{
        return _object;
    }

    override public function set object(value:ObjectBase):void {
        _object = value as Bot;
        apply_params_to_grid();
    }

    public function move_to(end:IsoTile, single_resorter:Function):void{
        clear_moving_queue();

        var path:Array = _object.find_path(end);
        path.shift();

        fill_moving_queue(path, single_resorter);
        start_moving_queue()
    }

    public function move_to_target(single_resorter:Function = null){
        var target:IsoTile = _object.next_target;
        if(target)
            move_to(target, single_resorter);
    }

    // procedurin` wrapper
    private function clear_moving_queue():void {
        _moving_queue.stop();
        _moving_queue.clear();
        _moving_queue.restart();
    }

    private function start_moving_queue():void{
        _moving_queue.play();
    }

    private var _speed:Number = 2;
    private function fill_moving_queue(path:Array, on_complete_resort:Function):void{
        var p:IsoTile;
        var time_for_one_step:Number;
        var step:Object;
        for (var i:int = 0; i < path.length; i++) {
            p = path[i];
            if(i == 0){
                time_for_one_step = _speed * (Math.abs(p.x_px -_object.x_px) / FieldController.TILE_WIDTH
                        + Math.abs(p.y_px - _object.y_px) / FieldController.TILE_LENGTH) / 2;
            }
            else{
                time_for_one_step = _speed / 2;
            }

            step = {x_px:p.x_px, y_px:p.y_px, ease:Linear.easeNone, onComplete: on_complete_step};
            _moving_queue.append(new TweenLite(_object, time_for_one_step, step));
        }

        var grid:IsoGrid;
        var tile:IsoTile;
        var self:BotController = this;
        function on_complete_step():void{
            grid = Config.field_c.grid;
            tile = grid.get_tile(_object.x, _object.y);
            tile.remove_object(self);

            _object.move_to_px(_object.x_px, _object.y_px); // tweening via

            tile = grid.get_tile(_object.x, _object.y);
            tile.add_object(self);

            if(tile == path[path.length - 1])
                Config.field_c.process_refresh_target_points();
        }
    }

    override public function apply_params_to_grid():void{
        var grid:IsoGrid = Config.field_c.grid;
        var t:IsoTile = grid.get_tile(object.x, object.y);
        t.add_object(this);
    }

}
}
