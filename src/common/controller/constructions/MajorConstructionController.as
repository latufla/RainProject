/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/25/12
 * Time: 11:31 PM
 * To change this template use File | Settings | File Templates.
 */
package common.controller.constructions {
import common.controller.FieldObjectController;
import common.model.points.TargetPoint;
import common.view.window.TargetWindow;

import flash.display.BitmapData;

public class MajorConstructionController extends FieldObjectController{
    public function MajorConstructionController() {
    }

    override public function draw(bd:BitmapData, service_bd:BitmapData = null, update_only:Boolean = false, x_offset:Number = 0):void{
        super.draw(bd, service_bd, update_only, x_offset);

        if(should_show_target_window)
            show_target_window();
    }

    override public function process_click():void{
        if(!_can_click)
            return;

        if(_object.target_point)
            show_target_window();
    }

    override protected function show_target_window():void{
        Config.scene_c.show_window(TargetWindow, _object.target_point, {x:_view.x + Config.scene_c.field_gui_offset.x + 50, y:_view.y, text:_object.target_point.description});
    }

    protected function get should_show_target_window():Boolean{
        var t_p:TargetPoint = _object.target_point;
        return t_p && !t_p.goal_completed && !Config.scene_c.window_already_shown(t_p);
    }
}
}
