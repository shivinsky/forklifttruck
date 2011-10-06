package game 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.geom.*;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	
	public class Truck extends Sprite
	{
		private var _truck:b2Body;
		private var _world:b2World;
		
		private var _timeStep:Number;
		private var _iterations:uint = 5;

		private var _scale:uint = 20;
		private var _gravity:b2Vec2 = new b2Vec2(0, 9.8);
		
		private var _width:uint;
		private var _height:uint;
		
		private var _position:Point = new Point(0, 0);
		private var _size:Point = new Point(50, 50);
		
		private var _debugBitmap:BitmapData = new DebugBitmap();
		
		private var _groundPos:b2Vec2;
		private var _groundSize:b2Vec2;
		
		public function Truck() 
		{									
			addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function create(e:Event) : void
		{
			_timeStep = 1 / stage.frameRate;
			_width = stage.stageWidth;
			_height = stage.stageHeight;
			
			_world = new b2World(_gravity, true);
			
			// setDebugDraw();
			
			_groundPos = new b2Vec2(200, _height - 170);
			_groundSize = new b2Vec2(_width / 4, 70);
			createPlatform(_groundPos, _groundSize);
			
			createWheel(new b2Vec2(100, 100), 30);
			createWheel(new b2Vec2(200, 100), 30);
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function destroy(e:Event) : void
		{
			removeEventListener(Event.ENTER_FRAME, update);	
		}
		
		private function update(e:Event) : void
		{
			_world.Step(_timeStep, _iterations, _iterations);
			_world.ClearForces();
			_world.DrawDebugData();
			for (var body:b2Body = _world.GetBodyList(); body; body = body.GetNext()) {
				if (body.GetUserData() is Sprite) {
					var sprite:Sprite = body.GetUserData();
					sprite.x = body.GetPosition().x * _scale;
					sprite.y = body.GetPosition().y * _scale;
					sprite.rotation = body.GetAngle() * 180 / Math.PI;
				}
			}
			graphics.beginBitmapFill(_debugBitmap);
			graphics.drawRect(_groundPos.x - _groundSize.x, _groundPos.y - _groundSize.y, _groundSize.x * 2, _groundSize.y * 2);
			graphics.endFill();
		}
		
		private function setDebugDraw() : void
		{
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetFillAlpha(0.5);
			debugDraw.SetLineThickness(2.0);
			debugDraw.SetDrawScale(_scale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			_world.SetDebugDraw(debugDraw);
		}
		
		private function createPlatform(position:b2Vec2, size:b2Vec2) : void 
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(position.x / _scale, position.y / _scale);
			
			var body:b2Body = _world.CreateBody(bodyDef);
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(size.x / _scale, size.y / _scale);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.friction = 1;
			body.CreateFixture(fixtureDef);
		}
		
		private function createWheel(position:b2Vec2, radius:uint) : void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(position.x / _scale, position.y / _scale);
			bodyDef.userData = new WheelTexture();
			bodyDef.userData.width = 2 * radius;
			bodyDef.userData.height = 2 * radius;
			addChild(bodyDef.userData);
			
			var body:b2Body = _world.CreateBody(bodyDef);

			var circleShape:b2CircleShape = new b2CircleShape();
			circleShape.SetRadius(radius / _scale);

			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0.8;
			body.CreateFixture(fixtureDef);
		}
		
	}

}