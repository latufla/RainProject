/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/25/12
 * Time: 11:12 PM
 * To change this template use File | Settings | File Templates.
 */
package common.controller.constructions {
import common.controller.FieldObjectController;
import common.view.window.DialogWindow;

import tr.Tr;

public class CivileanConstructionController extends FieldObjectController{
    public function CivileanConstructionController() {
    }

    override public function process_click(){
        if(!_can_click)
            return;

        if(_object.spawn_point)
            show_invade_window();
    }

    override protected function show_invade_window():void{
        Config.scene_c.show_window(DialogWindow, DialogWindow.KEY, {x:_view.x + Config.scene_c.field_gui_offset.x + 50, y:_view.y, text:Tr.invade_building_dialog_window,
            confirm_button:{cb: start_spawn_bots}, cancel_button:{}});
    }
}
}
