package game.entity 
{
	import Box2D.Common.Math.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	import flash.display.Sprite;
	
	public class Box extends PhysicEntity
	{
		
		public function Box(position : b2Vec2, size : b2Vec2, world : b2World) 
		{
			super(position, size, world);
			
			create();
		}
		
		private function create() : void
		{
			var position : b2Vec2 = new b2Vec2(_position.x / _scale, _position.y / _scale);
			var size : b2Vec2 = new b2Vec2(_size.x / _scale, _size.y / _scale);
			
			var sprite : Sprite = new WoodBoxSprite();
			addChild(sprite);
			
			var bodyDef : b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = sprite;
			bodyDef.position.Set(position.x + size.x / 2, position.y + size.y / 2);
			bodyDef.bullet = true;
						
			var body : b2Body = _world.CreateBody(bodyDef);
	
			var polygonShape : b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(size.x / 2, size.y / 2);
			
			var fixtureDef : b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 0.5;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0;
			body.CreateFixture(fixtureDef);
			
			var bottomShape : b2PolygonShape = new b2PolygonShape();
			bottomShape.SetAsOrientedBox(size.x / 2, 0.02, new b2Vec2(0, size.y / 2 + 0.2));

			fixtureDef.shape = bottomShape;
			body.CreateFixture(fixtureDef);
		}
		
		public override function update() : void
		{
		}
				
	}

}
