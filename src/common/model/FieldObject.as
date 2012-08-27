/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 11:11 PM
 * To change this template use File | Settings | File Templates.
 */
package common.model {
import common.event.GameEvent;

import flash.geom.Point;

public class FieldObject extends ObjectBase{

    public static const CIVILEAN_TYPE:String = "civilean";
    public static const BORDER_TYPE:String = "border";
    public static const MAJOR_TYPE:String = "major";
    public static const FACTORY_TYPE:String = "factory";
    public static const OFFENCIVE_TYPE:String = "offencive";

    private var _spawn_point:SpawnPoint; // bots spawn
    private var _target_point:TargetPoint; // bots move to

    private var _attack_radius:int; // offencive bot spawns and walks

    private var _produce_count:uint; // number of produce_class instances

    public function FieldObject(w:uint, l:uint, h:uint) {
        super();

        width = w;
        length = l;
        _debug_height = h;
    }

    public function create_spawn_point(bots_type:String = Bot.SIMPLE_ZOMBIE, bots_count:uint = 0):void {
        if(bots_count == 0)
            return;

        var grid:IsoGrid = Config.field_c.grid;
        var nearest_points:Vector.<Point> = get_nearest_points(grid);

        if(nearest_points.length == 0)
            throw new Error("can`t create spawn point");

        var p:Point = nearest_points[0];
        _spawn_point = new SpawnPoint(p.x, p.y);
        _spawn_point.apply_params_to_grid();

        for (var i:uint = 0; i < bots_count; i++){
            _spawn_point.add_bot(new Bot(bots_type));
        }
    }

    public function change_spawn_point_coords(x:uint, y:uint):void{
        _spawn_point.remove_params_from_grid();
        _spawn_point.x = x;
        _spawn_point.y = y;
        _spawn_point.apply_params_to_grid();
    }

    public function create_target_point(pnt:Point = null, priority:int = 1, bots_type:String = Bot.SIMPLE_ZOMBIE, bots_count:uint = 5):void {
        if(bots_count == 0)
            return;

        var grid:IsoGrid = Config.field_c.grid;
        var nearest_points:Vector.<Point> = get_nearest_points(grid);

        if(nearest_points.length == 0)
            throw new Error("can`t create target point");

        var p:Point = pnt ? pnt : nearest_points[0];
        _target_point = new TargetPoint(p.x, p.y, bots_type, bots_count);
        _target_point.priority = priority;
        _target_point.apply_params_to_grid();
        _target_point.addEventListener(GameEvent.COMPLETE_TARGET, on_complete_target);
    }

    public function change_target_point_coords(x:uint, y:uint):void{
        _target_point.remove_params_from_grid();
        _target_point.x = x;
        _target_point.y = y;
        _target_point.apply_params_to_grid();
    }

    private function on_complete_target(e:GameEvent):void {
        dispatchEvent(new GameEvent(GameEvent.COMPLETE_TARGET, {object:e.data.object}));
    }

    public function get target_point():TargetPoint {
        return _target_point;
    }

    public function get spawn_point():SpawnPoint{
        return _spawn_point;
    }

    public function get attack_radius():int {
        return _attack_radius;
    }

    public function set attack_radius(value:int):void {
        _attack_radius = value;
    }
}
}
