/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 11:15 AM
 * To change this template use File | Settings | File Templates.
 */
package {
import common.controller.FieldController;
import common.controller.SceneController;

public class Config {
    public function Config() {
    }

    public static var field_c:FieldController;
    public static var scene_c:SceneController;

    public static const SHOW_TILE_NUMBERS:Boolean = false;
    public static const SHOW_GRID:Boolean = true;
    public static const TILE_WIDTH:uint = 40;
    public static const TILE_LENGTH:uint = 40;
}
}
