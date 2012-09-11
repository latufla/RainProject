/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/27/12
 * Time: 10:16 PM
 * To change this template use File | Settings | File Templates.
 */
package common.controller.bots {

public class CarrierBotController extends BotController{
    public function CarrierBotController() {
    }

    override protected function on_complete_move_to_target(){
        super.on_complete_move_to_target();
        if(_object.product_point)
            _object.product_point.produce();
    }
}
}
