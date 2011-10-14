package game 
{
	import flash.events.Event;
	import flash.display.Sprite;
	import game.level.Level;
	import game.level.LevelManager;
	
	import flash.filters.*;

	public class Game extends Sprite
	{
		private var _levelManager:LevelManager;
		private var _currentLevel:Level;
		
		public function Game() 
		{
			addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		private function create(event:Event = null)
		{
			_levelManager = new LevelManager();
			_currentLevel = _levelManager.getLevel(0);
			addChild(_currentLevel);	
			// FIX
			_currentLevel.create();
			removeEventListener(Event.ADDED_TO_STAGE, create);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function destroy(event:Event)
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event)
		{
			_currentLevel.update();
		}
		
	}

}