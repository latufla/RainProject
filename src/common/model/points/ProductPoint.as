/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 9/11/12
 * Time: 4:33 PM
 * To change this template use File | Settings | File Templates.
 */
package common.model.points {
import common.model.FieldObject;

public class ProductPoint extends ActivePointBase{

    private var _product:FieldObject;

    public function ProductPoint(x:uint, y:uint, product:FieldObject) {
        super(x, y);
        _product = product;
    }

    public function get product():FieldObject {
        return _product;
    }

    override public function get x():uint{
        return _product.x;
    }

    override public function set x(value:uint):void {
        _product.x = value;
    }

    override public function get y():uint{
        return _product.y;
    }

    override public function set y(value:uint):void {
        _product.y = value;
    }

    public function produce():void{
        Config.field_c.add_building(_product);
    }
}
}
