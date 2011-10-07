package game 
{
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	
	public class TruckModel extends Sprite
	{
		private var _world:b2World;
		private var _scale:Number;
		
		private var _leftWheel:b2Body;
		private var _rightWheel:b2Body;
		private var _body:b2Body;
		
		public function TruckModel(world:b2World, scale:Number) 
		{
			_world = world;
			_scale = scale;
			
			_body = createBody(new b2Vec2(50, 0), new b2Vec2(250, 150));	
			var leftAxleFixture:b2FixtureDef = createAxleFixture(new b2Vec2(10, 30), -60, 20, 15);
			var rightAxleFixture:b2FixtureDef = createAxleFixture(new b2Vec2(10, 30), 60, 20, - 15);
			_body.CreateFixture(leftAxleFixture);
			_body.CreateFixture(rightAxleFixture);
			
			var leftAxle:b2Body = createAxle(new b2Vec2(- 50, 0), new b2Vec2(20, 20), -60, 20, 20);
		    var rightAxle:b2Body = createAxle(new b2Vec2(50, 0), new b2Vec2(20, 20), 60, 20, 20);
			
			_leftWheel = createWheel(new b2Vec2(100, 100), 35);
			_rightWheel = createWheel(new b2Vec2(200, 100), 35);
		}
						
		private function createWheel(posInPixels:b2Vec2, radiusInPixels:Number):b2Body
		{
			var pos:b2Vec2 = new b2Vec2(posInPixels.x / _scale, posInPixels.y / _scale);
			
			var shape:b2CircleShape = new b2CircleShape(radiusInPixels / _scale);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = shape;
			fixture.density = 1;
			fixture.friction = 10;
			fixture.restitution = 0.2;
			fixture.filter.groupIndex = -1;
			
			var bodyDef:b2BodyDef = new b2BodyDef();	
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(pos.x, pos.y);
			bodyDef.userData = new WheelSprite();
			bodyDef.userData.cacheAsBitmap = true;
			bodyDef.userData.width = radiusInPixels * 2;
			bodyDef.userData.height = radiusInPixels * 2;
			addChild(bodyDef.userData);
			
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			
			return body;
		}
		
		private function createBody(posInPixels:b2Vec2, sizeInPixels:b2Vec2):b2Body
		{
			var pos:b2Vec2 = new b2Vec2(posInPixels.x / _scale, posInPixels.y / _scale);
			var size:b2Vec2 = new b2Vec2(sizeInPixels.x / _scale, sizeInPixels.y / _scale);
			
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(size.x / 2, size.y / 2);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = shape;
			fixture.density = 5;
			fixture.friction = 3;
			fixture.restitution = 0.3;
			fixture.filter.groupIndex = -1;
			
			var bodyDef:b2BodyDef = new b2BodyDef();	
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(pos.x + size.x / 2, pos.y + size.y / 2);
			bodyDef.userData = new BodySprite();
			bodyDef.userData.cacheAsBitmap = true;
			bodyDef.userData.width = sizeInPixels.x;
			bodyDef.userData.height = sizeInPixels.y;
			addChild(bodyDef.userData);
			
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixture);
			
			return body;
		}
		
		private function createAxleFixture(size:b2Vec2, distance:Number, depth:Number, angle:Number):b2FixtureDef
		{
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsOrientedBox(size.x / _scale, size.y / _scale, 
				new b2Vec2(distance / _scale, depth / _scale), angle * Math.PI / 180);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = shape;
			fixture.restitution = 0.3;
			fixture.density = 3;
			fixture.friction = 3;
			fixture.filter.groupIndex = - 1;
			
			return fixture;
		}
		
		private function createAxle(pos:b2Vec2, size:b2Vec2, distance:Number, depth:Number, angle:Number):b2Body
		{
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsOrientedBox(size.x / _scale, size.y / _scale, 
				new b2Vec2(0, 0), angle * Math.PI / 180);
				
			var fixture:b2FixtureDef = new b2FixtureDef();
			fixture.shape = shape;
			fixture.restitution = 0;
			fixture.density = 0.5;
			fixture.friction = 3;
			fixture.filter.groupIndex = - 1;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
		
			bodyDef.position.Set(pos.x / _scale + distance / _scale + size.y / _scale, 
				pos.y / _scale  + depth / _scale + size.y / _scale);
			
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateFixture(fixture);

			return body;
		}
		
	}

}