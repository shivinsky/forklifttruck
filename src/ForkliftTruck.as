package  
{
	import game.Truck;
	import framework.SWFProfiler;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import level.LevelManager;
	
	public class ForkliftTruck extends Sprite
	{

		private var _originalFrameRate:uint = 60; 
		private var _standbyFrameRate:uint = 0; 
		
		public function ForkliftTruck() 
		{
			addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function create(e:Event = null) : void
		{
			stage.frameRate = _originalFrameRate;

			SWFProfiler.init(stage, this);
			SWFProfiler.show();
						
			var level = new LevelManager();
			addChild(new Truck());
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ACTIVATE, activate); 
			addEventListener(Event.DEACTIVATE, deactivate);

		}
		
		private function destroy(e:Event) : void
		{
			removeEventListener(Event.ACTIVATE, activate); 
			removeEventListener(Event.DEACTIVATE, deactivate);
			removeEventListener(Event.ENTER_FRAME, update);	
		}	
		
		function activate(e:Event) : void 
		{ 
			stage.frameRate = _originalFrameRate; 
		} 

		function deactivate(e:Event ) : void 
		{ 
			stage.frameRate = _standbyFrameRate; 
		}
			
		private function update(e:Event) : void
		{

	    }
		
	}

}