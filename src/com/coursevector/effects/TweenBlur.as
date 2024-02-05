package com.coursevector.effects {
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	
	public class TweenBlur extends Sprite {
		
		private var _s:Number;
		private var _t:int;
		private var _tO:Object;
		private var _timer:Timer;
		
		public function TweenBlur() {			
			//
		}
		
		public function blur(o:Object, t:int, s:Number) {			
			_s = s;
			_tO = o;
			_t = t;

			var blur:BlurFilter = new BlurFilter(0,0,3);
			var tempFilters:Array = [blur];
			_tO.filters = tempFilters;
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		} 
		
		public function unBlur(o:Object, s:Number):void {
			_s = s;
			_tO = o;
			_t = 0;

			var blur:BlurFilter = new BlurFilter(0,0,3);
			var tempFilters:Array = [blur];
			_tO.filters = tempFilters;
			
			_timer = new Timer(30);
			_timer.addEventListener(TimerEvent.TIMER, onTimer2);
			_timer.start();
		}
		
		private function onTimer(e:TimerEvent):void {
			var tempFilters:Array = _tO.filters;
 			var blur:BlurFilter = tempFilters[0];
			var _v:Number = (_t - blur.blurX) * _s;
			
			if(blur.blurX >= _t) {
 				blur.blurX = _t;
 				blur.blurY = _t;
 				_timer.stop();
 			} else {
				blur.blurX += _v;
	 			blur.blurY += _v;
	 			
	 			_tO.filters = tempFilters;
 			}
		}
		
		private function onTimer2(e:TimerEvent):void {
			var tempFilters:Array = _tO.filters;
 			var blur:BlurFilter = tempFilters[0];
			var _v:Number = (blur.blurX - _t) * _s;
			
			if(blur.blurX <= _t) {
 				blur.blurX = _t;
 				blur.blurY = _t;
 				_timer.stop();
 			} else {
				blur.blurX -= _v;
	 			blur.blurY -= _v;
	 			
	 			_tO.filters = tempFilters;
 			} 			
		}	
	}
}