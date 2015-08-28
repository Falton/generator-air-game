package <%= reversePath %>.<%= projectName %>.model 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Dima
	 */
	public class UserData 
	{
		public static var GAMECENTER_OPEN:Boolean = false;
		public static var GAMECENTER_LOGIN:Boolean = true;
		
		private static var _instance:UserData;
		private static var _allowed:Boolean = false;
		
		public function UserData() 
		{
			if (!_allowed) throw Error("Singlaton");
			
			this._localSavedData = SharedObject.getLocal("<%= projectName %>");
		}
		
		public static function getInstance():UserData {
			if (_instance == null) {
				_allowed = true;
				_instance = new UserData();
				_allowed = false;
			}
			
			return _instance;
		}
	
		private function loadSavedData():void {
			
		}
		
		public function save():void {
		
			this._localSavedData.flush();
			
			try {	
				this._localSavedData.flush();
			}catch (e:Error) {
				trace("NOT SAVED " + e);
			}
		}
	}
	

}