package com.coursevector.util {

    import flash.display.Sprite;
    import flash.geom.Point;   

    public class CoordinateTools {
        public static function localToLocal(containerFrom:Sprite, containerTo:Sprite):Point {
            var point:Point = new Point();
            point = containerFrom.localToGlobal(point);
            point = containerTo.globalToLocal(point);
            return point;
        }
    }
}
