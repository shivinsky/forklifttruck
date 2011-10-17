package game.level 
{
    import flash.utils.getDefinitionByName;
    
    /**
     * Level manager
     */
    public class LevelManager 
    {
        private var _levels : Array;
        
        public function LevelManager() 
        {
            _levels = [];
            _levels.push(
                Level1,
                Level2,
                Level3
            );
        }        
        
        public function getLevel(level : uint) : Level
        {
            return new _levels[level]();
        }
        
    }

}