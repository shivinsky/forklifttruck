package game 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
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
		private var _iterations:uint = 100;
		private var _scale:Number = 30;
		private var _gravity:b2Vec2 = new b2Vec2(0, 9.8);
		
		private var _width:uint;
		private var _height:uint;
		
		private var _position:Point = new Point(0, 0);
		private var _size:Point = new Point(50, 50);
		
		private var _debugBitmap:BitmapData = new DebugBitmap();
		
		private var _groundPos:b2Vec2;
		private var _groundSize:b2Vec2;
		
		private var _truckModel:TruckModel;
		private var _truckSpeed:Number = 0;
		private var _left:Boolean = false;
		private var _right:Boolean = false;
		
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
			
			var skyBox:Shape = new Shape(); 
			var gradientBoxMatrix:Matrix = new Matrix(); 
			gradientBoxMatrix.createGradientBox(800, 600, Math.PI / 2, 0, 60); 
			skyBox.graphics.beginGradientFill(GradientType.LINEAR, [0x0066FF, 0xFFFFF0], [0.2, 1], [0, 255], gradientBoxMatrix); 
			skyBox.graphics.drawRect(0, 0, 800, 600); 
			skyBox.graphics.endFill();
			addChild(skyBox);
			
			_world = new b2World(_gravity, true);
			
		    setDebugDraw();
			
			_groundPos = new b2Vec2(0, _height - 25);
			_groundSize = new b2Vec2(_width, 25);
			createPlatform(_groundPos, _groundSize);
						
    	    createBody(new b2Vec2(50, 50), new b2Vec2(45, 45));
			createBody(new b2Vec2(50, 0), new b2Vec2(45, 45));
			_truckModel = new TruckModel(new b2Vec2(200, 400), _world, _scale);
		    addChild(_truckModel);
			
			addChild(new TruckModel(new b2Vec2(400, 400), _world, _scale));
			addChild(new TruckModel(new b2Vec2(600, 400), _world, _scale));
			
			for (var i:int = 1; i < 15; i++) 
			{
		//	    createBody(new b2Vec2(i * 50, 10), new b2Vec2(45, 45));
			}
			
			addEventListener(Event.ENTER_FRAME, update);	
			
			var box:Shape = new Shape(); 
			box.graphics.beginBitmapFill(_debugBitmap);
			box.graphics.drawRect(_groundPos.x, _groundPos.y, _groundSize.x, _groundSize.y);
			box.graphics.endFill();
			addChild(box);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
			
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
			
			
			_truckSpeed = 0;
			
			if (_left)
				_truckSpeed = 3.5;
			else if (_right)
				_truckSpeed = - 3.5;
				
			// if (_truckSpeed > 5)
			// 	_truckSpeed = 5;
			// else if (_truckSpeed < - 5)
			// 	_truckSpeed = - 5;
								
			_truckModel.setSpeed(_truckSpeed);
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
			fixtureDef.density = 3;
			fixtureDef.friction = 0.2;
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
			bodyDef.bullet = true;
			addChild(bodyDef.userData);
			
			var body:b2Body = _world.CreateBody(bodyDef);
	
			var polygonShape:b2PolygonShape = new b2PolygonShape();
			polygonShape.SetAsBox(size.x / 2, size.y / 2);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = polygonShape;
			fixtureDef.density = 1;
			fixtureDef.friction = 1;
			fixtureDef.restitution = 0;
			body.CreateFixture(fixtureDef);
			
			var bottomShape:b2PolygonShape = new b2PolygonShape();
			bottomShape.SetAsOrientedBox(size.x / 2, 0.02, new b2Vec2(0, size.y / 2 + 0.2));

			fixtureDef.shape = bottomShape;
			body.CreateFixture(fixtureDef);
		}
		
		private function keyDownListener(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.DOWN)
				_truckModel.setForkSpeed( - 2);
			else if (e.keyCode == Keyboard.UP)
				_truckModel.setForkSpeed(2);
		    if (e.keyCode == Keyboard.LEFT)
				_left = true;
			if (e.keyCode == Keyboard.RIGHT)
				_right = true;		
		}
		
		private function keyUpListener(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.UP)
				_truckModel.setForkSpeed(0);
			if (e.keyCode == Keyboard.LEFT)
				_left = false;
			if (e.keyCode == Keyboard.RIGHT)
				_right = false;
				
		}

	}

}