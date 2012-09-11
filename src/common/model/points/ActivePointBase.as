/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 9/11/12
 * Time: 4:33 PM
 * To change this template use File | Settings | File Templates.
 */
package common.model.points {
import flash.events.EventDispatcher;

public class ActivePointBase extends EventDispatcher{

    protected var _x:uint; // tile field pos
    protected var _y:uint;

    public function ActivePointBase(x:uint, y:uint){
    }

    public function apply_params_to_grid():void{
    }

    public function remove_params_from_grid():void{
    }

    public function get x():uint {
        return _x;
    }

    public function set x(value:uint):void {
        _x = value;
    }

    public function get y():uint {
        return _y;
    }

    public function set y(value:uint):void {
        _y = value;
    }
}
}
