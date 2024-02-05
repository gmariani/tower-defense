	/**
	* 	Copyright (c) 2007 Course Vector.  All Rights Reserved.
	* 	#############################################################################
	* 	#	TOWER DEFENSE	#
	* 	#############################################################################
	*
	* 	@CLASS: QuickQuote
	* 	@ORIGINAL AUTHOR: Gabriel Mariani
	*
	* 	$File: TowerDefense.as
	*   $Author: gmariani $
	* 	$Revision: #1 $
	* 	$Date: 2007/01/19 $
	*
	* 	@PURPOSE:
	*			Warcraft 3 tower game remake
	*/

package {

	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.StageQuality;
	import flash.ui.Keyboard;
	import flash.events.*;
	//import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.utils.*;
	//import flash.utils.Timer;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	
	import com.Enemy;
	import com.Bullet;
	import com.Tower;
	import com.Towers.*;
	import com.ControlBar;
	import com.ericfeminella.effects.*;
	import flash.filters.BlurFilter;
	import com.coursevector.effects.TweenBlur;
	
	//[SWF(width="550", height="500", backgroundColor="#999999", frameRate="25")]
	

	////////////////////////////////////////////////////////////////////////////////////
	// TOWER DEFENSE CLASS /////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////

	public class TowerDefense extends Sprite {

		private var STAGE_WIDTH:int = 550;
		private var STAGE_HEIGHT:int = 500;
		private var INSTRUCTIONS:String = "This game is based on the popular Warcraft3 \"Element Tower Defense\" and the Starcraft \"Turret Defense\" gameplay. The object of the game is to prevent the hordes (waves) of monsters from getting to the castle by building element towers near the path.\nYour menu is located at the bottom of your screen. You can choose from a number of different elements to build towers from. When you click on a tower that has been built, the build menu becomes an upgrade menu, allowing you to make you towers stronger.\nThe monsters will spawn every 20 seconds. Their health will be multiplied by 1.25 with every wave. If your towers fail to kill the monsters, and they do get to the castle, a civilian of your castle will die. When all your civillians die, the game will be over.\nEvery game experience is different every time you play depending on the position, elements, and upgrades you choose for your towers.\nThe creator of this game scored 90. Can you beat that? Click \"Start\" to start the game.Press [SpaceBar] To Skip To Next Wave";
		private var ATK_DELAY:int = 5;		
		private var START_LIVES:int = 10;
		private var START_TIME:int = 5;
		private var START_HEALTH:int = 5;
		private var START_SPEED:int = 5;
		private var START_INCOME:int = 1;
		private var ENEMY_AMOUNT:int = 1;

		private var _mode:int = 0;
		private var _lives:int = START_LIVES;
		private var _wave:int = 0;
		private var _waveTime:int = START_TIME; // Maye increase this based on the level?
		private var _timeRemain:int = _waveTime;
		private var _health:uint = START_HEALTH;
		private var _speed:int = START_SPEED;
		private var _income:int = START_INCOME;
		private var _money:int = 0;
		private var _lumber:int = 0;
		private var _msgTime:int;
		private var _towerList:Array;
		private var _enemyList:Array;		
		private var _timer:Timer;
		private var _enemyTimer:Timer;
		private var _enemyCounter:int = 0;
		private var _gameOver:Boolean = false;

		// Text Formats
		//[Embed(source="C:\WINDOWS\Fonts\ARIAL.TTF", fontName="Arial", mimeType="application/x-font-truetype")]
		//[Embed(systemFont="Arial", fontName="Arial*", mimeType="application/x-font-truetype")]
		private var _arial_str:String;
		private var orange_frmt:TextFormat;
		private var grey_frmt:TextFormat;
		private var yellow_frmt:TextFormat;
		private var yellow2_frmt:TextFormat;
		private var black_frmt:TextFormat;
		private var white_frmt:TextFormat;
		private var toolbar_frmt:TextFormat;
		private var toolbarBtn_frmt:TextFormat;
		private var dropShadow_filter:DropShadowFilter;
		// Assets
		private var preLoader_spr:Sprite; // Preloader Container
		private var instructions_spr:Sprite; // Instructions Container
		private var game_spr:Sprite; // MovieClip Container
		private var toolbar_spr:Sprite;
		private var controlbar_spr:Sprite;
		private var lose_spr:Sprite;
		// Preloader Assets
		private var label_tf:TextField;
		private var info_tf:TextField;
		// Game Assets
		private var clock_tf:TextField;
		private var wave_tf:TextField;
		private var money_tf:TextField;
		private var citizen_tf:TextField;
		private var lumber_tf:TextField;
		private var msg_tf:TextField;
		private var guideRect_spr:Sprite;
		private var menuBar:ControlBar; // Control Bar
		private var income_tf:TextField;
		private var toolbar_filters:Array;
		private var _blurTween:TweenBlur;
		// Lose Assets
		private var score_tf:TextField;
		

		/**
		 * TowerDefense
		 *
		 * Construct
		 *
		 */
		public function TowerDefense():void {
			// Hide the default right-click menu items
			stage.showDefaultContextMenu = false;

			// Toolbar Format
			toolbar_frmt = new TextFormat();
			toolbar_frmt.bold = false;
			toolbar_frmt.color = 0xFFFFFF;
			toolbar_frmt.size = 9;
			toolbar_frmt.font = "Arial*";
			
			// Toolbar Button Format
			toolbarBtn_frmt = new TextFormat();
			toolbarBtn_frmt.bold = false;
			toolbarBtn_frmt.color = 0xFFFFFF;
			toolbarBtn_frmt.size = 10;
			toolbarBtn_frmt.font = "Arial*";
		
			// Orange Format
			orange_frmt = new TextFormat();
			orange_frmt.bold = true;
			orange_frmt.color = 0xFF9900;
			orange_frmt.size = 24;
			orange_frmt.font = "Arial*";

			// Grey Format
			grey_frmt = new TextFormat();
			grey_frmt.bold = true;
			grey_frmt.color = 0xCCCCCC;
			grey_frmt.size = 9;
			grey_frmt.font = "Arial*";

			// Yellow Format
			yellow_frmt = new TextFormat();
			yellow_frmt.bold = true;
			yellow_frmt.color = 0xFFCC00;
			yellow_frmt.size = 9;
			yellow_frmt.font = "Arial*";

			// Sunburst Yellow Format
			yellow2_frmt = new TextFormat();
			yellow2_frmt.bold = true;
			yellow2_frmt.color = 0xFFFF66;
			yellow2_frmt.size = 9;
			yellow2_frmt.font = "Arial*";

			// Black Format
			black_frmt = new TextFormat();
			black_frmt.bold = true;
			black_frmt.color = 0x000000;
			black_frmt.size = 12;
			black_frmt.font = "Arial*";
			black_frmt = black_frmt;

			// White Format
			white_frmt = new TextFormat();
			white_frmt.color = 0xFFFFFF;
			white_frmt.size = 9;
			white_frmt.font = "Arial*";
			
			// Drop Shadow
			dropShadow_filter = new DropShadowFilter();
			dropShadow_filter.color = 0x000000;
			dropShadow_filter.alpha = .3;
			dropShadow_filter.blurX = 2;
			dropShadow_filter.blurY = 2;
			dropShadow_filter.angle = -45 * (Math.PI/180);
			dropShadow_filter.distance = 2;
			dropShadow_filter.quality = 3;

			buildPreLoader();
			
			// Temp Border
			var border:Shape = new Shape();
			border.graphics.lineStyle(1, 0xFF0000);
			border.graphics.drawRect(0,0,STAGE_WIDTH,STAGE_HEIGHT);
			stage.addChild(border);
		}

		/**
		 * buildPreLoader
		 *
		 * Build preloader, and preload the game
		 *
		 */
		private function buildPreLoader():void {
			// Show Preloader
			preLoader_spr = new Sprite();
			preLoader_spr.name = "preLoader_spr";
			addChild(preLoader_spr);

			var bg:Shape = new Shape();
			bg.graphics.beginFill( 0x000000, .3 );
			bg.graphics.drawRoundRect(0, 0, 100, 30, 10);
			bg.graphics.endFill();
			preLoader_spr.addChild( bg );

			label_tf = addTextField( 0, 0 );
			label_tf.text = "Please wait while loading...";
			label_tf.setTextFormat(black_frmt);
			preLoader_spr.addChild(label_tf);

			info_tf = addTextField( 0, 10 );
			info_tf.text = "0k of ?k";
			info_tf.setTextFormat(black_frmt);
			preLoader_spr.addChild(info_tf);
			
			// Add loaderInfo listeners
			loaderInfo.addEventListener(Event.INIT, onPreloadInit);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onPreloadProgress);
			loaderInfo.addEventListener(Event.COMPLETE, onPreloadComplete);
		}

		private function onPreloadInit(e:Event):void {
			var lb:int = e.target.bytesLoaded / 1000;
			var ltl:int = e.target.bytesTotal / 1000;
			var ratio:int = lb/ltl*100;
			info_tf.text = lb + "k of " + ltl + "k / " + ratio + "%";
		}

		private function onPreloadProgress(e:ProgressEvent):void {
			var lb:int = e.bytesLoaded / 1000;
			var ltl:int = e.bytesTotal / 1000;
			var ratio:int = lb/ltl*100;
			info_tf.text = lb + "k of " + ltl + "k / " + ratio + "%";
		}

		private function onPreloadComplete(e:Event):void {
				var lb:int = e.target.bytesLoaded / 1000;
				var ltl:int = e.target.bytesTotal / 1000;
				var ratio:int = lb/ltl*100;
				label_tf.text = "Loading completed.";
				info_tf.text = lb + "k of " + ltl + "k / " + ratio + "%";
				removeChild(preLoader_spr);
				buildInstructions();
		}

		/**
		 * buildInstructions
		 *
		 * Build game instructions, display before game
		 *
		 */
		private function buildInstructions():void {
			instructions_spr = new Sprite();
			addChild(instructions_spr);

			// Attach Logo
			/*var logo:Logo = new Logo();
			logo.x = 111;
			logo.y = 5;
			instructions_spr.addChild( logo );*/

			// Attach Instructions BG
			var bg_shp:Shape = new Shape();
			bg_shp.graphics.beginFill( 0x000000, .3 );
			bg_shp.graphics.drawRoundRect(0, 0, 495, 305, 10);
			bg_shp.graphics.endFill();
			bg_shp.x = 30;
			bg_shp.y = 125;
			instructions_spr.addChild( bg_shp );

			// Attach Instructions
			var inst_tf:TextField = addTextField( 45, 156 );
			inst_tf.height = 211;
			inst_tf.width = 478;
			inst_tf.wordWrap = true;
			inst_tf.text = INSTRUCTIONS;
			inst_tf.setTextFormat(black_frmt);
			instructions_spr.addChild( inst_tf );

			// Add Start button
			var startGame_btn:SimpleButton = new SimpleButton();
			var up_spr:Sprite = new Sprite();
			var over_spr:Sprite = new Sprite();
			
			var up_tf:TextField = addTextField( 0, 0 );
			up_tf.text = "Start";
			up_tf.setTextFormat(black_frmt);
			var grey_shp:Shape = new Shape();
			grey_shp.graphics.beginFill( 0x000000, .2 );
			grey_shp.graphics.drawRoundRect(0, 0, 105, 25, 10);
			grey_shp.graphics.endFill();
			up_spr.addChild(grey_shp);
			up_spr.addChild(up_tf);
			
			var over_tf:TextField = addTextField( 0, 0 );
			over_tf.text = "Start";
			over_tf.setTextFormat(black_frmt);
			var orange_shp:Shape = new Shape();
			orange_shp.graphics.beginFill( 0xFF6600, .5 );
			orange_shp.graphics.drawRoundRect(0, 0, 105, 25, 10);
			orange_shp.graphics.endFill();
			over_spr.addChild(orange_shp);
			over_spr.addChild(over_tf);

			startGame_btn.upState = up_spr;
			startGame_btn.overState = over_spr;
			startGame_btn.downState = over_spr;
			startGame_btn.hitTestState = over_spr;
			startGame_btn.addEventListener(MouseEvent.CLICK, onStartGameClick);
			startGame_btn.x = (bg_shp.x + bg_shp.width) - startGame_btn.width;
			startGame_btn.y = (bg_shp.y + bg_shp.height) + 30;
			instructions_spr.addChild(startGame_btn);

		}

		private function onStartGameClick(e:Event):void {
			// Remove Instructions
			removeChild(instructions_spr);

			// Start Game
			buildGame();
		}
	
		/**
		 * buildGame
		 *
		 * Build game interface. Sets default value
		 *
		 */
		private function buildGame():void {
			game_spr = new Sprite();
			addChild(game_spr);
			
			// Reset Tower/Enemy List
			_towerList = new Array();
			_enemyList = new Array();
			
			// DRAW BUILDABLE AREA //
			/////////////////////////			
			var hitArea_spr:Sprite = new Sprite();
			hitArea_spr.graphics.beginFill(0x0000ff, .3);
			hitArea_spr.graphics.moveTo(0,20);
			hitArea_spr.graphics.lineTo(30,20);
			hitArea_spr.graphics.lineTo(30,390);
			hitArea_spr.graphics.lineTo(180,390);
			hitArea_spr.graphics.lineTo(180,90);
			hitArea_spr.graphics.lineTo(480,90);
			hitArea_spr.graphics.lineTo(480,210);
			hitArea_spr.graphics.lineTo(270,210);
			hitArea_spr.graphics.lineTo(270,390);
			hitArea_spr.graphics.lineTo(510,390);			
			hitArea_spr.graphics.lineTo(510,360);
			hitArea_spr.graphics.lineTo(300,360);
			hitArea_spr.graphics.lineTo(300,240);
			hitArea_spr.graphics.lineTo(510,240);
			hitArea_spr.graphics.lineTo(510,60);
			hitArea_spr.graphics.lineTo(150,60);
			hitArea_spr.graphics.lineTo(150,360);
			hitArea_spr.graphics.lineTo(60,360);
			hitArea_spr.graphics.lineTo(60,20);
			hitArea_spr.graphics.lineTo(STAGE_WIDTH,20);
			hitArea_spr.graphics.lineTo(STAGE_WIDTH,420);
			hitArea_spr.graphics.lineTo(0,420);
			hitArea_spr.graphics.lineTo(0,20);
			hitArea_spr.graphics.endFill();
			game_spr.addChild(hitArea_spr);
			////////////////////////
			// END BUILDABLE AREA //			
			
			// DRAW TOOLBAR //
			//////////////////
			toolbar_spr = new Sprite();
			var dropShadow_filter:DropShadowFilter = new DropShadowFilter();
			dropShadow_filter.color = 0x000000;
			dropShadow_filter.alpha = .5;
			dropShadow_filter.blurX = 2;
			dropShadow_filter.blurY = 2;
			dropShadow_filter.angle = 45 * (Math.PI/180);
			dropShadow_filter.distance = 2;
			dropShadow_filter.quality = 3;
			toolbar_filters = [dropShadow_filter];
			
			// Upper Toolbar
			var upper_shp:Shape = new Shape();
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [0x2E4052, 0x4E70A0, 0x395782, 0x3A5389, 0x2E416B];
			var alphas:Array = [100, 100, 100, 100, 100];
			var ratios:Array = [0, 64, 120, 180, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(STAGE_WIDTH, 20, 90 * (Math.PI/180));
			upper_shp.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr);
			upper_shp.graphics.drawRect(0, 0, STAGE_WIDTH, 20);
			upper_shp.graphics.endFill();
			toolbar_spr.addChild(upper_shp);

			// Wave Pane
			wave_tf = addTextField( 355, 3 );
			wave_tf.text = String(_wave);
			wave_tf.setTextFormat(orange_frmt);
			var waveLabel_tf:TextField = addTextField( 320, 3 );
			waveLabel_tf.text = "Wave";
			waveLabel_tf.setTextFormat(grey_frmt);
			toolbar_spr.addChild(wave_tf);
			toolbar_spr.addChild(waveLabel_tf);

			// Money
			var money_shp:Shape = new Shape();
			var toolbar_colors:Array = [0xFFFFFF, 0xFFFFFF];
			var toolbar_alphas:Array = [.6, .14];
			var toolbar_ratios:Array = [0, 255];
			var money_matr:Matrix = new Matrix();
			money_matr.createGradientBox(24, 14, 90 * (Math.PI/180));
			money_shp.graphics.beginGradientFill(GradientType.LINEAR, toolbar_colors, toolbar_alphas, toolbar_ratios, money_matr);
			money_shp.graphics.lineStyle(1, 0xCCCCCC, .27);
			money_shp.graphics.drawRoundRect(455.8, 3, 24, 14, 2);			
			money_shp.graphics.endFill();
			money_tf = addTextField( 456, 3);
			money_tf.text = String(_money);
			money_tf.setTextFormat(toolbar_frmt);
			money_tf.filters = toolbar_filters;
			money_tf.embedFonts = true;
			toolbar_spr.addChild(money_shp);
			toolbar_spr.addChild(money_tf);
			
			// Lumber
			var lumber_shp:Shape = new Shape();
			var lumber_matr:Matrix = new Matrix();
			lumber_matr.createGradientBox(24, 14, 90 * (Math.PI/180));
			lumber_shp.graphics.beginGradientFill(GradientType.LINEAR, toolbar_colors, toolbar_alphas, toolbar_ratios, lumber_matr);
			lumber_shp.graphics.lineStyle(1, 0xCCCCCC, .27);
			lumber_shp.graphics.drawRoundRect(498, 3, 16, 14, 2);			
			lumber_shp.graphics.endFill();
			lumber_tf = addTextField( STAGE_HEIGHT, 3 );
			lumber_tf.text = String(_lumber);
			lumber_tf.setTextFormat(toolbar_frmt);
			lumber_tf.filters = toolbar_filters;
			lumber_tf.embedFonts = true;
			toolbar_spr.addChild(lumber_shp);
			toolbar_spr.addChild(lumber_tf);

			// Citizens
			var citizen_shp:Shape = new Shape();
			var citizen_matr:Matrix = new Matrix();
			citizen_matr.createGradientBox(24, 14, 90 * (Math.PI/180));
			citizen_shp.graphics.beginGradientFill(GradientType.LINEAR, toolbar_colors, toolbar_alphas, toolbar_ratios, citizen_matr);
			citizen_shp.graphics.lineStyle(1, 0xCCCCCC, .27);
			citizen_shp.graphics.drawRoundRect(530, 3, 16, 14, 2);			
			citizen_shp.graphics.endFill();
			citizen_tf = addTextField( 530, 3 );
			citizen_tf.text = String(_lives);
			citizen_tf.setTextFormat(toolbar_frmt);
			citizen_tf.filters = toolbar_filters;
			citizen_tf.embedFonts = true;
			toolbar_spr.addChild(citizen_shp);
			toolbar_spr.addChild(citizen_tf);						

			// Add Quality button
			var quality_btn:SimpleButton = addToolBarButton("Quality");
			quality_btn.addEventListener(MouseEvent.CLICK, onQualityClick);
			quality_btn.x = 5;
			toolbar_spr.addChild(quality_btn);
			
			// Add Reset button
			var reset_btn:SimpleButton = addToolBarButton("Reset");
			reset_btn.addEventListener(MouseEvent.CLICK, onQualityClick);
			reset_btn.x = 45;
			toolbar_spr.addChild(reset_btn);
			
			game_spr.addChild(toolbar_spr);
			/////////////////
			// END TOOLBAR //
			
			// DRAW CONTROLBAR //
			/////////////////////
			controlbar_spr = new Sprite();
			controlbar_spr.y = 420;
			
			// Upper Toolbar
			var lower_shp:Shape = new Shape();
			var colors2:Array = [0x2E4052, 0x4E70A0, 0x395782, 0x3A5389, 0x2E416B];
			var alphas2:Array = [100, 100, 100, 100, 100];
			var ratios2:Array = [0, 64, 120, 180, 255];
			var matr2:Matrix = new Matrix();
			matr2.createGradientBox(STAGE_WIDTH, 200, 90 * (Math.PI/180));
			lower_shp.graphics.beginGradientFill(GradientType.LINEAR, colors2, alphas2, ratios2, matr2);
			lower_shp.graphics.drawRect(0, 0, STAGE_WIDTH, 200);
			lower_shp.graphics.endFill();
			controlbar_spr.addChild(lower_shp);
			
			// Message Box
			msg_tf = new TextField();
			msg_tf.antiAliasType = AntiAliasType.ADVANCED;
			msg_tf.setTextFormat(yellow2_frmt);
			msg_tf.selectable = true;			
			msg_tf.wordWrap = true;
			msg_tf.border = true; 
			msg_tf.multiline = true;		
			msg_tf.height = 75;
			msg_tf.width = 200;
			msg_tf.x = 3;
			msg_tf.y = 2;
			msg_tf.text = "Welcome to Flash Tower Defense";
			controlbar_spr.addChild(msg_tf);
			
			// Clock
			clock_tf = addTextField( 50, -20 );
			clock_tf.text = String(_timeRemain);
			clock_tf.setTextFormat(orange_frmt);
			var clockLabel_tf:TextField = addTextField( 5, -20 );
			clockLabel_tf.text = "Seconds";
			clockLabel_tf.setTextFormat(grey_frmt);
			controlbar_spr.addChild(clock_tf);
			controlbar_spr.addChild(clockLabel_tf);
			
			game_spr.addChild(controlbar_spr);			
			////////////////////
			// END CONTROLBAR //

			// Create / Hide build rectangle
			guideRect_spr = new Sprite();
			guideRect_spr.graphics.beginFill( 0xFFFFFF, .5 );
			guideRect_spr.graphics.drawRect( (25/2)*-1, (25/2)*-1, 25, 25 );
			guideRect_spr.graphics.endFill();
			guideRect_spr.x = -100;
			guideRect_spr.y = -100;
			game_spr.addChild(guideRect_spr);
			
			// Create Controls
			//controlPanel:ControlPanel = new ControlPanel();
			
			//_root.attachMovie("arrow", "selArrow", 1000);
			
			// DRAW LOSE WINDOW//
			/////////////////////
			lose_spr = new Sprite();					

			var _filters:Array = [dropShadow_filter];
			
			var lose_bg_shp:Shape = new Shape();
			lose_bg_shp.graphics.beginFill( 0x000000, .3 );
			lose_bg_shp.graphics.drawRoundRect(0, 0, 200, 150, 10);
			lose_bg_shp.graphics.endFill();
			lose_bg_shp.filters = _filters;
			lose_spr.addChild( lose_bg_shp );
			
			score_tf = new TextField();
			score_tf.antiAliasType = AntiAliasType.ADVANCED;
			score_tf.autoSize = TextFieldAutoSize.LEFT;
			score_tf.selectable = false;
			score_tf.x = 50;
			score_tf.y = 50;
			lose_spr.addChild( score_tf );
			
			lose_spr.y = STAGE_HEIGHT / 2 - (lose_spr.height / 2);
			lose_spr.x = STAGE_HEIGHT / 2 - (lose_spr.width / 2);
			addChild(lose_spr);
			lose_spr.visible = false;
			/////////////////////
			// END LOSE WINDOW //
			
			// Set Events
			stage.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
			stage.focus = this;						

			// Start Timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function updateToolbarText(tf:TextField, label:String):void {
			tf.text = String(label);
			tf.setTextFormat(toolbar_frmt);
			tf.filters = toolbar_filters;
			tf.embedFonts = true;
		}
		
		private function addToolBarButton(label:String):SimpleButton {
			var _btn:SimpleButton = new SimpleButton();
			var _text:String = label;			
			var _x:int = 1;			
			var _y:int = 0;			
			var _filters:Array = [dropShadow_filter];
						
			var up_spr:Sprite = new Sprite();
			var up_tf:TextField = addTextField( _x, _y);
			up_tf.text = _text;
			up_tf.setTextFormat(toolbarBtn_frmt);
			up_tf.filters = _filters;
			up_tf.embedFonts = true;

			var _w:int = up_tf.width + 2;
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
			over_tf.setTextFormat(toolbarBtn_frmt);
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
			down_tf.setTextFormat(toolbarBtn_frmt);
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

		private function onQualityClick(e:Event):void {
			// Toggle Quality
			if(stage.quality == "HIGH") {
				stage.quality = StageQuality.LOW;
			} else if(stage.quality == "LOW") {
				stage.quality = StageQuality.HIGH;
			}
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
			var temp_tf:TextField = new TextField();
			temp_tf.antiAliasType = AntiAliasType.ADVANCED;
			temp_tf.autoSize = TextFieldAutoSize.LEFT;
			temp_tf.selectable = false;
			temp_tf.x = x;
			temp_tf.y = y;
			return temp_tf;
		}

		public function get _numEnemies():int {
			return _enemyList.length;
		}

		/**
		 * giveMoney
		 *
		 * Increases money based on income
		 *
		 */
		private function giveMoney():void {
			_money += Math.round(_income);
			updateToolbarText(money_tf, String(_money));
		}

		/**
		 * onCitizenKill
		 *
		 * Kills a citizen. If no more citizens left, end game
		 *
		 */
		public function onCitizenKill(e:Event):void {
			--_lives;
			if(_lives < 0) {
				_lives = 0;
			}
			updateToolbarText(citizen_tf, String(_lives));
			
			// Remove Enemy
			removeEnemy(e.target._id);

			if (_lives <= 0) endGame();
		}

		/**
		 * newWave
		 *
		 * Starts a new wave, increases income, and enemy health
		 *
		 */
		private function newWave():void {
			++_wave;			
			wave_tf.text = String(_wave);
			
			if((_wave % 5) == 0) {
				++_lumber;
				trace("Lumber: " + _lumber);
				updateToolbarText(lumber_tf, String(_lumber));
			}
			
			msg_tf.text = "Level " + String(_wave) + " <type> - " + _health + "hp, worth " + String(_income) + "g";
			
			// Create Enemies
			_enemyTimer = new Timer(250, ENEMY_AMOUNT);
			_enemyTimer.addEventListener(TimerEvent.TIMER, onEnemyTimer);
			_enemyTimer.start();
			_enemyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onEnemyComplete);
		}
		
		private function findEnemyIndex(id:int):int {
			var curId:int;
			for(var i:int = _enemyList.length; i>= 0; i--) {
				if(_enemyList[i] && _enemyList[i]._id == id) {
					curId = i;
				}
			}
			return curId;
		}
		
		private function onEnemyTimer(e:TimerEvent):void {
			if(!_gameOver) {
				_enemyList.push(new Enemy(_enemyCounter, _health, _speed));
				var curE:Enemy = _enemyList[findEnemyIndex(_enemyCounter)];
				curE.addEventListener( "enemyKilled", onEnemyKill );
				curE.addEventListener( "citizenKilled", onCitizenKill );			
				game_spr.addChild(curE);
				toolbar_spr
				var curLevel:int = game_spr.getChildIndex(curE);
				game_spr.setChildIndex(toolbar_spr, curLevel++);
				_enemyCounter++;
			}
		}
		
		private function onEnemyComplete(e:TimerEvent):void {
			// Increase health and income
			_health = _health * 1.1 + _wave * 8.6;
			_income = _income * 0.02 + _wave * 1.1;
		}

		/**
		 * gameSeconds
		 *
		 * Run every second, manages clock and when to add new waves
		 *
		 */
		private function onTimer(e:TimerEvent):void {
			_gameOver = false;
			// Clock Seconds
			--_timeRemain;
			if (_timeRemain <= 0) {
				// Reset Timer
				_timeRemain = _waveTime;
				newWave();
			}
			clock_tf.text = String(_timeRemain);

			// Hide Message?
			--_msgTime;
			if (_msgTime <= 0) showMessage("", true);
		}

		/**
		 * onKeyDown
		 *
		 * @param event = Detects when the player hits Spacebar to skip to next wave
		 *
		 */
		private function onKeyDown( event:KeyboardEvent ):void {
			if(event.keyCode == Keyboard.SPACE) {
				if (_enemyList.length == 0) {
					_timeRemain = 0;
				}
			}
		}

		/**
		 * onMouseMove
		 *
		 * @param event = Detects where the mouse is, manages building validity.
		 *
		 */
		private function onMouseMove( event:MouseEvent ):void {
			// If in build mode, show rectangle
			if (_mode == 1) {
				guideRect_spr.x = mouseX;
				guideRect_spr.y = mouseY;

				// Checks if you can build on the grass or not
				//********* Change it to event based, if you roll off the grass, disable. rollover a tower, disable. rollover a path, disable
				var numTowers:int = _towerList.length;
				for( var i:int = 0; i <= numTowers; i++) {
					var curTower:Tower = this["TWR_"+i];
					if(mouseX > 25) {
					// TODO: Fix targetting
					//if ((curTower.x - mouseX > 25 | curTower.x - mouseX <- 25 | (curTower.y - mouseY > 25 | curTower.y - mouseY < -25)) & mouseY < 400 & (!_root.hit1 & !_root.hit2 & !_root.hit3 & !_root.hit4 & !_root.hit5 & !_root.hit6 & !_root.hit7 & !_root.hit8)) {
						setBuild("valid");
					} else {
						setBuild("invalid");
					}
				}
			} else {
				guideRect_spr.x = -100;
				guideRect_spr.y = -100;
			}
		}

		/**
		 * createRectangle
		 *
		 * Draws a rounded rectangle. Used for drawing game interface
		 *
		 * @param x = X coord
		 * @param y = Y coord
		 * @param w = Width
		 * @param h = Height
		 *
		 */
		private function createRectangle(x:uint, y:uint, w:int, h:int):Shape {
			var temp_shp:Shape = new Shape();
			temp_shp.graphics.beginFill( 0x000000, .3 );
			temp_shp.graphics.drawRoundRect(x, y, w, h, 10);
			temp_shp.graphics.endFill();
			return temp_shp;
		}

		/**
		 * setBuild
		 *
		 * @param mode = Can be either "invalid" or valid". Uses to determine if a tower
		 * 				can be built on a square or not.
		 *
		 */
		private function setBuild(mode:String):void {
			if(mode == "invalid") {
				// Turn Red
				var color:ColorTransform = guideRect_spr.transform.colorTransform;
				color.redMultiplier = .5;
				guideRect_spr.transform.colorTransform = color;
			} else if(mode == "valid") {
				// Reset
				guideRect_spr.transform.colorTransform = new ColorTransform();
			}
		}

		/**
		 * showMessage
		 *
		 * Displays a message to the player for 3 seconds
		 *
		 * @param msg = Message to display
		 * @param reset = Used to reset the textfield to nothing
		 *
		 */
		private function showMessage(msg:String, reset:Boolean):void {
			//msg_tf.text = msg;

			if(!reset) {
				_msgTime = 3;
			}
		}

		/**
		 * removeBuildTarget
		 *
		 * Hides the build target when not in build mode
		 *
		 */
		private function removeBuildTarget():void {
			// remove the rectangle
		}

		/**
		 * onMouseDown
		 *
		 * Manages tower building
		 *
		 */
		private function onMouseDown( e:MouseEvent ):void {
			var allow:Boolean = false;
			if (_mode == 1) {
				var numTowers:int = _towerList.length;
				// TODO: Make sure tower is built only on grass and not on other towers
				/*if (_numTowers > 0) {
					for (var k:int = 0; k < _numTowers; k++) {
						var curTower = _towerList[k];
						if ((curTower.x - mouseX > 25 | curTower.x - mouseX < -25 | (curTower.y - mouseY > 25 | curTower.y - mouseY < -25)) & mouseY< 400 & (!_root.hit1 & !_root.hit2 & !_root.hit3 & !_root.hit4 & !_root.hit5 & !_root.hit6 & !_root.hit7 & !_root.hit8)) {
							allow = true;
							setBuild("valid");
							continue;
						}

						allow = false;
						setBuild("invalid");
						showMessage("Not Enough Space to Build There!", false);
					}

				} else if (mouseY < 400 & (!_root.hit1 & !_root.hit2 & !_root.hit3 & !_root.hit4 & !_root.hit5 & !_root.hit6 & !_root.hit7 & !_root.hit8)) {
					allow = true;
					setBuild("valid");
				} else {
					allow = false;
					setBuild("invalid");
					showMessage("Please Build on the Grass.", false);
				}*/

				if (allow) {
					buildTower(menuBar._selectedType, guideRect_spr.x, guideRect_spr.y);
					_mode = 0;
					guideRect_spr.x = -100;
					guideRect_spr.y = -100;
				} else {
					//"Can't Build There";
				}
			}
		}

		/**
		 * onEnemyKill
		 *
		 * When an enemy dies, increase money
		 *
		 */
		private function onEnemyKill( e:Event ):void {
			// Give Money
			giveMoney();
			
			// Remove Enemy
			removeEnemy(e.target._id);
		}
		
		private function removeEnemy(id:int):void {			
			var curId:int = findEnemyIndex(id);
			// Remove from Stage
			game_spr.removeChild(_enemyList[curId]);
			// Remove from List
			_enemyList.splice(curId, 1);			
		}

		/**
		 * buildTower
		 *
		 * Builds a tower at specified location
		 *
		 * @param type = The type of tower to build
		 * @param x = X coord
		 * @param y = Y coord
		 *
		 */
		private function buildTower (type:int, x:int, y:int):void {
			switch(type) {
				case 1 :
					// Fire Tower
					if (_money >= 18) {
						_money -= 18;
						_towerList.push(new FireTower(x, y));						
					}
					break;
				case 2 :
					// Nature Tower
					if (_money>=10) {
						_money -= 10;
						_towerList.push(new NatureTower(x, y));
					}
					break;
				case 3 :
					// Ice Tower
					if (_money>=15) {
						_money -= 15;
						_towerList.push(new IceTower(x, y));
					}
					break;
				case 4 :
					// Flower Tower
					if (_money>=2000) {
						_money -= 2000;
						_towerList.push(new FlowerTower(x, y));
					}
					break;
				case 5 :
					// Storm Tower
					if (_money>=40) {
						_money -= 40;
						_towerList.push(new StormTower(x, y));
					}
					break;
				default :
					//
			}
			// Add Listeners
			var curT:Tower = _towerList[_towerList.length - 1];
			curT._enemyList = _enemyList;
			addEventListener(curT.SELECT_TOWER, onSelectTurret );
			
		}
		
		private function onSelectTurret( e:Event ):void {
			// Get tower stats and upgrade stats
			var towerInfo:Object = e.target._towerInfo;
		}


		/**
		 * endGame
		 *
		 * Ends the game, blurs interface and displays end score window with reset button
		 *
		 */
		private function endGame():void {
			// Stop waves
			_timer.stop();
			
			_gameOver = true;			

			// Remove Enemies
			for(var i:int = _enemyList.length; i >= 0; i--) {
				if(_enemyList[i] != null) {
					game_spr.removeChild(_enemyList[i]);
				}				
			}
			_enemyList = new Array();
			
			// Blur Game interface
			_blurTween = new TweenBlur(game_spr, 5, .5);
			
			// Display Score
			score_tf.text = "Score: " + String(_wave);
			lose_spr.visible = true;
		}

		/**
		 * restartGame
		 *
		 * Removes score window and resets game
		 *
		 */
		private function restartGame():void {
			_gameOver = false;
			
			// Unblur
			_blurTween = new TweenBlur(game_spr, 0, .5);
				
			// Reset counter
			_wave = 0;
			_money = 0;
			_lumber = 0;
			_lives = START_LIVES;			
			_waveTime = START_TIME;			
			_health = START_HEALTH;
			_speed = START_SPEED;
			_income = START_INCOME;
			
			wave_tf.text = String(_wave);
			money_tf.text = String(_money);
			lumber_tf.text = String(_lumber);
			citizen_tf.text = String(_lives);
		
			// Delete all towers
			//
			
			// Reset Lives
			
			// Reset Money
			// Reset build mode
		}

	}
}