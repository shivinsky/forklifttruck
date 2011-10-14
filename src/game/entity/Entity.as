package game.entity 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;

	public class Entity extends Sprite
	{
		protected var _position : b2Vec2;
		protected var _size : b2Vec2;
		
		public function Entity(position:b2Vec2, size:b2Vec2) 
		{
			_position = position;
			_size = size;
		}
		
		public function update() : void
		{
		}
				
	}

}