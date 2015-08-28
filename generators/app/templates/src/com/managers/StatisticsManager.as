package <%= reversePath %>.<%= projectName %>.managers 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dima
	 */
	public class StatisticsManager 
	{
		private static var _instance:StatisticsManager;
		private static var _allowed:Boolean = false;
		
		private var _statsCollections:Object;			//collection of arrays of stats (each array is the same stat based on stat type)
		public function StatisticsManager() 
		{
			if (!_allowed) throw Error("Singalton");
			this._statsCollections = new Object();
		}
		
		public static function getInstance():StatisticsManager {
			if (_instance == null) {
				_allowed = true;
				_instance = new StatisticsManager();
				_allowed = false;
			}
			return _instance;
		}
		
		/**
		 * update all stats of type with value
		 * @param	type
		 * @param	value
		 */
		public function update(type:String, value:Number):void {
			var i:int;
			var imax:int = (this._statsCollections[type] != undefined)?this._statsCollections[type].length:0;
			for (i = 0; i < imax; i++) {
				this._statsCollections[type][i].value = this._statsCollections[type][i].value + value;
			}
		
			
			//check for achieved stats and delete them
			for (i = (imax - 1); i >= 0 ; i--) {
				if (this._statsCollections[type][i].achieved) this._statsCollections[type].splice(i, 1);
			}
		}
		
		/**
		 * lock the stat from being updated, example if the stat cannot be achieved it can be temporarly locked
		 * @param	type
		 */
		public function lock(type:String):void {
			var i:int;
			var imax:int = (this._statsCollections[type] != undefined)?this._statsCollections[type].length:0;
			for (i = 0; i < imax; i++) {
				this._statsCollections[type][i].lock=true;
			}
		}
		
		public function unlock(type:String):void {
			var i:int;
			var imax:int = (this._statsCollections[type] != undefined)?this._statsCollections[type].length:0;
			for (i = 0; i < imax; i++) {
				this._statsCollections[type][i].lock= false;
			}
		}
		
		public function reset(type:String,value:Number=0):void {
			var i:int;
			var imax:int = (this._statsCollections[type] != undefined)?this._statsCollections[type].length:0;
			for (i = 0; i < imax; i++) {
				this._statsCollections[type][i].reset(value);
			}
		}
		
		/**
		 * addStat adds the stat and returns the id of that stat to be used for deleting the stat
		 * @param	val
		 * @return
		 */
		public function addStat(val:Stat):uint {
			trace("StatisticsManager::addStat(" + arguments + ")");
			if (this._statsCollections[val.type] == null) {
				this._statsCollections[val.type] = new Array();
			}
			this._statsCollections[val.type].push(val);
			//trace("StatisticsManager::addStat(" + val + ") = " + this._statsCollections[val.type].length);
			return this._statsCollections[val.type].length - 1;
		}
		
		/**
		 * deleteStat marks the stat for deletion
		 * @param	id
		 * @return
		 */
		public function deleteStat(id:uint,type:String):Boolean {
			if (this._statsCollections[type][id] != undefined) {
				this._statsCollections[type][id].achieved = true;
				return true;
			}else {
				return false;
			}
		}
		
	}

}