package game.entity 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2World;
    import game.layer.LayerType;
    import game.level.Level;
    
    public class EntityFactory 
    {
        private var _level : Level;
        
        public function EntityFactory(level : Level) 
        {
            _level = level;
        }
        
        public function createBox(position : b2Vec2, size : b2Vec2, layer : uint) : void
        {
            _level.add(new Box(position, size, _level.getWorld()), layer);
        }
        
        public function createPlatform(position : b2Vec2, size : b2Vec2, layer : uint) : void
        {
            _level.add(new Platform(position, size, _level.getWorld()), layer);
        }
        
        public function createSky(position : b2Vec2, size : b2Vec2, layer : uint) : void
        {
            _level.add(new Sky(position, size), layer);
        }
        
    }

}