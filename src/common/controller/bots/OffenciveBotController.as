/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/27/12
 * Time: 10:16 PM
 * To change this template use File | Settings | File Templates.
 */
package common.controller.bots {
import common.controller.*;
import common.controller.bots.BotController;
import common.model.Bot;
import common.model.FieldObject;

import flash.geom.Point;

public class OffenciveBotController extends BotController{
    public function OffenciveBotController() {
    }

    private function produce_object():void{
        var b:FieldObject = new FieldObject(1, 1, 2);
        b.type = FieldObject.BORDER_TYPE;
        b.move_to(_object.x, _object.y);
        b.create_target_point(new Point(_object.x -1, _object.y), 9999, Bot.SIMPLE_ZOMBIE, 5);
        Config.field_c.add_building(b);
    }
}
}
