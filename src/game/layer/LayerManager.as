package game.layer 
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    public class LayerManager 
    {
        private var _layers : Array;
        
        public function LayerManager(container : Sprite) 
        {
            _layers = [];
            
            container.addChild(addLayer(LayerType.BACK));
            container.addChild(addLayer(LayerType.MIDDLE));
            container.addChild(addLayer(LayerType.FORE));
        }
        
        private function addLayer(layerType : uint) : Layer
        {
            var layer : Layer = new Layer(layerType);
            _layers.push(layer);
            return layer;
        }
        
        public function getLayer(layer : uint) : Layer
        {
            return _layers[layer];
        }
        
        public function getLayersCount() : uint
        {
            return _layers.length;
        }
        
        public function update() : void
        {
            for (var i : uint = 0; i < _layers.length; i++)
            {
                _layers[i].update();
            }
        }
        
    }

}