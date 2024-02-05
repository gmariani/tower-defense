/*
 * cv_ToolTip, Version 1.0.0.0
 * Generates a tooltip ona designated movieclip
 *
 * @author: Gabriel Mariani
 * @version: 1.0.0.0
 *
 * - Flash 8 Version -
 */
import cv.core.UIDraw;
import cv.core.UITween;
import flash.filters.DropShadowFilter;
//
class cv.util.cv_ToolTip extends cv.core.Construct {
	private static var tooltipInterval:Number;
	private static var ttMouse_listener:Object;
	private static var myTextFormat:TextFormat;
	private static var lastTime:Number = 0;
	private static var _globalMC:MovieClip;
	private static var _alpha_target:Number;
	private static var _alpha_moveInterval:Number;
	private static var _alpha_speed:Number;
	///////////////////////
	// ToolTip Construct       //
	///////////////////////
	public function cv_ToolTip(_mc:MovieClip, tS:Number, tF:String, tA:String, tI:Number) {
		myTextFormat = new TextFormat();
		myTextFormat.size = checkNum(tS, 9);
		myTextFormat.indent = checkNum(tI, 0);
		myTextFormat.font = checkStr(tF, "Verdana");
		myTextFormat.align = checkStr(tA, "Left");
		_globalMC = _mc;
		ttMouse_listener = new Object();
		ttMouse_listener.onMouseMove = function() {
			var targX:Number = _globalMC._xmouse + _globalMC._tt_mc.bg_mc._width / 2;
			var targY:Number = _globalMC._ymouse + _globalMC._tt_mc.bg_mc._height / 2 + 20;
			setCoord(_globalMC._tt_mc, targX, targY);
		};
	}
	/////////////////
	// Add ToolTip     //
	/////////////////
	public function addToolTip(_msg:String):Void {
		// Create text Field
		var _ToolTip = _globalMC.createEmptyMovieClip("_tt_mc", 9000);
		var ttBG = _ToolTip.createEmptyMovieClip("bg_mc", 10);
		_ToolTip.createTextField("lbl_txt", 11, 0, 0, 9, 9);
		// Format Text
		_ToolTip.lbl_txt.autoSize = "left";
		_ToolTip.lbl_txt.antiAliasType = "advanced";
		_ToolTip.lbl_txt.embedFonts = true;
		_ToolTip.lbl_txt.multiline = true;
		_ToolTip.lbl_txt.selectable = false;
		_ToolTip.lbl_txt.text = _msg;
		_ToolTip.lbl_txt.setTextFormat(myTextFormat);
		setCoord(_ToolTip.lbl_txt, 0 - _ToolTip.lbl_txt._width / 2, 0 - _ToolTip.lbl_txt._height / 2);
		// Draw Background Box
		var rectangle_obj = new Object();
		rectangle_obj.lineWidth = 1;
		rectangle_obj.lineAlpha = 50;
		UIDraw.class_Rectangle(ttBG, _ToolTip.lbl_txt._width + 5, _ToolTip.lbl_txt._height, 0xFAFAC7, 100, rectangle_obj);
		setCoord(ttBG, 0 - _ToolTip.lbl_txt._width / 2 - 2, 0 - _ToolTip.lbl_txt._height / 2 -1);
		// Add Shadow
		var filter:DropShadowFilter = new DropShadowFilter(3, 45, 0x000000, .4, 3, 3, 1, 3, false, false, false);
		var filterArray:Array = new Array();
		filterArray.push(filter);
		_ToolTip.filters = filterArray;
		//
		_ToolTip._alpha = 10;
		_ToolTip._visible = false;
		if (lastTime == 0) {
			lastTime = getTimer();
		}
		setCoord(_ToolTip, _globalMC._xmouse + ttBG._width / 2, _globalMC._ymouse + ttBG._height / 2 + 20);
		// Set Timer to fade in ToolTip after 1/2s
		clearInterval(tooltipInterval);
		tooltipInterval = setInterval(delayToolTip, 10, _ToolTip);
		// On Mouse Move, update ToolTip coordinates
		Mouse.addListener(ttMouse_listener);
	}
	////////////////////
	// Remove ToolTip    //
	////////////////////
	public function removeToolTip():Void {
		_globalMC._tt_mc.removeMovieClip();
		Mouse.removeListener(ttMouse_listener);
		clearInterval(tooltipInterval);
		lastTime = 0;
	}
	//
	///////////////////////////////////////////////////////////////////////////
	// Private Functions                                                                                                               //
	///////////////////////////////////////////////////////////////////////////
	//
	/////////////////////
	// Set Coordinates      //
	/////////////////////
	private static function setCoord(mc:MovieClip, nX:Number, nY:Number):Void {
		mc._x = nX;
		mc._y = nY;
	}
	///////////////////
	// Delay ToolTip     //
	///////////////////
	private function delayToolTip(_ToolTip:MovieClip):Void {
		// Show the ToolTip if the mouse RollOver after 1/2s
		if (!_ToolTip._visible && (getTimer() - lastTime) > 500) {
			_ToolTip._visible = true;
			UITween.class_Tween("_alpha", 100, _ToolTip);
			clearInterval(tooltipInterval);
		}
	}
}
