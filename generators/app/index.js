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
                message: 'Whats your reverse path (eg: com.svetov)',
                default: 'com'
            },
            {
                type:    'input',
                name:    'projectType',
                message: 'Android or iOS? (type: android or ios)',
                default: 'android'
            }
        ];

        this.prompt(prompts, function (properties) {
            this.projectName   = properties.projectName   || ' ';
            this.reversePath = properties.reversePath || 'com';
            this.projectType = properties.projectType || 'android';
            done();
        }.bind(this));
    },

    generate: function () {
        this.mkdir('src');
        this.mkdir('bin');
        this.mkdir('bin/libs');

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
		}
        
        this.copy('bin/Achievements.json','bin/Achievements.json');
        
        var arr = this.reversePath.split('.');
        var imax = arr.length;
        var path = 'src/';
        for (var i = 0; i < imax; i++) {
            this.mkdir(path+arr[i]);
            path = path+arr[i]+'/';
        }
        
        this.mkdir(path+'screens');
        this.mkdir(path+'model');
        this.mkdir(path+'managers');
        this.mkdir(path+'interfaces');
        this.mkdir(path+'events');
        
        
        this.copy('src/FlashProject.as3proj', 'src/FlashProject.as3proj');
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
