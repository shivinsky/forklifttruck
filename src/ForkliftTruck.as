package  
{
	import game.Truck;
	import debug.FpsCounter;
	import debug.Version;
	import flash.display.Sprite;
	import flash.events.Event;
	
   [SWF(width="640", height="480", backgroundColor="#ffffff", frameRate="40")]
	public class ForkliftTruck extends Sprite
	{
		private var _fpsCounter:FpsCounter = new FpsCounter();
		private var _version:Version = new Version();
		private var _originalFrameRate:uint = 40; 
		private var _standbyFrameRate:uint = 0; 
		private var _truck:Truck = new Truck();
		
		public function ForkliftTruck() 
		{
			addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function create(e:Event) : void
		{
			stage.frameRate = _originalFrameRate;
			
			_version.y += 20;
			
			addChild(_fpsCounter);
			addChild(_version);
			addChild(_truck);
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