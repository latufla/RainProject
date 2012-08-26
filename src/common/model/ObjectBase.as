/**
 * Created with IntelliJ IDEA.
 * User: alexvasilyev
 * Date: 7/7/12
 * Time: 11:07 PM
 * To change this template use File | Settings | File Templates.
 */
package common.model {
import common.controller.FieldController;

import flash.events.EventDispatcher;

import flash.geom.Point;

import utils.FieldUtils;

// base not abstract
public class ObjectBase extends EventDispatcher{

    protected var _x_px:Number; // draw by this pixel coords
    protected var _y_px:Number;

    protected var _x:uint; // tile field pos
    protected var _y:uint;
    protected var _width:uint = 1; // tile field size
    protected var _length:uint = 1;
    protected var _debug_height:uint = 2; // so we got box here

    protected var _is_reachable:Boolean; // true - u can walk here
    protected var _is_occupied:Boolean;  // false - u can build here

    protected var _produce_class:Class; // produce smth.

    protected var _type:String; // use for bots etc.

    protected var _id:int = -1;
    public static var count:int = 0;
    public function ObjectBase() {
        _id = count++;
    }

    // move to exact tile, pos in definite point into the tile
    var pnt:Point = new Point();
    public function move_to(x, y):void{
        _x = x;
        _y = y;
        _x_px = _x * FieldController.TILE_WIDTH;
        _y_px = _y * FieldController.TILE_LENGTH;
    }

    // move to any field point but connected to exact tile
    public function move_to_px(x_px:int, y_px:int):void{
        _x_px = x_px;
        _y_px = y_px;
        _x = _x_px / FieldController.TILE_WIDTH;
        _y = _y_px / FieldController.TILE_LENGTH;
    }

    // use for z-order
    public function get topDiagonalId():int{
        return x + width - 1  + y;
    }

    // use for z-order
    public function get bottomDiagonalId():int{
        return x + y + length - 1;
    }

    public function get x():uint {
        return _x;
    }

    public function set x(value:uint):void {
        _x = value;
    }

    public function get y():uint {
        return _y;
    }

    public function set y(value:uint):void {
        _y = value;
    }

    public function get width():uint {
        return _width;
    }

    public function set width(value:uint):void {
        _width = value;
    }

    public function get length():uint {
        return _length;
    }

    public function set length(value:uint):void {
        _length = value;
    }

    public function get is_reachable():Boolean {
        return _is_reachable;
    }

    public function set is_reachable(value:Boolean):void {
        _is_reachable = value;
    }

    public function get is_occupied():Boolean {
        return _is_occupied;
    }

    public function set is_occupied(value:Boolean):void {
        _is_occupied = value;
    }

    public function intersects(o:ObjectBase):Boolean{
        var obj_1:Object = {x: x, y: y, w: width, h: length};
        var obj_2:Object = {x: o.x, y: o.y, w: o.width, h: o.length};
        return FieldUtils.intersects(obj_1, obj_2);
    }

//    public function contains_px(x_px:int, y_px:int):Boolean{
//
//    }

    public function contains(x:int, y:int):Boolean{
        return (this.x <= x && x < this.x + this.width) && (this.y <= y && y < this.y + this.length);
    }

    // TODO: make full functional
    // 01110
    // 12221
    // 12221
    // 01110
    public function get_nearest_points(grid:IsoGrid):Vector.<Point>{
        var res:Vector.<Point> = new Vector.<Point>();
        for(var i:int = x - 1; i <= x + width; i++){
            for(var j:int = y; j < y + length; j++){
                if(is_valid_nearest_point(i, j, grid))
                    res.push(new Point(i, j));
            }
        }

        for(var i:int = x; i < x + width; i++){
            for(var j:int = y - 1; j <= y + length; j++){
                if(is_valid_nearest_point(i, j, grid))
                    res.push(new Point(i, j));
            }
        }

        return res;
    }

    private function is_valid_nearest_point(i:uint, j:uint, grid:IsoGrid):Boolean{
        var t:IsoTile = grid.get_tile(i, j);
        return t && t.is_reachable;
    }

    public function get type():String {
        return _type;
    }

    public function set type(value:String):void {
        _type = value;
    }

    public function get debug_height():uint {
        return _debug_height;
    }

    public function set debug_height(value:uint):void {
        _debug_height = value;
    }

    public function get x_px():Number {
        return _x_px;
    }

    public function get y_px():Number {
        return _y_px;
    }

    public function set x_px(value:Number):void {
        _x_px = value;
    }

    public function set y_px(value:Number):void {
        _y_px = value;
    }

    public function get id():int {
        return _id;
    }

    public function get is_border():Boolean{
        return false;
    }

    public function get is_major():Boolean{
        return false;
    }

    public function get left ():int
    {
        return x;
    }

    /**
     * @inheritDoc
     */
    public function get right ():int
    {
        return x + width;
    }

    //////////////////f//////////////////////////////////////////////
    //	BACK / FRONT
    ////////////////////////////////////////////////////////////////

    /**
     * @inheritDoc
     */
    public function get back ():int
    {
        return y;
    }

    /**
     * @inheritDoc
     */
    public function get front ():int
    {
        return y + length;
    }

    public function get produce_class():Class {
        return _produce_class;
    }

    public function set produce_class(value:Class):void {
        _produce_class = value;
    }
}
}
