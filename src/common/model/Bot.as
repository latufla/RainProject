/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/10/12
 * Time: 12:53 PM
 * To change this template use File | Settings | File Templates.
 */
package common.model {
import common.controller.FieldController;

import utils.PathfindUtils;

public class Bot extends ObjectBase{

    public static const SIMPLE_TYPE:int = 1;
    public static const SIMPLE_ZOMBIE = "simple_zombie";
    public static const OFFENCIVE_ZOMBIE = "offencive_zombie";

    protected var _path:Array = [];
    protected var _target:IsoTile;

    public function Bot(type:String = Bot.SIMPLE_ZOMBIE) {
        super();

        _type = type;
        _is_reachable = true;
        _debug_height = 1;
    }

    public function find_path(end:IsoTile):Array{
        var grid:IsoGrid = Config.field_c.grid;
        grid.clear_p_nodes();

        _path = PathfindUtils.a_star_find_path(position_tile, end, grid.get_four_connected_p_nodes);
        return _path;
    }

    public function find_path_to_next_target():Array{
        return find_path(next_target);
    }

    public function get position_tile():IsoTile{
        return Config.field_c.grid.get_tile(x, y);
    }

    public function get next_target():IsoTile{
        var field_c:FieldController = Config.field_c;
        var target_points:Array = field_c.get_active_target_points_for(_type);
        if(target_points.length == 0)
            return null;

        var target_point:TargetPoint = target_points[0];
        var tile:IsoTile = field_c.grid.get_tile(target_point.x, target_point.y);
        return tile;
    }

}
}
