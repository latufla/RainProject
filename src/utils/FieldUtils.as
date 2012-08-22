/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 6/22/12
 * Time: 10:41 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import common.controller.FieldController;
import common.model.FieldObject;

import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.getTimer;

public class FieldUtils {
    public function FieldUtils(){
    }

    private static var _rect1:Rectangle = new Rectangle();
    private static var _rect2:Rectangle = new Rectangle();
    public static function generate_field_with_objects(max_size:uint, field_size:Object, dispertion:Point):Array{
        var time:Number = getTimer();
        var field:Array = [];
        var fld_size:Object = {x:0, y:0, w:field_size.w, h:field_size.h};
        var obj_to_add:Object;

        for (var i:int = 0; i < field_size.w; i += dispertion.x) {
            for (var j:int = 0; j < field_size.h; j += dispertion.y) {
                obj_to_add = {x:i, y:j, w: 1 + int(Math.random() * max_size), h: 1 + int(Math.random() * max_size)}

                var in_field_and_no_intersections:Boolean = (contains(fld_size, obj_to_add) && !contains_intersection_obj(field, obj_to_add));
                if(in_field_and_no_intersections){
                    field.push(obj_to_add);
                }

            }
        }

        trace("generate_field_with_objects: ", getTimer() - time);
        return field;
    }


    public static function contains_intersection_obj(list:Array, a:Object):Boolean{
        for each(var b:Object in list){
            if(intersects(a, b))
                return true;
        }
        return false;
    }


    public static function intersects(a:Object, b:Object):Boolean{
        _rect1.x = a.x;
        _rect1.y = a.y;
        _rect1.width = a.w;
        _rect1.height = a.h;

        _rect2.x = b.x;
        _rect2.y = b.y;
        _rect2.width = b.w;
        _rect2.height = b.h;

        return _rect1.intersects(_rect2);
    }

    public static function contains(a:Object, b:Object):Boolean{
        _rect1.x = a.x;
        _rect1.y = a.y;
        _rect1.width = a.w;
        _rect1.height = a.h;

        _rect2.x = b.x;
        _rect2.y = b.y;
        _rect2.width = b.w;
        _rect2.height = b.h;

        return _rect1.containsRect(_rect2);
    }

    //utils
    public static function debug_generate_random_buildings(field_c:FieldController):void{
        var b:FieldObject;
        var fld:Array = FieldUtils.generate_field_with_objects(3, {w:field_c.field_width, h:field_c.field_length}, new Point(1, 1));
        for each(var o:Object in fld){
            b = new FieldObject(o.w, o.h, 2);
            b.move_to(o.x, o.y);
            field_c.add_building(b);
            // trace("{ x:" + o.x + ", y:" + o.y + ", w:" + o.w + ", l:" + o.h + " }")
        }
    }

}
}
