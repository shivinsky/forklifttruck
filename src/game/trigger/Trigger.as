package game.trigger 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	
	import game.entity.PhysicEntity;
	
	/**
	 * Trigger
	 */
	public class Trigger extends PhysicEntity
	{
		public function Trigger(position : b2Vec2, size : b2Vec2, world : b2World) 
		{
			super(position, size, world);	
		}
		
		public override function update() : void
		{
		}
		
	}

}