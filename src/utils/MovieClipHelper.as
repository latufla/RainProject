/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 6/10/12
 * Time: 12:55 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.DisplayObject;

public class MovieClipHelper {
    public function MovieClipHelper() {
    }

    public static function try_remove(mc:DisplayObject):void{
        if(mc is DisplayObject && mc.parent){
            mc.parent.removeChild(mc);
        }
    }
}
}
