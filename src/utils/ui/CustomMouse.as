/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/26/12
 * Time: 9:34 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.ui {
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class CustomMouse {

    private var _position:Point = new Point();
    private var _last_object_over:*;

    private static var _instance:CustomMouse = new CustomMouse();
    public function CustomMouse() {
    }

    public static function get instance():CustomMouse {
        return _instance;
    }

    public function get last_object_over():* {
        return _last_object_over;
    }

    public function set last_object_over(value:*):void {
        _last_object_over = value;
    }

    public function get x():int {
        return _position.x;
    }

    public function set x(value:int):void {
        _position.x = value;
    }

    public function get y():int {
        return _position.y;
    }

    public function set y(value:int):void {
        _position.y = value;
    }

    public function get position():Point{
        return _position;
    }

    public function set cursor(value:String):void{
        Mouse.cursor = value;
    }
}
}
