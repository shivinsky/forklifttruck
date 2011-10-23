package game.entity 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2World;
    
    import flash.display.Sprite;  
    import flash.geom.Point;
    import flash.filters.DropShadowFilter;
    import flash.filters.BitmapFilterQuality;

    public class Entity extends Sprite
    {
        protected var _position : b2Vec2;
        protected var _size : b2Vec2;
        protected var _angle : Number;
        
        public function Entity(position : b2Vec2, size : b2Vec2, angle : Number = 0) 
        {
            _position = position;
            _size = size;
            _angle = angle;

            /*
            var shadow : DropShadowFilter = new DropShadowFilter();
            shadow.distance = 0;
            shadow.color = 0x333333;
            shadow.blurX = 2;
            shadow.blurY = 2;
            shadow.quality = BitmapFilterQuality.HIGH;

            filters = [shadow];
            */

            x = _position.x;
            y = _position.y;
            rotation = _angle; 
        }
        
        public function update() : void
        {
        }
                
    }

}