package <%= reversePath %>.<%= projectName %>.managers 
{
	/**
	 * ...
	 * @author
	 */
	public class Stat 
	{
		private var _type:String;
		private var _value:Number;
		private var _reportValue:Number;
		private var _callback:Function;
		private var _eval:String;
		private var _achieved:Boolean;
		private var _persistence:Boolean;
		private var _id:uint;
		private var _lock:Boolean; //lock the stat -- cannot be updated while locked
		
		public static const EQUALS:String = "=";
		public static const GRATER_THEN:String = ">=";
		public static const LESS_THEN:String = "<=";
		
		public function Stat(type:String, eval:String,reportVal:Number, callback:Function) {
			this._reportValue = reportVal;
			this._callback = callback;
			this._eval = eval;
			this._value = 0;
			this._achieved = false;
			this._type = type;
			this._persistence = true;
			this._lock = false;
		}
		
		public function get reportValue():Number { return this._reportValue; }
		public function get type():String { return this._type; }
		public function get value():Number { return this._value; }
		public function get persistence():Boolean { return this._persistence; }
		public function get achieved():Boolean { return this._achieved; }
		public function get id():uint { return this._id; }
		public function set lock(val:Boolean):void { this._lock = val; }
		
		public function set id(val:uint):void { this._id = val; }
		public function set persistence(val:Boolean):void { this._persistence = val; }
		public function set achieved(val:Boolean):void { this._achieved = val; }
		public function set type(val:String):void { this._type = val; }
		public function set value(val:Number):void { 
			if (this._lock || this._achieved) return;
			this._value = val;
			switch(this._eval) {
				case EQUALS:
					if (this._value == this._reportValue ) {
						this._achieved = true;
						this._callback(this);
					}
					break;
				case GRATER_THEN:
					if (this._value >= this._reportValue) {
						this._achieved = true;
						this._callback(this);
					}
					break;
				case LESS_THEN:
					if (this._value <= this._reportValue) {
						this._achieved = true;
						this._callback(this);
					}
					break;
			}
		}
		
		public function reset(val:Number = 0):void {
			if (this._lock || this._achieved) return;
			this._value = val;
		}
		
		public function toString():String {
			return "[Stat]: " + this._type + " = " +value.toString()+ "/" +this.reportValue.toString();
		}
		
	}

}