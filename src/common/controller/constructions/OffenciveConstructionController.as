/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 8/22/12
 * Time: 10:05 PM
 * To change this template use File | Settings | File Templates.
 */
package common.controller.constructions {
import common.controller.*;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import utils.MovieClipHelper;
import utils.iso.IsoMathUtil;
import utils.iso.IsoRenderUtil;

public class OffenciveConstructionController extends FieldObjectController{

    private var _x_offset:Number;
    private var _attack_radius_view:Bitmap;
    public function OffenciveConstructionController() {
    }

    override public function draw(bd:BitmapData, service_bd:BitmapData = null, update_only:Boolean = false, x_offset:Number = 0):void{
        super.draw(bd, service_bd, update_only, x_offset);
        _x_offset = x_offset;
    }

    public function draw_attack_radius(layer:Sprite, x_offset:Number = 0):void {
        if(_attack_radius_view){
            layer.addChild(_attack_radius_view);
            return;
        }

        var sp:Sprite = new Sprite();
        sp.graphics.beginFill(0xFFFF00, .5);
        sp.graphics.lineStyle(1, 0xFFFF00);
        IsoRenderUtil.draw_iso_circle(sp.graphics, new Point(0, 0), FieldController.TILE_WIDTH * _object.attack_radius);
        sp.graphics.beginFill(0xFFFF00);
        sp.graphics.drawRect(-2, -2, 4, 4);
        sp.graphics.endFill();

        var bounds:Rectangle = sp.getBounds(sp);
        var _bd = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
        var m:Matrix = new Matrix();
        m.translate(-bounds.x, -bounds.y);

        _bd.draw(sp, m);
        _attack_radius_view = new Bitmap(_bd);

        var pnt:Point = IsoMathUtil.isoToScreen(_object.x_px, _object.y_px);
        _attack_radius_view.x = pnt.x + _x_offset + bounds.x ;
        _attack_radius_view.y = pnt.y + bounds.y;

        layer.addChild(_attack_radius_view);
    }

    public function clear_attack_radius():void{
        MovieClipHelper.try_remove(_attack_radius_view);
    }

    override public function process_click():void{
        if(!_can_click)
            return;


        if(_attack_radius_view && _attack_radius_view.parent)
            clear_attack_radius();
        else
            draw_attack_radius(Config.field_c.service_view);

//        if(_object.spawn_point)
//            start_spawn_bots();
    }


}
}
