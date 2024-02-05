package com.towerdefense {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import gs.TweenMax;
	import gs.easing.Linear;
	
	public class Enemy extends Sprite {
		
		private var CHECK_POINT_COORD:Array = [[45,375],
												[165,375],
												[165,75],
												[495,75],
												[495, 225],
												[285, 225],
												[285, 375],
												[510, 375]];
		private var _id:int;
		private var _health:int;
		private var _totalHealth:int;

		public function Enemy(id:int, h:uint, speed:int):void {
			_health = h;
			_totalHealth = h;
			_id = id;
			
			this.x = 45;
			this.y = 0;
			this.alpha = 100;
			
			var arrTweens:Array = new Array();
			arrTweens.push( { time:speed, 		x:CHECK_POINT_COORD[0][0], y:CHECK_POINT_COORD[0][1], ease:Linear.easeNone } );
			arrTweens.push( { time:speed * .4, x:CHECK_POINT_COORD[1][0], y:CHECK_POINT_COORD[1][1], ease:Linear.easeNone } );
			arrTweens.push( { time:speed * .75, x:CHECK_POINT_COORD[2][0], y:CHECK_POINT_COORD[2][1], ease:Linear.easeNone } );
			arrTweens.push( { time:speed, 		x:CHECK_POINT_COORD[3][0], y:CHECK_POINT_COORD[3][1], ease:Linear.easeNone } );
			arrTweens.push( { time:speed * .5, x:CHECK_POINT_COORD[4][0], y:CHECK_POINT_COORD[4][1], ease:Linear.easeNone } );
			arrTweens.push( { time:speed * .5, x:CHECK_POINT_COORD[5][0], y:CHECK_POINT_COORD[5][1], ease:Linear.easeNone } );
			arrTweens.push( { time:speed * .5, x:CHECK_POINT_COORD[6][0], y:CHECK_POINT_COORD[6][1], ease:Linear.easeNone } );
			arrTweens.push( { time:speed * .5, x:CHECK_POINT_COORD[7][0], y:CHECK_POINT_COORD[7][1], ease:Linear.easeNone, onComplete:killCitizen } );
			TweenMax.sequence(this, arrTweens);
		}
		
		public function get id():int {
			return _id;
		}
		
		public function get health():int {
			return _health;
		}
		
		public function addDamage(num:int):void {
			_health -= num;
			this.alpha = _health / _totalHealth;
			
			if(_health <= 0) {
				dispatchEvent(new Event("enemyKilled"));
			}
		}	
		
		private function killCitizen():void {
			dispatchEvent(new Event("citizenKilled"));
		}
	}
}