package com.towerdefense.towers {	

	import com.towerdefense.towers.Tower;
	
	public class FlowerTower extends Tower{
	
		public function FlowerTower(x:int, y:int):void {
			__lvl1 = {
				damage: 9090,
				range: 150,
				price: 3000,
				label: "Ultimate Armed Tower",
				turretY: -7.5,
				graphic: new FlowerTower1()
			};
			
			__lvl2 = {
				damage: 15050,
				range: 100,
				price: 5000,
				label: "Flower Power Tower",
				turretY: -7.5,
				graphic: new FlowerTower2()
			};
			
			__lvl3 = {
				damage: 909090,
				range: 90,
				price: 15000,
				label: "TTHHE ULLTTIMMATTE TTOWWERRr",
				turretY: -12.5,
				graphic: new FlowerTower3()
			};
		
			_type = "flower";
			_speed = 500;
			_upgradeList = [__lvl1, __lvl2, __lvl3];
			_showTurret = false;
			
			super(x, y);
		}			
	}
}