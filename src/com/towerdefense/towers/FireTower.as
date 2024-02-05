package com.towerdefense.towers {

	import com.towerdefense.towers.Tower;
	
	public class FireTower extends Tower {
		
		public function FireTower(x:int, y:int):void {
			
			__lvl1 = {
				damage: 5,
				range: 100,
				price: 18,
				label: "Small Fire Tower",
				turretY: -7.5,
				graphic: new FireTower1()
			};
			
			__lvl2 = {
				damage: 12,
				range: 100,
				price: 20,
				label: "Large Fire Tower",
				turretY: -12.5,
				graphic: new FireTower2()
			};
			
			__lvl3 = {
				damage: 36,
				range: 100,
				price: 40,
				label: "Advanced Fire Tower",
				turretY: -12.5,
				graphic: new FireTower3()
			};
			
			__lvl4 = {
				damage: 108,
				range: 100,
				price: 50,
				label: "Great Fire Tower",
				turretY: -12.5,
				graphic: new FireTower4()
			};
			
			__lvl5 = {
				damage: 300,
				range: 100,
				price: 80,
				label: "Super Fire Tower",
				turretY: -12.5,
				graphic: new FireTower5()
			};
			
			__lvl6 = {
				damage: 2056,
				range: 110,
				price: 600,
				label: "Century Inferno Tower",
				turretY: -12.5,
				graphic: new FireTower6()
			};
			
			__lvl7 = {
				damage: 7021,
				range: 120,
				price: 1500,
				label: "FireLord Elemental Tower",
				turretY: -12.5,
				graphic: new FireTower7()
			};
						
			_type = "fire";
			_speed = 200;
			_upgradeList = [__lvl1, __lvl2, __lvl3, __lvl4, __lvl5, __lvl6, __lvl7];
			_showTurret = true;
			
			super(x, y);			
		}			
	}
}
