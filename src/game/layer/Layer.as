package game.layer 
{
    import flash.display.Sprite;
    
    import game.entity.Entity;

    public class Layer extends Sprite
    {
        
        private var _type : uint;
        private var _entities : Array;
        
        public function Layer(layer : uint) 
        {
            _type = layer;
            _entities = [];
        }
        
        public function addEntity(entity : Entity)
        {
            _entities.push(entity);
            addChild(entity);
        }
        
        public function update() : void
        {
            for (var i : uint = 0; i < _entities.length; i++)
            {
                _entities[i].update();
            }
        }
        
    }

}