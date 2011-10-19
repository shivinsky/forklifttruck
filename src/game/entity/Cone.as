package game.entity 
{
	import Box2D.Common.Math.b2Vec2;
	
	import flash.filters.*;
	import flash.filters.BitmapFilterQuality;
	
	/**
	 * Cone
	 */
	public class Cone extends Entity
	{
		
		public function Cone(position : b2Vec2, size : b2Vec2) 
		{
			super(position, size);
				
			var shadow : DropShadowFilter = new DropShadowFilter();
			shadow.distance = 0;
			shadow.color = 0x333333;
			shadow.blurX = 2;
			shadow.blurY = 2;
			shadow.quality = BitmapFilterQuality.HIGH;
			
			filters = [shadow];
			x = _position.x;
			y = _position.y;
			addChild(new ConeSprite());	
		}
		
	}

}