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
        
        /**
         * Constructor 
         */
        public function Truck(position : b2Vec2, world : b2World) 
        {                    
            super(position, new b2Vec2(100, 100), world);        
            
            addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
            addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
        }
        
        /**
         * Create
         */
        private function create(e : Event) : void
        {                                
            removeEventListener(Event.ADDED_TO_STAGE, create);
            
            _truckRight = new TruckModel(_position, true, _world);
            _truckLeft = new TruckModel(_position, false, _world);
            _truck = _truckLeft;
            _truck.setActive(true);
            
            addChild(_truck);
            
            stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);    
        }
        
        /**
         * Destroy
         */
        private function destroy(e : Event) : void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
            stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);   
        }
        
        /**
         * Update
         */
        public override function update() : void
        {
            _truck.update();
        }
        
        /**
         * Flip truck
         */
        private function flip() : void
        {
            removeChild(_truck);
            
            var temp : TruckModel = _truck; 
            _truck = _truck == _truckRight ? _truckLeft : _truckRight;    
            _truck.setTransform(temp);
            temp.setActive(false);
            _truck.setActive(true);  
            
            addChild(_truck);
        }
        
        /**
         * Key down listener
         */
        private function keyDownListener(e : KeyboardEvent) : void
        {
            switch (e.keyCode)
            {
                case Keyboard.DOWN:  
                    _truck.setForkSpeed(- 2);
                    break;
                case Keyboard.UP:
                    _truck.setForkSpeed(2);
                    break; 
                case Keyboard.LEFT:
                    _truck.setSpeed(4);
                    break;
                case Keyboard.RIGHT:
                    _truck.setSpeed(- 4); 
                    break;                  
            }
        }
        
        /**
         * Key up listener
         */
        private function keyUpListener(e : KeyboardEvent) : void
        {
            switch (e.keyCode)
            {
                case Keyboard.DOWN:
                case Keyboard.UP:
                    _truck.setForkSpeed(0);
                    break;
                case Keyboard.LEFT:
                case Keyboard.RIGHT:
                    _truck.setSpeed(0);
                    break;
                case Keyboard.SPACE:
                    flip();
                    break;
            }
        }

    }

}