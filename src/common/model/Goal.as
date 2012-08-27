/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/26/12
 * Time: 10:57 PM
 * To change this template use File | Settings | File Templates.
 */
package common.model {
public class Goal {

    private var _type:String = Bot.SIMPLE_ZOMBIE;
    private var _count:uint;
    private var _completed:Boolean;

    public function Goal() {
    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
    }

    public function get count():uint {
        return _count;
    }

    public function set count(value:uint):void {
        _count = value;
    }

    public function get completed():Boolean {
        return _completed;
    }

    public function set completed(value:Boolean):void {
        _completed = value;
    }
}
}
