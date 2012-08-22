/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/9/12
 * Time: 10:48 AM
 * To change this template use File | Settings | File Templates.
 */
package common.event {
import flash.events.Event;

public class GameEvent extends Event{
    private var _data:Object;
    public static const COMPLETE_TARGET:String = "complete_target";

    public function GameEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false){
        super(type, bubbles, cancelable);
        this._data = data;
        return;
    }

    public function get data():Object {
        return _data;
    }
}
}
