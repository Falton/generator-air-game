package <%= reversePath %>.<%= projectName %> 
{
	import <%= reversePath %>.<%= projectName %>.managers.ScreenManager;
	import <%= reversePath %>.<%= projectName %>.model.GameData;
	import <%= reversePath %>.<%= projectName %>.model.UserData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import com.svetov.services.ga.GAInterface;
	/**
	 * ...
	 * @author 
	 */
	public class Main extends Sprite 
	{
		public var bg:MovieClip;
		private var _screenManager:ScreenManager;
		public function Main() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			this.bg.gotoAndStop(2);
		}
		private function init(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(Event.DEACTIVATE, deactivated);
			stage.addEventListener(Event.ACTIVATE, activated);
		
			GAInterface.getInstance().trackingId = "##-#######-#";
			
			
			this.stage.scaleMode = StageScaleMode.EXACT_FIT;
			this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			GameData.getInstance();
			
			UserData.getInstance();
			
			this._screenManager = new ScreenManager();
			this.addChild(this._screenManager);
		}
		
		private function deactivated(e:Event):void {
			
		}
		
		private function activated(e:Event):void {
		}
	}

}