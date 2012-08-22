/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/7/12
 * Time: 12:03 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

public class DoubleBuffer {
    private var _width:uint;
    private var _height:uint;

    private var _buffer:Array = [new Bitmap(), new Bitmap()];
    private var _bd:BitmapData;

    public function DoubleBuffer(w:uint, h:uint) {
        _width = w;
        _height = h;
        _bd = new BitmapData(1280, 768, true, 0xFFFFFF);
    }

    public function get width():uint {
        return _width;
    }

    public function get height():uint {
        return _height;
    }

    public function get bd():BitmapData {
        return _bd;
    }

    public function refresh():void{
        _bd = new BitmapData(1280, 768, true, 0xFFFFFF);
    }

    public function draw(view:DisplayObjectContainer):void{
        _buffer[1].bitmapData = bd;

        var tmp:Bitmap;
        tmp = _buffer[0];
        _buffer[0] = _buffer[1];
        _buffer[1] = tmp;

        view.addChild(_buffer[0])
        MovieClipHelper.try_remove(_buffer[1]);
    }
}
}
