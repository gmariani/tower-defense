package com.towerdefense.towers {
	
	import com.towerdefense.towers.Tower;
	
	public class NatureTower extends Tower{		
		
		public function NatureTower(x:int, y:int):void {
			__lvl1 = {
				damage: 3,
				range: 100,
				price: 10,
				label: "Small Nature Tower",
				turretY: -7.5,
				graphic: new NatureTower1()
			};
			
			__lvl2 = {
				damage: 10,
				range: 100,
				price: 20,
				label: "Large Nature Tower",
				turretY: -12.5,
				graphic: new NatureTower2()
			};
			
			__lvl3 = {
				damage: 20,
				range: 110,
				price: 40,
				label: "Great Nature Tower",
				turretY: -12.5,
				graphic: new NatureTower3()
			};
			
			__lvl4 = {
				damage: 90,
				range: 150,
				price: 80,
				label: "Master Nature Tower",
				turretY: -12.5,
				graphic: new NatureTower4()
			};
			
			__lvl5 = {
				damage: 300,
				range: 170,
				price: 160,
				label: "Millenium Nature Tower",
				turretY: -12.5,
				graphic: new NatureTower5()
			};
			
			__lvl6 = {
				damage: 1013,
				range: 190,
				price: 320,
				label: "Enchanted Nature Tower",
				turretY: -12.5,
				graphic: new NatureTower6()
			};
			
			__lvl7 = {
				damage: 1458,
				range: 200,
				price: 640,
				label: "Supernatural Tower",
				turretY: -12.5,
				graphic: new NatureTower7()
			};
			
			__lvl8 = {
				damage: 9000,
				range: 215,
				price: 1100,
				label: "Living Tower",
				turretY: -12.5,
				graphic: new NatureTower8()
			};
			
			_type = "nature";
			_speed = 100;
			_upgradeList = [__lvl1, __lvl2, __lvl3, __lvl4, __lvl5, __lvl6, __lvl7, __lvl8];
			_showTurret = true;
			
			super(x, y);
		}			
	}
}