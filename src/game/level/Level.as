package game.level 
{
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.*;
    
    import flash.display.Sprite;
    import flash.events.Event;
    
    import game.entity.*;
    import game.common.*;
    import game.layer.*;
    
    /**
     * Level 
     */
    public class Level extends Sprite
    {        
        private var _scale : uint;
        private var _iterations : uint;
		private var _debug : Boolean;
        private var _debugDraw : b2DebugDraw;
		
        protected var _world : b2World;
        protected var _factory : EntityFactory;
        protected var _layers : LayerManager;
        
        protected var _truck : PhysicEntity;
        
        public function Level() 
        {
            _world = new b2World(Settings.gravity, true);    
            _factory = new EntityFactory(this);
            _layers = new LayerManager(this);
            _scale = Settings.scale;
            _iterations = Settings.iterations;
            
			_debug = false;
			_debugDraw = new b2DebugDraw();
            _debugDraw.SetSprite(new Sprite());
            _debugDraw.SetFillAlpha(0.5);
            _debugDraw.SetLineThickness(2.0);
            _debugDraw.SetDrawScale(_scale);
            _debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
        }
        
        public function setDebug(value : Boolean) : void
        {
            if (value)
            {
				addChild(_debugDraw.GetSprite());
                _world.SetDebugDraw(_debugDraw);		
            }
            else
            {			
				removeChild(_debugDraw.GetSprite());
                _world.SetDebugDraw(null);
            }
          	_debug = !_debug;  
        }
		
		public function isDebug() : Boolean
		{
			return _debug;
		}
        
        public function create() : void
        {
        }
        
        public function getWorld() : b2World
        {
            return _world;
        }
        
        public function add(entity : Entity, layer : uint) : void
        {
            _layers.getLayer(layer).addEntity(entity);
        }
        
        public function update(event : Event = null) : void
        {            
            _world.Step(1.0 / stage.frameRate, _iterations, _iterations);
            _world.ClearForces();
            _world.DrawDebugData();
            
            for (var body : b2Body = _world.GetBodyList(); body; body = body.GetNext()) 
            {
                 if (body.GetUserData() is Sprite) 
                {
                    var sprite : Sprite = body.GetUserData();
                    sprite.x = body.GetPosition().x * _scale;
                    sprite.y = body.GetPosition().y * _scale;
                    sprite.rotation = body.GetAngle() * 180 / Math.PI;
                }
            }
            
            _layers.update();
        }
    }

}