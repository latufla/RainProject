/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/26/12
 * Time: 1:22 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.creator {
import common.controller.FieldController;
import common.model.FieldObject;

import flash.geom.Point;

public class NMDemoFieldCreator {
    private static const GRID:Array = [
       //0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
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
//        {type: FieldObject.BORDER_TYPE, x:8, y:4, w:1, l:1, h:1, target:{priority:2, bots_type:"def", bots_count:15}},
//        {type: FieldObject.BORDER_TYPE, x:7, y:9, w:1, l:1, h:1, target:{x:7, y:10, priority:3, bots_type:"def", bots_count:10}},
        {type: FieldObject.OFFENCIVE_TYPE, x:9, y:3, w:2, l:1, h:2, attack_radius: 3, target:{x:8, y:4, priority:9999, bots_type:"def", bots_count:3}, spawn:{bots_type:"def", bots_count:1}},
        {type: FieldObject.MAJOR_TYPE, x:12, y:3, w:2, l:1, h:2, target:{priority: 1, bots_type:"def", bots_count:15}},
        {type: FieldObject.CIVILEAN_TYPE, x:11, y:9, w:2, l:1, h:2, spawn:{bots_type:"def", bots_count:5}},
//        {type: FieldObject.CIVILEAN_TYPE, x:6, y:12, w:1, l:2, h:2, spawn:{bots_type:"def", bots_count:5}},
//        {type: FieldObject.CIVILEAN_TYPE, x:2, y:13, w:1, l:1, h:2, spawn:{bots_type:"def", bots_count:5}},
    ]

    public function NMDemoFieldCreator() {

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
            b.attack_radius = p.attack_radius;
            b.move_to(p.x, p.y);

            if(p.spawn){
                b.create_spawn_point(p.spawn.bots_type, p.spawn.bots_count);
            }

            if(p.target){
                pnt = p.target.x ? new Point(p.target.x, p.target.y) : null;
                b.create_target_point(pnt, p.target.priority, p.target.bots_type, p.target.bots_count);
            }

            field_c.add_building(b);
            pnt = null;
        }

        return field_c;
    }


    protected static function get grid():Array{
        return GRID;
    }

    protected static function get objects():Array{
        return OBJECTS;
    }
}

}
