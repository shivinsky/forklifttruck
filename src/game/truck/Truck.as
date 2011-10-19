package game.truck 
{

    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2World;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import game.entity.PhysicEntity;
    import game.trigger.TriggerEvent;
            
    /**
     * Truck
     */
    public class Truck extends PhysicEntity
    {                
        private var _truckRight : TruckModel;
        private var _truckLeft : TruckModel;
        private var _truck : TruckModel;
        
        public function Truck(position : b2Vec2, world : b2World) 
        {                    
            super(position, new b2Vec2(100, 10), world);
            
            _truckRight = new TruckModel(position, true, world, _scale);
            _truckLeft = new TruckModel(position, false, world, _scale);
            _truck = _truckLeft;
            _truck.setActive(true);
            addChild(_truck);
            
            addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
        }
        
        private function create(e : Event) : void
        {                                    
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);    
        }
        
        public override function update() : void
        {
            _truck.update();
        }
        
        private function keyDownListener(e : KeyboardEvent) : void
        {
            if (e.keyCode == Keyboard.DOWN)
            {
                _truck.setForkSpeed(- 2);
            }
            else if (e.keyCode == Keyboard.UP)
            {
                _truck.setForkSpeed(2);
            }
            else if (e.keyCode == Keyboard.LEFT)
            {
                _truck.setSpeed(4);
            }
            else if (e.keyCode == Keyboard.RIGHT)
            {
                _truck.setSpeed(- 4);    
            }
        }
        
        private function keyUpListener(e : KeyboardEvent) : void
        {
            if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.UP)
                _truck.setForkSpeed(0);
            else if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT)
                _truck.setSpeed(0);
            else if (e.keyCode == Keyboard.SPACE)
            {  
                removeChild(_truck);

                var temp : TruckModel = _truck; 
                _truck = _truck == _truckRight ? _truckLeft : _truckRight;    
                _truck.setTransform(temp);

                temp.setActive(false);
                _truck.setActive(true);

                addChild(_truck);
            }
        }

    }

}