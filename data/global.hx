import Date;
import Xml;
import flixel.system.ui.FlxSoundTray;
import funkin.backend.MusicBeatState;
import funkin.backend.system.framerate.Framerate;
import funkin.backend.system.macros.GitCommitMacro;
import funkin.backend.utils.DiscordUtil;
import funkin.backend.utils.NativeAPI;
import hxvlc.util.Handle;
import lime.app.Application;
import lime.graphics.Image;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.text.TextFormat;
import sys.FileSystem;
import sys.io.File;

using StringTools;

static var goodCommitNumba = "9757b00";
static var goodVersion = "1.0.1";
static var cneDownloadLink = "https://github.com/CodenameCrew/CodenameEngine/releases/tag/v1.0.1";

// Use when necessary
static function upscaleText(text, upscaleAmt)
{
    text.antialiasing = true;
    text.size *= upscaleAmt;
    text.scale.x /= upscaleAmt;
    text.scale.y /= upscaleAmt;
    text.borderQuality *= upscaleAmt;
    text.borderSize *= upscaleAmt;
    text.fieldWidth *= upscaleAmt;
    text.updateHitbox();
}

var randomMusic:FlxSound = new FlxSound();
static var initialized:Bool = false;
static var hasLoad:Bool = true;
static var menuMusic = "freakyMenu";

static var PowerUpState_powerUpData:Array<Array<String>> = [
	['None',			'No Effect', 						  1],
	['Fire Flower',		'Scroll Speed is increased by x1.5',   1.5],
	['Ice Flower',		'Scroll Speed is decreased by x0.5',   0.5],
	['Metal Cap',		'You cannot take damage',			  -99],
	['Poison Mushroom',	'If you miss a note you die',		  2],
	['Retro Mushroom',	'Retro Mushroom',					  1]
];

static var songList:Array<String>=[
	'Immortal',
	'Betrayed',
	'Cataclysmic',
	'Cosmic-copy',
	'Infernal',
	'Cracked-egg',
	'Iceberg',
	"Silent",
	'Disturbing-presence',
	'Blessing',
	'Golden-Hammer',
	'Fatal rap',
	"Heartless",
	"Poltergeist",
	'Earache',
];

function new(){
	Handle.init([]);

	var settingsData = {
		disto: true,
		viewWarningState: true,
		showCutscene:true,

		curPowerUp: 0,

		// VISUALS (SHADERS)
		glow: true,
		heatwave: true,
		tv: true,
		saturation: true,
		flou: true,

		particles: true,
		flashing: true,

		//Gameplay
		hud: false,
		waitTimer: false,

		wonLuigi: false,
		alwaysLuigi: false,
		unlockedMaltigi: false,

		alreadyUnlockedDisto: false,
		distoLocked: false,
		shouldShowFinalCutscene: false,
		seenFreeplayFinal: false,
		seenFreeplayIntro: false,
		hasFinishedPolter: false,

		//Debug
		song: false,

		language: "english",
		menuMusicType: "default",
	};

	
	for (field in Reflect.fields(settingsData))
		if (Reflect.field(FlxG.save.data, field) == null)
			Reflect.setField(FlxG.save.data, field, Reflect.field(settingsData, field));
	
	for (song in songList)
		if (hasLoad)
			randomMusic.loadEmbedded(Paths.music(song), true, true);
	setLang(FlxG.save.data.language);
}

static function applySoundTrayTheme(soundtray:FlxSoundTray, image, color) {
	soundtray.removeChildren();

	var bg:Bitmap = new Bitmap(Assets.getBitmapData(image));
	soundtray._width = 746;
	soundtray._defaultScale = 0.3;
	soundtray.addChild(bg);
	soundtray.screenCenter();

	var tmp:Bitmap;

	var _bx:Int = 160;
	var bx:Int = _bx;
	var by:Int = 130;

	var globalVolume:Int = FlxG.sound.muted ? 0 : Math.round(FlxG.sound.volume * 10);
	soundtray._bars = [];
	for (i in 0...10)
	{
		tmp = new Bitmap(new BitmapData(11 / 0.3, 30 / 0.3, false, color));
		tmp.x = bx;
		tmp.y = by;
		soundtray.addChild(tmp);
		soundtray._bars.push(tmp);
		tmp.alpha = i < globalVolume ? 1 : 0.5;
		bx += 13 / 0.3;
	}
}

static var redirectStates:Map<FlxState, String> = [
	TitleState => "TitleScreen",
	MainMenuState => "MainMenuState",
	FreeplayState => "Freeplay",
];

var shaderTime = 0;
function update(elapsed) {
	if (FlxG.keys.justPressed.F7) {
		FlxG.bitmap.clearCache();
		FlxG.bitmap._cache.clear();
		Paths.tempFramesCache.clear();
		FlxG.resetState();
	}
	if (FlxG.keys.justPressed.F8)
	{
		setLang(FlxG.save.data.language);
	}
	shaderTime += elapsed;
	shaders.tv.iTime = shaderTime;
}

function postUpdate(elapsed)
{
	MusicBeatState.ALLOW_DEV_RELOAD = false;
}

var shaders = {
	tv: new CustomShader('tv'),
	ihy: new CustomShader('IHY'),
};
static function addMenuShaders(?cameras) {
	var daCam = cameras == null ? [FlxG.camera] : cameras;
	if (FlxG.save.data.tv)
		for (cam in daCam)
			cam.addShader(shaders.tv);
	
	if (FlxG.save.data.saturation)
		for (cam in daCam)
			cam.addShader(shaders.ihy);
}

static function updateRPC(details:String, ?state:String, ?smallImageKey:String) {
	DiscordUtil.changePresence(details, state, smallImageKey);
}

function postStateSwitch() {
	shaderTime = 0;
}

static function updateMenuMusic()
{
	var date = Date.now();
	if (date.getDate() == 14 && date.getMonth() == 6)
		menuMusic = "mainmenu/marseillaise";
	else {
		menuMusic = switch (FlxG.save.data.menuMusicType)
		{
			case "alt":
				"mainmenu/intense";
			default:
				"mainmenu/default";
		}
	}	
}

function preStateSwitch() {
	if (!initialized){
		initialized = true;
		applySoundTrayTheme(FlxG.game.soundTray, Paths.getPath("images/soundtray/volumebox.png"), FlxColor.WHITE);
		#if SHOW_BUILD_ON_FPS
		Framerate.codenameBuildField.text = "Sunday Night Plumbin'";
		#end
		updateMenuMusic();

		for (i => cat in [Framerate.fpsCounter, Framerate.memoryCounter #if SHOW_BUILD_ON_FPS , Framerate.codenameBuildField #end])
		{
			var texts = [];
			switch (i)
			{
				case 0:
					texts = [cat.fpsNum, cat.fpsLabel];
				case 1:
					texts = [cat.memoryText, cat.memoryPeakText];
				case 2:
					texts = [cat];
			}
			for (text in texts) {
				var format = text.defaultTextFormat;
				format.font = Paths.getFontName(Paths.font("U.ttf"));
				text.setTextFormat(format);
			}
		}

		var gameCommit = GitCommitMacro.commitHash;
		var gameVer = Application.current.meta['version'];
		if (gameVer != goodVersion || gameCommit != goodCommitNumba)
			FlxG.game._requestedState = new ModState("WrongCNEVersion");
		else if (FlxG.save.data.viewWarningState || FlxG.save.data.showCutscene)
			FlxG.game._requestedState = FlxG.save.data.viewWarningState ? new ModState('Warning') : new ModState('CutsceneState');
	}
	
	for (normalState => modState in redirectStates)
		if (FlxG.game._requestedState is normalState)
			FlxG.game._requestedState = new ModState(modState);

	for (i in 0...songList.length)
		if (hasLoad)
			randomMusic.loadEmbedded(Paths.music(songList[i]), true, true);
}

static var showCodenames:Bool = false;
static var lastOptionsState = null;

function destroy() {
	initialized = null;
	randomMusic.kill();
	MusicBeatState.ALLOW_DEV_RELOAD = true;
}

static var languageXML:Xml;
static var langCache:Map<String, String> = [];
static function getString(string:String)
{
	if(!langCache.exists(string))
	{
		var gotTranslated = string;
		for (elem in languageXML.elements())
		{
			if (elem.nodeName == string)
				gotTranslated = elem.get("value");
		}
		langCache.set(string, gotTranslated);
	}
	return fixUpText(langCache.get(string));
}

static function fixUpText(s)
{
    var fixedString = s;
    fixedString = StringTools.replace(fixedString, "\\n", "\n");
    fixedString = StringTools.replace(fixedString, "\\r", "\r");
    fixedString = StringTools.replace(fixedString, "\r\n", "\n"); // Normalize mixed newlines
    return fixedString;
}

static function applyFiller(string:String, fillers:Array<String>)
{
	var s = string;
	for (i=>d in fillers)
	{
		s = StringTools.replace(s, "{" + i + "}", d);
	}
	return s;
}

function addToLogFile(text:String)
{
	var filePath = "./SNP_logs.txt";
	if (!FileSystem.exists(filePath))
		File.saveContent(filePath, text);
	else {
		var fileContent = File.getContent(filePath);
		File.saveContent(filePath, fileContent + "\n" + text);
	}
}

function onScriptCreated(script, type)
{
	var oldErrorHandler = script.interp.errorHandler;
	var rawPath = script.path;
	script.interp.errorHandler = function(error) {
		var fn = rawPath + ":" + error.line + " | ";
		var err = error.toString();
		while(err.startsWith(fn)) {
			if (err.startsWith(fn)) err = err.substr(fn.length);
		}

		addToLogFile(Date.now().toString() + " - " + fn + err);

		oldErrorHandler(error); //default error handler
	};
}

static function setLang(l:String)
{
	var lang = l;
	var path = "assets/languages/" + lang + ".xml";
	if (!Assets.exists(path))
	{
		trace('fallback to english, because ' + lang + ' is missing');
		FlxG.save.data.language = 'english';
		lang = FlxG.save.data.language;
	}
	var languagePath = Assets.getText(path);
	langCache.clear();
	languageXML = Xml.parse(languagePath).firstElement();
}

static function copyArray(f)
{
	var a = [];

	for (i=>g in f)
		a[i] = g;
	return a;
}
