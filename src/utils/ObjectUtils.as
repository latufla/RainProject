/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/15/12
 * Time: 9:20 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.utils.Dictionary;

public class ObjectUtils {
    public function ObjectUtils() {
    }

    public static function debug_trace(o:*):void{
        for each(var p:* in o){
            trace(p);
        }
    }
}
}
