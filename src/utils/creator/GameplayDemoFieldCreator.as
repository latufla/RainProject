/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/8/12
 * Time: 3:47 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.creator {
import common.controller.FieldController;
import common.model.FieldObject;

import flash.geom.Point;

public class GameplayDemoFieldCreator {

    private static const GRID:Array = [
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
    ];

    private static const OBJECTS:Array = [
        {type: FieldObject.BORDER_TYPE, x:8, y:4, w:1, l:1, h:1, target:{priority:2, bots_type:"def", bots_count:15}},
        {type: FieldObject.BORDER_TYPE, x:7, y:9, w:1, l:1, h:1, target:{x:7, y:10, priority:3, bots_type:"def", bots_count:10}},
        {type: FieldObject.MAJOR_TYPE, x:10, y:3, w:3, l:1, h:2, target:{priority:1, bots_type:"def", bots_count:15}},
        {type: "civilean", x:11, y:9, w:2, l:1, h:2, spawn:{bots_type:"def", bots_count:5}},
        {type: "civilean", x:6, y:12, w:1, l:2, h:2, spawn:{bots_type:"def", bots_count:5}},
        {type: "civilean", x:2, y:13, w:1, l:1, h:2, spawn:{bots_type:"def", bots_count:5}},
    ]

    private static const PASSIVE_OBJECTS:Array = [
    //    {x:19, y:28, w:1, l:1, h:3, t:true, tp:2},
    ]

    public function GameplayDemoFieldCreator() {
    }

    public static function create():FieldController{
        var field_c:FieldController = new FieldController();
        field_c.create_grid(grid.length, grid[i].length);
//
//        field_c.create_grid(20, 20);
//
        for (var i:int = 0; i < grid.length; i++) {
            for (var j:int = 0; j < grid[i].length; j++) {
                switch (grid[i][j]){
                    case 0:
                        field_c.grid.get_tile(j, i).is_reachable = false;
                        break;
                    case 2:
                        field_c.grid.get_tile(j, i).is_target = true;
                    default:
                    // do nothing
                }
            }
        }
//
//        FieldUtils.debug_generate_random_buildings(field_c);

        var pnt:Point;
        for each (var p:Object in objects){
            var b:FieldObject = new FieldObject(p.w, p.l, p.h);
            b.type = p.type;
            b.move_to(p.x, p.y);

            if(p.spawn){
                b.create_spawn_point(p.spawn.bots_type, p.spawn.bots_count);
            }
            else if(p.target){
                pnt = p.target.x ? new Point(p.target.x, p.target.y) : null;
                b.create_target_point(pnt, p.target.priority, p.target.bots_type, p.target.bots_count);
            }

            field_c.add_building(b);
            pnt = null;
        }

        for each (var p:Object in passive_objects){
            var b:FieldObject = new FieldObject(p.w, p.l, p.h);
            b.move_to(p.x, p.y);
            field_c.add_building(b);
        }

        return field_c;
    }


    protected static function get grid():Array{
        return GRID;
    }

    protected static function get objects():Array{
        return OBJECTS;
    }

    protected static function get passive_objects():Array{
        return PASSIVE_OBJECTS;
    }
}
}
