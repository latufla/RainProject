/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/10/12
 * Time: 4:11 PM
 * To change this template use File | Settings | File Templates.
 */
package common.view {
import common.controller.FieldController;
import common.model.Bot;

import flash.display.Bitmap;

import flash.display.BitmapData;

import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.text.TextField;

import utils.iso.IsoRenderUtil;

public class BotView extends Sprite{
    private var _bd:BitmapData;
    private var _x_offset:int;// we need them, cause draw at 0, 0 on bd
    private var _y_offset:int;

    private var _object:Bot;
    public function BotView() {
    }

    private var _t_f:TextField = new TextField();
    public function draw():void{
        if(!_object)
            throw new Error("BotView -> draw(): object is null" );

        var sp:Sprite = sprite_to_draw;
        var bounds:Rectangle = sp.getBounds(sp);
        _x_offset = bounds.x;
        _y_offset = bounds.y;
        _bd = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
        var m:Matrix = new Matrix();
        m.translate(-_x_offset, -_y_offset);
//        _t_f.text = String(_object.id);
//        _t_f.y = - 20;
//        _t_f.x = - 10;
        //sp.addChild(_t_f);

        bd.draw(sp, m);
    }

    private function get sprite_to_draw():Sprite{
        var sp:Sprite = new Sprite();
        var w:uint = 6;
        var l:uint = 6;
        var h:uint = 15;
        IsoRenderUtil.draw_iso_box(sp, w, l, h, 0xC2C3C2);

        return sp;
    }

    public function get object():Bot{
        return _object;
    }

    public function set object(value:Bot):void {
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
