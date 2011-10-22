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
            _factory.createPlatform(new b2Vec2(0, stage.stageHeight - 30), new b2Vec2(stage.stageWidth, 30), LayerType.MIDDLE);
            _factory.createPlatform(new b2Vec2(600, 510), new b2Vec2(200, 90), LayerType.MIDDLE);
             
            _factory.createBox(new b2Vec2(400, 515), LayerType.MIDDLE);      
            _factory.createBox(new b2Vec2(45, 515), LayerType.MIDDLE);
            _factory.createBox(new b2Vec2(0, 515), LayerType.MIDDLE);
            _factory.createBox(new b2Vec2(0, 465), LayerType.MIDDLE);
            
            add(new Cone(new b2Vec2(20, 557), new b2Vec2(21, 26)), LayerType.FORE);  
            add(new Cone(new b2Vec2(40, 557), new b2Vec2(21, 26)), LayerType.FORE); 
            add(new Truck(new b2Vec2(100, 460), _world), LayerType.MIDDLE);    
            // add(new TurnTrigger(new b2Vec2(450, 450), new b2Vec2(200, 100), _world, _truck), LayerType.MIDDLE);
        }
        
    }

}