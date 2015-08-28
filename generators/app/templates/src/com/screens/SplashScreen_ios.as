package <%= reversePath %>.<%= projectName %>.screens 
{
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import com.svetov.services.ga.GAInterface;
	import <%= reversePath %>.<%= projectName %>.events.ScreenEvent;
	import <%= reversePath %>.<%= projectName %>.interfaces.IScreen;
	import <%= reversePath %>.<%= projectName %>.managers.AchievementsManager;
	import <%= reversePath %>.<%= projectName %>.managers.SoundManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import <%= reversePath %>.<%= projectName %>.model.UserData;
	import <%= reversePath %>.<%= projectName %>.model.GameData;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Dima
	 */
	public class SplashScreen extends Sprite implements IScreen 
	{
		//public var result_txt:TextField;
		public var googlePlayServices_btn:MovieClip;
		public var play_btn:MovieClip;
		private var _soundManager:SoundManager;
		public var titleMc:MovieClip;
		
		private var _creditsPopup:Credits;
		private var _loginLock:Boolean;
		public function SplashScreen() 
		{
			this._soundManager = SoundManager.getInstance();
			this.play_btn.gotoAndStop(1);
			this.googlePlayServices_btn.gotoAndStop(1);
			this._loginLock = false;
		}
		
		
		public function initScreen():void 
		{
			this.play_btn.addEventListener(MouseEvent.CLICK, playClicked);
			this.play_btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseOver);
			this.play_btn.addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			
			if (GameCenter.isSupported && !UserData.GAMECENTER_OPEN) this.googlePlayServices_btn.addEventListener(MouseEvent.CLICK, loginGPS);
			else if(GameCenter.isSupported && UserData.GAMECENTER_OPEN) this.googlePlayServices_btn.addEventListener(MouseEvent.CLICK, openAchievements);
			else this.googlePlayServices_btn.visible = false;
		}
		
		public function playScreen():void 
		{
			this._soundManager.stopBGSounds();
			
			GAInterface.getInstance().trackView("SplashScreen");
		}
		
		private function loginGPS(e:MouseEvent):void {
			if (this._loginLock) return;
			try
			{
				this.googlePlayServices_btn.gotoAndStop(2);
				this._loginLock = true;
				GameCenter.localPlayerAuthenticated.add( localPlayerAuthenticated );
				GameCenter.localPlayerNotAuthenticated.add( localPlayerNotAuthenticated );
				GameCenter.authenticateLocalPlayer();
			}
			catch( error : Error )
			{
				this.googlePlayServices_btn.gotoAndStop(1);
				this._loginLock = false;
				GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
				GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
			}
		}
		
		private function localPlayerAuthenticated() : void
		{
			this._loginLock = false;
			this.googlePlayServices_btn.gotoAndStop(1);
			GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
			GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
			
			UserData.GAMECENTER_OPEN = true;
			this.googlePlayServices_btn.removeEventListener(MouseEvent.CLICK, loginGPS);
			this.googlePlayServices_btn.addEventListener(MouseEvent.CLICK, openAchievements);
			
			AchievementsManager.getInstance().resubmitAchievements();
			
			openAchievements();
		}
		
		private function localPlayerNotAuthenticated() : void
		{
			this._loginLock = false;
			this.googlePlayServices_btn.gotoAndStop(1);
			GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
			GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
			UserData.GAMECENTER_OPEN = false;
		}
		
		private function openAchievements(e:MouseEvent = null):void {
			try
			{
				GameCenter.showStandardAchievements();
			}
			catch( error : Error ){}
		}
		
		
		private function mouseOver(e:MouseEvent):void {
			e.currentTarget.gotoAndStop(2);
		}
		
		private function mouseOut(e:MouseEvent):void {
			e.currentTarget.gotoAndStop(1);
		}
		
		private function playClicked(e:MouseEvent):void {
			e.currentTarget.gotoAndStop(1);
			if (GameData.getInstance().getLevelById(0, 0).stars == 0) {
				UserData.getInstance().curSection = 0;
				UserData.getInstance().curLevel = GameData.getInstance().getLevelById(0, 0);
				dispatchEvent(new ScreenEvent(ScreenEvent.GAME_SCREEN));
			}else if (!GameData.getInstance().getSectionMapDataById(0).complete) {
				UserData.getInstance().curSection = 0;
				dispatchEvent(new ScreenEvent(ScreenEvent.LEVEL_SCREEN));
			}
			else dispatchEvent(new ScreenEvent(ScreenEvent.SECTION_SCREEN));
		}
		
		public function destroy():void 
		{
			this.play_btn.removeEventListener(MouseEvent.CLICK, playClicked);
			this.play_btn.removeEventListener(MouseEvent.MOUSE_DOWN, mouseOver);
			this.play_btn.removeEventListener(MouseEvent.ROLL_OUT, mouseOut);
			
			this.googlePlayServices_btn.removeEventListener(MouseEvent.CLICK, loginGPS);
			this.googlePlayServices_btn.removeEventListener(MouseEvent.CLICK, openAchievements);
		}
		
	}

}