package game.entity 
{

	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import Box2D.Dynamics.b2Body;
	import game.common.Settings;
	
	public class PhysicEntity extends Entity
	{
		
		protected var _world : b2World;
		protected var _scale : uint;
		
		public function PhysicEntity(position : b2Vec2, size : b2Vec2, world : b2World) 
		{
			super(position, size);
			
			_world = world;
			_scale = Settings.scale;
		}
		
	}

}