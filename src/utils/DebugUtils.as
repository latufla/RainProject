/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 6/26/12
 * Time: 10:11 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.utils.Dictionary;
import flash.utils.getTimer;

public class DebugUtils {

    private static var  _block_begin_at:Object={};
    private static var  _block_counter:Dictionary = new Dictionary();
    private static var  _block_sum:Dictionary = new Dictionary();

    public static var _blocks_counter:int = 0;

    public function DebugUtils() {
    }

    private static var  _current_blocks:Array=[];

    public static function current_blocks():String
    {
        return _current_blocks.join(",");
    }

    public static function start_profile_block(block:String):void {
        _current_blocks.push(block);
        trace("Block: " + block + " started ");
        _block_begin_at[block] = getTimer();
        if(!_block_counter[block])
            _block_counter[block] = 0;
        if(!_block_sum[block])
            _block_sum[block] = 0;
    }

    public static function stop_profile_block(block:String):int {
        _current_blocks.pop();
        var done_in:int =getTimer() -_block_begin_at[block];
        _block_counter[block] = _block_counter[block] + 1;
        if(done_in < 100)
            _block_sum[block] = _block_sum[block] + done_in;
        trace("Block: " + block + " done in " + done_in);
        trace("Average time for block "+block+": " + Number(_block_sum[block]) / Number(_block_counter[block]));
        trace("Total time for block "+block+": " + Number(_block_sum[block]) + " block count " + _block_counter[block]);
        return done_in;
    }

    public static function profile_block(... rest):int {
        var block_counter:String = (_blocks_counter++).toString();
        var fnc:Function;
        if(rest[0] is String) {
            block_counter = rest[0];
            fnc = rest[1]
        } else {
            fnc = rest[0]
        }

        start_profile_block(block_counter.toString());
        fnc();
        return stop_profile_block(block_counter.toString());
    }
}
}
