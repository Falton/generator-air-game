package <%= reversePath %>.<%= projectName %>.managers 
{
	import <%= reversePath %>.<%= projectName %>.events.ScreenEvent;
	import <%= reversePath %>.<%= projectName %>.screens.SplashScreen;
	import <%= reversePath %>.<%= projectName %>.interfaces.IScreen;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author
	 */
	public class ScreenManager extends Sprite 
	{
		private var _curScreen:IScreen;
		
		private var _splashScreen:SplashScreen;
		private var _gameScreen:GameScreen;
		private var _levelScreen:LevelSelectScreen;
		public function ScreenManager() 
		{
			this._splashScreen = new SplashScreen();
			this._splashScreen.addEventListener(ScreenEvent.LEVEL_SELECT, loadLevelScreen);
			
			loadSplashScreen();
		}
		
		
		private function loadSplashScreen(e:ScreenEvent = null) {
			curScreen = this._splashScreen;
		}
		
		private function set curScreen(val:IScreen):void {
			
			if (this._curScreen != null) {
				this._curScreen.destroy();
				this.removeChild(this._curScreen as DisplayObject);
			}
			val.initScreen();
			this._curScreen = val;
			this.addChild(this._curScreen as DisplayObject);
			this._curScreen.playScreen();
		}
		
	}

}