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
import flash.geom.Point;
import flash.geom.Rectangle;

import utils.BitmapUtils;

import utils.MovieClipHelper;
import utils.iso.IsoMathUtil;
import utils.iso.IsoRenderUtil;

public class OffenciveConstructionController extends FieldObjectController{

    private static const ATTACK_RADIUS_COLOR:uint = 0x22FF22;
    private var _x_offset:int;
    private var _attack_radius_view:Bitmap;
    public function OffenciveConstructionController() {
    }

    override public function draw(bd:BitmapData, service_bd:BitmapData = null, update_only:Boolean = false, x_offset:Number = 0):void{
        super.draw(bd, service_bd, update_only, x_offset);
        _x_offset = x_offset;
    }

    public function draw_attack_radius(layer:Sprite, update_only:Boolean = false, x_offset:Number = 0):void {
        if(update_only && _attack_radius_view){
            layer.addChild(_attack_radius_view);
            return;
        }

        var sp:Sprite = attack_radius_to_draw;
        var bd:BitmapData = BitmapUtils.create_bitmap_data_from(sp);
        _attack_radius_view = new Bitmap(bd);
        update_attack_radius_position(sp.getBounds(sp));
        layer.addChild(_attack_radius_view);
    }

    private function get attack_radius_to_draw():Sprite{
        var sp:Sprite = new Sprite();
        sp.graphics.beginFill(ATTACK_RADIUS_COLOR, .5);
        sp.graphics.lineStyle(1, ATTACK_RADIUS_COLOR);
        IsoRenderUtil.draw_iso_circle(sp.graphics, new Point(0, 0), FieldController.TILE_WIDTH * _object.attack_radius);
        sp.graphics.endFill();
        return sp;
    }

    private function update_attack_radius_position(sp_bounds:Rectangle):void{
        var r_x:int = _object.x_px + _object.width * Config.TILE_WIDTH / 2;
        var r_y:int = _object.y_px + _object.length * Config.TILE_LENGTH / 2
        var pnt:Point = IsoMathUtil.isoToScreen(r_x, r_y);
        _attack_radius_view.x = pnt.x + sp_bounds.x + _x_offset;
        _attack_radius_view.y = pnt.y + sp_bounds.y;
    }

    public function clear_attack_radius():void{
        MovieClipHelper.try_remove(_attack_radius_view);
    }

    override public function process_click():void{
        if(!_can_click)
            return;

//        if(_object.spawn_point)
//            start_spawn_bots();
    }

    override public function process_mouse_over():void{
        if(!attack_radius_shown)
            draw_attack_radius(Config.field_c.service_view, _attack_radius_view);
    }

    override public function process_mouse_out():void{
        clear_attack_radius();
    }

    private function get attack_radius_shown():Boolean{
        return _attack_radius_view && _attack_radius_view.parent;
    }

}
}
