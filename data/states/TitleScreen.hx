import Date;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.MusicBeatState;

var enterAllowed = false;

function create() {
	hasLoad = true;
	FlxG.camera.fade(FlxColor.BLACK, 1, true);
	if (FlxG.save.data.curPowerUp == null) FlxG.save.data.curPowerUp = 0;
	
	addMenuShaders();
	
	updateRPC('In the Title Screen');
	
	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music(menuMusic), true, 0, true);
		FlxG.sound.music.persist = true;
	}

	if (FlxG.sound.music != null && FlxG.sound.music.volume == 0) {
		FlxG.sound.music.fadeIn(0.5, 0, 0.7);
		FlxG.sound.music.play();
	}

	FlxG.camera.zoom = 3;
	FlxG.camera.angle = 45;

	FlxTween.tween(FlxG.camera, {zoom: 1}, 1.6, {
		ease: FlxEase.expoInOut, 
		onComplete: function(twn:FlxTween) {
			FlxTween.tween(pressEnter, {alpha: 1}, 1.2, {
				ease: FlxEase.sineInOut,
				onComplete: function(twn:FlxTween) {
					enterAllowed = true;
				}
			});
		}
	});
	FlxTween.tween(FlxG.camera, {angle: 0}, 1.75, {ease: FlxEase.expoInOut});

	bg = new FlxSprite(-80).loadGraphic(Paths.image('states/tilte/titlebg'));
	bg.scale.set(0.6, 0.6);
	bg.screenCenter();
	bg.x = -700;
	add(bg);

	cloud = new FlxBackdrop(Paths.image('states/tilte/cloud'), 0, 0, true, false, 0, 0);
	cloud.velocity.set(-25, 0);
	cloud.scrollFactor.set(0.6, 0.6);
	cloud.y = -100;
	add(cloud);

	var logoSpr = "logo";
	var date = Date.now();
	if (date.getDate() == 14 && date.getMonth() == 6)
		logoSpr = "logofr";

	logo = new FlxSprite().loadGraphic(Paths.image('states/tilte/' + logoSpr));
	logo.scale.set(0.4, 0.4);
	logo.screenCenter();
	logo.y -= 600;
	add(logo);

	menuBG = new FlxSprite(FlxG.width).loadGraphic(Paths.image('states/bgm-sep'));
	menuBG.updateHitbox();
	menuBG.screenCenter();
	menuBG.x = FlxG.width;
	menuBG.scrollFactor.set(0, 0);
	add(menuBG);

	pressEnter = new FlxSprite().loadGraphic(Paths.image('states/tilte/pressEnter'));
	pressEnter.scale.set(0.75, 0.75);
	pressEnter.screenCenter();
	pressEnter.y += 185;
	pressEnter.alpha = 0;
	add(pressEnter);

	FlxTween.tween(logo, {y: -300}, 1, {ease: FlxEase.sineInOut});
}

static var TitleState_cloudX = 0;

var menuBG;
var titleTimer:Float = 0;

function update(elapsed:Float) {
	titleTimer += FlxMath.bound(elapsed, 0, 1);

	var pressedEnter:Bool = (FlxG.keys.justPressed.ENTER || controls.ACCEPT) && enterAllowed;

	if (!pressedEnter) pressEnter.scale.x = pressEnter.scale.y = 0.75 + Math.sin(titleTimer * 4) / 40;

	if (pressedEnter) {
		enterAllowed = false;
		FlxG.camera.flash(FlxColor.WHITE, 1);
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		new FlxTimer().start(0.5, ()->{
			FlxTween.tween(pressEnter, {alpha: 0}, 0.9, {ease: FlxEase.cubeInOut});
			FlxTween.tween(logo, {x: -800, alpha: 0}, 1, {ease: FlxEase.cubeInOut});
			FlxTween.tween(bg, {x: -1400}, 1, {ease: FlxEase.cubeInOut});
			FlxTween.tween(menuBG, {x: -3}, 1, {ease: FlxEase.cubeInOut});
		});

		new FlxTimer().start(2, function(tmr:FlxTimer) {
			MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
			TitleState_cloudX = cloud.x;
			FlxG.switchState(new MainMenuState());
		});
	}
}