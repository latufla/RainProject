/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/10/12
 * Time: 1:56 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import common.model.IsoTile;

public class PNode{

    private var _f:int;
    private var _g:int;
    private var _h:int;
    private var _parent_node:PNode;

    private var _tile:IsoTile;

    public function PNode(tile:IsoTile) {
        init(tile);
    }

    private function init(tile:IsoTile):void {
        if(!tile)
            throw new Error("PNode -> init(): tile is null");

        _tile = tile;
    }

    public function clone():PNode {
        var res:PNode = new PNode(_tile);
        res.f = _f;
        res.g = _g;
        res.h = _h;
        res.parent_node = _parent_node;
        return res;
    }

    public function fill_params(parent_node:PNode, f:int, g:int, h:int):void{
        _parent_node = parent_node;
        _f = f;
        _g = g;
        _h = h;
    }

    public function get f():int {
        return _f;
    }

    public function set f(value:int):void {
        _f = value;
    }

    public function get g():int {
        return _g;
    }

    public function set g(value:int):void {
        _g = value;
    }

    public function get h():int {
        return _h;
    }

    public function set h(value:int):void {
        _h = value;
    }

    public function get parent_node():PNode {
        return _parent_node;
    }

    public function set parent_node(value:PNode):void {
        _parent_node = value;
    }

    public function get tile():IsoTile {
        return _tile;
    }

    public function set tile(value:IsoTile):void {
        _tile = value;
    }
}
}
