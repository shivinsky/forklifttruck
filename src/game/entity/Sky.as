package game.entity 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.geom.Matrix;
	import flash.display.Sprite;
	import flash.display.GradientType;
	
	/**
	 * Simple gradient sky
	 */
	public class Sky extends Entity
	{
		
		public function Sky(position : b2Vec2, size : b2Vec2) 
		{
			super(position, size);
			
			create();
		}
		
		private function create() : void
		{
			var skyBox : Sprite = new Sprite(); 
			var gradientBox : Matrix = new Matrix(); 
			gradientBox.createGradientBox(_size.x, _size.y, Math.PI / 2, 0, 60); 
			skyBox.graphics.beginGradientFill(GradientType.LINEAR, [0x0066FF, 0xFFFFF0], [0.2, 1], [0, 255], gradientBox); 
			skyBox.graphics.drawRect(_position.x, _position.y, _size.x, _size.y); 
			skyBox.graphics.endFill();
			addChild(skyBox);	
		}
		
		public override function update() : void
		{		
		}
		
	}

}