package com.coursevector.effects {
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.utils.*;

	public class Tween extends flash.events.EventDispatcher {
		
		private var _s:Number;
		private var _tN:Number;
		private var _tO:Object;
		private var _p:String;
		private var _dir:int;
		private var _shape:Shape;

		/**
		 * Tween
		 * 
		 * Attaches a tween to a given display object
		 * 
		 * @param p = Property
		 * @param tN = Target Number
		 * @param tO = Target Object
		 * @param s = Speed
		 * 
		 */		
		public function Tween(p:String, tN:Number, tO:Object, s:Number):void {
			_tN = tN;
			_tO = tO;
			_p = p;
			_s = s;
			_shape = new Shape();
		}

		/**
		 * start
		 * 
		 * Starts tween
		 * 
		 */		
		public function start():void {			
	    	_shape.addEventListener(Event.ENTER_FRAME, onTween);
	    }
		
		public function stop():void {
			_shape.removeEventListener(Event.ENTER_FRAME, onTween);
		}
		
		public function updateTween(p:String, tN:Number):void {
			stop();
			_tN = tN;
			_p = p;
			start();
		}

		/**
		 * onTween
		 * 
		 * Called every frame
		 * 
		 * @param e = Event
		 * 
		 */		
		private function onTween(e:Event):void {
			_tO[_p] += _s * _dir;
			if (getDelta() <= _s) {
				_tO[_p] = _tN;
				stop();
    			dispatchEvent(new Event("complete"));				
			}
		}
		
		/**
		 * getDelta
		 * 
		 * Gets the distance between target coordinate and current value
		 * 
		 * @return Number
		 * 
		 */		
		private function getDelta():Number {
			var _delta:Number;
			// If both are negative or positive
			if(_tN <= 0 && _tO[_p] <= 0) {
				if(_tN > _tO[_p]) {
					_dir = 1;
				}
				if(_tN < _tO[_p]) {
					_dir = -1;
				}
				_delta = _tO[_p] - _tN;
			}
			if(_tN >= 0 && _tO[_p] >= 0) {
				if(_tN > _tO[_p]) {
					_dir = 1;
				}
				if(_tN < _tO[_p]) {
					_dir = -1;
				}
				_delta = _tO[_p] - _tN;
			}
			
			// If target is negative and current is positive
			if(_tN < 0 && _tO[_p] >= 0) {
				_delta = (_tN * -1) + _tO[_p];
				_dir = -1;
			}
			
			// If current is negative and target is positive
			if(_tN >= 0 && _tO[_p] < 0) {
				_delta = (_tO[_p] * -1) + _tN;
				_dir = 1;
			}
						
			if(_delta < 0) {
				_delta *= -1;
			}
			return _delta;
		}
	}
}
