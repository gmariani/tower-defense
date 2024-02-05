package com.towerdefense {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.BlendMode;
	
	public class Bullet extends MovieClip {
		
		private var _graphic:MovieClip;
		
        public function Bullet(type:String):void{
        	switch(type) {
        		case "fire" :
		        	_graphic = new FireBullet();
		            break;
		        case "ice" :
        			_graphic = new IceBullet();
		            break;
		        case "nature" :
        			_graphic = new NatureBullet();
		            break;
		     	case "storm" :
        			_graphic = new StormBullet();
		            break;
				case "flower" :
        			_graphic = new FlowerBullet();
					_graphic.blendMode = BlendMode.INVERT;
		            break;
        	}
			addChild(_graphic);
        }

        public function reset():void {
			this.x = 0;
	       	this.y = 0;
	    	this.visible = false;
        }

        ////////////
        // onMove //
        ////////////

        public function onMove(pntDelta:Point):void {
        	this.visible = true;
        	this.x += pntDelta.x / 2;
        	this.y += pntDelta.y / 2;
        }
	}
}