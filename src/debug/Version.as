package debug 
{
	import flash.system.Capabilities;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Version extends Sprite
	{
		private var _text:TextField = new TextField();
		
		public function Version() 
		{
			_text.text = Capabilities.version;	
			addChild(_text);
		}
		
	}

}