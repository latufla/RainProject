/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/27/12
 * Time: 10:50 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.creator {
import common.controller.bots.BotController;
import common.controller.bots.OffenciveBotController;
import common.model.Bot;

import flash.utils.Dictionary;

public class BotControllerCreator {

    private static const BOTS:Dictionary = new Dictionary()
    BOTS[Bot.SIMPLE_ZOMBIE] =  BotController;
    BOTS[Bot.OFFENCIVE_ZOMBIE] =  OffenciveBotController;

    public function BotControllerCreator () {
    }

    public static function create(b:Bot):OffenciveBotController{
        return new BOTS[b.type]();
    }
}
}
