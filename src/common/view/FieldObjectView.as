/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 11:18 PM
 * To change this template use File | Settings | File Templates.
 */
package common.view {
import common.controller.FieldController;
import common.model.FieldObject;

import flash.display.Bitmap;

import flash.display.BitmapData;

import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;

import utils.iso.IsoRenderUtil;

public class FieldObjectView extends Sprite{
    private var _bd:BitmapData;
    private var _x_offset:int;// we need them, cause draw at 0, 0 on bd
    private var _y_offset:int;

    private var _object:FieldObject;

    public function FieldObjectView() {
    }

    private var _t_f:TextField = new TextField();
    public function draw():void{
        if(!_object)
            throw new Error("FieldObjectView -> draw(): object is null" );

        var sp:Sprite = sprite_to_draw;
        var bounds:Rectangle = sp.getBounds(sp);
        _x_offset = bounds.x;
        _y_offset = bounds.y;
        _bd = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
        var m:Matrix = new Matrix();
        m.translate(-_x_offset, -_y_offset);

        bd.draw(sp, m);
    }

    private var _left_bd_pnt:Point = new Point();
    public function contains_px(pnt:Point):Boolean{
        _left_bd_pnt.x = x;
        _left_bd_pnt.y = y;
        return _bd.hitTest(_left_bd_pnt, 0xFFFFFF, pnt);
    }

    private function get sprite_to_draw():Sprite{
        var w:uint = _object.width * FieldController.TILE_WIDTH - 2;
        var l:uint = _object.length * FieldController.TILE_LENGTH - 2;
        var h:uint = _object.debug_height * FieldController.TILE_LENGTH;
        var sp:Sprite = new Sprite();
        IsoRenderUtil.draw_iso_box(sp, w, l, h, 0xC2C3C2);

        return sp;
    }

    public function get object():FieldObject{
        return _object;
    }

    public function set object(value:FieldObject):void {
        _object = value;
    }

    public function get bd():BitmapData {
        return _bd;
    }

    override public function get x():Number{
        return super.x + _x_offset;
    }

    override public function get y():Number{
        return super.y + _y_offset;
    }

    public function get y_offset():int {
        return _y_offset;
    }

    public function get x_offset():int {
        return _x_offset;
    }
}
}
