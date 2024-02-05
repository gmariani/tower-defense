package com.towerdefense.towers {

	import com.towerdefense.towers.Tower;
	
	public class StormTower extends Tower {		
		
		public function StormTower(x:int, y:int):void {
			
			__lvl1 = {
				damage: 40,
				range: 100,
				price: 40,
				label: "Storm Tower",
				turretY: -12.5,
				graphic: new StormTower1()
			};
			
			_type = "storm";
			_speed = 300;
			_upgradeList = [__lvl1];
			_showTurret = false;
		
			super(x, y);
		}			
	}
}
