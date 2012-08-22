/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 5/26/12
 * Time: 12:05 AM
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class ClassHelper {
    public function ClassHelper() {
    }

    public static function class_from_instance(inst:*):Class {
        return Object(inst).constructor;
    }
}
}
