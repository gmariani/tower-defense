/**
* Copyright (c) 2007 Course Vector.  All Rights Reserved.
* #############################################################################
* #TOWER DEFENSE#
* #############################################################################
*
* @CLASS: QuickQuote
* @ORIGINAL AUTHOR: Gabriel Mariani
*
* $File: Main.as
* $Author: gmariani $
* $Revision: #1 $
* $Date: 2007/01/19 $
*
* @PURPOSE:
*  Warcraft 3 tower game remake
*/

/*
	TODO
	- update instructions window
	- update lose window
	- show current tower stats in upgrade pane
	- show current tower stats in tooltip?
*/

package com.towerdefense {

	import com.towerdefense.ui.UpgradePane;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.StageQuality;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.utils.*;
	import flash.utils.Timer;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;

	import com.towerdefense.Enemy;
	import com.towerdefense.Bullet;
	import com.towerdefense.towers.Tower;
	import com.towerdefense.towers.*;
	import com.towerdefense.ui.ControlBar;
	import com.towerdefense.ui.MenuBar;
	import com.ericfeminella.effects.*;
	import flash.filters.BlurFilter;
	import com.coursevector.effects.TweenBlur;

	////////////////////////////////////////////////////////////////////////////////////
	// TOWER DEFENSE CLASS /////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////

	public class Main extends Sprite {

		private const STAGE_WIDTH:int = 550;
		private const STAGE_HEIGHT:int = 500;
		private const INSTRUCTIONS:String = "This game is based on the popular Warcraft3 \"Element Tower Defense\" and the Starcraft \"Turret Defense\" gameplay. The object of the game is to prevent the hordes (waves) of monsters from getting to the castle by building element towers near the path.\nYour menu is located at the bottom of your screen. You can choose from a number of different elements to build towers from. When you click on a tower that has been built, the build menu becomes an upgrade menu, allowing you to make you towers stronger.\nThe monsters will spawn every 20 seconds. Their health will be multiplied by 1.25 with every wave. If your towers fail to kill the monsters, and they do get to the castle, a civilian of your castle will die. When all your civillians die, the game will be over.\nEvery game experience is different every time you play depending on the position, elements, and upgrades you choose for your towers.\nThe creator of this game scored 90. Can you beat that? Click \"Start\" to start the game.Press [SpaceBar] To Skip To Next Wave";
		private const ATK_DELAY:int = 5;
		private const START_LIVES:int = 10;
		private const START_TIME:int = 20;
		private const START_HEALTH:int = 5;
		private const START_SPEED:int = 3;
		private const START_INCOME:int = 1;
		private const START_MONEY:int = 60000;
		private const ENEMY_AMOUNT:int = 8;

		private var _mode:int = 0;
		private var _lives:int = START_LIVES;
		private var _wave:int = 0;
		private var _waveTime:int = START_TIME;// Maye increase this based on the level?
		private var _timeRemain:int = _waveTime;
		private var _health:uint = START_HEALTH;
		private var _speed:int = START_SPEED;
		private var _income:int = START_INCOME;
		private var _money:int = START_MONEY;
		private var _lumber:int = 0;
		private var _msgTime:int;
		private var _towerList:Array;
		private var _enemyList:Array;
		private var _timer:Timer;
		private var _enemyTimer:Timer;
		private var _enemyCounter:int = 0;
		private var _gameOver:Boolean = false;
	
		// Text Formats
		private var _arial_str:String;
		private var yellow_frmt:TextFormat;
		private var black_frmt:TextFormat;
		private var white_frmt:TextFormat;
		private var dropShadow_filter:DropShadowFilter;
		// Assets
		private var preLoader_spr:Sprite;// Preloader Container
		private var instructions_spr:Sprite;// Instructions Container
		private var sprGame:Sprite;// MovieClip Container
		private var btnDisableLayer:SimpleButton;
		private var sprUI:Sprite;
		private var sprLose:Sprite;
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
		private var sprGuideRect:Sprite;
		private var controlBar:ControlBar;// Control Bar
		private var menuBar:MenuBar;// Control Bar
		private var income_tf:TextField;
		private var toolbar_filters:Array;
		private var _blurTween:TweenBlur;
		private var sprCastle:Castle;
		private var mcHitArea:Sprite;
		// Lose Assets
		private var txtScore:TextField;

		/**
		 * Main
		 *
		 * Construct
		 *
		 */
		public function Main():void {
			// Hide the default right-click menu items
			stage.showDefaultContextMenu = false;

			// Yellow Format
			yellow_frmt = new TextFormat();
			yellow_frmt.bold = true;
			yellow_frmt.color = 0xFFCC00;
			yellow_frmt.size = 9;
			yellow_frmt.font = "Arial";

			// Black Format
			black_frmt = new TextFormat();
			black_frmt.bold = true;
			black_frmt.color = 0x000000;
			black_frmt.size = 12;
			black_frmt.font = "Arial";
			black_frmt = black_frmt;

			// White Format
			white_frmt = new TextFormat();
			white_frmt.color = 0xFFFFFF;
			white_frmt.size = 9;
			white_frmt.font = "Arial";

			// Drop Shadow
			dropShadow_filter = new DropShadowFilter();
			dropShadow_filter.color = 0x000000;
			dropShadow_filter.alpha = .3;
			dropShadow_filter.blurX = 2;
			dropShadow_filter.blurY = 2;
			dropShadow_filter.angle = -45 * (Math.PI/180);
			dropShadow_filter.distance = 2;
			dropShadow_filter.quality = 3;
			
			_blurTween = new TweenBlur();

			buildPreLoader();
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
		 * gameSeconds
		 *
		 * Run every second, manages clock and when to add new waves
		 *
		 */
		private function onTimer(e:TimerEvent) {
			this._gameOver = false;
			
			// Clock Seconds
			--this._timeRemain;
			if (this._timeRemain < 0) {
				// Reset Timer
				this._timeRemain = this._waveTime;
				this.newWave();
			}
			
			this.controlBar._clock = this._timeRemain;
		}
		
		/**
		 * buildGame
		 *
		 * Build game interface. Sets default value
		 *
		 */
		private function buildGame():void {
			btnDisableLayer = new SimpleButton();
			var shpBox:Shape = new Shape();
			shpBox.graphics.beginFill(0x000000);
			shpBox.graphics.drawRect(0,0,5000,5000);
			shpBox.graphics.endFill();
			btnDisableLayer.hitTestState = shpBox;
			btnDisableLayer.useHandCursor = false;
			btnDisableLayer.visible = false;
			
			sprGame = new Sprite();
			sprUI = new Sprite();

			// Reset Tower/Enemy List
			_towerList = new Array();
			_enemyList = new Array();

			// Buildable Area
			mcHitArea = new HitArea();
			sprGame.addChild(mcHitArea);

			// Attach Castle
			sprCastle = new Castle();
			sprCastle.x = 520;
			sprCastle.y = 370;
			sprGame.addChild(sprCastle);

			// Top Menu Bar
			menuBar = new MenuBar(STAGE_WIDTH);
			menuBar.addEventListener("resetGame", onRestart);
			sprUI.addChild(menuBar);

			// Bottom Control Bar
			controlBar = new ControlBar(STAGE_WIDTH, _timeRemain);
			controlBar.y = 420;			
			controlBar.addEventListener("buildTower", onStartBuild);
			controlBar.addEventListener("upgradeTower", onUpgradeTurret);
			sprGame.addChild(controlBar);

			// Create / Hide build rectangle
			sprGuideRect = new Sprite();
			sprGuideRect.graphics.beginFill( 0xFFFFFF, .5 );
			sprGuideRect.graphics.drawRect( (25/2)*-1, (25/2)*-1, 25, 25 );
			sprGuideRect.graphics.endFill();
			sprGuideRect.x = -100;
			sprGuideRect.y = -100;
			sprGuideRect.visible = false;
			sprGame.addChild(sprGuideRect);			
			addChild(sprGame);
			addChild(btnDisableLayer);
			addChild(sprUI);

			//_root.attachMovie("arrow", "selArrow", 1000);

			// DRAW LOSE WINDOW//
			/////////////////////
			sprLose = new Sprite();

			var _filters:Array = [dropShadow_filter];

			var shpLoseBG:Shape = new Shape();
			shpLoseBG.graphics.beginFill( 0x000000, .3 );
			shpLoseBG.graphics.drawRoundRect(0, 0, 200, 150, 10);
			shpLoseBG.graphics.endFill();
			shpLoseBG.filters = _filters;
			sprLose.addChild(shpLoseBG);

			txtScore = new TextField();
			txtScore.antiAliasType = AntiAliasType.ADVANCED;
			txtScore.autoSize = TextFieldAutoSize.LEFT;
			txtScore.selectable = false;
			txtScore.x = 50;
			txtScore.y = 50;
			sprLose.addChild(txtScore);

			sprLose.y = STAGE_HEIGHT / 2 - (sprLose.height / 2);
			sprLose.x = STAGE_HEIGHT / 2 - (sprLose.width / 2);
			addChild(sprLose);
			sprLose.visible = false;
			/////////////////////
			// END LOSE WINDOW //
			
			menuBar.updateToolbarText("txtMoney", String(_money));
			menuBar.updateToolbarText("txtLumber", String(_lumber));
			menuBar.updateToolbarText("txtCitizen", String(_lives));

			// Set Events
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.focus = this;			
			
			// Start Timer
			_timer = new Timer(1000, 0);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
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
			txtTemp.antiAliasType = AntiAliasType.ADVANCED;
			txtTemp.autoSize = TextFieldAutoSize.LEFT;
			txtTemp.selectable = false;
			txtTemp.x = x;
			txtTemp.y = y;
			return txtTemp;
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
			menuBar.updateToolbarText("txtMoney", String(_money));
		}
		
		private function takeMoney(amount:int):void {
			_money -= amount;
			menuBar.updateToolbarText("txtMoney", String(_money));
		}

		/**
		 * onCitizenKill
		 *
		 * Kills a citizen. If no more citizens left, end game
		 *
		 */
		public function onCitizenKill(e:Event):void {
			--this._lives;
			if (this._lives < 0) {
				this._lives = 0;
			}
			this.menuBar.updateToolbarText("txtCitizen", String(this._lives));

			// Remove Enemy
			this.removeEnemy(e.target);

			if (this._lives <= 0) {
				this.endGame();
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
			this.giveMoney();

			// Remove Enemy
			this.removeEnemy(e.target);
		}
		
		private function removeEnemy(e:Enemy):void {
			// Remove from List
			var curId:int = findEnemyIndex(e.id);			
			_enemyList.splice(curId, 1);
			updateEnemyList();
			
			// Remove from Stage
			e.removeEventListener("enemyKilled", onEnemyKill);
			e.removeEventListener("citizenKilled", onCitizenKill);			
			sprGame.removeChild(e);		
			delete e;
		}

		/**
		 * newWave
		 *
		 * Starts a new wave, increases income, and enemy health
		 *
		 */
		private function newWave():void {			
			++this._wave;
			
			this.controlBar.addMessage("Starting wave " + this._wave);
			this.menuBar.updateToolbarText("txtWave", String(this._wave));

			if ((this._wave % 5) == 0) {
				++this._lumber;
				this.controlBar.addMessage("Lumber " + this._lumber);
				this.menuBar.updateToolbarText("txtLumber", String(this._lumber));
			}

			// Create Enemies
			this._enemyTimer = new Timer(350, this.ENEMY_AMOUNT);
			this._enemyTimer.addEventListener(TimerEvent.TIMER, this.onEnemyTimer);
			this._enemyTimer.start();
			this._enemyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onEnemyComplete);
		}
		
		private function findEnemyIndex(id:int):int {
			for (var i:int in _enemyList) {
				if (_enemyList[i].id == id) {
					return i;
				}
			}
			return -1;
		}
		
		private function onEnemyTimer(e:TimerEvent):void {
			if (!this._gameOver) {
				this._enemyList.push(new Enemy(this._enemyCounter, this._health, this._speed));
				var curE:Enemy = this._enemyList[this.findEnemyIndex(this._enemyCounter)];
				curE.addEventListener( "enemyKilled", this.onEnemyKill );
				curE.addEventListener( "citizenKilled", this.onCitizenKill );
				this.updateEnemyList();
				this.sprGame.addChild(curE);
				this._enemyCounter++;
			}
		}
		private function onEnemyComplete(e:TimerEvent):void {
			// Increase health and income
			_health = _health * 1.1 + _wave * 8.6;
			_income = _income * 0.02 + _wave * 1.1;
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
		private function showMessage(msg:String):void {
			controlBar.addMessage(msg);
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
		 * onKeyDown
		 *
		 * @param event = Detects when the player hits Spacebar to skip to next wave
		 *
		 */		 
		private function onKeyDown( event:KeyboardEvent ):void {
			switch(event.keyCode) {
				case Keyboard.SPACE :
					if (_enemyList.length == 0) {
						_timeRemain = 0;
					}
					break;
				case Keyboard.END :				
					if(_mode == 1) {
						_mode = 0;
						sprGuideRect.visible = false;
					}
					break;
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

		private function onStartBuild(e:Event):void {
			// Set to build mode
			if(controlBar._towerCost > _money) {
				showMessage("You need more money.");
				_mode = 0;
				sprGuideRect.visible = false;
			} else {
				_mode = 1;				
			}
		}
		
		/**
		 * setBuild
		 *
		 * @param mode = Can be either "invalid" or valid". Uses to determine if a tower
		 * can be built on a square or not.
		 *
		 */
		private function setBuild(mode:String):void {
			if (mode == "invalid") {
				// Turn Red
				var color:ColorTransform = sprGuideRect.transform.colorTransform;
				color.blueMultiplier = 0;
				color.greenMultiplier = 0;
				sprGuideRect.transform.colorTransform = color;
			} else if (mode == "valid") {
				// Reset
				sprGuideRect.transform.colorTransform = new ColorTransform();
			}
		}
		
		private function checkValidBuild():Boolean {
			// Check Top Bar
			if(controlBar._hitArea.hitTestObject(sprGuideRect)) {
				setBuild("invalid");
				return false;
			}
			// Check Bottom Bar
			if(menuBar.hitTestObject(sprGuideRect)) {
				setBuild("invalid");
				return false;
			}
			// Check Grass
			var nDif:int = sprGuideRect.width / 2;
			if(!mcHitArea.hitTestPoint(mouseX - nDif, mouseY - nDif, true)){
				setBuild("invalid");
				return false;
			}
			if(!mcHitArea.hitTestPoint(mouseX + nDif, mouseY - nDif, true)) {
				setBuild("invalid");
				return false;
			}
			if(!mcHitArea.hitTestPoint(mouseX + nDif, mouseY + nDif, true)) {
				setBuild("invalid");
				return false;
			}
			if(!mcHitArea.hitTestPoint(mouseX - nDif, mouseY + nDif, true)) {
				setBuild("invalid");
				return false;
			}
			// Check Towers
			for (var i:int in _towerList) {
				if (_towerList[i].hitTestObject(sprGuideRect)) {
					setBuild("invalid");
					return false;
				}
			}			
			
			setBuild("valid");
			return true;
		}

		/**
		 * onMouseMove
		 *
		 * @param event = Detects where the mouse is, manages building validity.
		 *
		 */
		private function onMouseMove(e:MouseEvent):void {
			// If in build mode, show rectangle
			if (_mode == 1) {
				sprGuideRect.visible = true;
				sprGuideRect.x = mouseX;
				sprGuideRect.y = mouseY;

				// Checks if you can build on the grass or not
				checkValidBuild();
			} else {
				sprGuideRect.visible = false;
			}
		}

		/**
		 * onMouseDown
		 *
		 * Manages tower building
		 *
		 */
		private function onMouseDown( e:MouseEvent ):void {
			var allow:Boolean = false;
			
			if(controlBar._mode == 1) {
				if(!controlBar._hitArea.hitTestPoint(mouseX, mouseY, true)) {
					controlBar.showShop();
				}
			}
			
			if (_mode == 1) {
				allow = checkValidBuild();

				if (allow) {
					_mode = 0;
					sprGuideRect.visible = false;					
					buildTower(controlBar._towerType, controlBar._towerCost, sprGuideRect.x, sprGuideRect.y);
				} else {
					//"Can't Build There";
					showMessage("Please Build on the Grass.");
				}
			}
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
		private function buildTower(type:String, cost:int, x:int, y:int):void {
			switch(type) {
				case "fire" :
					_towerList.push(new FireTower(x, y));
					break;
				case "nature" :
					_towerList.push(new NatureTower(x, y));
					break;
				case "ice" :
					_towerList.push(new IceTower(x, y));
					break;
				case "flower" :
					_towerList.push(new FlowerTower(x, y));
					break;
				case "storm" :
					_towerList.push(new StormTower(x, y));
					break;
				default :
					//
					trace("Not enough money");
					return;
			}
			
			takeMoney(cost);
			// Add Listeners
			var curT:Tower = _towerList[_towerList.length - 1];
			curT._enemyList = _enemyList;
			curT.addEventListener(curT.SELECT_TOWER, onSelectTurret );
			//curT.addEventListener(curT.UPGRADE, onTurretUpgrade );
			sprGame.addChild(curT);
		}		
		
		private function onSelectTurret( e:Event ):void {
			// Get tower stats and upgrade stats
			controlBar.showUpgrade(e.target);
		}
		
		private function onUpgradeTurret(e:Event):void {
			var curTower:Tower = e.target._tower;
			if(curTower._towerInfo.nextPrice == "N/A") {
				showMessage("Tower fully upgraded.");
				return;
			}
			if(_money - curTower._towerInfo.nextPrice > 0) {
				curTower.upgrade();
				e.target.setTower(curTower);
				takeMoney(curTower._towerInfo.price);
			} else {
				showMessage("You need more money.");
			}
		}


		/**
		 * endGame
		 *
		 * Ends the game, blurs interface and displays end score window with reset button
		 *
		 */
		private function endGame():void {
			if(_gameOver != true) {
				// Blur Game interface
				_blurTween.blur(sprGame, 5, .5);
			}
			
			// Stop waves
			_timer.stop();

			_gameOver = true;
			btnDisableLayer.visible = true;

			// Display Score
			txtScore.text = "Score: " + String(_wave);
			sprLose.visible = true;
		}

		private function updateEnemyList():void {
			for (var i:int in _towerList) {
				_towerList[i]._enemyList = _enemyList;
			}
		}
		
		/**
		 * restartGame
		 *
		 * Removes score window and resets game
		 *
		 */
		private function onRestart(e:Event):void {			
			_gameOver = false;
			btnDisableLayer.visible = false;

			// Unblur
			sprLose.visible = false;
			_blurTween.unBlur(sprGame, .5);

			// Reset counter
			_wave = 0;
			_mode = 0;
			_money = START_MONEY;
			_lumber = 0;
			_lives = START_LIVES;
			_health = START_HEALTH;
			_speed = START_SPEED;
			_income = START_INCOME;
			_enemyCounter = 0;
			_waveTime = START_TIME;
			_timeRemain = _waveTime;
			
			controlBar._clock = _timeRemain;
			controlBar.resetMessage();			

			menuBar.updateToolbarText("txtWave", String(_wave));
			menuBar.updateToolbarText("txtMoney", String(_money));
			menuBar.updateToolbarText("txtLumber", String(_lumber));
			menuBar.updateToolbarText("txtCitizen", String(_lives));

			// Remove Enemies
			for (var i:int in _enemyList) {
				var en:Enemy = _enemyList[i];
				en.removeEventListener("enemyKilled", onEnemyKill);
				en.removeEventListener("citizenKilled", onCitizenKill);
				sprGame.removeChild(en);
				delete en;
			}
			
			// Delete all towers
			for (var i:int in _towerList) {
				sprGame.removeChild(_towerList[i]);
				delete _towerList[i];
			}
			
			// Reset Tower/Enemy List
			_towerList = new Array();
			_enemyList = new Array();
			
			_enemyTimer.stop();
			_timer.start();
		}
	}
}