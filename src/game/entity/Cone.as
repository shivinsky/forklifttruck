package game.entity 
{
    import Box2D.Common.Math.b2Vec2;

    /**
    * Cone
    */
    public class Cone extends Entity
    {

    public function Cone(position : b2Vec2, size : b2Vec2, angle : Number = 0) 
    {
        super(position, size, angle);

        addChild(new ConeSprite()); 
    }

    }

}