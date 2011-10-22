package game 
{
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.display.Sprite;
 
    import game.level.Level;
    import game.level.LevelManager;
    
    import flash.filters.*;

    /**
     * Game
     */
    public class Game extends Sprite
    {
        private var _levelManager : LevelManager;
        private var _currentLevel : Level;
        
        public function Game() 
        {
            addEventListener(Event.ADDED_TO_STAGE, create, false, 0, true);
            addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
        }
          
        private function create(event : Event = null)
        {
            removeEventListener(Event.ADDED_TO_STAGE, create);
            _levelManager = new LevelManager();
            _currentLevel = _levelManager.getLevel(0);
            addChild(_currentLevel);    
            // FIX
            _currentLevel.create();

            addEventListener(Event.ENTER_FRAME, update);
            stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener); 
        }
  
        private function keyUpListener(e : KeyboardEvent) : void
        {
            // Ctrl + D
            if (e.keyCode == 68)
            {
                _currentLevel.setDebug(!_currentLevel.isDebug());  
            } 
            // Restart level
            // Move to LevelManager?
            else if (e.keyCode == 82)
            {
                if (_currentLevel)
                {
                   removeChild(_currentLevel);
                }
                _currentLevel = _levelManager.getLevel(0);
                addChild(_currentLevel);
                _currentLevel.create();
            }
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