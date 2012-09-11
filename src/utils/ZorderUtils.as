package utils {
import common.controller.ControllerBase;
import common.controller.FieldController;
import common.controller.FieldObjectController;
import common.model.grid.IsoGrid;
import common.model.grid.IsoTile;
import common.model.ObjectBase;

import flash.utils.getTimer;

public class ZorderUtils {

    public static function custom_zorder(list:Array):Array{
//        var start_time:Number = getTimer();
        var res:Array = list.sort(function(a_c:*, b_c:*):int{
            var i:int = tile_object_compare(a_c, b_c);
            trace("---step---");
            trace("a:", a_c.object.x, a_c.object.y, "|", a_c.object.id, "vs", "b:", b_c.object.x, b_c.object.y, "|", b_c.object.id, "=", i);
            return i;
        })
//        trace("custom_zorder end. Elapsed: ", getTimer() - start_time);
        return res;
    }

    public static function tile_object_compare(a_c:*, b_c:*):int{
        var a:ObjectBase = a_c.object;
        var b:ObjectBase = b_c.object;

//        determine same tile objects
//        if(a.x == b.x && a.y == b.y){
//            if(a.id < b.id)
//                return 1;
//            else
//                return -1;
//        }

        if (a.right <= b.left)
            return -1;
        else if (a.left >= b.right)
            return 1;
        else if (a.front <= b.back)
            return -1;
        else if (a.back >= b.front)
            return 1;

        return 0;
//        determine same tile objects

//
//        if(a.x > b.x && a.bottomDiagonalId >= b.topDiagonalId)
//            return 1;
//
//        if(a.y >= b.y + b.length && a.topDiagonalId > b.bottomDiagonalId)
//            return 1;
//
//        return -1;
    }

//    public static function tile_object_compare(a:ObjectBase, b:ObjectBase):int{
//        if(a.x > b.x && a.bottomDiagonalId >= b.topDiagonalId)
//            return 1;
//
//        if(a.y + a.length <= b.y && a.topDiagonalId > b.bottomDiagonalId)
//            return 1;
//
//        return -1;
//    }

    public static function bin_insert_resort_single_object(obj_c:*, a:Vector.<ControllerBase>):int{
        if(a.length == 0 || tile_object_compare(a[0], obj_c) != -1){
            a.unshift(obj_c);
            return 0;
        }

        if(tile_object_compare(a[a.length - 1], obj_c) == -1){
            a.push(obj_c);
            return a.length - 1;
        }

        var idx:int = ArrayUtils.get_insert_index_in_sorted(a, obj_c, tile_object_compare);
        a.splice(idx, 0, obj_c);
        return idx;
    }

    public static function get_vertical(grid:IsoGrid, id:uint):Vector.<IsoTile>{
//        if(id >= grid.tiles.length)
//            return null;

        return grid.tiles[id];
    }

    // walk through verticals
    public static function z_sort_multi(grid:IsoGrid):Vector.<ControllerBase>{
        var res:Vector.<ControllerBase> = new Vector.<ControllerBase>();

        // traverse
        var cur_elems:Vector.<ControllerBase>;
        var cur_vert:Vector.<IsoTile>;
        var idx_last_traversed:int;
        var already_traversed_in_vertical:Vector.<ControllerBase> = new Vector.<ControllerBase>();
        var n:uint = grid.tiles.length;
        for (var i:int = 0; i < n; i++) {
            already_traversed_in_vertical.length = 0;
            cur_vert = get_vertical(grid, i);
            for (var j:int = cur_vert.length - 1; j >= 0; j--) {
                cur_elems = cur_vert[j].objects;
                if(cur_elems.length == 0)
                    continue;

                    // not in res, then insert it before last traversed
                var l:uint = cur_elems.length - 1;
                if(!cur_elems[0].static_zordered){
                    for(var k:int = 0; k <= l; k++){
                        if(already_traversed_in_vertical.length == 0)
                            res.push(cur_elems[k]);
                        else
                            res.splice(idx_last_traversed++, 0, cur_elems[k]);
                    }
                }

                cur_elems[0].static_zordered = true;
                already_traversed_in_vertical.push(cur_elems[0]);
                idx_last_traversed = res.indexOf(cur_elems[0]);
            }
        }

        // clear flags
        for each (var p:ControllerBase in res){
            p.static_zordered = false;
        }

        return res;
    }
}
}
