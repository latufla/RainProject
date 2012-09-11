package {

import common.controller.ControllerBase;
import common.controller.ControllerBase;
import common.model.grid.IsoTile;
import common.view.IsoTileRenderer;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import utils.ArrayUtils;

import utils.ArrayUtils;
import utils.DebugUtils;

import utils.FPSCounter;
import utils.iso.IsoRenderUtil;

[SWF(width="1280", height="748", frameRate="30", backgroundColor = "0xFFFFFF")]
public class RainProject extends Sprite {

    private var _engine:Engine;
    public static var main_stage:Stage;

    public function RainProject() {
        addEventListener(Event.ADDED_TO_STAGE, onAddStage)
    }

    public function onAddStage(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddStage);
        stage.scaleMode = "noScale";
        stage.align = "left";
        main_stage = stage;

        _engine = new Engine();
        _engine.init();

        add_to_main_stage(new FPSCounter());
    }

    public static function add_to_main_stage(view:DisplayObject):void{
        if(main_stage)
            main_stage.addChild(view);
    }

}
}
