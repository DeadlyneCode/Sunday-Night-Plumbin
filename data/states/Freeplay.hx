import flixel.graphics.FlxGraphic;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.chart.Chart;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.utils.NdllUtil;
import funkin.savedata.FunkinSave;
import hxvlc.flixel.FlxVideoSprite;
import openfl.display.BitmapData;

var objects = {
	paintings: [],
	scoreTexts: [],

	arrowLeft: new FlxSprite(),
	arrowRight: new FlxSprite(),
};

function enableWindowControls(enable)
{
	window.resizable = enable;
	NdllUtil.getFunction("WindowUtils", enable ? "ndllexample_restore_window_controls" : "ndllexample_remove_window_controls", 0)();
}

var optionPos:Array<Array<Float>> = [];
var bg = new FlxSprite();
var prevBg = new FlxSprite();

static var Freeplay_curSelected:Int = 0;
var preloadedGraphics:Array<Dynamic> = [];
var inactivityTimer = 0;

inline function destroyGraphic(graphic:FlxGraphic)
{
	// free some gpu memory
	if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null)
		graphic.bitmap.__texture.dispose();
	FlxG.bitmap.remove(graphic);
}

var assetStore:Map<String, FlxGraphic> = [];
function getAsset(path:String):FlxGraphic {
	var coolPath = Paths.image(path);

	var graphic:FlxGraphic = null;
	if (assetStore.exists(path))
	{
		graphic = assetStore.get(path);
	} else {
		if (Assets.exists(coolPath))
		{
			var bitmap = BitmapData.fromFile(Assets.getPath(coolPath));
			if (bitmap.image != null) {
				bitmap.lock();
				if (bitmap.__texture == null)
				{
					bitmap.image.premultiplied = true;
					bitmap.getTexture(FlxG.stage.context3D);
				}
				bitmap.getSurface();
				bitmap.disposeImage();
				bitmap.image.data = null;
				bitmap.image = null;
				bitmap.readable = true;
			}
			graphic = FlxGraphic.fromBitmapData(bitmap, false, path, true);
		} else
			graphic = FlxGraphic.fromRectangle(1, 1, FlxColor.TRANSPARENT, false, path);
			
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		assetStore.set(path, graphic);
	}

	return graphic;
}
var holdTime:Float = 0;

var unlockedSongList = [];

function clearAssets() {
	for (asset => graphic in assetStore)
		destroyGraphic(graphic);
}

function destroy() {
	window.onMove.remove(onWindowMove);
	clearAssets();
}

var gfStuck;
var gfStuckAlphaMulti = 0.001;
var gfStuckAlpha = 0.001;
var gfStuckTween;
var gfStuckAlphaTween;
function create()
{
	for (i in 0...songList.length)
	{
		var unlocked = i == 0 ? true : (FlxG.save.data.song || FunkinSave.getSongHighscore(songList[i-1], "normal").score > 0);
		if (songList[i] == "Earache")
			unlocked = FlxG.save.data.unlockedMaltigi;
		
		if (unlocked || FlxG.save.data.song)
		{
			//load music
			currentMusic = FlxG.sound.load(Paths.music(songList[i]), 1, true);
			currentMusic.volume = 0;
			soundsLoaded.set(songList[i], currentMusic);
			unlockedSongList.push(songList[i]);
		} else {
			//Prevent later songs to be unlocked if you didnt beat one
			//For example You didn't finish disturbing presence but you finished blessing (for some reason)
			//With blessing beaten you could play Golden Hammer and Cracked Egg when you werent supposed to
			break;
		}
	}

	updateRPC("In the Freeplay Menu");
	
	addMenuShaders();

	maltigi = new FlxSprite(0, 0).loadGraphic(getAsset('states/freeplay/paintings/Earache'));
	maltigi.setGraphicSize(400);
	maltigi.updateHitbox();
	maltigi.screenCenter(FlxAxes.X);
	maltigi.alpha = 0.001;
	maltigi.y = 170;
	add(maltigi);

	gfStuck = new FlxSprite(0, 0).loadGraphic(getAsset('states/freeplay/bg/gf_tableau'));
	gfStuck.setGraphicSize(200);
	gfStuck.updateHitbox();
	gfStuck.screenCenter(FlxAxes.X);
	gfStuck.y = 170;
	add(gfStuck);

	var showGFStuck = true;
	var runHideTween = null;
	runHideTween = function()
	{
		var wantedAlpha = showGFStuck ? FlxG.random.float(0.3, 1) : FlxG.random(0.001, 0.2);
		var duration = FlxG.random.float(0.5, 6);
		gfStuckAlphaTween = FlxTween.num(gfStuckAlpha, wantedAlpha, duration, {onComplete: runHideTween, ease: FlxEase.quadInOut}, function(v) {
			gfStuckAlpha = v;
		});
		showGFStuck = !showGFStuck;
	};
	runHideTween();
	
	leftDoor = new FlxSprite(0, 0).loadGraphic(getAsset('states/freeplay/bg/porte_gauche'));
	leftDoor.scale.set(0.9, 0.9);
	leftDoor.updateHitbox();
	leftDoor.screenCenter(FlxAxes.X);
	leftDoor.x -= leftDoor.width / 2;
	leftDoor.alpha = 0.001;

	rightDoor = new FlxSprite(0, 0).loadGraphic(getAsset('states/freeplay/bg/porte_droite'));
	rightDoor.scale.set(leftDoor.scale.x, leftDoor.scale.y);
	rightDoor.updateHitbox();
	rightDoor.screenCenter(FlxAxes.X);
	rightDoor.x += rightDoor.width / 2;
	rightDoor.alpha = 0.001;

	rightDoor.y = leftDoor.y = 145;
	leftDoor.offset.set(28, 0);
	rightDoor.offset.set(leftDoor.offset.x, 1);

	add(leftDoor);
	add(rightDoor);

	add(bg);
	add(prevBg);
	prevBg.alpha = 0.001;

	add(catafire1 = makeFire(190, -12, 0.4));
	add(catafire2 = makeFire(995, -12, 0.4));
	add(betrafire1 = makeFire(7, -75, 0.4));
	add(betrafire2 = makeFire(1183, -75, 0.4));
	add(crackedfire1 = makeFire(267, 85, 0.4));
	add(crackedfire2 = makeFire(913, 85, 0.4));

	preloadAssets();
	niqueTaMere();
	initializeArrows();

	var firstTimeFreeplay = !FlxG.save.data.seenFreeplayIntro;
	gilbertForced = FlxG.save.data.distoLocked;

	if (gilbertForced)
	{
		var intensity = 0.05;
		new FlxTimer().start(intensity, (t) -> {
			if (objects.scoreTexts[8] != null)
			{
				objects.scoreTexts[8].text = shuffleString("Disturbing") + " " +  shuffleString("Presence");
			}
			if (Freeplay_curSelected == 8)
			{
				Framerate.codenameBuildField.text = getString("freeplay_hes_waiting") + "\n"+objects.scoreTexts[8].text;
				window.title = getString("freeplay_hes_waiting").toUpperCase();
				intendedMisses = intendedScore = FlxG.random.int(-1000000, 1000000);
			}
			t.reset(intensity);
		});
	}

	enableWindowControls(true);
	if (gilbertForced) {
		Freeplay_curSelected = 8;
		objects.arrowLeft.visible = objects.arrowRight.visible = false;

		enableWindowControls(false);
		FlxG.fullscreen = FlxG.autoPause = false;
		FlxG.resizeWindow(1280, 720);

		var cutsceneCam = new FlxCamera();
		cutsceneCam.bgColor = 0x00FFFFFF;
		var cutsceneCamText = new FlxCamera();
		cutsceneCamText.bgColor = 0x00FFFFFF;
		var cutsceneText = new FlxText(0, FlxG.height, FlxG.width, "", 24 * 1.75);
		cutsceneText.setFormat(Paths.font("U.ttf"), 36 * 1.25, FlxColor.WHITE, "center");
		cutsceneText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
		cutsceneText.y = 630;
		cutsceneText.antialiasing = true;
		add(cutsceneText);

		FlxG.camera.visible = false;
		var video = new FlxVideoSprite();
		var videoName = "gilbert-cut_1";
		video.load(Assets.getPath(Paths.video(videoName)));
		video.antialiasing = true;
		video.bitmap.onFormatSetup.add(function():Void
		{
			if (video.bitmap != null && video.bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);

				video.setGraphicSize(video.bitmap.bitmapData.width * scale, video.bitmap.bitmapData.height * scale);
				video.updateHitbox();
				video.screenCenter();
			}
			add(video);
			add(cutsceneText);
			cutsceneText.camera = cutsceneCamText;
		});
		FlxG.cameras.add(cutsceneCam, false);
		FlxG.cameras.add(cutsceneCamText, false);
		new FlxTimer().start(3.5, function()
		{
			video.bitmap.onEndReached.add(function()
			{
				FlxG.camera.visible = true;
				canMoveGilbert = true;
				shakeIntensityTwn = FlxTween.num(0, 100, 60*30, {}, function(v)
				{
					shakeItensity = v;
				});
				//music.fadeIn(0.5, 0, 0.7);
				remove(video);
				FlxG.cameras.remove(cutsceneCam, true);
				FlxG.cameras.remove(cutsceneCamText, true);
				video.destroy();
			});
			video.camera = cutsceneCam;
			//videoPlaying = true;
			var cutsceneSound = FlxG.sound.load(Paths.music("disto_cutscene"));
			new FlxTimer().start(2.68, function()
			{
				video.play();
				var textTimes = [0.1, 0.9, 2.6, 2.9, 1.2, 3.1, 1.1, 5];
				var curIndex = 0;
				new FlxTimer().start(textTimes[curIndex], (t) -> {
					if ((curIndex == textTimes.length - 1))
					{
						FlxTween.tween(cutsceneText, {alpha: 0.001}, 1.5, {ease: FlxEase.quadInOut});
						return;
					}
					cutsceneText.applyMarkup(getString("freeplay_dp_dialogue" + (curIndex + 1)),
						[
							new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "*"),
						]
					);
					curIndex++;
					t.reset(textTimes[curIndex]);
				});
			});
			new FlxTimer().start(cutsceneSound.length / 1000, function()
			{
				currentMusic = soundsLoaded.get("Disturbing-presence");
				currentMusic.volume = 0.7;
				currentMusic.play();
				new FlxTimer().start(currentMusic.length / 1000, function(t)
				{
					currentMusic.play();
					t.reset(currentMusic.length / 1000);
				});
			});
			cutsceneSound.play();
		});
	}

	if (firstTimeFreeplay)
	{
		FlxG.camera.visible = false;
		var cutsceneCamText = new FlxCamera();
		cutsceneCamText.bgColor = 0x00FFFFFF;
		var cutsceneText = new FlxText(0, FlxG.height, FlxG.width, "", 24 * 1.75);
		cutsceneText.setFormat(Paths.font("U.ttf"), 36, FlxColor.WHITE, "center");
		cutsceneText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
		cutsceneText.y = 630;
		cutsceneText.antialiasing = true;
		add(cutsceneText);
		inputAllowed = false;
		var firstVideo = null;
		add(firstVideo = new FlxVideoSprite());
		firstVideo.antialiasing = true;
		firstVideo.autoPause = true;
		firstVideo.bitmap.onEndReached.add(function()
		{
			currentMusic = soundsLoaded.get(unlockedSongList[Freeplay_curSelected]);
			currentMusic.play();
			FlxG.save.data.seenFreeplayIntro = true;
			FlxG.save.flush();
			FlxG.cameras.remove(cutsceneCamText, true);
			FlxTween.tween(firstVideo, {alpha: 0}, 0.5, {onComplete: function() {	
				remove(firstVideo);
				firstVideo.destroy();
			}});
			FlxTween.tween(currentMusic, {volume: 0.7}, 1, {onComplete: function() {
				inputAllowed = true;
			}});
		});
		firstVideo.bitmap.onFormatSetup.add(function() if (firstVideo.bitmap != null && firstVideo.bitmap.bitmapData != null) {
			final width = firstVideo.bitmap.bitmapData.width;
			final height = firstVideo.bitmap.bitmapData.height;
			final scale:Float = Math.min(FlxG.width / width, FlxG.height / height);
			firstVideo.setGraphicSize(Std.int(width * scale), Std.int(height * scale));
			firstVideo.updateHitbox();
			firstVideo.screenCenter();
		});
		firstVideo.load(Assets.getPath(Paths.video("cutscene")));

		firstVideo.bitmap.onPlaying.add(function () {
			FlxG.cameras.add(cutsceneCamText, false);
			cutsceneText.camera = cutsceneCamText;
			FlxG.camera.visible = true;

			var textTimes = [6.3, 2, 1.5, 2.6, 1.3, 1.3, 3, 2, 0.8, 1, 2.8, 1, 2, 0.6, 1.7, 1.2, 3];
			var curIndex = 0;
			new FlxTimer().start(textTimes[curIndex], (t) -> {
				if ((curIndex == textTimes.length - 1))
				{
					FlxTween.tween(cutsceneText, {alpha: 0.001}, 1.5, {ease: FlxEase.quadInOut});
					return;
				}
				cutsceneText.applyMarkup(getString("freeplay_intro_dialogue" + (curIndex + 1)),
	                [
	                    new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "*"),
	                    new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF44BAFF), "#")
                ]
	            );
				curIndex++;
				t.reset(textTimes[curIndex]);
			});
		});
		
		new FlxTimer().start(1.5, (_) -> {
			firstVideo.play();
		});
	}

	if (!FlxG.save.data.seenFreeplayFinal && FlxG.save.data.shouldShowFinalCutscene)
	{
		FlxG.camera.visible = false;
		var cutsceneCamText = new FlxCamera();
		cutsceneCamText.bgColor = 0x00FFFFFF;
		var cutsceneText = new FlxText(0, FlxG.height, FlxG.width, getString("freeplay_final"), 32);
		cutsceneText.setFormat(Paths.font("U.ttf"), 32, FlxColor.WHITE, "center");
		cutsceneText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
		cutsceneText.updateHitbox();
		cutsceneText.antialiasing = true;
		cutsceneText.alpha = 0.001;
		cutsceneText.screenCenter();
		add(cutsceneText);
		inputAllowed = false;
		var firstVideo = null;
		add(firstVideo = new FlxVideoSprite());
		firstVideo.antialiasing = true;
		firstVideo.autoPause = true;
		firstVideo.bitmap.onEndReached.add(function()
		{
			FlxTween.tween(cutsceneText, {alpha: 1}, 1.5, {ease: FlxEase.quadInOut});
			new FlxTimer().start(13 - 1.5, function()
			{
				FlxTween.tween(cutsceneText, {alpha: 0.001}, 1.5, {ease: FlxEase.quadInOut});
			});
			new FlxTimer().start(13, function()
			{
				currentMusic = soundsLoaded.get(unlockedSongList[Freeplay_curSelected]);
				currentMusic.play();
				FlxG.save.data.seenFreeplayFinal = true;
				FlxG.save.flush();
				FlxG.cameras.remove(cutsceneCamText, true);
				FlxTween.tween(firstVideo, {alpha: 0}, 0.5, {onComplete: function() {	
					remove(firstVideo);
					firstVideo.destroy();
				}});
				FlxTween.tween(currentMusic, {volume: 0.7}, 1, {onComplete: function() {
					inputAllowed = true;
				}});
			});
		});
		firstVideo.bitmap.onFormatSetup.add(function() if (firstVideo.bitmap != null && firstVideo.bitmap.bitmapData != null) {
			final width = firstVideo.bitmap.bitmapData.width;
			final height = firstVideo.bitmap.bitmapData.height;
			final scale:Float = Math.min(FlxG.width / width, FlxG.height / height);
			firstVideo.setGraphicSize(Std.int(width * scale), Std.int(height * scale));
			firstVideo.updateHitbox();
			firstVideo.screenCenter();
			cutsceneText.camera = cutsceneCamText;
			FlxG.camera.visible = true;
		});
		firstVideo.load(Assets.getPath(Paths.video("post-gilbert")));
		firstVideo.play();
		changeSelection(1);
		FlxG.cameras.add(cutsceneCamText, false);
	}
	
	changeSelection(0);

	if (FlxG.sound.music != null)
		FlxG.sound.music.pause();

	window.onMove.add(onWindowMove);
}

var gilbertForced = false;
var canMoveGilbert = false;

function makeFire(x, y, scale) {
	var fire = new FlxSprite(x, y);
	fire.frames = Paths.getSparrowAtlas("stages/betrayed/feu");
	fire.animation.addByPrefix("idle", "fire0", 30, true);
	fire.animation.play('idle');
	fire.scale.set(scale, scale);
	fire.updateHitbox();
	fire.alpha = 0.001;
	return fire;
}

var catafire1:FlxSprite;
var catafire2:FlxSprite;
var betrafire1:FlxSprite;
var betrafire2:FlxSprite;
var crackedfire1:FlxSprite;
var crackedfire2:FlxSprite;

function initializeArrows() {
	objects.arrowRight = new FlxSprite(0, 250).loadGraphic(getAsset('states/freeplay/arrow'));
	objects.arrowRight.x = FlxG.width - 50 - objects.arrowRight.width;
	objects.arrowRight.updateHitbox();
	add(objects.arrowRight);

	objects.arrowLeft = new FlxSprite(0, 250).loadGraphic(getAsset('states/freeplay/arrow'));
	objects.arrowLeft.updateHitbox();
	objects.arrowLeft.flipX = true;
	objects.arrowLeft.x = 50;
	add(objects.arrowLeft);
}

var maltigi:FlxSprite;
var leftDoor:FlxSprite;
var rightDoor:FlxSprite;

var scoreText:FlxText;
function niqueTaMere()
{
	for (i in 0...unlockedSongList.length) {
		var painting = new FlxSprite(100, -800);
		painting.loadGraphic(preloadedGraphics[i].painting);
		painting.antialiasing = true;
		painting.scale.set(0.225, 0.225);
		painting.updateHitbox();
		painting.screenCenter(); 
		painting.y -= 160;
		objects.paintings.push(painting);
		painting.alpha = 0.001;
		painting.ID = i;
		add(painting);

		var chartMeta = Chart.loadChartMeta(unlockedSongList[i], null, "normal", true, false);
		
		var text = new FlxText(0, FlxG.height, FlxG.width, chartMeta.displayName, 24 * 1.75);
		text.setFormat(Paths.font("U.ttf"), 36 * 1.75, FlxColor.WHITE, "center");
		text.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
		text.y = 600;
		text.antialiasing = true;
		text.alpha = 0.001;
		add(text);
		text.ID = i;
		objects.scoreTexts.push(text);

		optionPos.push([painting.offset.x,  painting.offset.y, FlxG.random.float(0.1, 0.5), FlxG.random.float(0.1, 0.5), FlxG.random.float(0.1, 0.5)]);
	}

	scoreText = new FlxText(0, FlxG.height, FlxG.width, "", 18);
	scoreText.setFormat(Paths.font("U.ttf"), 36, FlxColor.WHITE, "center");
	scoreText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
	scoreText.y = 570;
	scoreText.antialiasing = true;
	add(scoreText);
}

function preloadAssets() {
	for (i in 0...unlockedSongList.length) {
		preloadedGraphics.push({
			painting: getAsset('states/freeplay/paintings/' + unlockedSongList[i])
		});
	}
}

var lerpScore = 0;
var intendedScore = 0;
var intendedMisses = 0;

function onWindowMove(x, y) {
	windowPosX = x;
	windowPosY = y;
}

var inputAllowed:Bool = true;
var updatedTime:Float = FlxG.random.float(10, 1000);
var shakeItensity = 0;
function update(elapsed) {
	gfStuck.alpha = gfStuckAlpha * gfStuckAlphaMulti;
	if (shakeItensity > 0)
	{
		window.x = windowPosX + FlxG.random.float(-shakeItensity, shakeItensity) * 2.5;
		window.y = windowPosY + FlxG.random.float(-shakeItensity, shakeItensity) * 2.5;
	}
	updatedTime += elapsed * 2;
	var lerpVal:Float = FlxMath.bound(elapsed * 9.6, 0, 1);
	for (spr in objects.paintings) {
		spr.offset.x = optionPos[spr.ID][0] + Math.cos(optionPos[spr.ID][2] * updatedTime * 2) * 3;
		spr.offset.y = optionPos[spr.ID][1] + Math.cos(optionPos[spr.ID][3] * updatedTime * 2) * 3;
		spr.angle = FlxMath.lerp(spr.angle, Math.cos(optionPos[spr.ID][4] * updatedTime * 2) * 1.5, lerpVal);
	}

	lerpScore = Math.floor(lerp(lerpScore, intendedScore, 0.4));
	if (Math.abs(lerpScore - intendedScore) <= 10)
		lerpScore = intendedScore;

	scoreText.text = applyFiller(getString("freeplay_score"), [lerpScore]) + " | " + applyFiller(getString("freeplay_misses"), [intendedMisses]);

	FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, camZoom, lerpVal);

	leftDoor.alpha = rightDoor.alpha;
	catafire2.alpha = catafire1.alpha;
	betrafire2.alpha = betrafire1.alpha;
	crackedfire2.alpha = crackedfire1.alpha;
	if (!canMoveGilbert && gilbertForced) return;
	if (!inputAllowed) return;

	//INPUT SHIT
	
	if (controls.BACK) {
		applySoundTrayTheme(FlxG.game.soundTray, Paths.getPath("images/soundtray/volumebox.png"), FlxColor.WHITE);
		if (gilbertForced)
			enableWindowControls(true);
		inputAllowed = false;
		if (FlxG.sound.music != null) {
			FlxG.sound.music.resume();
			FlxTween.tween(FlxG.sound.music, { volume: 1 }, 1.25, { ease: FlxEase.quadInOut });
		}
		FlxTween.tween(currentMusic, { volume: 0 }, 1.25, { ease: FlxEase.quadInOut });
		FlxG.camera.fade(FlxColor.BLACK, 1.25, false);
		new FlxTimer().start(1.5, function() {
			clearAssets();
			FlxG.switchState(new MainMenuState());
		});

		if (shakeIntensityTwn != null)
			shakeIntensityTwn.cancel();

		shakeIntensityTwn = FlxTween.num(shakeItensity, 0, 1.2, { ease: FlxEase.quadInOut }, function(v)
		{
			shakeItensity = v;
		});
	} 

	if (!gilbertForced)
	{
		if (controls.LEFT_P || controls.RIGHT_P) {
			var spr = controls.LEFT_P ? objects.arrowLeft : objects.arrowRight;
			spr.scale.set(0.9, 0.9);
			spr.color = 0xFFCCCCCC;
			inactivityTimer = 0;
			holdTime = 0;
			changeSelection(controls.LEFT_P ? -1 : 1);
		}
	
		if (controls.LEFT || controls.RIGHT)
		{
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed / 3;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
	
			if (holdTime > (0.5 / 3) && checkNewHold - checkLastHold > 0)
				changeSelection(controls.LEFT ? -1 : 1);
		}
	
		if (controls.LEFT_R || controls.RIGHT_R) {
			holdTime = 0;
			var spr = controls.LEFT_R ? objects.arrowLeft : objects.arrowRight;
			spr.scale.set(1, 1);
			spr.color = 0xFFFFFFFF;
		}
	}

	if (controls.ACCEPT) {
		var loading = new ModSubState('substate/loading');
		hasLoad = false;
		inputAllowed = false;
		var soundToPlay = "";
		var closeToPoint = FlxPoint.get(FlxG.width / 2, FlxG.height * 0.3);
		if (isInactive) closeToPoint.y = FlxG.height * 0.35;
		switch (unlockedSongList[Freeplay_curSelected]) {
			case "Iceberg": 
				closeToPoint.x = leftDoor.x + leftDoor.width - 15;
				closeToPoint.y = leftDoor.y + (leftDoor.height / 2) + 20;
				if (isInactive) closeToPoint.y = FlxG.height * 0.5;
				FlxTween.tween(leftDoor, { x: leftDoor.x - leftDoor.width }, 0.7, { ease: FlxEase.cubeIn });
				FlxTween.tween(rightDoor, { x: rightDoor.x + rightDoor.width }, 0.7, { ease: FlxEase.cubeIn });
				soundToPlay = 'stardoor-open';
			case 'Cosmic-copy':
				soundToPlay = 'cosmic-hello';
				closeToPoint.y = FlxG.height * 0.375;
				if (isInactive) closeToPoint.y = FlxG.height * 0.42;
			case 'Infernal':
				soundToPlay = 'confirm-fnf';
				closeToPoint.y = FlxG.height * 0.33;
				if (isInactive) closeToPoint.y = FlxG.height * 0.39;
			case 'Disturbing-presence':
				if (shakeIntensityTwn != null)
					shakeIntensityTwn.cancel();

				shakeIntensityTwn = FlxTween.num(shakeItensity, 0, 2, {}, function(v)
				{
					shakeItensity = v;
				});
			case "Silent":
				closeToPoint.y = FlxG.height * 0.37;
				if (isInactive) closeToPoint.y = FlxG.height * 0.45;

			case "Poltergeist":
				closeToPoint.y = FlxG.height * 0.37;
				if (isInactive) closeToPoint.y = FlxG.height * 0.45;
				if (gfStuckAlphaTween != null)
					gfStuckAlphaTween.cancel();
				gfStuckAlphaTween = FlxTween.num(gfStuckAlpha, 1, 2, {ease: FlxEase.quadInOut}, function(v) {
					gfStuckAlpha = v;
				});

			case 'Earache': 
				if (isInactive) closeToPoint.y = FlxG.height * 0.45;
		}
		if (soundToPlay != "")
			FlxG.sound.play(Paths.sound(soundToPlay), 0.5);
		PlayState.loadSong(unlockedSongList[Freeplay_curSelected], "normal");
		inactivityTimer = -12222220;

		if (FlxG.save.data.tv)
		{
			closeToPoint.x /= FlxG.width;
			closeToPoint.y /= FlxG.height;
			closeToPoint.x = (closeToPoint.x - 0.5) * 2.0;
			closeToPoint.y = (closeToPoint.y - 0.5) * 2.0;
			closeToPoint.x *= 1.1;	
			closeToPoint.y *= 1.1;	
			closeToPoint.x *= 1.0 + Math.pow((Math.abs(closeToPoint.y) / 5.0), 2.0);
			closeToPoint.y *= 1.0 + Math.pow((Math.abs(closeToPoint.x) / 4.0), 2.0);
			closeToPoint.x = (closeToPoint.x / 2.0) + 0.5;
			closeToPoint.y = (closeToPoint.y / 2.0) + 0.5;
			closeToPoint.x = closeToPoint.x *0.95 + 0.0275;
			closeToPoint.y = closeToPoint.y *0.95 + 0.0275;
			closeToPoint.x *= FlxG.width;
			closeToPoint.y *= FlxG.height;
		}

		loading.data = {closeToPoint: closeToPoint, currentMusic: currentMusic, followText: objects.scoreTexts[Freeplay_curSelected]};
		openSubState(loading);
		FlxTween.cancelTweensOf(currentMusic);
		FlxTween.tween(currentMusic, {volume: 0.5}, 1, {ease: FlxEase.sineOut});
		new FlxTimer().start(2, function(tmr:FlxTimer) {
			clearAssets();
			//FlxG.switchState(new PlayState());
		});
	}

	if (!gilbertForced) {
		inactivityTimer += elapsed;
		if (inactivityTimer >= 10 && !isInactive) {
			hideUI();
		}
	}
}

var camZoom = 1;
var zoomTween:NumTween;
static var Freeplay_maltigiJumpscared:Bool = false;
var isInactive = false;
function hideUI() {
	var fadeDuration = 0.5;
	isInactive = true;
	if (zoomTween != null)
		zoomTween.cancel();
	var zoomDuration = fadeDuration + 5.2;
	var zoom = 1.2;
	var camPos = -60;
	if (unlockedSongList[Freeplay_curSelected] == "Iceberg") {
		camPos = 20;
		if (!Freeplay_maltigiJumpscared)
		{
			inputAllowed = false;
			new FlxTimer().start(zoomDuration + 1, function(_) {
				Freeplay_maltigiJumpscared = true;
				zoomTween = FlxTween.num(camZoom, 1.5, 0.7, { ease: FlxEase.quadInOut }, function(val) {
					camZoom = val;
				});
				maltigi.alpha = 1;
				maltigi.scale.set(0.208, 0.208);
				FlxTween.tween(leftDoor, { x: leftDoor.x - leftDoor.width }, 0.7, { ease: FlxEase.cubeInOut });
				FlxTween.tween(rightDoor, { x: rightDoor.x + leftDoor.width }, 0.7, { ease: FlxEase.cubeInOut, onComplete: function(_) {
					new FlxTimer().start(0.1, function(_) {
						FlxG.sound.play(Paths.sound("scream"), 1).persist = true;
						FlxG.camera.shake(0.025, 3, true);
					
						new FlxTimer().start(3, function(_) {
							zoomTween = FlxTween.num(camZoom, 1.2, 0.2, { ease: FlxEase.quadInOut }, function(val) {
								camZoom = val;
							});

							new FlxTimer().start(0.1, function(_) {
								FlxTween.tween(leftDoor, { x: leftDoor.x + leftDoor.width }, 0.3, { ease: FlxEase.quadInOut });
								FlxTween.tween(maltigi, { alpha: 0.001, 'scale.x': 0.1, 'scale.y': 0.1 }, 0.2, { ease: FlxEase.quadInOut });
								FlxTween.tween(rightDoor, { x: rightDoor.x - leftDoor.width }, 0.3, { ease: FlxEase.quadInOut, onComplete: function(_) {
									inputAllowed = true;
								} });
							});
						});
					});
				}});
			});
		}
	}
	if (unlockedSongList[Freeplay_curSelected] == "Earache") {
		camPos = -150;
		zoomDuration = 0.3;
		zoom = 1.7;
		new FlxTimer().start(0.1, function(_) {
			FlxG.sound.play(Paths.sound("scream"), 1).persist = true;
			FlxG.camera.shake(0.025, 3, true);

			new FlxTimer().start(3, function(_) {
				if (unlockedSongList[Freeplay_curSelected] == "Earache") {
					zoomTween = FlxTween.num(camZoom, 1.2, 0.2, { ease: FlxEase.expoOut }, function(val) {
						camZoom = val;
					});
				}
			});
		});
	}
	zoomTween = FlxTween.num(camZoom, zoom, zoomDuration - 0.2, { ease: FlxEase.quadInOut }, function(val) {
		camZoom = val;
	});
	FlxTween.tween(currentMusic, { volume: 1 }, fadeDuration, { ease: FlxEase.quadInOut });
	FlxTween.tween(FlxG.camera.scroll, {y: camPos}, zoomDuration, { ease: FlxEase.quadInOut });
	for (spr in [objects.arrowLeft, objects.arrowRight])
		FlxTween.tween(spr, { alpha: 0.001 }, fadeDuration, { ease: FlxEase.quadInOut });

	for (spr in objects.scoreTexts)
		FlxTween.tween(spr, { alpha: 0.001 }, fadeDuration, { ease: FlxEase.quadInOut });

	FlxTween.tween(scoreText, { alpha: 0.001 }, fadeDuration, { ease: FlxEase.quadInOut });
}

function isLetter(letter:String):Bool
{
	var code = letter.charCodeAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
}

function shuffleString(s:String):String {
	var letters = [];
	var indices = [];
	
	for (i in 0...s.length) {
		if (isLetter(s.charAt(i))) {
			letters.push(s.charAt(i));
			indices.push(i);
		}
	}
	
	for (i in 0...letters.length) {
		var j = Std.random(letters.length);
		var temp = letters[i];
		letters[i] = letters[j];
		letters[j] = temp;
	}
	
	var arr = s.split("");
	for (i in 0...indices.length) {
		arr[indices[i]] = letters[i];
	}
	
	return arr.join("");
}

function showUI(change:Int = 0) {
	if (zoomTween != null)
		zoomTween.cancel();
	zoomTween = FlxTween.num(camZoom, 1, 0.1, { ease: FlxEase.quadInOut }, function(val) {
		camZoom = val;
	});
	FlxTween.cancelTweensOf(FlxG.camera.scroll);
	FlxTween.tween(FlxG.camera.scroll, {y: 0}, 0.2, { ease: FlxEase.quadInOut });
	isInactive = false;
	for (spr in [objects.arrowLeft, objects.arrowRight])
	{
		FlxTween.cancelTweensOf(spr);
		FlxTween.tween(spr, { alpha: 1 }, 0.2, { ease: FlxEase.quadInOut });
	}
	
	for (spr in objects.scoreTexts) {
		FlxTween.cancelTweensOf(spr);
		FlxTween.tween(spr, { alpha: (spr.ID == (Freeplay_curSelected + change)) ? 1 : 0.001 }, 0.2, { ease: FlxEase.quadInOut });
	}

	FlxTween.tween(scoreText, { alpha: 1 }, 0.2, { ease: FlxEase.quadInOut });
}

var currentMusic:FlxSound;
var soundsLoaded:Map<String, FlxSound> = [];

function playMusicWithFade(musicName:String, fadeDuration:Float = 0.5):Void {
	if (gilbertForced || !inputAllowed)
		return;
	if (soundsLoaded.exists(musicName))
	{
		FlxTween.tween(currentMusic, { volume: 0 }, fadeDuration, {});
		new FlxTimer().start(fadeDuration, function() {
			currentMusic.stop();
			currentMusic = soundsLoaded.get(musicName);
			currentMusic.volume = 0;
			FlxTween.tween(currentMusic, { volume: 0.7 }, fadeDuration);
			currentMusic.play();
		});
	} else {
		//shouldnt happen since they are preloaded in the start
		currentMusic = FlxG.sound.load(Paths.music(musicName), 1, true);
		currentMusic.volume = 0;
		soundsLoaded.set(musicName, currentMusic);
	}
}

var windowPosX = null;
var windowPosY = null;
var shakeIntensityTwn;

function changeSelection(change = 0) {
	var newSelected:Int = Freeplay_curSelected + change;

	if (newSelected >= unlockedSongList.length || newSelected < 0)
		return;

	if (isInactive)
		showUI(controls.LEFT_P ? -1 : 1);

	prevBg.loadGraphic(getAsset('states/freeplay/bg/' + unlockedSongList[Freeplay_curSelected]));
	bg.loadGraphic(getAsset('states/freeplay/bg/' + unlockedSongList[newSelected]));
	
	playMusicWithFade(unlockedSongList[newSelected], 0.25);

	bg.alpha = 0.001;
	prevBg.alpha = 1;

	for (spr in [objects.arrowLeft, objects.arrowRight, bg, prevBg])
		FlxTween.cancelTweensOf(spr);

	FlxTween.tween(objects.arrowLeft, { alpha: newSelected == 0 ? 0 : 1 }, 0.2, { ease: FlxEase.sineInOut });
	FlxTween.tween(objects.arrowRight, { alpha: newSelected == unlockedSongList.length - 1 ? 0 : 1 }, 0.2, { ease: FlxEase.sineInOut });

	FlxTween.tween(bg, { alpha: 1 }, 0.2, { ease: FlxEase.sineInOut });
	FlxTween.tween(prevBg, { alpha: 0.001 }, 0.2, { ease: FlxEase.sineInOut });

	for (spr in objects.scoreTexts) {
		var isSelected = (spr.ID == newSelected);
		var newScale = isSelected ? 1 : 1/1.75;
		FlxTween.completeTweensOf(spr);
		FlxTween.tween(spr, { alpha: isSelected ? 1 : 0.001, y: isSelected ? 600 : 675, "scale.x": newScale, "scale.y": newScale}, 0.3, { ease: FlxEase.cubeOut });
	}

	if (newSelected == 13) {
		if (gfStuckTween != null)
			gfStuckTween.cancel();
		gfStuckTween = FlxTween.num(gfStuckAlphaMulti, 1, 0.2, { ease: FlxEase.sineInOut }, function(val) {
			gfStuckAlphaMulti = val;
		});
	} else if (Math.abs(13 - newSelected) == 1)
	{
		if (gfStuckTween != null)
			gfStuckTween.cancel();
		gfStuckTween = FlxTween.num(gfStuckAlphaMulti, 0.001, 0.2, { ease: FlxEase.sineInOut }, function(val) {
			gfStuckAlphaMulti = val;
		});
	}

	Freeplay_curSelected = newSelected;
	
	var songData = FunkinSave.getSongHighscore(unlockedSongList[Freeplay_curSelected], "normal");
	intendedMisses = songData.misses;
	intendedScore = songData.score;

	if (windowPosX != null)
		window.x = windowPosX;
	if (windowPosY != null)
		window.y = windowPosY;

	windowPosX = window.x;
	windowPosY = window.y;

	if (shakeIntensityTwn != null)
		shakeIntensityTwn.cancel();

	if (Freeplay_curSelected != 8) {
		shakeItensity = 0;
		Framerate.codenameBuildField.text = "Sunday Night Plumbin'";
		window.title = "SUNDAY NIGHT PLUMBIN";
		applySoundTrayTheme(FlxG.game.soundTray, Paths.getPath("images/soundtray/volumebox.png"), FlxColor.WHITE);
		objects.arrowLeft.loadGraphic(getAsset('states/freeplay/arrow'));
		objects.arrowRight.loadGraphic(getAsset('states/freeplay/arrow'));
	} else {
		if (!gilbertForced)
		{
			shakeIntensityTwn = FlxTween.num(0, 100, 60*30, {}, function(v)
			{
				shakeItensity = v;
			});
		}
		applySoundTrayTheme(FlxG.game.soundTray, Paths.getPath("images/soundtray/volumebox_bw.png"), FlxColor.BLACK);
		
		objects.arrowLeft.loadGraphic(getAsset('states/freeplay/arrow-evil'));
		objects.arrowRight.loadGraphic(getAsset('states/freeplay/arrow-evil'));
	}

	FlxTween.tween(rightDoor, { alpha: (unlockedSongList[Freeplay_curSelected] == "Iceberg") ? 1 : 0.001 }, 0.2, { ease: FlxEase.sineInOut });
	FlxTween.tween(catafire1, { alpha: (unlockedSongList[Freeplay_curSelected] == "Cataclysmic") ? 1 : 0.001 }, 0.2, { ease: FlxEase.sineInOut });
	FlxTween.tween(betrafire1, { alpha: (unlockedSongList[Freeplay_curSelected] == "Betrayed") ? 1 : 0.001 }, 0.2, { ease: FlxEase.sineInOut });
	FlxTween.tween(crackedfire1, { alpha: (unlockedSongList[Freeplay_curSelected] == "Cracked-egg") ? 1 : 0.001 }, 0.2, { ease: FlxEase.sineInOut });

	updatePortraits(change);
}

function updatePortraits(posOrNeg:Int) {
	for (spr in objects.paintings) {
		FlxTween.cancelTweensOf(spr);
	}
	for (spr in objects.paintings) {
		FlxTween.tween(spr, { angle: posOrNeg * 25 }, 0.1, { ease: FlxEase.cubeOut });
		FlxTween.tween(spr, { alpha: (Freeplay_curSelected == spr.ID) ? 1 : 0.001 }, 0.3, { ease: FlxEase.cubeOut });
		FlxTween.tween(spr, { x: (FlxG.width / 2) + (spr.ID - Freeplay_curSelected) * 500 - spr.width / 2 }, 0.4, { ease: FlxEase.cubeOut });
	}
}
