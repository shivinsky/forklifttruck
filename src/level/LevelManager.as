package level 
{

	public class LevelManager 
	{
		private _levels:Array = new Array();
		
		public function LevelManager() 
		{
			_levels[0] = new Level1();
			_levels[1] = new Level2();
		}
		
	}

}