package com.towerdefense.ui {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import com.towerdefense.towers.*;
	
	public class ShopPane extends Sprite {
		
		private var _arrTowers:Array = ["fire", "ice", "nature", "storm", "flower"];
		private var _arrIconList:Array;
		private var filterDropShadow:DropShadowFilter;
		private var arrayFilters:Array;
		private var __towerType:String;
		private var __towerCost:int;
		
		public function ShopPane():void {
			
			// Stat Label Format
			frmtStatLabel = new TextFormat();
			frmtStatLabel.color = 0xffffff;
			frmtStatLabel.size = 10;
			frmtStatLabel.bold = true;
			frmtStatLabel.font = "Arial";
			
			// Stat Format
			frmtStat = new TextFormat();
			frmtStat.color = 0xffffff;
			frmtStat.size = 10;
			frmtStat.font = "Arial";
			
			// Coin Format
			frmtStatCoin = new TextFormat();
			frmtStatCoin.color = 0xFFCC00;
			frmtStatCoin.size = 10;
			frmtStatCoin.font = "Arial";
			
			// Init Shadow
			filterDropShadow = new DropShadowFilter();
			filterDropShadow.color = 0x000000;
			filterDropShadow.alpha = .5;
			filterDropShadow.blurX = 2;
			filterDropShadow.blurY = 2;
			filterDropShadow.angle = 45 * (Math.PI/180);
			filterDropShadow.distance = 2;
			filterDropShadow.quality = 3;
			arrayFilters = [filterDropShadow];
			
			init();
		}
		
		private function init():void {
			_arrIconList = new Array();
			var _nX:int = 5;
			
			// recurse through tower list, draw icon
			for(var i in _arrTowers) {
				switch(_arrTowers[i]) {
					case "fire" :
						_arrIconList.push(drawIcon(new FireTower(0,0)));						
						break;
					case "ice" :
						_arrIconList.push(drawIcon(new IceTower(0,0)));
						break;
					case "nature" :
						_arrIconList.push(drawIcon(new NatureTower(0,0)));
						break;
					case "storm" :
						_arrIconList.push(drawIcon(new StormTower(0,0)));
						break;
					case "flower" :
						_arrIconList.push(drawIcon(new FlowerTower(0,0)));
						break;						
				}
				
				_arrIconList[i].myType = _arrTowers[i];
				_arrIconList[i].x = _nX;
				_arrIconList[i].y = 5;
				_arrIconList[i].addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
				_arrIconList[i].addEventListener(MouseEvent.MOUSE_OUT, onIconOut);
				_arrIconList[i].addEventListener(MouseEvent.CLICK, onUpgrade);
				_arrIconList[i].alpha = .5;
				_nX += 55;
				addChild(_arrIconList[i]);
			}	
		}
		
		private function drawIcon(towerType):MovieClip {
			var _objTowerInfo:Object = towerType._towerInfo;
			var _mc:MovieClip = new MovieClip();
			
			// Icon BG
			var _sprIconBG:Sprite = new Sprite();
			_sprIconBG.graphics.beginFill(0x000000, .2);
			_sprIconBG.graphics.drawRoundRect(0, 0, 50, 50, 3);
			_sprIconBG.graphics.endFill();
			
			// Icon
			// do switch for all icon types
			var _mcIcon:MovieClip;
			switch(_objTowerInfo.type) {
				case "fire" :
					_mcIcon = new FlameIcon();
					break;
				case "ice" :
					_mcIcon = new IceIcon();
					break;
				case "nature" :
					_mcIcon = new NatureIcon();
					break;
				case "storm" :
					_mcIcon = new StormIcon();
					break;
				case "flower" :
					_mcIcon = new FlowerIcon();
					break;						
			}
			_mcIcon.x = (_sprIconBG.width / 2) - (_mcIcon.width / 2);
			_mcIcon.y = (_sprIconBG.height / 2) - (_mcIcon.height / 2);
			
			// Damage Label
			var _txtDmgLbl:TextField = addTextField( 50, 5 );
			_txtDmgLbl.autoSize = TextFieldAutoSize.RIGHT;
			_txtDmgLbl.text = "dmg";
			_txtDmgLbl.filters = arrayFilters;
			_txtDmgLbl.x -= _txtDmgLbl.width;
			_txtDmgLbl.setTextFormat(frmtStatLabel);
			
			// Damage
			var _txtDamage:TextField = addTextField( _txtDmgLbl.x, _txtDmgLbl.y);
			_txtDamage.autoSize = TextFieldAutoSize.RIGHT;
			_txtDamage.text = _objTowerInfo.damage;
			_txtDamage.filters = arrayFilters;
			_txtDamage.x = _txtDmgLbl.x - 2;
			_txtDamage.setTextFormat(frmtStat);
			
			// Coin Icon
			var _mcCoin:MovieClip = new CoinIcon();
			_mcCoin.x = 0;
			_mcCoin.y = _sprIconBG.height + 5;
			
			// Cost
			var _txtCost:TextField = addTextField( _mcCoin.x + _mcCoin.width, _mcCoin.y - 5 );
			_txtCost.text = _objTowerInfo.price;
			_txtCost.filters = arrayFilters;
			_txtCost.setTextFormat(frmtStatCoin);
			_mc.myCost = _objTowerInfo.price;
			
			_mc.addChild(_sprIconBG);
			_mc.addChild(_mcIcon);
			_mc.addChild(_txtDmgLbl);
			_mc.addChild(_txtDamage);
			_mc.addChild(_mcCoin);
			_mc.addChild(_txtCost);			
			
			delete towerType;
			return _mc;
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
		
		private function onUpgrade(e:Event):void {
			__towerType = e.currentTarget.myType;
			__towerCost = e.currentTarget.myCost;
			dispatchEvent(new Event("buildTower"));
		}
		
		private function onIconOver(e:Event):void {
			e.currentTarget.alpha = .9;
		}
		
		private function onIconOut(e:Event):void {
			e.currentTarget.alpha = .5;
		}
		
		public function get _towerType():String {
			return __towerType;
		}
		public function get _towerCost():String {
			return __towerCost;
		}
	}	
}