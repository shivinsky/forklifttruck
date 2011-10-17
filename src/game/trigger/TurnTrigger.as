package game.trigger 
{
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2World;
    
    import game.entity.PhysicEntity;
    
    import flash.utils.getTimer;
    
    /**
     * Turn trigger
     */
    public class TurnTrigger extends Trigger
    {
        
        private var _time : int;
        private var _target : PhysicEntity;
        private var _area : b2AABB;
        private var _previous : Boolean;
        private var _current : Boolean;
        
        public function TurnTrigger(position : b2Vec2, size : b2Vec2, world : b2World, target : PhysicEntity) 
        {
            super(position, size, world);
            
            _target = target;
            _area = new b2AABB();
            _area.lowerBound.Set(position.x / _scale, position.y / _scale);
            _area.upperBound.Set(size.x / _scale, size.y / _scale);
            _previous = false;
            
            graphics.lineStyle(1, 0x000000);
            graphics.drawRect(position.x, position.y, size.x, size.y);
                        
            _time = getTimer();
        }
        
        private function checkBody(fixture : b2Fixture) : Boolean
        {
            return false;
        }
        
        public override function update() : void
        {
            // Every 200 ms
            if (getTimer() - _time > 200)
            {
                _world.QueryAABB(checkBody, _area);
                
                // Don't spam
                if (_previous != _current)
                {
                    dispatchEvent(new TriggerEvent());
                    _previous = _current;
                }
                
                _time = getTimer();
            }
        }
        
    }

}