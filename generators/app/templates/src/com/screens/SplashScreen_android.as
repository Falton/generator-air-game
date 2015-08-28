package <%= reversePath %>.<%= projectName %>.screens 
{
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;
	import com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGamesEvent;
	import com.svetov.services.ga.GAInterface;
	import <%= reversePath %>.<%= projectName %>.events.ScreenEvent;
	import <%= reversePath %>.<%= projectName %>.interfaces.IScreen;
	import <%= reversePath %>.<%= projectName %>.model.GameData;
	import <%= reversePath %>.<%= projectName %>.model.UserData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Dima
	 */
	public class SplashScreen extends Sprite implements IScreen 
	{
	
		public var play_btn:MovieClip;
		public var achievements_btn:MovieClip;
		public var credits_btn:MovieClip;
		private var _loginLock:Boolean;
		public function SplashScreen() 
		{
			this.play_btn.gotoAndStop(1);
			this.achievements_btn.gotoAndStop(1);
			
			this._loginLock = false;
		}
		
		public function initScreen():void 
		{
			this.play_btn.addEventListener(MouseEvent.CLICK, playClicked);
			
			this.achievements_btn.addEventListener(MouseEvent.CLICK, achievementsClicked);
			
			if (AirGooglePlayGames.isSupported && !UserData.GAMECENTER_OPEN) this.achievements_btn.addEventListener(MouseEvent.CLICK, loginGPS);
			else if(AirGooglePlayGames.isSupported && UserData.GAMECENTER_OPEN) this.achievements_btn.addEventListener(MouseEvent.CLICK, achievementsClicked);
			else this.achievements_btn.visible = false;
		}
		
		private function achievementsClicked(e:MouseEvent):void {
			AirGooglePlayGames.getInstance().showStandardAchievements();
		}
		
		private function loginGPS(e:MouseEvent):void {
			if (this._loginLock) return;
			this._loginLock = true;
			this.achievements_btn.gotoAndStop(2);
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
			AirGooglePlayGames.getInstance().addEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
			AirGooglePlayGames.getInstance().signIn();
		}
		
		private function onSignInFail(e:AirGooglePlayGamesEvent):void 
		{
			this._loginLock = false;
			this.achievements_btn.gotoAndStop(1);
			//result_txt.text = "onSignInFail";
			AirGooglePlayGames.getInstance().removeEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
			AirGooglePlayGames.getInstance().removeEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
			AirGooglePlayGames.getInstance().removeEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
			UserData.GAMECENTER_OPEN = false;
		}
		
		private function onSignOutSuccess(e:AirGooglePlayGamesEvent):void 
		{
			//result_txt.text = "onSignOutSuccess";
			AirGooglePlayGames.getInstance().removeEventListener(AirGooglePlayGamesEvent.ON_SIGN_OUT_SUCCESS, onSignOutSuccess);
			UserData.GAMECENTER_OPEN = false;
		}
		
		private function onSignInSuccess(e:AirGooglePlayGamesEvent):void 
		{
			this._loginLock = false;
			this.googlePlayServices_btn.gotoAndStop(1);
			//result_txt.text = "onSignInSuccess";
			AirGooglePlayGames.getInstance().removeEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_SUCCESS, onSignInSuccess);
			AirGooglePlayGames.getInstance().removeEventListener(AirGooglePlayGamesEvent.ON_SIGN_IN_FAIL, onSignInFail);
			UserData.GAMECENTER_OPEN = true;
			
			this.achievements_btn.removeEventListener(MouseEvent.CLICK, loginGPS);
			this.achievements_btn.addEventListener(MouseEvent.CLICK, openAchievements);
			
			AchievementsManager.getInstance().resubmitAchievements();
			
			achievementsClicked();
		}
		
		private function playClicked(e:MouseEvent):void {
			dispatchEvent(new ScreenEvent(ScreenEvent.LEVEL_SELECT));
		}
		
		public function playScreen():void 
		{
			GAInterface.getInstance().trackView("SplashScreen");
		}
		
		public function destroy():void 
		{
			this.play_btn.removeEventListener(MouseEvent.CLICK, playClicked);
			
			this.achievements_btn.removeEventListener(MouseEvent.CLICK, achievementsClicked);
		}
		
	}

}