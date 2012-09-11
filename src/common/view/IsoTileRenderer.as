/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 11:29 AM
 * To change this template use File | Settings | File Templates.
 */
package common.view {
import common.controller.FieldController;
import common.model.grid.IsoTile;

import flash.display.Graphics;

import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import utils.iso.IsoMathUtil;
import utils.iso.IsoRenderUtil;

public class IsoTileRenderer {
    private static const NON_REACHABLE_COLOR:uint = 0x939393;
    private static const REACHABLE_COLOR:uint = 0xAEAEAE;

    private static const SPAWN_POINT_COLOR:uint = 0x2222FF;
    private static const TARGET_POINT_COLOR:uint = 0xFF2222;

    public function IsoTileRenderer() {
    }

    public function draw(tile:IsoTile, layer:Sprite):void {
        if(!tile || !layer)
            throw new Error("IsoTileRenderer -> draw(): Illegal argument");

        var color:uint = NON_REACHABLE_COLOR;
        if(tile.is_reachable)
            color = REACHABLE_COLOR;


        if(tile.is_target)
            color = TARGET_POINT_COLOR;

        if(tile.is_spawn)
            color = SPAWN_POINT_COLOR;

        var size:Rectangle = new Rectangle(tile.x_px, tile.y_px, FieldController.TILE_WIDTH - 1, FieldController.TILE_LENGTH - 1);
        var g:Graphics = layer.graphics;
        g.beginFill(color, 1);
        IsoRenderUtil.draw_iso_rect(g, size);
        g.endFill();
    }

    public function draw_debug_info(tile:IsoTile, layer:Sprite, debug_field:TextField):void {
        if(!Config.SHOW_TILE_NUMBERS)
            return;

        var iso:Point = IsoMathUtil.isoToScreen(tile.x_px, tile.y_px);
        debug_field.x = iso.x - 15;
        debug_field.y = iso.y + 5;

        debug_field.autoSize = TextFieldAutoSize.LEFT;
        debug_field.text = "x" + tile.x + " y" + tile.y;
        layer.addChild(debug_field);
    }
}
}
