package game.truck 
{
    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Common.b2Settings;
    import Box2D.Dynamics.Contacts.*;
    import Box2D.Dynamics.Joints.*;
    import flash.geom.Point;
    
    import game.entity.*;
    
    import flash.display.Sprite;
    import flash.events.*;
    
    /**
     * Truck model
     */
    public class TruckModel extends PhysicEntity
    {
        private var _body:b2Body;
        
        private var _leftWheel:b2Body;
        private var _leftWheelJoint:b2RevoluteJoint;
        private var _leftWheelSprite : Sprite;
        
        private var _rightWheel:b2Body;
        private var _rightWheelJoint:b2RevoluteJoint;
        private var _rightWheelSprite : Sprite;
                
        private var _fork:b2Body;
        private var _forkOffset:int;
        private var _forkJoint:b2PrismaticJoint;
        private var _forkSensor : b2Fixture;
       
        private var _flip:Boolean;
        
        /**
         * Constructor
         */
        public function TruckModel(position:b2Vec2, flip:Boolean, world:b2World) 
        {
            super(position, new b2Vec2(100, 100), world);

            _flip = flip;
            create();
        }
        
        private function create(event : Event = null) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, create);
            _body = createBody(_position, new b2Vec2(123, 103));    

            _leftWheel = createWheel(new b2Vec2(_position.x + 30, _position.y + 89), 24);
            _rightWheel = createWheel(new b2Vec2(_position.x + 95, _position.y + 89), 24);
            
            // FIX THIS SHIT
            _forkOffset = - 46;
            if (_flip)
            {
                _forkOffset = + 123;
            }
            _fork = createFork(new b2Vec2(_position.x + _forkOffset, _position.y), new b2Vec2(46, 41));
                
            var leftRevoluteJointDef:b2RevoluteJointDef = new  b2RevoluteJointDef();
            leftRevoluteJointDef.Initialize(_leftWheel, _body, _leftWheel.GetWorldCenter());
            leftRevoluteJointDef.maxMotorTorque = 350.0;
            leftRevoluteJointDef.enableMotor = true;
            _leftWheelJoint = _world.CreateJoint(leftRevoluteJointDef) as b2RevoluteJoint;
            
            var rightRevoluteJointDef:b2RevoluteJointDef = new  b2RevoluteJointDef();
            rightRevoluteJointDef.Initialize(_rightWheel, _body, _rightWheel.GetWorldCenter());
            rightRevoluteJointDef.maxMotorTorque = 350.0;
            rightRevoluteJointDef.enableMotor = true;
            _rightWheelJoint = _world.CreateJoint(rightRevoluteJointDef) as b2RevoluteJoint;
            
            var forkPrismaticJointDef: b2PrismaticJointDef = new b2PrismaticJointDef();
            var axis: b2Vec2 = new b2Vec2(0, 1);
            forkPrismaticJointDef.Initialize(_fork, _body, _fork.GetWorldCenter(), axis);
            forkPrismaticJointDef.lowerTranslation = -2.3;
            forkPrismaticJointDef.upperTranslation = 0;
            forkPrismaticJointDef.enableLimit = true;
            forkPrismaticJointDef.maxMotorForce = 1500;
            forkPrismaticJointDef.motorSpeed = 0;
            forkPrismaticJointDef.enableMotor = true;
            _forkJoint = _world.CreateJoint(forkPrismaticJointDef) as b2PrismaticJoint;
        }
        
        private function destroy(event : Event) : void
        {
            
        }
                        
        private function createWheel(posInPixels:b2Vec2, radiusInPixels:Number):b2Body
        {
            var pos:b2Vec2 = new b2Vec2(posInPixels.x / _scale, posInPixels.y / _scale);
            
            var shape:b2CircleShape = new b2CircleShape(radiusInPixels / _scale);
            
            var fixture:b2FixtureDef = new b2FixtureDef();
            fixture.shape = shape;
            fixture.density = 10;
            fixture.friction = 10;
            fixture.restitution = 0.1;
            fixture.filter.groupIndex = - 1;
            
            var bodyDef:b2BodyDef = new b2BodyDef();    
            bodyDef.type = b2Body.b2_dynamicBody;
            bodyDef.active = false;
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
        
        private function invertAxis(element:b2Vec2, index:int, arr:Array):void 
        {
            element.x = - element.x;
        }
        
        private function createBody(posInPixels:b2Vec2, sizeInPixels:b2Vec2):b2Body
        {
            var pos:b2Vec2 = new b2Vec2(posInPixels.x / _scale, posInPixels.y / _scale);
            var size:b2Vec2 = new b2Vec2(sizeInPixels.x / _scale, sizeInPixels.y / _scale);
                                    
            var sprite:Sprite = new BodySprite();
            sprite.width = sizeInPixels.x;
            sprite.height = sizeInPixels.y;
            sprite.cacheAsBitmap = true;    
            if (_flip)
            {
                sprite.scaleX = - 1;
            }
            addChild(sprite);
            
            var bodyDef:b2BodyDef = new b2BodyDef();    
            bodyDef.type = b2Body.b2_dynamicBody;
            bodyDef.position.Set(pos.x + size.x / 2, pos.y + size.y / 2);
            bodyDef.userData = sprite;
            bodyDef.active = false;
            
            var body:b2Body = _world.CreateBody(bodyDef);
                        
            var shapeCabin:b2PolygonShape = new b2PolygonShape();
            var verticesCabin:Array = new Array();
            verticesCabin.push(new b2Vec2(- 50 / _scale, 42 / _scale));
            verticesCabin.push(new b2Vec2(- 50 / _scale, 6 / _scale));
            verticesCabin.push(new b2Vec2(- 35 / _scale, - 35 / _scale));
            verticesCabin.push(new b2Vec2(10 / _scale, - 35 / _scale));
            verticesCabin.push(new b2Vec2(10 / _scale, 42 / _scale));    
            
            var shapeEngine:b2PolygonShape = new b2PolygonShape();
            var verticesEngine:Array = new Array();
            verticesEngine.push(new b2Vec2(10 / _scale, 42 / _scale));    
            verticesEngine.push(new b2Vec2(10 / _scale, - 2 / _scale));
            verticesEngine.push(new b2Vec2(61 / _scale,  10 / _scale));
            verticesEngine.push(new b2Vec2(61 / _scale, 42 / _scale));    
            
            var shapePipe:b2PolygonShape = new b2PolygonShape();
            var verticesPipe:Array = new Array();
            verticesPipe.push(new b2Vec2(18 / _scale, 0 / _scale));
            verticesPipe.push(new b2Vec2(18 / _scale, - 25 / _scale));
            verticesPipe.push(new b2Vec2(24 / _scale, - 25 / _scale));
            verticesPipe.push(new b2Vec2(24 / _scale, 1 / _scale));        
            
            var shapeFork:b2PolygonShape = new b2PolygonShape();
            var verticesFork:Array = new Array();
            verticesFork.push(new b2Vec2(- 61 / _scale, 51 / _scale));
            verticesFork.push(new b2Vec2(- 61 / _scale, - 51 / _scale));
            verticesFork.push(new b2Vec2(- 55 / _scale, - 51 / _scale));    
            verticesFork.push(new b2Vec2(- 55 / _scale, 51 / _scale));    

            if (_flip)
            {
                verticesCabin.reverse();
                verticesCabin.forEach(invertAxis);
                
                verticesEngine.reverse();
                verticesEngine.forEach(invertAxis);
                
                verticesPipe.reverse();
                verticesPipe.forEach(invertAxis);
                
                verticesFork.reverse();
                verticesFork.forEach(invertAxis);
            }
            
            shapeCabin.SetAsArray(verticesCabin);
            shapeEngine.SetAsArray(verticesEngine);    
            shapePipe.SetAsArray(verticesPipe);
            shapeFork.SetAsArray(verticesFork);
            
            var fixture:b2FixtureDef = new b2FixtureDef();
            fixture.density = 30;
            fixture.friction = 1;
            fixture.restitution = 0;
            fixture.filter.groupIndex = - 1;
            
            fixture.shape = shapeCabin;
            body.CreateFixture(fixture);
            
            fixture.shape = shapeEngine;
            body.CreateFixture(fixture);
                            
            fixture.shape = shapePipe;
            body.CreateFixture(fixture);
            
            fixture.shape = shapeFork;    
            body.CreateFixture(fixture);
            
            return body;
        }
        
        private function createFork(posInPixels:b2Vec2, sizeInPixels:b2Vec2):b2Body
        {
            var pos:b2Vec2 = new b2Vec2(posInPixels.x / _scale, posInPixels.y / _scale);
            var size:b2Vec2 = new b2Vec2(sizeInPixels.x / _scale, sizeInPixels.y / _scale);
                        
            var bodyDef:b2BodyDef = new b2BodyDef();    
            bodyDef.type = b2Body.b2_dynamicBody;
            bodyDef.position.Set(pos.x + size.x / 2, pos.y + size.y / 2);
            bodyDef.active = false;
            bodyDef.userData = new ForkSprite();
            bodyDef.userData.cacheAsBitmap = true;
            bodyDef.userData.width = sizeInPixels.x;
            bodyDef.userData.height = sizeInPixels.y;
            if (_flip)
            {
                bodyDef.userData.scaleX = - 1;
            }
            addChild(bodyDef.userData);
            
            var body:b2Body = _world.CreateBody(bodyDef);
			
            var verticesHor:Array = new Array();
			
		    verticesHor.push(new b2Vec2( - 23 / _scale, 19.5 / _scale));
            verticesHor.push(new b2Vec2( - 23 / _scale, 19 / _scale));
            verticesHor.push(new b2Vec2(23 / _scale, 19 / _scale));
            verticesHor.push(new b2Vec2(23 / _scale, 20 / _scale));
			

                  
			var verticesVer: Array = new Array();
			
			verticesVer.push(new b2Vec2( 18 / _scale, 20 / _scale));
			verticesVer.push(new b2Vec2( 18 / _scale, -20 / _scale));
			verticesVer.push(new b2Vec2( 23 / _scale, -20 / _scale));
			verticesVer.push(new b2Vec2( 23 / _scale, 20 / _scale));
			
			
			if (_flip)
            {
                verticesHor.reverse();
                verticesHor.forEach(invertAxis);
                
                verticesVer.reverse();
                verticesVer.forEach(invertAxis);
            }
			
			var shapeHor:b2PolygonShape = new b2PolygonShape();
			var shapeVer:b2PolygonShape = new b2PolygonShape();
			
			shapeHor.SetAsArray(verticesHor);
			shapeVer.SetAsArray(verticesVer);
			
			var fixture:b2FixtureDef = new b2FixtureDef();
			
            fixture.density = 5;
            fixture.friction = 0.5;
            fixture.restitution = 0;
            fixture.filter.groupIndex = - 1;
			
			fixture.shape = shapeHor;
			body.CreateFixture(fixture);
			
			fixture.shape = shapeVer;
			body.CreateFixture(fixture);
            
            // Sensors
            var sensorShape : b2PolygonShape = new b2PolygonShape();
            sensorShape.SetAsOrientedBox(0.1, 0.1, new b2Vec2(0, 0.4));
   
            var sensorFixture : b2FixtureDef = new b2FixtureDef();
            sensorFixture.shape = sensorShape;
            sensorFixture.density = 0;
            sensorFixture.isSensor = true;
            sensorFixture.filter.groupIndex = - 1;

            _forkSensor = body.CreateFixture(sensorFixture);
            
            return body;
        }
                
        public function setSpeed(speed : Number) : void
        {
            if (_leftWheelJoint.GetMotorSpeed() != speed || _rightWheelJoint.GetMotorSpeed() != speed)
            {
                _leftWheelJoint.SetMotorSpeed(speed);
                _rightWheelJoint.SetMotorSpeed(speed);
            }
        }
        
        public function setForkSpeed(speed : Number) : void
        {
            if (_forkJoint.GetMotorSpeed() != speed)
            {
                _forkJoint.SetMotorSpeed(speed);
            }
        }
  
        public function setTransform(truck : TruckModel) : void
        {
            _body.SetTransform(truck._body.GetTransform());
            _leftWheel.SetTransform(truck._leftWheel.GetTransform());
            _rightWheel.SetTransform(truck._rightWheel.GetTransform());

            // Set fork position
            var forkPos : b2Vec2 = _body.GetPosition();
            forkPos.x += _forkOffset / _scale;
            forkPos.y = truck._fork.GetPosition().y;
            _fork.SetPosition(forkPos);
            
            transferCargo(truck);
        }
        
        private function transferCargo(truck : TruckModel) : void
        {
            // Set boxes position
            var boxPos : b2Vec2 = _fork.GetPosition();
            boxPos.x -= 1;

            var contactList : b2ContactEdge = truck._fork.GetContactList();
            var contact : b2Contact;
            var box : b2Fixture = null;
            while (contactList)
            {
                contact = contactList.contact;
                if (contact.GetManifold().m_pointCount > 0)
                {
                    // Find box
                    if (contact.GetFixtureA().GetBody().GetUserData() is Box)
                        box = contact.GetFixtureA();
                    else if (contact.GetFixtureB().GetBody().GetUserData() is Box)
                        box = contact.GetFixtureB();
                        
                    if (box && box.GetAABB().TestOverlap(truck._forkSensor.GetAABB()))
                    {
                        box.GetBody().SetPosition(boxPos);    
                        break;
                    }
                }
                contactList = contactList.next;
            }
            
            // FIX
            if (box)
            {
                var forkPos : b2Vec2 = _fork.GetPosition();
                forkPos.y -= 0.1;
                _fork.SetPosition(forkPos);
            }    
        }

        public function setActive(active : Boolean) : void
        {
            _leftWheelJoint.SetMotorSpeed(0);
            _rightWheelJoint.SetMotorSpeed(0); 
            _fork.SetLinearVelocity(new b2Vec2(0, 0));
            _body.SetLinearVelocity(new b2Vec2(0, 0));
            _leftWheel.SetLinearVelocity(new b2Vec2(0, 0));
            _rightWheel.SetLinearVelocity(new b2Vec2(0, 0));
            _body.SetActive(active);
            _fork.SetActive(active);
            _leftWheel.SetActive(active);
            _rightWheel.SetActive(active);
        }
                
        public override function update() : void
        {
        }
        
    }

}