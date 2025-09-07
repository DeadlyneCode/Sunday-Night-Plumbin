import sys.io.File;
import sys.FileSystem;
import flixel.FlxObject;
import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.utils.FunkinParentDisabler;
import funkin.backend.utils.DiscordUtil;
import funkin.editors.charter.Charter;
import funkin.backend.scripting.Script;

var daChar:Character;
var loop = 1;
var confirm:Bool = true;
var fond:FlxSprite;

var isScripted = false;
var isVid = false;
var isPng = false;

var currentGameOverData:Dynamic;
var gameOverScript:Dynamic;
var onConfirms:Array<Void->Void> = [];

function onClose() {
    FlxG.cameras.remove(camera, true);
}

function getFieldDefault(o:Dynamic, field:String, defaultValue:String):String
{
	if (Reflect.hasField(o, field))
	    return Reflect.field(o, field) ?? defaultValue;
	
	return defaultValue;
}

var parentDisabler:FunkinParentDisabler;
function create() {
	for (camera in FlxG.cameras.list)
		camera.stopFX();

	DiscordUtil.call("onGameOver", []);
    add(parentDisabler = new FunkinParentDisabler());
    camera = new FlxCamera();
    camera.bgColor =  FlxColor.fromRGBFloat(0, 0, 0, 0);
    FlxG.cameras.add(camera, false);
	if (FileSystem.exists(Paths.getAssetsRoot() + '/songs/' + PlayState.SONG.meta.name.toLowerCase() + '/gameover.json'))
		currentGameOverData = Json.parse(File.getContent(Paths.getAssetsRoot() + '/songs/' + PlayState.SONG.meta.name.toLowerCase() + '/gameover.json'));

	var scriptName = getFieldDefault(currentGameOverData, "scriptName", "");
	if (StringTools.trim(scriptName) != "" && gameOverScript == null) {
		gameOverScript = Script.create(Paths.script("data/scripts/" + scriptName));
		stateScripts.add(gameOverScript);

		gameOverScript.set("currentGameOverData", currentGameOverData);
		gameOverScript.set("switchState", switchState);

		gameOverScript.load();
	}

	var gameoverType = getFieldDefault(currentGameOverData, "gameoverType", "Video");
	switch (gameoverType)
	{
		case "PNG":
			isPng = true;
		case "Video":
			isVid = true;
		case "Scripted":
			isScripted = true;
	}
	if (gameOverScript != null) {
		gameOverScript.set("isPng", isPng);
		gameOverScript.set("isVid", isVid);
		gameOverScript.set("isScripted", isScripted);
	}
	hasLoad = false;
}

var deathMusic;

function postCreate(){
	if (isPng) {
		var pngOptions = getFieldDefault(currentGameOverData, "pngOptions", {imageName: "findluigi", fadeDuration: 8});
		var imageName = getFieldDefault(pngOptions, "imageName", "findluigi");
		var fadeDuration = getFieldDefault(pngOptions, "fadeDuration", 8);
		
		over = new FlxSprite(0, 0).loadGraphic(Paths.image(imageName));
		add(over);
		over.setGraphicSize(FlxG.width, FlxG.height);
		over.scrollFactor.set();
		over.updateHitbox();
		over.cameras = [camera];
		if (fadeDuration > 0)
			camera.fade(FlxColor.BLACK, fadeDuration, true);
	}
	else if (isVid) {
		var videoOptions = getFieldDefault(currentGameOverData, "videoOptions", {videoName: "placeholder_gameover", videoHasSound: true, videoLooping: true});
		var videoName = getFieldDefault(videoOptions, "videoName", "placeholder_gameover");
		var videoHasSound = getFieldDefault(videoOptions, "videoHasSound", true);
		var videoLooping = getFieldDefault(videoOptions, "videoLooping", true);
		
		var gameoverVideo = new FlxVideoSprite(0, 0);
		gameoverVideo.load(Assets.getPath(Paths.video(videoName)), [(!videoHasSound ? ' :no-audio' : ':audio'), (videoLooping ? ':input-repeat=65535' : '')]);
		
		gameoverVideo.bitmap.onFormatSetup.add(function():Void
		{
			if (gameoverVideo.bitmap != null && gameoverVideo.bitmap.bitmapData != null)
			{
				var scale:Float = Math.min(FlxG.width / gameoverVideo.bitmap.bitmapData.width, FlxG.height / gameoverVideo.bitmap.bitmapData.height);
				gameoverVideo.setGraphicSize(gameoverVideo.bitmap.bitmapData.width * scale, gameoverVideo.bitmap.bitmapData.height * scale);
				gameoverVideo.updateHitbox();
				gameoverVideo.screenCenter();
			}
		});
		gameoverVideo.cameras = [camera];

		onConfirms.push(() -> gameoverVideo.stop());

		add(gameoverVideo);
		gameoverVideo.play();
	}
	
	var deathMusicStr = getFieldDefault(currentGameOverData, "deathMusic", "");
	if (StringTools.trim(deathMusicStr) != "") {
		var musicDelay = getFieldDefault(currentGameOverData, "musicDelay", 0);
		if (musicDelay > 0)
		{
			new FlxTimer().start(musicDelay, function(_) {
				deathMusic = FlxG.sound.play(Paths.music(deathMusicStr));
				deathMusic.looped = true;
				deathMusic.persist = true;
			});
		} else {
			deathMusic = FlxG.sound.play(Paths.music(deathMusicStr));
			deathMusic.looped = true;
			deathMusic.persist = true;
		}
	}
	
	var deathSfxStr = getFieldDefault(currentGameOverData, "deathSfx", "");
	if (StringTools.trim(deathSfxStr) != "") {
		var sfxDelay = getFieldDefault(currentGameOverData, "sfxDelay", 0);
		if (sfxDelay > 0)
		{
			new FlxTimer().start(sfxDelay, function(_) {
				FlxG.sound.play(Paths.sound(deathSfxStr));
			});
		} else
			FlxG.sound.play(Paths.sound(deathSfxStr));
	}
}

function update(){
	if (controls.ACCEPT && confirm) {
		confirmF();
	}
	if (controls.BACK) {
		if (deathMusic != null)
			deathMusic.stop();
		if (gameOverScript != null) {
			var continueNormal = gameOverScript.call("exitGameover", []);
			if (CoolUtil.isNotNull(continueNormal)) {
				if (!continueNormal)
					return;
			}
		}
		if (PlayState.isStoryMode){
			FlxG.switchState(new StoryMenuState());
			hasLoad = true;
		}
		if (PlayState.chartingMode)
			FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, false));
		if (!PlayState.isStoryMode && !PlayState.chartingMode){
			FlxG.switchState(new FreeplayState());
			hasLoad = true;
		}
	}
}

function confirmF(){
	confirm = false;

	if (deathMusic != null && deathMusic.playing)
		deathMusic.stop();

	var retrySfx = getFieldDefault(currentGameOverData, "retrySfx", "");
	if (StringTools.trim(retrySfx) != "")
		FlxG.sound.play(Paths.sound(retrySfx)).persist = true;

	try {
		for (confirmFunc in onConfirms)
			confirmFunc();
    } catch (e:Dynamic) {
	}

	if (gameOverScript != null) {
		var continueNormal = gameOverScript.call("confirmGameover", []);
		if (CoolUtil.isNotNull(continueNormal)) {
			if (!continueNormal)
				return;
		}
	}

	switchState(2);
}

function switchState(time:Float){
	var switchMyFuckingState = () -> { FlxG.switchState(new PlayState()); };
	if (Math.abs(time) > 0)
	{
		camera.stopFX();
		camera.fade(FlxColor.BLACK, Math.abs(time), false, switchMyFuckingState);
	} else
		new FlxTimer().start(0.05, switchMyFuckingState);
}