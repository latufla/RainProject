/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/15/12
 * Time: 2:00 PM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.events.MouseEvent;
import flash.utils.Dictionary;

public class GuiUtils {

    private static var _buttons:Dictionary = new Dictionary();
    public function GuiUtils() {
    }

    public static function set_button(button:CustomButtonDesign, text:String, cb:Function):void{
        button.mouseChildren = false;
        button.buttonMode = true;


        button.gotoAndStop(1);
        button.ButtonText.text = text;

        button.addEventListener(MouseEvent.CLICK, cb);

        button.addEventListener(MouseEvent.MOUSE_OVER, on_over);
        button.addEventListener(MouseEvent.MOUSE_DOWN, on_down);
        button.addEventListener(MouseEvent.MOUSE_UP, on_up);
        button.addEventListener(MouseEvent.MOUSE_OUT, on_up);

        _buttons[button] = {text: text, cb: cb};

//        trace("_buttons");
//        ObjectUtils.debug_trace(_buttons);
    }

    public static function unset_button(button:CustomButtonDesign):void{
        if(!_buttons[button])
            return;

        button.removeEventListener(MouseEvent.CLICK, _buttons[button].cb);
        button.removeEventListener(MouseEvent.MOUSE_OVER, on_over);
        button.removeEventListener(MouseEvent.MOUSE_DOWN, on_down);
        button.removeEventListener(MouseEvent.MOUSE_UP, on_up);
        button.removeEventListener(MouseEvent.MOUSE_OUT, on_up);

        delete _buttons[button];
    }

    private static function on_over(e:MouseEvent):void{
        var btn:CustomButtonDesign = e.currentTarget as CustomButtonDesign;
        if(btn){
            btn.gotoAndStop(2);
            btn.ButtonText.text = _buttons[btn].text;
        }
    }

    private static function on_down(e:MouseEvent):void{
        var btn:CustomButtonDesign = e.currentTarget as CustomButtonDesign;
        if(btn){
            btn.gotoAndStop(3);
            btn.ButtonText.text = _buttons[btn].text;
        }
    }

    private static function on_up(e:MouseEvent):void{
        var btn:CustomButtonDesign = e.currentTarget as CustomButtonDesign;
        if(btn){
            btn.gotoAndStop(1);
            btn.ButtonText.text = _buttons[btn].text;
        }
    }

}
}
