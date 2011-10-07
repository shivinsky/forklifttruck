package game 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
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
		private var _iterations:uint = 10;
		private var _scale:Number = 30;
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
			_timeStep = 1.0 / stage.frameRate;
			_width = stage.stageWidth;
			_height = stage.stageHeight;
			
			_world = new b2World(_gravity, true);
			
		    // setDebugDraw();
			
			_groundPos = new b2Vec2(0, _height - 35);
			_groundSize = new b2Vec2(_width, 35);
			createPlatform(_groundPos, _groundSize);
			
			for (var i:int = 1; i < 6; i++) 
			{
				createWheel(new b2Vec2(i * 100, 200), 24);
				createWheel(new b2Vec2(i * 100, 100), 24);
				createBody(new b2Vec2(i * 120, 10), new b2Vec2(45, 45));
			}
			
			// var truck:TruckModel = new TruckModel(_world, _scale);
		    // addChild(truck);
			
			addEventListener(Event.ENTER_FRAME, update);	
			
			graphics.beginBitmapFill(_debugBitmap);
			graphics.drawRect(_groundPos.x, _groundPos.y, _groundSize.x, _groundSize.y);
			graphics.endFill();	
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
				if (body.GetUserData() is Sprite) 
				{
					var sprite:Sprite = body.GetUserData();
					sprite.x = body.GetPosition().x * _scale;
					sprite.y = body.GetPosition().y * _scale;
					sprite.rotation = body.GetAngle() * 180 / Math.PI;
				}
			}
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
				
		private function toMeter(value:Number) : Number
		{
			return value / _scale;
		}	
		
		private function createPlatform(posInPixels:b2Vec2, sizeInPixels:b2Vec2) : void 
		{
			var pos:b2Vec2 = new b2Vec2(toMeter(posInPixels.x), toMeter(posInPixels.y));
			var size:b2Vec2 = new b2Vec2(toMeter(sizeInPixels.x), toMeter(sizeInPixels.y));
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.Set(pos.x + size.x / 2, pos.y + size.y / 2);
			
			var body:b2Body = _world.CreateBody(bodyDef);
			
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(size.x / 2, size.y / 2);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 0;
			fixtureDef.friction = 1;
			body.CreateFixture(fixtureDef);
		}
		
		private function createWheel(posInPixels:b2Vec2, radiusInPixels:Number) : void
		{
			var pos:b2Vec2 = new b2Vec2(toMeter(posInPixels.x), toMeter(posInPixels.y));
			var radius:Number = toMeter(radiusInPixels);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(pos.x, pos.y);
			bodyDef.userData = new WheelSprite();
			bodyDef.userData.cacheAsBitmap = true;
			bodyDef.userData.width = 2 * radiusInPixels;
			bodyDef.userData.height = 2 * radiusInPixels;
			addChild(bodyDef.userData);
			
			var body:b2Body = _world.CreateBody(bodyDef);

			var circleShape:b2CircleShape = new b2CircleShape(radius);
	
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0.3;
			body.CreateFixture(fixtureDef);
		}
		
		private function createBody(posInPixels:b2Vec2, sizeInPixels:b2Vec2):void
		{
			var pos:b2Vec2 = new b2Vec2(toMeter(posInPixels.x), toMeter(posInPixels.y));
			var size:b2Vec2 = new b2Vec2(toMeter(sizeInPixels.x), toMeter(sizeInPixels.y));
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.position.Set(pos.x + size.x / 2, pos.y + size.y / 2);
			
			bodyDef.userData = new WoodBoxSprite();
			bodyDef.userData.cacheAsBitmap = true;
			bodyDef.userData.width = sizeInPixels.x;
			bodyDef.userData.height = sizeInPixels.y;
			addChild(bodyDef.userData);
			
			var body:b2Body = _world.CreateBody(bodyDef);
	
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(size.x / 2, size.y / 2);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 5;
			fixtureDef.friction = 0.7;
			body.CreateFixture(fixtureDef);
		}
		
	}

}