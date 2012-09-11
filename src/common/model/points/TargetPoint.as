/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/28/12
 * Time: 8:51 PM
 * To change this template use File | Settings | File Templates.
 */
package common.model.points {
import common.model.*;
import common.controller.ControllerBase;
import common.event.GameEvent;
import common.model.grid.IsoTile;

import flash.events.EventDispatcher;

public class TargetPoint extends ActivePointBase{

    private var _priority:int = -1; // -1 is inactive

    private var _bots_type:String;
    private var _goal:Goal = new Goal();

    public function TargetPoint(x:uint, y:uint, bots_type:String = "simple_zombie", goal_type:String = "simple_zombie", goal_count:uint = 5) {
        super(x, y);
        _bots_type  = bots_type;

        _goal.type = goal_type;
        _goal.count = goal_count;
    }

    override public function apply_params_to_grid():void{
        var t:IsoTile = tile;
        if(t){
            t.is_target = true;
            Config.field_c.redraw_grid = true;
        }
    }

    override public function remove_params_from_grid():void{
        var t:IsoTile = tile;
        if(t){
            t.is_target = false;
            Config.field_c.redraw_grid = true;
        }
    }

    public function refresh():void {
        var t:IsoTile = tile;
        if(!t)
            return;

        var bots:Vector.<ControllerBase> = t.bots;
        bots = bots.filter(function(item:ControllerBase, index:int, v:Vector.<ControllerBase>):Boolean{ return item.object.type == _goal.type});
        if (bots.length >= _goal.count){
            _goal.completed = true;
            remove_params_from_grid();
            dispatchEvent(new GameEvent(GameEvent.COMPLETE_TARGET, {object:this}));
        }
    }

    public function get goal_completed():Boolean{
        return _goal.completed;
    }

    public function get tile():IsoTile{
        return Config.field_c.grid.get_tile(_x, _y);
    }

    public function get priority():int {
        return _priority;
    }

    public function set priority(value:int):void {
        _priority = value;
    }

    public function get description():String{
        return "" + tile.bots.length + "/" + _goal.count;
    }

    public function get bots_type():String {
        return _bots_type;
    }

    public function set bots_type(value:String):void {
        _bots_type = value;
    }
}
}
