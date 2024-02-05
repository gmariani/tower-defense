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
	import flash.events.MouseEvent;
	import com.towerdefense.towers.Tower;
	import flash.events.EventDispatcher;
	
	public class UpgradePane extends Sprite {
		
		private var _objTowerInfo:Object;
		private var _txtName:TextField;
		private var _txtDmgLbl:TextField;
		private var _txtDamage:TextField;
		private var _txtRngLbl:TextField;
		private var _txtRange:TextField;
		private var _mcCoin:MovieClip;
		private var _txtCost:TextField;
		private var _mcIcon:UpgradeArrowIcon;
		private var _sprIconBG:Sprite;
		private var _selectedTower:Tower;
		
		public function UpgradePane():void {
			
			// Stat Label Format
			frmtStatLabel = new TextFormat();
			frmtStatLabel.color = 0x000000;
			frmtStatLabel.size = 10;
			frmtStatLabel.bold = true;
			frmtStatLabel.font = "Arial";
			
			// Stat Format
			frmtStat = new TextFormat();
			frmtStat.color = 0x000000;
			frmtStat.size = 10;
			frmtStat.font = "Arial";
			
			// Coin Format
			frmtStatCoin = new TextFormat();
			frmtStatCoin.color = 0xFFCC00;
			frmtStatCoin.size = 10;
			frmtStatCoin.font = "Arial";
			
			init();
		}
		
		private function init():void {
			
			// BG
			var _shpBG:Shape = new Shape();
			_shpBG.graphics.beginFill(0xffffff, .2);
			_shpBG.graphics.drawRoundRect(0, 0, 170, 70, 3);
			_shpBG.graphics.endFill();
			
			// Icon BG
			_sprIconBG = new Sprite();
			_sprIconBG.graphics.beginFill(0x000000, .2);
			_sprIconBG.graphics.drawRoundRect(0, 0, 50, 50, 3);
			_sprIconBG.graphics.endFill();
			_sprIconBG.x = 5;
			_sprIconBG.y = 5;
			_sprIconBG.addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
			_sprIconBG.addEventListener(MouseEvent.MOUSE_OUT, onIconOut);
			_sprIconBG.addEventListener(MouseEvent.CLICK, onUpgrade);
			
			// Icon
			_mcIcon = new UpgradeArrowIcon();
			_mcIcon.x = _sprIconBG.x + ((_sprIconBG.width / 2) - (_mcIcon.width / 2));
			_mcIcon.y = _sprIconBG.y + ((_sprIconBG.height / 2) - (_mcIcon.height / 2));
			_mcIcon.alpha = .5;
			_mcIcon.addEventListener(MouseEvent.MOUSE_OVER, onIconOver);
			_mcIcon.addEventListener(MouseEvent.MOUSE_OUT, onIconOut);
			_mcIcon.addEventListener(MouseEvent.CLICK, onUpgrade);			
			
			// Damage Label
			_txtDmgLbl = addTextField( 55, 17 );
			_txtDmgLbl.text = "Dmg";
			_txtDmgLbl.setTextFormat(frmtStatLabel);
			
			// Damage
			_txtDamage = addTextField( _txtDmgLbl.x + _txtDmgLbl.width, _txtDmgLbl.y);
			_txtDamage.text = "100";
			_txtDamage.setTextFormat(frmtStat);
			
			// Range Label
			_txtRngLbl = addTextField( 105, _txtDmgLbl.y );
			_txtRngLbl.text = "Rng";
			_txtRngLbl.setTextFormat(frmtStatLabel);
			
			// Range
			_txtRange = addTextField( _txtRngLbl.x + _txtRngLbl.width, _txtRngLbl.y);
			_txtRange.text = "190";
			_txtRange.setTextFormat(frmtStat);
			
			// Add Coin Icon
			_mcCoin = new CoinIcon();
			_mcCoin.x = _txtDmgLbl.x + 5;
			_mcCoin.y = 35;
			
			// Cost
			_txtCost = addTextField( _mcCoin.x + _mcCoin.width, _mcCoin.y - 5 );
			_txtCost.text = "2000";
			_txtCost.setTextFormat(frmtStatCoin);
			
			// Name Label
			_txtName = addTextField( 55, 5 );
			_txtName.width = 110;
			_txtName.wordWrap = true;
			_txtName.multiline = true;
			_txtName.setTextFormat(frmtStatLabel);
			
			addChild(_shpBG);			
			addChild(_sprIconBG);
			addChild(_mcIcon);
			addChild(_txtDmgLbl);
			addChild(_txtDamage);
			addChild(_txtRngLbl);
			addChild(_txtRange);
			addChild(_txtCost);
			addChild(_mcCoin);
			addChild(_txtName);
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
		
		public function setTower(selectedTower):void {			
			_selectedTower = selectedTower;
			_objTowerInfo = _selectedTower._towerInfo;
			/*_dataObj.label
		    _dataObj.damage
		    _dataObj.range
		    _dataObj.speed
			_dataObj.nextLabel
			_dataObj.nextDamage
			_dataObj.nextRange
			_dataObj.nextPrice
			_dataObj.nextSpeed*/
			_txtName.text = _objTowerInfo.nextLabel;
			_txtName.setTextFormat(frmtStatLabel);
			_txtCost.text = _objTowerInfo.nextPrice;
			_txtCost.setTextFormat(frmtStatCoin);
			_txtRange.text = _objTowerInfo.nextRange;
			_txtRange.setTextFormat(frmtStat);
			_txtDamage.text = _objTowerInfo.nextDamage;
			_txtDamage.setTextFormat(frmtStat);
			
			var newY:int = _txtName.y + _txtName.textHeight + 3;
			_txtDmgLbl.y = newY;
			_txtDamage.y = newY;
			_txtRngLbl.y = newY;
			_txtRngLbl.x = _txtDamage.x + _txtDamage.width + 3;
			_txtRange.y = newY;
			_txtRange.x = _txtRngLbl.x + _txtRngLbl.width;			
			_mcCoin.y = newY + 18;
			_txtCost.y = _mcCoin.y - 5;
			visible = true;
		}
		
		private function onUpgrade(e:Event):void {
			dispatchEvent(new Event("upgradeTower", true));
		}
		
		public function get _tower():Tower {
			return _selectedTower;
		}
		
		private function onIconOver(e:Event):void {
			_mcIcon.alpha = 10;
		}
		
		private function onIconOut(e:Event):void {
			_mcIcon.alpha = .5;
		}
	}
}