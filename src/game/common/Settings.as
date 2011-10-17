package game.common 
{
    import Box2D.Common.Math.b2Vec2;
    
    public class Settings 
    {
        
        public static var iterations : uint = 10;
        
        public static var scale : uint = 30;
        
        public static var gravity : b2Vec2 = new b2Vec2(0, 9.8);
            
    }

}