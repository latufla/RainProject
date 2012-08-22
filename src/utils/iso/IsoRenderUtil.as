package utils.iso {

import as3isolib.geom.Pt;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

public class IsoRenderUtil {
    // renders simple rect in iso
    // takes iso coordinates
    public static function draw_iso_rect(layer:Sprite, size:Rectangle, borderWidth:int, color:uint, borderColor:uint, alpha:Number = 1):void {
        layer.graphics.beginFill(color, alpha);
        layer.graphics.lineStyle(borderWidth, borderColor);

        var addPoint:Point = IsoMathUtil.isoToScreen(size.x, size.y);
        layer.graphics.moveTo(addPoint.x, addPoint.y);

        addPoint = IsoMathUtil.isoToScreen(size.x + size.width, size.y);
        layer.graphics.lineTo(addPoint.x, addPoint.y);

        addPoint = IsoMathUtil.isoToScreen(size.x + size.width, size.y + size.height);
        layer.graphics.lineTo(addPoint.x, addPoint.y);

        addPoint = IsoMathUtil.isoToScreen(size.x, size.y + size.height);
        layer.graphics.lineTo(addPoint.x, addPoint.y);

        addPoint = IsoMathUtil.isoToScreen(size.x, size.y);
        layer.graphics.lineTo(addPoint.x, addPoint.y);

        layer.graphics.endFill();
    }

    public static function draw_iso_box(layer:Sprite, w:int, l:int, h:int, color:uint):void{
        var g:Graphics = layer.graphics;
        g.clear();
        g.lineStyle(1, 0xFF0000);

        //all pts are named in following order "x", "y", "z" via rfb = right, front, bottom
        var lbb:Point = IsoMathUtil.isoToScreen(0, 0, 0);
        var rbb:Point = IsoMathUtil.isoToScreen(w, 0, 0);
        var rfb:Point = IsoMathUtil.isoToScreen(w, l, 0);
        var lfb:Point = IsoMathUtil.isoToScreen(0, l, 0);

        var lbt:Point = IsoMathUtil.isoToScreen(0, 0, h);
        var rbt:Point = IsoMathUtil.isoToScreen(w, 0, h);
        var rft:Point = IsoMathUtil.isoToScreen(w, l, h);
        var lft:Point = IsoMathUtil.isoToScreen(0, l, h);

        //front-left face
        g.moveTo(lfb.x, lfb.y);
        g.beginFill(color);
        g.lineTo(lft.x, lft.y);
        g.lineTo(rft.x, rft.y);
        g.lineTo(rfb.x, rfb.y);
        g.lineTo(lfb.x, lfb.y);
        g.endFill();

        //front-right face
        g.moveTo(rbb.x, rbb.y);
        g.beginFill(color);
        g.lineTo(rfb.x, rfb.y);
        g.lineTo(rft.x, rft.y);
        g.lineTo(rbt.x, rbt.y);
        g.lineTo(rbb.x, rbb.y);
        g.endFill();

        //top face
        g.moveTo(lbt.x, lbt.y);
        g.beginFill(color);
        g.lineTo(rbt.x, rbt.y);
        g.lineTo(rft.x, rft.y);
        g.lineTo(lft.x, lft.y);
        g.lineTo(lbt.x, lbt.y);
        g.endFill();
    }
}
}