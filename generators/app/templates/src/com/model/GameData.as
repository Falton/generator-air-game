package <%= reversePath %>.<%= projectName %>.model 
{
	/**
	 * ...
	 * @author Dima
	 */
	public class GameData 
	{
		private static var _instance:GameData;
		private static var _allowed:Boolean = false;
		
		public function GameData() 
		{
			if (!_allowed) throw Error("Singlaton");

		}
		
		public static function getInstance():GameData {
			if (_instance == null) {
				_allowed = true;
				_instance = new GameData();
				_allowed = false;
			}
			
			return _instance;
		}
		
	}

}