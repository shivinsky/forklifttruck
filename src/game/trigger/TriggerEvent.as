package game.trigger 
{
	import flash.events.Event;
	
	/**
	 * Trigger event
	 */
	public class TriggerEvent extends Event
	{
	
		public static const TURN : String = "Turn";
		
		public function TriggerEvent()
		{
			super(TURN, true, false);
		}
		
		public override function clone() : Event 
		{ 
			return new TriggerEvent();
		} 
		
		public override function toString() : String 
		{ 
			return formatToString("TriggerEvent", type, "bubbles", "cancelable", "eventPhase"); 
		}
		
	}

}