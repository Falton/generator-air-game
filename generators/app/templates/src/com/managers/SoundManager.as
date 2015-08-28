package <%= reversePath %>.<%= projectName %>.managers 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.ApplicationDomain;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author
	 */
	public class SoundManager
	{
		private static var BG_VOLUME:Number = 0.6;
		private static var FX_VOLUME:Number = 0.7;
		private static var VO_VOLUME:Number = 1;
		
		public static const SOUND_BG:String = "bg";
		public static const SOUND_FX:String = "fx";
		public static const	SOUND_VO:String = "vo";
		
		private static var _instance:SoundManager;
		private static var _allowed:Boolean = false;
		private var _soundsBG:Object;
		private var _soundsFX:Object;
		private var _soundsVO:Object;
		private var _mute:Boolean;
		
		public function SoundManager() 
		{
			if (!_allowed) throw Error("singlaton class use getInstance()");
			this._soundsBG = new Object();
			this._soundsFX = new Object();
			this._soundsVO = new Object();
			this._mute = false;
		}
		
		
		public static function getInstance():SoundManager {
			if (_instance == null) {
				_allowed = true;
				_instance = new SoundManager();
				_allowed = false;
			}			
			return _instance;
		}
		
		public function get isMuted():Boolean { return this._mute; }		
		
		public function bgIsPlaying(name:String):Boolean{
			return (this._soundsBG[name] != null);
		}
		
		public function playSound(name:String, type:String, loop:Boolean = false, customKey:String = "") : void {
			
			//var tmpSoundClass:Class = this._pLib.getDefinition(name) as Class;
			//var tmpSound:Sound = new tmpSoundClass() as Sound;
			//var tmpSound:Sound = new this._assetLibrary[name]() as Sound;
			var tmpSound:Sound = new Sound();
			var myChannel:SoundChannel = new SoundChannel();
			tmpSound.load(new URLRequest("sounds/"+name+".mp3"));
			
			var loops:int = (loop)?int.MAX_VALUE: 0;
			var soundTransform:SoundTransform;
			if(!this._mute){
				switch(type) {
					case SoundManager.SOUND_BG:
						soundTransform = new SoundTransform(BG_VOLUME);
						break;
					case SoundManager.SOUND_FX:
						soundTransform = new SoundTransform(FX_VOLUME);
						break;
					case SoundManager.SOUND_VO:
						soundTransform = new SoundTransform(VO_VOLUME);
						break;
				}
			}else {
				soundTransform = new SoundTransform(0);
			}
			var soundKey : String = (customKey != "")? customKey : name;
			switch(type) {
				case SoundManager.SOUND_BG:
					this._soundsBG[soundKey] = tmpSound.play(0, loops, soundTransform);
					break;
				case SoundManager.SOUND_FX:
					this._soundsFX[soundKey] = tmpSound.play(0, loops, soundTransform);
					break;
				case SoundManager.SOUND_VO:
					this._soundsVO[soundKey] = tmpSound.play(0, loops, soundTransform);
					break;
			}
			
			
		}
		
		public function stopSound(name:String, type:String = "", customKey:String = "") : void {
			var soundKey : String = (customKey != "")? customKey : name;

			switch(type) {
				case SoundManager.SOUND_BG:
					SoundChannel(this._soundsBG[soundKey]).stop();
					this._soundsBG[soundKey] = null;
					delete this._soundsBG[soundKey];
					break;
				case SoundManager.SOUND_FX:
					SoundChannel(this._soundsFX[soundKey]).stop();
					this._soundsFX[soundKey] = null;
					delete this._soundsFX[soundKey];
					break;
				case SoundManager.SOUND_VO:
					SoundChannel(this._soundsVO[soundKey]).stop();
					this._soundsVO[name] = null;
					delete this._soundsVO[soundKey];
					break;
				default:
					if (this._soundsBG[soundKey]) {
						SoundChannel(this._soundsBG[soundKey]).stop();
						this._soundsBG[soundKey] = null;
					}else if (this._soundsFX[soundKey]) {
						SoundChannel(this._soundsFX[soundKey]).stop();
						this._soundsFX[soundKey] = null;
					}else if (this._soundsVO[soundKey]) {
						SoundChannel(this._soundsVO[soundKey]).stop();
						this._soundsVO[soundKey] = null;
					}
					break;
			}
		}
		
		public function stopBGSounds() : void {
			var snd:SoundChannel;
			for each(snd in this._soundsBG) {
				snd.stop();
				snd = null;
			}
		}

		public function stopFXSounds() : void {
			var snd:SoundChannel;
			for each(snd in this._soundsFX) {				
				if(snd != null)snd.stop();
				snd = null;
			}
		}
		
		public function muteAll() : void {
			this._mute = true;
			var snd:SoundChannel;
			for each(snd in this._soundsBG) {				
				if(snd != null) snd.soundTransform = new SoundTransform(0);
			}
			for each(snd in this._soundsFX) {
				if(snd != null) snd.soundTransform = new SoundTransform(0);
			}
			for each(snd in this._soundsVO) {
				if(snd != null) snd.soundTransform = new SoundTransform(0);
			}
		}
		
		public function unmuteAll() : void {
			this._mute = false;
			var snd:SoundChannel;
			for each(snd in this._soundsBG) {
				if(snd != null) snd.soundTransform = new SoundTransform(BG_VOLUME);
			}
			for each(snd in this._soundsFX) {
				if(snd != null) snd.soundTransform = new SoundTransform(FX_VOLUME);
			}
			for each(snd in this._soundsVO) {
				if(snd != null) snd.soundTransform = new SoundTransform(VO_VOLUME);
			}
		}
	}
	
}