package <%= reversePath %>.<%= projectName %>.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class AcheivementEvent extends Event 
	{
		public static var NEW_ACHIEVEMENT_UNLOCKED:String = "NEW_ACHIEVEMENT_UNLOCKED";
		public function AcheivementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}