package <%= reversePath %>.<%= projectName %>.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dima
	 */
	public class ScreenEvent extends Event 
	{
		public static var SPLASH_SCREEN:String = "splashscreen";
		public static var LOAD_COMPLETE:String = "loadcomplete";
		public function ScreenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}