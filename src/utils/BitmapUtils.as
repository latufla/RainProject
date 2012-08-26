/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/26/12
 * Time: 8:54 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;

public class BitmapUtils {
    public function BitmapUtils() {
    }

    private static var _bounds:Rectangle;
    public static function create_bitmap_data_from(sp:Sprite):BitmapData{
        _bounds = sp.getBounds(sp);
        var bd = new BitmapData(_bounds.width, _bounds.height, true, 0xFFFFFF);
        var m:Matrix = new Matrix();
        m.translate(-_bounds.x, -_bounds.y);
        bd.draw(sp, m);
        return bd;
    }
}
}
