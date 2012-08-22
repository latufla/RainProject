/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 4:04 PM
 * To change this template use File | Settings | File Templates.
 */
package common.view {
import common.model.IsoGrid;
import common.model.IsoTile;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.Shape;

import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;

import utils.DebugUtils;
import utils.MovieClipHelper;

public class IsoGridView extends Sprite{

    private var _grid:IsoGrid;
    private var _tile_renderer:IsoTileRenderer = new IsoTileRenderer();

    //initial offset
    private var _offset:Point = new Point();

    // debug
    private var _debug_fields:Array = [];
    private var _used_debug_fields:Array = [];

    // draw
    private var _shape_sprite:Sprite = new Sprite(); // sprite is for adding fields
    private var _grid_view:Bitmap = new Bitmap();
    private var _bd:BitmapData;
    private var _matrix:Matrix = new Matrix();

    public function IsoGridView() {
    }

    public function draw():void{
        if(!_grid)
            throw new Error("IsoGridView -> draw(): grid is null" );

        DebugUtils.start_profile_block("IsoGridView -> draw()");

        clear_debug_fields();
        draw_grid_shape(_grid, _tile_renderer);
        draw_grid_bitmap(_bd, _matrix, _shape_sprite);
        addChild(_grid_view);
        align();

        DebugUtils.stop_profile_block("IsoGridView -> draw()")
    }

    private function draw_grid_shape(grid:IsoGrid, renderer:IsoTileRenderer):Sprite {
        _shape_sprite.graphics.clear();
        grid.tiles.forEach(function (v:Vector.<IsoTile>, index:int, vector:Vector.<Vector.<IsoTile>>):void{
            v.forEach(function (tile:IsoTile, index:int, vector:Vector.<IsoTile>):void{
                renderer.draw(tile, _shape_sprite);
                renderer.draw_debug_info(tile, _shape_sprite, create_debug_field());
            });
        });
        return _shape_sprite;
    }

    // TODO:fuck the double buffring now
    private function draw_grid_bitmap(bd:BitmapData, m:Matrix, source:Sprite):Bitmap {
        if(bd)
            bd.dispose();

        var bounds:Rectangle = source.getBounds(source);
        bd = new BitmapData(bounds.width, bounds.height);
        m.identity();
        m.translate(-bounds.x, -bounds.y);
        bd.draw(source, m);
        bd.lock();
        _grid_view.bitmapData = bd;
        _grid_view.x = bounds.x; //save native iso offsets
        _grid_view.y = bounds.y;
        return _grid_view;
    }

    private function align():void {
        var bounds:Rectangle = getBounds(this);
        this.x = -bounds.x;
        this.y = -bounds.y;

        _offset.x = -bounds.x;
        _offset.y = -bounds.y;
    }

    private function create_debug_field():TextField{
        var debug_field:TextField = _debug_fields.pop();
        if(!debug_field)
            debug_field = new TextField();

        debug_field.mouseEnabled = false;
        _used_debug_fields.push(debug_field);

        return debug_field;
    }

    private function clear_debug_fields():void {
        for each(var p:TextField in _used_debug_fields){
            MovieClipHelper.try_remove(p);
        }
        _debug_fields =_debug_fields.concat(_used_debug_fields);
        _used_debug_fields = [];
    }

    public function get grid():IsoGrid {
        return _grid;
    }

    public function set grid(value:IsoGrid):void {
        _grid = value;
    }

    public function get offset():Point {
        return _offset;
    }
}
}
