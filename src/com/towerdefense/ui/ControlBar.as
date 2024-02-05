package com.towerdefense.ui {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.display.GradientType;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import fl.controls.UIScrollBar;
	import com.towerdefense.ui.UpgradePane;
	import com.towerdefense.towers.Tower;
	
	public class ControlBar	extends Sprite {

		private var STAGE_WIDTH:int;
		private var frmtMessage:TextFormat;
		private var frmtClock:TextFormat;
		private var _timeRemain:int;
		private var txtMessage:TextField;
		private var upgradePane:UpgradePane;
		private var __towerType:String;
		private var __towerCost:int;
		private var lower_shp:Shape;
		private var sbMessage:UIScrollBar;
		private var __mode:int;
		
		public function ControlBar(w:int, startTime:int):void {
			STAGE_WIDTH = w;
			_timeRemain = startTime;
			
			// Message Format
			frmtMessage = new TextFormat();
			frmtMessage.color = 0x000000;
			frmtMessage.size = 10;
			frmtMessage.font = "Arial";
			
			// Clock Format
			frmtClock = new TextFormat();
			frmtClock.bold = true;
			frmtClock.color = 0xFF6600;
			frmtClock.size = 15;
			frmtClock.font = "Arial";
			
			init();			
		}
		
		private function init():void {
			// Upper Toolbar
			lower_shp = new Shape();
			var colors2:Array = [0x2E4052, 0x4E70A0, 0x395782, 0x3A5389, 0x2E416B];
			var alphas2:Array = [100, 100, 100, 100, 100];
			var ratios2:Array = [0, 64, 120, 180, 255];
			var matr2:Matrix = new Matrix();
			matr2.createGradientBox(STAGE_WIDTH, 200, 90 * (Math.PI/180));
			lower_shp.graphics.beginGradientFill(GradientType.LINEAR, colors2, alphas2, ratios2, matr2);
			lower_shp.graphics.drawRect(0, 0, STAGE_WIDTH, 80);
			lower_shp.graphics.endFill();
			this.addChild(lower_shp);
			
			// Message
			txtMessage = addTextField( 7.7, 8.7 );
			txtMessage.autoSize = TextFieldAutoSize.NONE;
			txtMessage.selectable = true;			
			txtMessage.wordWrap = true;
			txtMessage.multiline = true;		
			txtMessage.height = 65;
			txtMessage.width = 190;
			txtMessage.text = "Welcome to Flash Tower Defense";
			txtMessage.setTextFormat(frmtMessage);
			
			// Message BG
			var shpMessage:Shape = new Shape();
			shpMessage.graphics.beginFill(0xffffff);
			shpMessage.graphics.drawRoundRect(0, 0, 205, 68, 3);
			shpMessage.graphics.endFill();
			shpMessage.x = 5;
			shpMessage.y = 6;
			
			// Message ScrollBar
			sbMessage = new UIScrollBar();
			sbMessage.x = 195;
			sbMessage.y = 8;
			sbMessage.width = 15;
			sbMessage.height = 65;
			sbMessage.scrollTarget = txtMessage;
			sbMessage.update();
			
			this.addChild(shpMessage);
			this.addChild(sbMessage);
			this.addChild(txtMessage);
			
			// Clock
			txtClock = addTextField( 80, -25 );
			txtClock.text = String(_timeRemain);			
			txtClock.setTextFormat(frmtClock);
			// Clock Label
			var txtClockLabel:TextField = addTextField( 5, -25 );
			txtClockLabel.text = "Time Left:";
			txtClockLabel.setTextFormat(frmtClock);			
			this.addChild(txtClock);
			this.addChild(txtClockLabel);
			
			// Upgrade Pane
			upgradePane = new UpgradePane();
			upgradePane.x = 215;
			upgradePane.y = 5;
			upgradePane.visible = false;
			this.addChild(upgradePane);
			
			// Shop Pane
			shopPane = new ShopPane();
			shopPane.x = 215;
			shopPane.y = 5;
			shopPane.addEventListener("buildTower", onStartBuild);
			this.addChild(shopPane);
			
			__mode = 0;
		}
		
		/**
		 * addTextField
		 *
		 * @param lbl = Textfield name
		 * @param x	= X coord
		 * @param y	= Y coord
		 * @param frmt	= Text format to apply to textfield
		 * @return
		 *
		*/
		private function addTextField(x:int, y:int):TextField {
			var txtTemp:TextField = new TextField();
			txtTemp.embedFonts = true;
			txtTemp.antiAliasType = AntiAliasType.ADVANCED;
			txtTemp.autoSize = TextFieldAutoSize.LEFT;
			txtTemp.selectable = false;
			txtTemp.x = x;
			txtTemp.y = y;
			return txtTemp;
		}
		
		public function get _selectedType():int {
			return _towerType;
		}
		
		public function set _clock(n:int):void {
			_timeRemain = n;
			txtClock.text = String(_timeRemain);
			txtClock.setTextFormat(frmtClock);
		}
		
		public function addMessage(str:String):void {
			txtMessage.text += "\n" + str;
			txtMessage.setTextFormat(frmtMessage);
			sbMessage.update();
			sbMessage.scrollPosition = sbMessage.maxScrollPosition;			
		}
		
		private function onStartBuild(e:Event):void {			
			__towerType = e.currentTarget._towerType;
			__towerCost = e.currentTarget._towerCost;
			dispatchEvent(new Event("buildTower"));
		}
		
		public function get _towerType():String {
			return __towerType;
		}
		
		public function get _towerCost():String {
			return __towerCost;
		}
		
		public function get _hitArea():Shape {
			return lower_shp;
		}
		
		public function resetMessage():void {
			txtMessage.text = "Welcome to Flash Tower Defense";
			txtMessage.setTextFormat(frmtMessage);
			sbMessage.update();
			sbMessage.scrollPosition = sbMessage.maxScrollPosition;		
		}
		
		public function showUpgrade(selectedTower:Tower):void {
			upgradePane.setTower(selectedTower);
			upgradePane.visible = true;
			shopPane.visible = false;
			__mode = 1;
		}
		
		public function showShop():void {
			upgradePane.visible = false;
			shopPane.visible = true;
			__mode = 0;
		}
		
		public function get _mode():int {
			return __mode;
		}
	}
}