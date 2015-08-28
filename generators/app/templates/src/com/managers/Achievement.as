package <%= reversePath %>.<%= projectName %>.managers 
{
	import <%= gameCenterANE %>
	import <%= reversePath %>.<%= projectName %>.model.UserData;
	/**
	 * ...
	 * @author Dima
	 */
	public class Achievement 
	{
		private var _stats:Vector.<Stat>;
		private var _id:uint;
		private var _onlineId:String;
		private var _submitted:Boolean;
		private var _name:String;
		private var _desc:String;
		private var _statManager:StatisticsManager;
		private var _initialized:Boolean;
		private var _achieved:Boolean;
		private var _visible:Boolean;
		private var _achivManager:AchievementsManager;
		public function Achievement() 
		{
			this._achieved = false;
			this._initialized = false;
			this._stats = new Vector.<Stat>();
			this._statManager = StatisticsManager.getInstance();
			this._submitted = false;
		}
		
		public function createAchievementFromObject(val:Object):void {
			this._id = val.id;
			this._onlineId = val.onlineId;
			this._name = val.name;
			this._desc = val.description;
			this._visible = val.visible;
			for each(var monitor:Object in val.monitor) {
				var tmpStat:Stat = new Stat(monitor.statType, monitor.creteria, monitor.result, this.statFinished);
				tmpStat.persistence = monitor.persistence;
				this._stats.push(tmpStat);
			}
		}
		
		public function get statCount():uint { return this._stats.length; }
		public function set submitted(val:Boolean):void { this._submitted = val; }
		public function get submitted():Boolean { return this._submitted; }
		
		public function submit():void {
			if (this._achieved && !this._submitted && UserData.GAMECENTER_OPEN) {
				//AirGooglePlayGames.getInstance().reportAchievement(this._onlineId);
				this._submitted = true;
			}
		}
		
		public function toObject():Object { 
			var rval:Object = new Object();
			rval.achieved = this._achieved;
			rval.submitted = this._submitted;
			if (!this._achieved) {
				var imax:uint = this._stats.length;
				rval.stats = new Object;
				rval.stats.achieved = new Array();
				rval.stats.value = new Array();
				for (var i:uint = 0; i < imax; i++) {
					rval.stats.achieved[i] = this._stats[i].achieved;
					rval.stats.value[i] = (this._stats[i].persistence)?this._stats[i].value:0;
				}
			}
			
			return rval;
		}
		
		public function get visible():Boolean { return this._visible; }
		public function get initialized():Boolean { return this._initialized; }
		public function get id():uint { return this._id; }
		public function get achieved():Boolean { return this._achieved; }
		public function get name():String { return this._name; }
		public function get desc():String { return this._desc; }
		public function set achieved(val:Boolean):void {
			this._achieved = val;
			if (this._achieved == true) this._initialized = true;
		}
		
		public function activateAchievement(val:Object = null):void {
			this._initialized = true;
			var i:uint;
			var imax:uint = this._stats.length;
			if (val != null && val.achieved.length == imax){
				for (i = 0; i < imax; i++) {
					this._stats[i].achieved = val.achieved[i];
					this._stats[i].value = val.value[i]
				}
			}
			
			for (i = 0; i < imax; i++) {
				if (!this._stats[i].achieved) this._stats[i].id = this._statManager.addStat(this._stats[i]);
			}
			this._achivManager = AchievementsManager.getInstance();
		}
		
		public function getProgress(statId:int = -1, percent:Boolean = false):Number {
			var rval:Number=0;
			if (statId == -1) {
				var imax:uint = this._stats.length;
				for (var i:uint = 0; i < imax; i++) {
					rval += (percent)?this._stats[i].value/this._stats[i].reportValue:this._stats[i].value;
				}
			}else {
				rval = (percent)?this._stats[statId].value / this._stats[statId].reportValue:this._stats[statId].value;
			}
			
			return rval;
		}
	
		public function statFinished(stat:Stat):void {
			//trace("Achievement::statFinished(" + this._id.toString() + " = " + stat.toString() + ")");
			//this._statManager.deleteStat(stat.id, stat.type);
			if (this._achieved) return;
			var imax:uint = this._stats.length;
			var flag:Boolean = true;
			for (var i:uint = 0; i < imax; i++) {
				if (!this._stats[i].achieved) flag = false;
			}
			if (flag) {
				this._achieved = true;
				
				trace("ACHIEVEMENT ACHIEVED id:" + this._id);
				this._achivManager.addUnlocked(this);
				
				if (this._onlineId != "") {
					if (UserData.GAMECENTER_OPEN) {
                        <%= achievementSubmit %>
						this._submitted = true;
					}
				}
				
				UserData.getInstance().saveStats();
			}
		}
	}

}