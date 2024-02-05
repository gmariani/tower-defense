package com.towerdefense.ui{

	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.DropShadowFilter;
	import flash.display.GradientType;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.display.StageQuality;

	public class MenuBar extends Sprite {

		private var filterDropShadow:DropShadowFilter;
		private var arrayFilters:Array;
		private var frmtMenuBar:TextFormat;
		private var frmtButton:TextFormat;
		private var frmtGrey:TextFormat;
		private var txtMoney:TextField;
		private var txtLumber:TextField;
		private var txtCitizen:TextField;
		private var txtWave:TextField;
		private var STAGE_WIDTH:int;

		public function MenuBar(w:int):void {
			STAGE_WIDTH = w;

			// Toolbar Format
			frmtMenuBar = new TextFormat();
			frmtMenuBar.bold = false;
			frmtMenuBar.color = 0xFFFFFF;
			frmtMenuBar.size = 9;
			frmtMenuBar.font = "Arial";

			// Toolbar Button Format
			frmtButton = new TextFormat();
			frmtButton.bold = false;
			frmtButton.color = 0xFFFFFF;
			frmtButton.size = 10;
			frmtButton.font = "Arial";

			// Grey Format
			frmtGrey = new TextFormat();
			frmtGrey.bold = true;
			frmtGrey.color = 0xCCCCCC;
			frmtGrey.size = 9;
			frmtGrey.font = "Arial";

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

			// Upper Toolbar
			var shpUpper:Shape = new Shape();
			var colors:Array = [0x2E4052, 0x4E70A0, 0x395782, 0x3A5389, 0x2E416B];
			var alphas:Array = [100, 100, 100, 100, 100];
			var ratios:Array = [0, 64, 120, 180, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(STAGE_WIDTH, 20, 90 * (Math.PI/180));
			shpUpper.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			shpUpper.graphics.drawRect(0, 0, STAGE_WIDTH, 20);
			shpUpper.graphics.endFill();
			this.addChild(shpUpper);

			// Wave Pane
			var txtWaveLabel:TextField = addTextField( 400, 3 );			
			txtWaveLabel.text = "Wave";
			txtWaveLabel.setTextFormat(frmtMenuBar);
			txtWave = addTextField( txtWaveLabel.x + txtWaveLabel.width + 2, 3 );
			txtWave.text = "0";
			txtWave.setTextFormat(frmtMenuBar);
			this.addChild(txtWave);
			this.addChild(txtWaveLabel);

			// Money
			txtMoney = addDisplayItem(456, 3, 24, "Money");

			// Lumber
			txtLumber = addDisplayItem(498, 3, 16, "Tree");

			// Citizens
			txtCitizen = addDisplayItem(530, 3, 16, "Lives");

			// Add Quality button
			var btnQuality:SimpleButton = addButton("Quality");
			btnQuality.addEventListener(MouseEvent.CLICK, onQualityClick);
			btnQuality.x = 5;
			this.addChild(btnQuality);

			// Add Reset button
			var btnReset:SimpleButton = addButton("Reset");
			btnReset.addEventListener(MouseEvent.CLICK, onResetClick);
			btnReset.x = 45;
			this.addChild(btnReset);
		}
		public function updateToolbarText(tf:String, label:String):void {
			var t:TextField = this[tf];
			t.text = String(label);
			t.setTextFormat(frmtMenuBar);
			t.filters = arrayFilters;
			t.embedFonts = true;
		}
		
		private function onQualityClick(e:Event):void {
			// Toggle Quality
			if (stage.quality == "HIGH") {
				stage.quality = StageQuality.LOW;
			} else if (stage.quality == "LOW") {
				stage.quality = StageQuality.HIGH;
			}
		}
		
		private function onResetClick(e:Event):void {
			dispatchEvent(new Event("resetGame"));
		}
		/**
		 * addTextField
		 *
		 * @param lbl = Textfield name
		 * @param x= X coord
		 * @param y= Y coord
		 * @param frmt= Text format to apply to textfield
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
		private function addDisplayItem(x:int, y:int, w:int, strIcon:String):TextField {
			var h:int = 14;
			var colors:Array = [0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [.6, .14];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
			var txtTemp:TextField = new TextField();
			var shpTemp:Shape = new Shape();
			var mcTempIcon:MovieClip;

			switch (strIcon) {
				case "Lives" :
					mcTempIcon = new LivesIcon();
					break;
				case "Tree" :
					mcTempIcon = new TreeIcon();
					break;
				case "Money" :
					mcTempIcon = new CoinIcon();
					break;
				default :
					mcTempIcon = new MovieClip();
			}
			matrix.createGradientBox(24, 14, 90 * (Math.PI/180));
			shpTemp.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			shpTemp.graphics.lineStyle(1, 0xCCCCCC, .27);
			//drawRoundRect(x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Number);
			shpTemp.graphics.drawRoundRect(x, y, w, h, 2);
			shpTemp.graphics.endFill();
			mcTempIcon.x = x - 10;
			mcTempIcon.y = (h / 2) - (mcTempIcon.height / 2) + 3;
			txtTemp = addTextField( x, 3 );
			txtTemp.text = "0";
			txtTemp.setTextFormat(frmtMenuBar);
			txtTemp.filters = arrayFilters;
			txtTemp.embedFonts = true;
			this.addChild(shpTemp);
			this.addChild(mcTempIcon);
			this.addChild(txtTemp);
			return txtTemp;
		}
		
		private function addButton(label:String):SimpleButton {
			var _btn:SimpleButton = new SimpleButton();
			var _text:String = label;
			var _x:int = 1;
			var _y:int = -1;
			var _filters:Array = [filterDropShadow];
			var up_spr:Sprite = new Sprite();
			var up_tf:TextField = addTextField( _x, _y);

			up_tf.text = _text;
			up_tf.setTextFormat(frmtButton);
			up_tf.filters = _filters;
			up_tf.embedFonts = true;

			var _w:int = up_tf.width + 4;
			var _h:int = up_tf.height + .5;
			var up_shp:Shape = new Shape();
			var up_colors:Array = [0x547992, 0x7095BA, 0x4A6B9B, 0x314471, 0x496FA5];
			var _alphas:Array = [100, 100, 100, 100, 100];
			var _ratios:Array = [0, 64, 120, 180, 255];
			var _matr:Matrix = new Matrix();

			_matr.createGradientBox(_w, _h, 90 * (Math.PI/180));
			up_shp.graphics.beginGradientFill(GradientType.LINEAR, up_colors, _alphas, _ratios, _matr);
			up_shp.graphics.lineStyle(1, 0x000000, .27);
			up_shp.graphics.drawRoundRect(0, 0, _w, _h, 2);
			up_shp.graphics.endFill();
			up_spr.addChild(up_shp);
			up_spr.addChild(up_tf);

			var over_spr:Sprite = new Sprite();
			var over_tf:TextField = addTextField( _x, _y);
			over_tf.text = _text;
			over_tf.setTextFormat(frmtButton);
			over_tf.filters = _filters;
			over_tf.embedFonts = true;
			var over_shp:Shape = new Shape();
			var over_colors:Array = [0x6D93AB, 0x87A7C5, 0x6485B5, 0x425A93, 0x6184B8];
			over_shp.graphics.beginGradientFill(GradientType.LINEAR, over_colors, _alphas, _ratios, _matr);
			over_shp.graphics.lineStyle(1, 0x000000, .27);
			over_shp.graphics.drawRoundRect(0, 0, _w, _h, 2);
			over_shp.graphics.endFill();
			over_spr.addChild(over_shp);
			over_spr.addChild(over_tf);

			var down_spr:Sprite = new Sprite();
			var down_tf:TextField = addTextField( _x, _y);
			down_tf.text = _text;
			down_tf.setTextFormat(frmtButton);
			down_tf.filters = _filters;
			down_tf.embedFonts = true;
			var down_shp:Shape = new Shape();
			var down_colors:Array = [0x47677C, 0x5381AC, 0x3D577E, 0x29395F, 0x37537B];
			down_shp.graphics.beginGradientFill(GradientType.LINEAR, down_colors, _alphas, _ratios, _matr);
			down_shp.graphics.lineStyle(1, 0x000000, .27);
			down_shp.graphics.drawRoundRect(0, 0, _w, _h, 2);
			down_shp.graphics.endFill();
			down_spr.addChild(down_shp);
			down_spr.addChild(down_tf);

			_btn.upState = up_spr;
			_btn.overState = over_spr;
			_btn.downState = down_spr;
			_btn.hitTestState = up_spr;
			_btn.y = 2.5;
			return _btn;
		}
	}
}