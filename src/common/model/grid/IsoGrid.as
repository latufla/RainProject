/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 11:24 AM
 * To change this template use File | Settings | File Templates.
 */
package common.model.grid {
import common.model.*;

import utils.DebugUtils;
import utils.PNode;
import utils.ZorderUtils;

public class IsoGrid {

    private var _tiles:Vector.<Vector.<IsoTile>> = new Vector.<Vector.<IsoTile>>();
    private var _width:uint;
    private var _length:uint;

    public function IsoGrid(w:uint, l:uint) {
        _width = w;
        _length = l;
    }

    public function create():void{
        for (var i:int = 0; i < _width; i++){
            _tiles[i] = new Vector.<IsoTile>();
            for (var j:int = 0; j < _length; j++) {
                _tiles[i][j] = new IsoTile(i, j);
            }
        }

//        trace("get_vertical", ZorderUtils.get_vertical(this, 7));
//        update_p_nodes();
    }

    // pathfinding info, call after any grid resizing
//    private function update_p_nodes():void{
//        _p_nodes = new Vector.<Vector.<PNode>>();
//
//        var n:uint = _tiles.length;
//        var m:uint = _tiles[0].length;
//        for (var i:int = 0; i < n; i++) {
//            _p_nodes[i] = new Vector.<PNode>();
//            for (var j:int = 0; j < m; j++) {
//                _p_nodes[i][j] = _tiles[i][j].p_node;
//            }
//       }
//    }

    public function resize(w:uint, l:uint):void {
//        DebugUtils.start_profile_block("IsoGrid -> resize()");
        var new_tiles:Vector.<Vector.<IsoTile>> = new Vector.<Vector.<IsoTile>>();

        // width
        for (var i:uint = 0; i < w; i++){
            if(i < _width){
                new_tiles[i] = _tiles[i];
                continue;
            }
            new_tiles.push(new Vector.<IsoTile>());
        }

        // height
        for (i = 0; i < w; i++){
            for (var j:uint = 0; j < l; j++) {
                if(i < _width && j < _length)
                    new_tiles[i][j] = _tiles[i][j];
                else
                    new_tiles[i].push(new IsoTile(i, j));
            }
            new_tiles[i].length = l;
        }
        _width = w;
        _length = l;
        _tiles = new_tiles;

//        update_p_nodes();
//        DebugUtils.stop_profile_block("IsoGrid -> resize()");
    }

    // for settin` tile properties
    public function get_tile(x:uint, y:uint):IsoTile{
        if(x >= _tiles.length || y >= _tiles[x].length)
            return null;

        return _tiles[x][y];
    }

    public function get_tiles_in_square(x:uint, y:uint, w:uint, l:uint):Array{
        var res:Array = [];
        var tile:IsoTile;
        var n:uint = x + w;
        var m:uint = y + l;
        for (var i:int = x; i < n; i++) {
            for (var j:int = y; j < m; j++) {
                tile = get_tile(i, j);
                if(tile)
                    res.push(tile);
            }
        }
        return res;
    }

    public function debug_generate_random(disp:Number = 0.7):void{
        for (var i:int = 0; i < _width; i++){
            tiles[i] = new Vector.<IsoTile>();
            for (var j:int = 0; j < _length; j++) {
                trace(tiles[i][j] = new IsoTile(i, j));

                if(Math.random() > disp)
                    tiles[i][j].is_reachable = false;

            }
        }
    }

    public function get tiles():Vector.<Vector.<IsoTile>> {
        return _tiles;
    }

    // ort + dia
//    public function get_eight_connected_tiles(tile:IsoTile):Array{
//        var res:Array = [];
//
//        var t_x:uint = tile.x;
//        var t_y:uint = tile.y;
//
//        for (var i:int = t_x - 1; i <= t_x + 1; i++) {
//            if(i < 0 || i > tiles.length - 1)
//                continue;
//
//            var h_tiles:Vector.<IsoTile> = tiles[i];
//            for (var j:int = t_y - 1; j <= t_y + 1; j++) {
//
//                if(j < 0 || j > h_tiles.length - 1 || h_tiles[j] == tile || !h_tiles[j].is_reachable)
//                    continue;
//
//                res.push(h_tiles[j]);
//            }
//        }
//        return res;
//    }
//
    // ort
//    public function get_four_connected_tiles(tile:IsoTile):Array{
//        var res:Array = [];
//
//        var tx:int = tile.x;
//        var ty:int = tile.y;
//        var tile_coords:Array = [{x:tx - 1, y:ty}, {x:tx + 1, y:ty}, {x:tx,  y:ty - 1}, {x:tx,  y:ty + 1}];
//
//        for each (var p:Object in tile_coords){
//            tx = p.x;
//            ty = p.y;
//
//            if(tx < 0 || tx > tiles.length - 1 || ty < 0 || ty > tiles[tx].length - 1)
//                continue;
//
//            if(!tiles[tx][ty].is_reachable)
//                continue;
//
//            res.push(tiles[tx][ty]);
//        }
//
//        return res;
//    }

    public function get_four_connected_p_nodes(node:PNode):Array{
        var res:Array = [];

        var tx:int = node.tile.x;
        var ty:int = node.tile.y;
        var tile_coords:Array = [{x:tx - 1, y:ty}, {x:tx + 1, y:ty}, {x:tx,  y:ty - 1}, {x:tx,  y:ty + 1}];

        for each (var p:Object in tile_coords){
            tx = p.x;
            ty = p.y;

            if(tx < 0 || tx > tiles.length - 1 || ty < 0 || ty > tiles[tx].length - 1)
                continue;

            if(!tiles[tx][ty].is_reachable)
                continue;

            res.push(tiles[tx][ty].p_node);
        }
        return res;
    }

    public function get width():uint {
        return _width;
    }

    public function get length():uint {
        return _length;
    }

    public function clear_p_nodes():void{
        _tiles.forEach(function (v:Vector.<IsoTile>, index:int, vector:Vector.<Vector.<IsoTile>>):void{
            v.forEach(function (tile:IsoTile, index:int, vector:Vector.<IsoTile>):void{
                tile.p_node.fill_params(null, 0, 0, 0);
            });
        });
    }
}
}
