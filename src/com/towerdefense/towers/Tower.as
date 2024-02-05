package com.towerdefense.towers {
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import com.towerdefense.Bullet;
	import com.towerdefense.Enemy;
	import com.coursevector.util.CoordinateTools;
	import flash.geom.Point;
	
	public class Tower extends MovieClip {
		public const SELECT_TOWER:String = "selectTower";
		public const UPGRADE:String = "upgrade";
		
		private var _label:String;
		private var _damage:int;
		private var _range:int;
		private var _turretY:uint;
		private var _price:int;		

		private var _minDist:int = 0;
	    private var _target:Enemy = null;
	    private var _distX:int = 0;
	    private var _distY:int = 0;
	    private var _level:int = 1;
	    private var _bullet:Bullet;
		private var _turret:Turret;
	    private var __enemyList:Array;
		private var _targetTimer:Timer;
		private var _bulletTimer:Timer;
		private var _shootTimer:Timer;
		private var _isShoot:Boolean;
		private var _graphic:MovieClip;
	    
	    protected var __lvl1:Object;
	    protected var __lvl2:Object;
	    protected var __lvl3:Object;
	    protected var __lvl4:Object;
	    protected var __lvl5:Object;
	    protected var __lvl6:Object;
	    protected var __lvl7:Object;
	    protected var __lvl8:Object;
	    protected var __lvl9:Object;
	    protected var __lvl10:Object;
	    protected var _upgradeList:Array;
	    protected var _type:String;
		protected var _speed:int;
		protected var _showTurret:Boolean;
		

		public function Tower(x:int, y:int) {
			this.x = x;
			this.y = y;
			//this.gotoAndStop(1);
			
			// Add Turret
			_turret = new Turret();
			_turret.x = 0;
			_turret.y = 0;
			_turret.gotoAndStop(10);
			addChild(_turret);
			
			if(_showTurret == false) {
				_turret.visible = false;
			}
			
			// Add Bullet
			_bullet = new Bullet(_type);
		    addChild(_bullet);
			_bullet.reset();
		    
		    // Set to basic level 1 tower
		    updateLevel();
			
			// Start Loop
			_targetTimer = new Timer(10);
			_targetTimer.addEventListener(TimerEvent.TIMER, gameSeconds);
			_targetTimer.start();
			
			_bulletTimer = new Timer(50);
			_bulletTimer.addEventListener(TimerEvent.TIMER, updateBullet);
			_bulletTimer.start();
			
			_shootTimer = new Timer(50);
			_shootTimer.addEventListener(TimerEvent.TIMER, updateShoot);
			_shootTimer.start();
			
			this.addEventListener(MouseEvent.CLICK, setTurret);
		}

		public function upgrade():void {
			_level++;
			updateLevel();
			dispatchEvent(new Event(UPGRADE));
		}
		
		public function set _enemyList(a:Array):void {
			_targetTimer.start();
			__enemyList = a;
			pickTarget();
		}
		
		public function updateLevel():void {
			// Set tower to these settings
			if(_level > _upgradeList.length) { 
				//
			} else {
				var targObj:Object = _upgradeList[_level - 1];
				_label = targObj.label;
				_damage = targObj.damage;
				_range = targObj.range;
				_turretY = targObj.turretY;
				_price = targObj.price;
				_turret.y = _turretY;
				_bullet.scaleX += .3;
				_bullet.scaleY += .3;

				if(_graphic != null) {
					removeChild(_graphic);
				}
				_graphic = targObj.graphic;
				addChild(_graphic);
				
				setChildIndex(_graphic, 0);
				setChildIndex(_turret, 1);
				setChildIndex(_bullet, 2);
			}
		}
		
		public function get _turretTarg():MovieClip {
			return _turret;
		}

		private function pickTarget():void {
			if(__enemyList == null) {
				//trace("Enemy list not set, don't search");
				_targetTimer.stop();
				return;
			}
			
			if(__enemyList.length == 0) {
				_bullet.reset();
				_isShoot = false;
				_target = null;
			}
			
			if(_target != null) {
				if(getDistance(_target, this) > _range) {
					_bullet.reset();
					_isShoot = false;
					_target = null;
				} else if(_target.health <= 0) {
					_target = null;
				} else {
					return;
				}
			}				

			if(__enemyList.length > 0) {
				for(var i:int in __enemyList) {
					var _tempTarg:Enemy = __enemyList[i];
					if(getDistance(_tempTarg, this) < _range) {
						//trace("- Assign Enemy");
						_target = _tempTarg;
						return;
					}
				}
			}
			//trace("- No enemies found");
			_target = null;
		}
		
		private function getDistance(objTo:Object, objFrom:Object):int {
			var pntTo:Point = objTo.localToGlobal(new Point());
			var pntFrom:Point = objFrom.localToGlobal(new Point());
			var deltaX:int = pntTo.x - pntFrom.x;
	       	var deltaY:int = pntTo.y - pntFrom.y;
			var deltaR:int = Math.sqrt(Math.pow(deltaX, 2) + Math.pow(deltaY, 2));
			return deltaR;
		}
		
		private function updateShoot(e:TimerEvent):void {
			if(_target != null && _bullet.x == 0 && _bullet.y == 0) {
				_turret.play();
				_isShoot = true;
			}
		}

		private function updateBullet(e:TimerEvent):void {
			// Get new target
			pickTarget();

	        if (_target != null && _isShoot == true) {
	            _bullet.onMove(CoordinateTools.localToLocal(_target, _bullet));
				
				// Use coord to determine hit?
				//trace("Distance: " + getDistance(_target, _bullet));
								
				if(_bullet.hitTestObject(_target)) {
	            	// Bullet Hit
					_bullet.reset();
					_isShoot = false;
					_target.addDamage(Math.floor((Math.random()*(_damage * 0.3)) + _damage * 0.7));
					pickTarget();
	            }
	        } else {
	        	// If no targets available
	            _bullet.reset();
	        }
		}
		
		public function get _towerInfo():Object {
			var _dataObj:Object = new Object();
		    _dataObj.label = _label;
		    _dataObj.damage = _damage;
		    _dataObj.range = _range;
		    _dataObj.speed = _speed;
			_dataObj.type = _type;
			_dataObj.price = _price;
		    if(_level >= _upgradeList.length) {
		    	_dataObj.nextLabel = "N/A";
			    _dataObj.nextDamage = "N/A";
			    _dataObj.nextRange = "N/A";
			    _dataObj.nextPrice = "N/A";
			    _dataObj.nextSpeed = "N/A";
		    } else {
				var _towerUpgrade:Object = _upgradeList[_level];
			    _dataObj.nextLabel = _towerUpgrade.label;
			    _dataObj.nextDamage = _towerUpgrade.damage;
			    _dataObj.nextRange = _towerUpgrade.range;
			    _dataObj.nextPrice = _towerUpgrade.price;
			    _dataObj.nextSpeed = _towerUpgrade.speed;
		    }
		    return _dataObj;
		}

		private function setTurret(e:MouseEvent):void {
		    dispatchEvent(new Event(SELECT_TOWER));
		}

		private function gameSeconds(e:TimerEvent):void {
			if (_target == null) {
		        pickTarget();
		    } else {
		        var __x:int = _target.x - this.x;
		        var __y:int = (_target.y - this.y) * -1;
		        var _angle:uint = Math.atan(__y / __x) / 0.01745329;
		        if (__x < 0) {
		            _angle += 180;
		        }
		        if (__x >= 0 && __y < 0) {
		            _angle += 360;
		        }
		        _turret.rotation = _angle * -1;
		       // updateBullet();
		    }
		}
	}
}