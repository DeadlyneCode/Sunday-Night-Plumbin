import flixel.math.FlxPoint;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.utils.FunkinParentDisabler;
import funkin.editors.charter.Charter;
import funkin.options.TreeMenu;

var metaData = PlayState.instance.SONG.meta;

var prvCams;
var camPause:FlxCamera;
var blur:CustomShader;

var curSelect:Int = 0;
var canSelect:Bool = false;
var options:Array<String> = ["resume", "restart", "options", "powerup", "exit"];

var black:FunkinSprite;
var color:FunkinSprite;
var highlight:FunkinSprite;
var icon:FunkinSprite;
var buttons:FlxSpriteGroup;
var portrait:FunkinSprite;
var songDisplay:FunkinText;
var musicpause:FlxSound;

function postCreate() {
	var musicName = "pausemusic";
	if (isDisto)
		musicName = "distoPauseMusic";
	musicpause = FlxG.sound.load(Paths.music(musicName));
	musicpause.volume = 0;
	musicpause.play();
	FlxTween.tween(musicpause, { volume: 0.3 }, 8);
	musicpause.looped = true;
}

var isDisto = false;
function create() {
    add(parentDisabler = new FunkinParentDisabler());

    prvCams = copyArray(FlxG.cameras.list);
    blur = new CustomShader('flouv2');

    camPause = new FlxCamera();
    camPause.bgColor = 0x00000000;
	FlxG.cameras.add(camPause, false);

	if (StringTools.trim(StringTools.replace(metaData.name, " ", "-").toLowerCase()) == "disturbing-presence")
		isDisto = true;

	if (isDisto)
		options.remove("powerup");

	if (PlayState.chartingMode)
		options.push("charter");

	var metaSpr = metaData.pause.image;

	for (changeData in metaData.pause.imageChangeData)
	 	if (changeData.step <= PlayState.instance.curStep)
	 		metaSpr = changeData.newImage;

	portrait = new FunkinSprite();
	portrait.loadGraphic(Paths.image("states/pause/" + metaSpr));
	portrait.x = FlxG.width - portrait.width - 100;
	portrait.y = FlxG.height - portrait.height + 25;
	portrait.alpha = 0.0;
	portrait.updateHitbox();
	portrait.antialiasing = true;
	portrait.cameras = [camPause];
	add(portrait);

	black = new FunkinSprite();
	black.makeGraphic(FlxG.width, 64, FlxColor.BLACK);
	black.origin.set(0, black.height / 2);
	black.y = FlxG.height - black.height;
	black.scale.x = 0;
	black.cameras = [camPause];
	add(black);

	color = new FunkinSprite();
	color.makeGraphic(FlxG.width, 10,  PlayState.instance.dad.iconColor);
	color.origin.set(0, color.height / 2);
	color.y = black.y;
	color.scale.x = 0;
	color.cameras = [camPause];
	add(color);

	songDisplay = new FunkinText(32, FlxG.height);
	songDisplay.setFormat(Paths.font("U.ttf"), 26, FlxColor.WHITE);
	songDisplay.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1, 1);
	songDisplay.cameras = [camPause];
	songDisplay.text = metaData.displayName + " / " + metaData.pause.composer;
	songDisplay.antialiasing = true;
	add(songDisplay);

	highlight = new FunkinSprite();
	highlight.makeGraphic(450, 50, FlxColor.WHITE);
	highlight.cameras = [camPause];
	highlight.angle = -5;
	highlight.antialiasing = true;
	add(highlight);

	icon = new FunkinSprite();
	icon.loadGraphic(Paths.image("states/pause/scripulous"));
	icon.scale.set(0.4, 0.4);
	icon.cameras = [camPause];
	add(icon);

	buttons = new FlxSpriteGroup();
	buttons.cameras = [camPause];
	add(buttons);

	for (o=>option in options) {
        var button:FunkinText = new FunkinText(-500, o * 75, 0, getString("pause_" + (isDisto ? "disto_" : "") + option));
		button.setFormat(Paths.font("U.ttf"), 25, FlxColor.WHITE);
		button.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1, 1);
		button.updateHitbox();
		button.antialiasing = true;
		button.angle = -5;
		button.ID = o;
    	buttons.add(button);

		if (option == 'resume' || option == 'restart') {
			button.size = 45;
			button.updateHitbox();
		}
		else
			button.y += 20;

		var point = FlxPoint.get(20, 0);
		point.degrees = button.angle;
		FlxTween.tween(button.offset, {y: -point.y, x: -point.x}, 3, {type: 4, ease: FlxEase.quadInOut, startDelay: o / 2});
	}

	buttons.screenCenter(FlxAxes.Y);

	enterPause();
	changeSelect(0, true);
}

function update(elapsed) {
    if (canSelect) {
        if (controls.UP_P || controls.DOWN_P)
			changeSelect((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0), false);

		if (controls.ACCEPT)
            confirmSelect();

    	if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            goBack();
        }
	}

	for (button in buttons) {
		var colorIntended = (button.ID == curSelect) ? 0xFF000000 : 0xFFFFFFFF;

		button.color = CoolUtil.lerpColor(button.color, colorIntended, 16 / 60);
	}
}

function enterPause() {
	FlxTween.num(0, 0.2, 0.5, {ease: FlxEase.expoOut, startDelay: 0.1}, function (v) {
		camPause.bgColor =  FlxColor.fromRGBFloat(0, 0, 0, v);
	});

	FlxTween.num(0, 8, 0.5, {ease: FlxEase.expoOut, startDelay: 0.1}, function (v) {
		blur.Size = v;
	});

	FlxTween.tween(black.scale,	{x: 1},									0.65,		{ease: FlxEase.expoOut, startDelay: 0.2});
	FlxTween.tween(color.scale,	{x: 1},									0.65,		{ease: FlxEase.expoOut, startDelay: 0.3});
	FlxTween.tween(songDisplay,	{y: black.y + 22.5},					0.65,		{ease: FlxEase.expoOut, startDelay: 0.4});
	FlxTween.tween(portrait,	{alpha: 1 },							0.65,	{ease: FlxEase.sineInOut});
	FlxTween.tween(portrait,	{y: FlxG.height - portrait.height },	0.5,	{ease: FlxEase.smootherStepOut});
	FlxTween.tween(highlight,	{x: 125 - 65, alpha: 1},				0.5,	{ease: FlxEase.expoOut, startDelay: 0.1});
	FlxTween.tween(icon,		{x: 125 - 65 + 15},						0.5,	{ease: FlxEase.expoOut, startDelay: 0.1});

	for (button in buttons)
	    FlxTween.tween(button, {x: 125}, 0.5, {ease: FlxEase.expoOut, startDelay: button.ID / 15});

	new FlxTimer().start(0.8, function(_) {
		canSelect = true;
	});

	if (FlxG.save.data.flou)
		for (cams in prvCams)
			cams.addShader(blur);
}

function changeSelect(select:Int, force:Bool) {
    if (!force) {
        if (select == 0)
            return;

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	var prvSelect:Int = curSelect;
	curSelect = FlxMath.wrap(curSelect + select, 0, options.length-1);

	var fixThemFuckingHitboxes = function() {
		highlight.updateHitbox();
		icon.updateHitbox();
	};

	for (button in buttons) {
	    var isSelect:Bool = (button.ID == curSelect);
		var wasSelect:Bool = (button.ID == prvSelect);

		if (isSelect) {
		    var highScale:Float = 1.0;
			var highPos:FlxPoint = FlxPoint.get(button.x - 65, button.y - button.height / 2 - 2.5);

			var iconScale:Float = 0.4;
			var iconPos:FlxPoint = FlxPoint.get(highPos.x + 15, highPos.y + 20);

			if (button.size > 25) {
			    highScale = 1.15;
				highPos.y += 20;

				iconScale = 0.425;
				iconPos.y += 25;
			}

			if (select != 0) {
    			FlxTween.cancelTweensOf(icon);
    			FlxTween.cancelTweensOf(highlight);
                FlxTween.tween(icon, {x: iconPos.x, y: iconPos.y}, 0.5, {ease: FlxEase.expoOut});
                FlxTween.tween(highlight, {x: highPos.x, y: highPos.y}, 0.5, {ease: FlxEase.expoOut});
			} else {
			    icon.y = iconPos.y;
			    highlight.y = highPos.y;
			}

			FlxTween.tween(icon, {"scale.x": iconScale, "scale.y": iconScale}, 0.5, {ease: FlxEase.expoOut});
			FlxTween.tween(highlight, {"scale.x": highScale, "scale.y": highScale}, 0.5, {ease: FlxEase.expoOut, onUpdate: fixThemFuckingHitboxes});
		}
	}
}


function confirmSelect() {
	canSelect = false;

	FlxG.sound.play(Paths.sound('confirmMenu'));

	switch(options[curSelect]) {
		case 'resume':
			goBack();

		case 'restart':
			parentDisabler.reset();
			FlxG.resetState();

		case 'options':
			lastOptionsState = PlayState;
			FlxG.switchState(new ModState('Options'));

		case 'powerup':
			canSelect = true;
			persistentDraw = true;
			openSubState(new ModSubState('PowerUpStates'));

		case 'charter':
			FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, PlayState.variation, false));

		case 'exit':
			if (PlayState.chartingMode && Charter.undos.unsaved)
				state.saveWarn(false);
			else {
				PlayState.deathCounter = 0;
				PlayState.seenCutscene = false;

				if (Charter.instance != null) Charter.instance.__clearStatics();

				state.strumLines.forEachAlive(function(grp) grp.notes.__forcedSongPos = Conductor.songPosition);

				FlxG.switchState(new FreeplayState());
				musicpause.stop();
			}
			
	}
}

function goBack() {
    canSelect = false;

	FlxTween.num(0.2, 0, 0.5, {ease: FlxEase.expoOut, startDelay: 0.1}, function (v) {
		camPause.bgColor =  FlxColor.fromRGBFloat(0, 0, 0, v);
	});

	FlxTween.num(8, 0, 0.5, {ease: FlxEase.expoOut, startDelay: 0.1}, function (v) {
		blur.Size = v;
	});

	black.origin.set(black.width, black.height / 2);
	color.origin.set(color.width, color.height / 2);

	FlxTween.tween(black.scale, {x: 0},										1,		{ease: FlxEase.expoOut, startDelay: 0.3});
	FlxTween.tween(color.scale, {x: 0},										1,		{ease: FlxEase.expoOut, startDelay: 0.2});
	FlxTween.tween(songDisplay, {y: FlxG.width},							1,		{ease: FlxEase.expoOut});
	FlxTween.tween(portrait,	{alpha: 0.0},								0.65,	{ease: FlxEase.sineInOut});
	FlxTween.tween(portrait,	{y: FlxG.height - portrait.height + 25},	0.5,	{ease: FlxEase.smootherStepOut});
	FlxTween.tween(highlight,	{x: -500, alpha: 0},						0.5,	{ease: FlxEase.expoIn, startDelay: curSelect / 15});
	FlxTween.tween(icon,		{x: -500},									0.5,	{ease: FlxEase.expoIn, startDelay: curSelect / 15});
	FlxTween.tween(musicpause, { volume: 0}, 1,{onComplete: ()->{
		musicpause.stop();
	}});


	for (button in buttons)
		FlxTween.tween(button,	{x: -500}, 0.5, {ease: FlxEase.expoIn, startDelay: button.ID / 15});

	new FlxTimer().start(1.15, function(_) {
		if (FlxG.save.data.flou)
			for (cams in prvCams)
				cams.removeShader(blur);

		for (item in members)
			item.kill();

		close();
	});
}

function onClose() {
	FlxG.cameras.remove(camPause, true);
}