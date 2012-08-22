package utils.iso {
import as3isolib.geom.IsoMath;
import as3isolib.geom.Pt;

import flash.geom.Point;
import flash.geom.Rectangle;

public class IsoMathUtil {

    public static function screenToIso(x:Number, y:Number, z:Number = 0):Point {
        return IsoMath.screenToIso(new Pt(x, y, z));
    }

    public static function isoToScreen(x:int, y:int, z:Number = 0):Point {
        return IsoMath.isoToScreen(new Pt(x, y, z));
    }

    public static function getScreenSizeFromIso(isoSize:Rectangle):Rectangle {
        var size:Rectangle = new Rectangle();

        var point1:Point = isoToScreen(isoSize.x, isoSize.y);
        var point2:Point = isoToScreen(isoSize.x + isoSize.width, isoSize.y + isoSize.height);
        size.width = point2.x - point1.x;

        point1 = isoToScreen(isoSize.x + isoSize.width, isoSize.y);
        point2 = isoToScreen(isoSize.x, isoSize.y + isoSize.height);
        size.height = point1.y - point2.y;

        //trace("pixelWidth", size);
        return size;
    }
}
}