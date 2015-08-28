package <%= reversePath %>.<%= projectName %>.managers 
{
	import <%= reversePath %>.<%= projectName %>.events.AcheivementEvent
	import <%= reversePath %>.<%= projectName %>.model.UserData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Dima
	 */
	public class AchievementsManager extends EventDispatcher
	{
		private static var _instance:AchievementsManager;
		private static var _allowed:Boolean = false;
		
		private var _achievements:Vector.<Achievement>;
		private var _newlyUnlocked:Vector.<Achievement>;
		private var _achievementLoader:URLLoader;
		public function AchievementsManager() 
		{
			if (!_allowed) throw Error("Singalton");
			this._achievements = new Vector.<Achievement>();
			this._newlyUnlocked = new Vector.<Achievement>();
			loadAchievevments();
		}
		
		public static function getInstance():AchievementsManager {
			if (_instance == null) {
				_allowed = true;
				_instance = new AchievementsManager();
				_allowed = false;
			}
			return _instance;
		}
		
		public function resubmitAchievements():void {
			var imax:uint = this._achievements.length;
			for (var i:uint = 0; i < imax; i++) {
				this._achievements[i].submit();
			}
			UserData.getInstance().saveStats();
		}
		
		public function toObject():Object {
			var rval:Object = new Object();
			rval.achievement = new Array();
			var imax:uint = this._achievements.length;
			for (var i:uint = 0; i < imax; i++) {
				rval.achievement[i] = this._achievements[i].toObject();
			}
			
			return rval;
		}
		
		public function getAchievementById(id:uint):Achievement {
			var imax:uint = this._achievements.length;
			for (var i:uint = 0; i < imax; i++) {
				if (this._achievements[i].id == id) return this._achievements[i];
			}
			
			return null;
		}
		
		public function get completedAchievements():Vector.<Achievement> {
			var rval:Vector.<Achievement> = new Vector.<Achievement>();
			var imax:uint = this._achievements.length;
			for (var i:uint = 0; i < imax; i++) {
				if (this._achievements[i].achieved) rval.push(this._achievements[i]);
			}
			
			return rval;
		}
		
		
		
		private function loadAchievevments():void {
			this._achievementLoader = new URLLoader();
			this._achievementLoader.addEventListener(Event.COMPLETE, onAchievementsLoaded);
			this._achievementLoader.load(new URLRequest("Achievements.json"));
			
		}
		private function onAchievementsLoaded(e:Event):void{
			var achievementJSON:Object = JSON.parse( this._achievementLoader.data);
			for each(var teamObj:Object in achievementJSON.achievements) {
				var tmpAchievement:Achievement = new Achievement();
				tmpAchievement.createAchievementFromObject(teamObj);
				this._achievements.push(tmpAchievement);
			}
		}
		
		public function get achievements():Vector.<Achievement> { return this._achievements; }
		public function get visibleAchievements():Vector.<Achievement> { 
			var rval:Vector.<Achievement> = new Vector.<Achievement>();
			var imax:uint = this._achievements.length;
			for (var i:uint = 0; i < imax; i++) {
				if (this._achievements[i].visible) rval.push(this._achievements[i]);
			}
			return rval; 
		}
		
		public function addUnlocked(e:Achievement):void {
			this._newlyUnlocked.push(e);
			
			if (this._newlyUnlocked.length == 1) {
				dispatchEvent(new AcheivementEvent(AcheivementEvent.NEW_ACHIEVEMENT_UNLOCKED));
			}
		}
		
		public function get newUnlockedAchievements():Vector.<Achievement> { return this._newlyUnlocked; }
		public function getNextUnlock():Achievement {
			if (this._newlyUnlocked.length > 0) {
				return this._newlyUnlocked.shift();
			}
			
			return null;
		}
		public function resetNewUnlocks():void { this._newlyUnlocked = new Vector.<Achievement>(); }
	
		public function fromUserObject(val:Object = null):void {
			var imax:uint = this._achievements.length;
			var i:uint;
			if(val==null){
				for (i = 0; i < imax; i++) {
					this._achievements[i].activateAchievement();
				}
			}else {
				for (i = 0; i < imax; i++) {
					if (val.achievement[i].achieved) {
						this._achievements[i].achieved = true;
					}else {
						this._achievements[i].activateAchievement(val.achievement[i].stats);
					}
					this._achievements[i].submitted = val.achievement[i].submitted;
					
				}
			}
		}
		
	}

}