package debug 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class FpsCounter extends Sprite 
	{
		private var _time:uint;
		private var _fps:uint = 0;
		private var _frames:uint = 0;
		private var _text:TextField = new TextField();
		
		public function FpsCounter()
		{
			addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function create(e:Event) : void
		{
			addChild(_text);
			addEventListener(Event.ENTER_FRAME, update);
			
			_time = getTimer();
		}
		
		private function destroy(e:Event) : void
		{
			removeEventListener(Event.ENTER_FRAME, update);	
		}
		
		private function update(e:Event) : void
		{
			_frames++;
			if (getTimer() - 1000 >= _time)
			{
				_fps = _frames;
				_frames = 0;
				_time = getTimer();
			}
			_text.text = "FPS: " + _fps + "/" + uint(stage.frameRate);
		}
		
	}

}