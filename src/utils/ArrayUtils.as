/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/13/12
 * Time: 11:58 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import common.controller.ControllerBase;

public class ArrayUtils {
    public function ArrayUtils() {
    }

    public static function shuffle(a:Array):Array{
        var res:Array = [];
        var rnd_pos:int;
        while(a.length > 0){
            rnd_pos = Math.random() * a.length;
            res.push(a[rnd_pos]);
            a.splice(rnd_pos, 1);

        }
        return res;
    }

    // TODO: check on simle arrays
    public static function get_insert_index_in_sorted(a:Vector.<ControllerBase>, e:*, cmp:Function): int{
        var leftIndex:int;
        var rightIndex:int = a.length - 1;
        var middleIndex:int;
        var middleElement:*;

        var cmp_res:int;

        while (leftIndex <= rightIndex)
        {
            middleIndex = (rightIndex + leftIndex) / 2;
            middleElement = a[middleIndex];

            cmp_res = cmp(e, middleElement);

            if(cmp_res != 1){
                rightIndex = middleIndex - 1;
            } else {
                leftIndex = middleIndex + 1;
            }
        }

        if(cmp_res != 1)
            return middleIndex;

        return middleIndex + 1;
    }
}
}
