'use strict';

var generators = require('yeoman-generator')
  , util       = require('util')
  , path       = require('path')
  , chalk      = require('chalk')
  , foldername = path.basename(process.cwd());

module.exports = generators.Base.extend({
    init: function () {
        this.on('end', function () {
            if (!this.options['skip-install']) {
                this.installDependencies();
            }
        });
    },

    info: function () {
        this.log(this.yeoman);
        this.log(chalk.magenta('Adobe AIR for Mobile Project Generator'));
    },

    runPrompt: function () {
        var done    = this.async()
          , prompts = [
            {
                type:    'input',
                name:    'projectName',
                message: 'What is the title of your project?',
                default: foldername
            },
            {
                type:    'input',
                name:    'reversePath',
                message: 'Whats your reverse path eg - "com.svetov":',
                default: 'com'
            },
            {
                type:    'input',
                name:    'projectType',
                message: 'Android or iOS? type - "android" or "ios":',
                default: 'android'
            },
            {
                type:    'input',
                name:    'flashType',
                message: 'IDE vs Flex: type - "ide" or "flex":',
                default: 'flex'
            }
        ];

        this.prompt(prompts, function (properties) {
            this.projectName   = properties.projectName   || ' ';
            this.reversePath = properties.reversePath || 'com';
            this.projectType = properties.projectType || 'android';
            this.flashType = properties.flashType || 'flex';
            done();
        }.bind(this));
    },

    generate: function () {
        this.mkdir('src');
        this.mkdir('bin');
        this.mkdir('bin/libs');
        this.mkdir('bin/AppIconsForPublish');
        this.mkdir('cert');
        this.mkdir('bat');
        
        this.copy('bat/CreateCertificate.bat','bat/CreateCertificate.bat');
        this.copy('bat/InstallAirRuntime.bat','bat/InstallAirRuntime.bat');
        this.copy('bat/PackageApp.bat','bat/PackageApp.bat');
        this.copy('bat/Packager.bat','bat/Packager.bat');
        this.copy('bat/RunApp.bat','bat/RunApp.bat');
        this.copy('bat/SetupApp.bat','bat/SetupApp.bat');
        this.copy('bat/SetupSDK.bat','bat/SetupSDK.bat');
        
        this.copy('bin/AppIconsForPublish/icon_48.png','bin/AppIconsForPublish/icon_48.png');
        this.copy('bin/AppIconsForPublish/icon_57.png','bin/AppIconsForPublish/icon_57.png');
        this.copy('bin/AppIconsForPublish/icon_72.png','bin/AppIconsForPublish/icon_72.png');
        this.copy('bin/AppIconsForPublish/icon_76.png','bin/AppIconsForPublish/icon_76.png');
        this.copy('bin/AppIconsForPublish/icon_96.png','bin/AppIconsForPublish/icon_96.png');
        this.copy('bin/AppIconsForPublish/icon_114.png','bin/AppIconsForPublish/icon_114.png');
        this.copy('bin/AppIconsForPublish/icon_120.png','bin/AppIconsForPublish/icon_120.png');
        this.copy('bin/AppIconsForPublish/icon_144.png','bin/AppIconsForPublish/icon_144.png');
        this.copy('bin/AppIconsForPublish/icon_152.png','bin/AppIconsForPublish/icon_152.png');
        this.copy('bin/AppIconsForPublish/icon_192.png','bin/AppIconsForPublish/icon_192.png');
        this.copy('bin/AppIconsForPublish/icon_512.png','bin/AppIconsForPublish/icon_512.png');

        this.template('_README.md', 'README.md');
        this.template('_package.json', 'package.json');
        
		if (this.projectType === 'android') {
			this.gameCenterANE = 'com.freshplanet.ane.AirGooglePlayGames.AirGooglePlayGames;';
            this.achievementSubmit = 'AirGooglePlayGames.getInstance().reportAchievement(this._onlineId);';
			this.copy('bin/lib/AirGooglePlayGamesService.ane', 'bin/lib/AirGooglePlayGamesService.ane');
			this.copy('bin/lib/GAServiceANE.ane', 'bin/lib/GAServiceANE.ane');
		} else if (this.projectType === 'ios') {
			this.gameCenterANE = 'com.sticksports.nativeExtensions.gameCenter.GameCenter;';
            this.achievementSubmit = 'GameCenter.reportAchievement(this._onlineId, 1, true);';
			this.copy('bin/lib/GameCenter.ane', 'bin/lib/GameCenter.ane');
			this.copy('bin/lib/googleAnalyticsANEiOS.ane', 'bin/lib/googleAnalyticsANEiOS.ane');
			this.copy('bin/Default.png', 'bin/Default.png');
			this.copy('bin/Default@2x.png', 'bin/Default@2x.png');
			this.copy('bin/Default-568h@2x.png', 'bin/Default-568h@2x.png');
			this.copy('bin/Default-Landscape.png', 'bin/Default-Landscape.png');
			this.copy('bin/Default-Portrait.png', 'bin/Default-Portrait.png');
		}
        
        this.copy('bin/Achievements.json','bin/Achievements.json');
        this.template('bin/application.xml','bin/application.xml');
        
        var arr = this.reversePath.split('.');
        var imax = arr.length;
        var path = 'src/';
        this.reverseFolderPath = '';
        for (var i = 0; i < imax; i++) {
            this.mkdir(path+arr[i]);
            path = path+arr[i]+'/';
            this.reverseFolderPath = this.reverseFolderPath+arr[i]+'\\';
        }
        
        this.mkdir(path+'screens');
        this.mkdir(path+'model');
        this.mkdir(path+'managers');
        this.mkdir(path+'interfaces');
        this.mkdir(path+'events');
        
        if (this.flashType === 'ide') {
            this.copy('src/FlashProject.as3proj', 'src/FlashProject.as3proj');
            this.copy('src/template.fla', 'src/'+this.projectName+'.fla');
        } else if (this.flashType === 'flex') {
            this.template('src/AIRProject.as3proj', 'src/AIRProject.as3proj');
        }
        
        this.template('src/com/Main.as', path+'Main.as');
        this.template('src/com/events/AcheivementEvent.as', path+'events/AcheivementEvent.as');
        this.template('src/com/events/GameEvent.as', path+'events/GameEvent.as');
        this.template('src/com/events/ScreenEvent.as', path+'events/ScreenEvent.as');
        this.template('src/com/interfaces/IScreen.as', path+'interfaces/IScreen.as');
        this.template('src/com/managers/Achievement.as', path+'managers/Achievement.as');
        this.template('src/com/managers/AchievementsManager.as', path+'managers/AchievementsManager.as');
        this.template('src/com/managers/ScreenManager.as', path+'managers/ScreenManager.as');
        this.template('src/com/managers/SoundManager.as', path+'managers/SoundManager.as');
        this.template('src/com/managers/Stat.as', path+'managers/Stat.as');
        this.template('src/com/managers/StatisticsManager.as', path+'managers/StatisticsManager.as');
        this.template('src/com/managers/StatTypeList.as', path+'managers/StatTypeList.as');
        this.template('src/com/model/GameData.as', path+'model/GameData.as');
        this.template('src/com/model/UserData.as', path+'model/UserData.as');
        this.template('src/com/screens/LoadingScreen.as', path+'screens/LoadingScreen.as');
        if (this.projectType === 'android') {
            this.template('src/com/screens/SplashScreen_android.as', path+'screens/SplashScreen.as');
        } else if (this.projectType === 'ios') {
            this.template('src/com/screens/SplashScreen_ios.as', path+'screens/SplashScreen.as');
        }

    }
});
