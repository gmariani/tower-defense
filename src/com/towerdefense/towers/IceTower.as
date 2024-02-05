package com.towerdefense.towers {	

	import com.towerdefense.towers.Tower;
	
	public class IceTower extends Tower{			
		
		public function IceTower(x:int, y:int):void {
			__lvl1 = {
				damage: 5,
				range: 100,
				price: 15,
				label: "Water Tower",
				turretY: -7.5,
				graphic: new IceTower1()
			};
			
			__lvl2 = {
				damage: 15,
				range: 150,
				price: 20,
				label: "Cold Water Tower",
				turretY: -12.5,
				graphic: new IceTower2()
			};
			
			__lvl3 = {
				damage: 45,
				range: 150,
				price: 40,
				label: "Ice Tower",
				turretY: -12.5,
				graphic: new IceTower3()
			};
			
			// damage seems wrong
			__lvl4 = {
				damage: 145,
				range: 180,
				price: 80,
				label: "Frost Tower",
				turretY: -12.5,
				graphic: new IceTower4()
			};
			
			__lvl5 = {
				damage: 405,
				range: 200,
				price: 160,
				label: "Master Ice Tower",
				turretY: -12.5,
				graphic: new IceTower5()
			};
			
			__lvl6 = {
				damage: 1215,
				range: 200,
				price: 320,
				label: "Termination Tower",
				turretY: -12.5,
				graphic: new IceTower6()
			};
			
			__lvl7 = {
				damage: 3342,
				range: 200,
				price: 730,
				label: "Frozen Tower",
				turretY: -12.5,
				graphic: new IceTower7()
			};
			
			__lvl8 = {
				damage: 6684,
				range: 215,
				price: 1000,
				label: "Glacier Tower",
				turretY: -12.5,
				graphic: new IceTower8()
			};
			
			__lvl9 = {
				damage: 7335,
				range: 300,
				price: 1000,
				label: "Ultimate Ice Tower",
				turretY: -32.5,
				graphic: new IceTower9()
			};
			
			_type = "ice";
			_speed = 200;
			_upgradeList = [__lvl1, __lvl2, __lvl3, __lvl4, __lvl5, __lvl6, __lvl7, __lvl8, __lvl9];
			_showTurret = true;
			
			super(x, y);			
		}			
	}
}