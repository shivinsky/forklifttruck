package game.level 
{
	import Box2D.Common.Math.b2Vec2;	
	
	import game.entity.EntityFactory;
	import game.layer.LayerType;
	
	import game.truck.Truck;
	
	public class Level1 extends Level
	{
	
		public override function create() : void
		{
			_factory.createSky(new b2Vec2(0, 0), new b2Vec2(stage.stageWidth, stage.stageHeight), LayerType.BACK);
			_factory.createBox(new b2Vec2(100, 100), new b2Vec2(45, 45), LayerType.MIDDLE);
			_factory.createPlatform(new b2Vec2(0, stage.stageHeight - 30), new b2Vec2(stage.stageWidth, 30), LayerType.MIDDLE);
			_factory.createPlatform(new b2Vec2(100, 100), new b2Vec2(100, 100), LayerType.MIDDLE);
			add(new Truck(new b2Vec2(100, 100), _world), LayerType.MIDDLE);	
		}
		
	}

}