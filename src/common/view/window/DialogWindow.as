/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/15/12
 * Time: 9:44 AM
 * To change this template use File | Settings | File Templates.
 */
package common.view.window {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import tr.Tr;

import utils.GuiUtils;

public class DialogWindow extends DialogWindowDesign{

    private var _params:Object;

    public static const KEY:String = "DialogWindow";
    public function get cancel_button():CustomButtonDesign{ return CancelButton;}
    public function get confirm_button():CustomButtonDesign{ return ConfirmButton;}
    public function get close_button():MovieClip{return CloseButton;}
    public function get tip_field():TextField{ return TipText;}

    public function DialogWindow(params:Object) {
        _params = params;
        init();
    }

    private function init():void {
        alpha = .7;
        x = _params.x;
        y = _params.y;
        tip_text = _params.text;
        init_buttons();
    }

    private function init_buttons():void {
        clear_buttons();

        confirm_button.visible = _params.confirm_button;
        confirm_button.gotoAndStop(1);
        if(_params.confirm_button){
            var confirm_text:String = _params.confirm_button.text ? _params.confirm_button.text : Tr.confirm_button;
            GuiUtils.set_button(confirm_button, confirm_text, on_confirm);
        }

        cancel_button.gotoAndStop(1);
        cancel_button.visible = _params.cancel_button;
        if(_params.cancel_button){
            var cancel_text:String = _params.cancel_button.text? _params.cancel_button.text : Tr.cancel_button;
            GuiUtils.set_button(cancel_button, cancel_text, on_cancel);
        }

        close_button.buttonMode = true;
        close_button.addEventListener(MouseEvent.CLICK, close_window);
    }

    private function clear_buttons():void{
        GuiUtils.unset_button(confirm_button);
        GuiUtils.unset_button(cancel_button);
        close_button.removeEventListener(MouseEvent.CLICK, close_window);
    }

    private function on_confirm(e:Event):void{
        close_window();
        if(_params.confirm_button.cb)
            _params.confirm_button.cb();
    }

    private function on_cancel(e:Event):void{
        close_window();
        if(_params.cancel_button.cb)
            _params.cancel_button.cb();
    }

    private function close_window(e:Event = null):void{
        Config.scene_c.remove_window(KEY);
    }

    public function set tip_text(value:String):void{
        tip_field.text = value;
        tip_field.autoSize = TextFieldAutoSize.LEFT;
    }

    public function refresh(params:Object){
        _params = params;
        init();
    }
}
}
