/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/25/12
 * Time: 11:49 PM
 * To change this template use File | Settings | File Templates.
 */
package utils.creator {
import common.controller.FieldObjectController;
import common.controller.constructions.BorderConstructionController;
import common.controller.constructions.CivileanConstructionController;
import common.controller.constructions.MajorConstructionController;
import common.controller.constructions.OffenciveConstructionController;
import common.model.FieldObject;

import flash.utils.Dictionary;

public class ConstructionControllerCreator {

    private static const CONSTRUCTIONS:Dictionary = new Dictionary()
    CONSTRUCTIONS[FieldObject.CIVILEAN_TYPE] =  CivileanConstructionController;
    CONSTRUCTIONS[FieldObject.BORDER_TYPE] =  BorderConstructionController;
    CONSTRUCTIONS[FieldObject.MAJOR_TYPE] =  MajorConstructionController;

    CONSTRUCTIONS[FieldObject.FACTORY_TYPE] =  FieldObjectController;
    CONSTRUCTIONS[FieldObject.OFFENCIVE_TYPE] =  OffenciveConstructionController;

    public function ConstructionControllerCreator() {
    }

    public static function create(b:FieldObject):FieldObjectController{
        return new CONSTRUCTIONS[b.type]();
    }
}
}
