package game.entity 
{
	import Box2D.Common.Math.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.*;
	
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Platform extends PhysicEntity
	{

		public function Platform(position : b2Vec2, size : b2Vec2, world : b2World) 
		{
			super(position, size, world);
			
			create();
		}
		
		private function create() : void 
		{
			var position : b2Vec2 = new b2Vec2(_position.x / _scale, _position.y / _scale);
			var size : b2Vec2 = new b2Vec2(_size.x / _scale, _size.y / _scale);
						
			var sprite : Sprite = new Sprite();
			sprite.graphics.beginBitmapFill(new DebugBitmap());
			sprite.graphics.drawRect(- _size.x / 2, - _size.y / 2, _size.x, _size.y);
			sprite.graphics.endFill();
			sprite.cacheAsBitmap = true;
			addChild(sprite);
			
			var bodyDef : b2BodyDef = new b2BodyDef();
			bodyDef.userData = sprite;
			bodyDef.position.Set(position.x + size.x / 2, position.y + size.y / 2);
			
			var body : b2Body = _world.CreateBody(bodyDef);
			
			var polygonShape : b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(size.x / 2, size.y / 2);
			
			var fixtureDef : b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 0;
			fixtureDef.friction = 1;
			body.CreateFixture(fixtureDef);
		}
		
		public override function update() : void
		{
		} 
		
	}

}