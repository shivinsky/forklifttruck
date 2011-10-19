package game.level 
{
    import Box2D.Common.Math.b2Vec2;    
    
    import game.entity.*;
    import game.layer.LayerType;
    
    import game.truck.Truck;
    import game.trigger.*
    
    public class Level1 extends Level
    {
        
        public override function create() : void
        {
            _factory.createSky(new b2Vec2(0, 0), new b2Vec2(stage.stageWidth, stage.stageHeight), LayerType.BACK);
            _factory.createBox(new b2Vec2(600, 400), new b2Vec2(45, 45), LayerType.MIDDLE);
            _factory.createPlatform(new b2Vec2(0, stage.stageHeight - 30), new b2Vec2(stage.stageWidth, 30), LayerType.MIDDLE);
            // _factory.createPlatform(new b2Vec2(100, 100), new b2Vec2(100, 100), LayerType.MIDDLE);
            add(new Cone(new b2Vec2(450, 557), new b2Vec2(21, 26)), LayerType.FORE);  
            add(new Cone(new b2Vec2(650, 557), new b2Vec2(21, 26)), LayerType.FORE); 
            add(new Truck(new b2Vec2(200, 500), _world), LayerType.MIDDLE);    
            // add(new TurnTrigger(new b2Vec2(450, 450), new b2Vec2(200, 100), _world, _truck), LayerType.MIDDLE);
        }
        
    }

}