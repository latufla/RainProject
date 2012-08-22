/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/8/12
 * Time: 11:22 AM
 * To change this template use File | Settings | File Templates.
 */
package common.model {
import common.model.ObjectBase;

public class FieldObjectsList {

    private var _list:Vector.<Vector.<ObjectBase>> = new Vector.<Vector.<ObjectBase>>();

    public function FieldObjectsList() {
    }

    public function get list():Vector.<Vector.<ObjectBase>> {
        return _list;
    }

    public function add(o:ObjectBase):void{
        _list.push(o);
    }

    public function remove(o:ObjectBase):void{
        var idx:int = _list.indexOf(o);
        if(idx != -1)
            _list.splice(idx, 1);
    }

    public function insert(o:ObjectBase, idx:uint):Boolean{
        if(idx > _list.length)
            return false;

        _list.splice(idx, 0, o);
        return true;
    }

    public function get length():uint {
        return _list.length;
    }

    public function set length(value:uint):void {
        _list.length = value;
    }
}
}
