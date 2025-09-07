import funkin.backend.system.Flags;
import flixel.text.FlxTextBorderStyle;

var isPause:Bool = (FlxG.state == PlayState.instance);

var curSelect:Int = 0;
var canSelect:Bool = true;

var powerTxt:FunkinText;
var powerDescTxt:FunkinText;

var curMenuTxt:FunkinText;
var curPowerTxt:FunkinText;

var powerGroup:Array<FunkinSprite> = [];
var powerSquare:Array<FunkinSprite> = [];

var camPower:FlxCamera = FlxG.cameras.list[FlxG.cameras.list.length-1];

var powerUps:Array<Array<Dynamic>> = [];

function create() {
	for (i => powerUp in PowerUpState_powerUpData)
		powerUps[i] = powerUp;
	
	if (isPause)
	    powerUps.pop();
	else
		updateRPC("In the Power Up Selection Menu");

	curSelect = FlxG.save.data.curPowerUp;

	var bg = new FunkinSprite();
	bg.loadGraphic(Paths.image("states/powerup/background"));
	bg.setGraphicSize(0, FlxG.height);
	bg.updateHitbox();
	bg.screenCenter();
	bg.antialiasing = true;
	add(bg);

	powerTxt = new FunkinText(0, 0, FlxG.width);
	powerTxt.setFormat(Paths.font("U.ttf"), 64, FlxColor.WHITE, "center");
	powerTxt.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
	powerTxt.screenCenter(FlxAxes.X);
	powerTxt.antialiasing = true;
	powerTxt.y = camPower.height - 150;

	powerDescTxt = new FunkinText(0, 0, FlxG.width, "Test");
	powerDescTxt.setFormat(Paths.font("U.ttf"), 32, FlxColor.WHITE, "center");
	powerDescTxt.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
	powerDescTxt.screenCenter(FlxAxes.X);
	powerDescTxt.antialiasing = true;
	powerDescTxt.y = powerTxt.y + powerTxt.height;

	var stupidPipeY:Float;

	if (!isPause) {
    	var cube = new FunkinSprite(0, 10);
    	cube.loadGraphic(Paths.image("states/powerup/itemBox"));
    	cube.setGraphicSize(cube.width * 0.8);
    	cube.updateHitbox();
    	cube.screenCenter(FlxAxes.X);
    	cube.antialiasing = true;
    	add(cube);

    	var cubeBg = new FunkinSprite(cube.x, cube.y);
    	cubeBg.makeGraphic(cube.width, cube.height, 0x50000000);
    	insert(members.indexOf(cube), cubeBg);

    	for (p=>powerUp in powerUps) {
    		var power = new FunkinSprite(0, 10);
    		power.loadGraphic(Paths.image("states/powerup/items/" + powerUp[0]));
    		power.scale.set(0.8, 0.8);
    		power.screenCenter(FlxAxes.X);
    		power.antialiasing = true;
    		power.ID = p;
    		add(power);

    		powerSquare.push(power);

    		power.visible = (p == curSelect);
    	}
	}
	else {
    	var black:FunkinSprite = new FunkinSprite();
    	black.makeGraphic(FlxG.width, 64, FlxColor.BLACK);
		add(black);

    	var color:FunkinSprite = new FunkinSprite();
    	color.makeGraphic(FlxG.width, 10, 0xFFFFFFFF);
		color.color = PlayState.instance.dad.iconColor;
    	color.y = black.height;
    	add(color);

		curMenuTxt = new FunkinText(32);
    	curMenuTxt.setFormat(Paths.font("U.ttf"), 26, FlxColor.WHITE);
    	curMenuTxt.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1, 1);
        curMenuTxt.text = getString("powerup_title");
        curMenuTxt.y = (black.height - curMenuTxt.height) / 2;
		curMenuTxt.fieldWidth = FlxG.width - curMenuTxt.x;
    	curMenuTxt.antialiasing = true;
    	add(curMenuTxt);

    	curPowerTxt = new FunkinText();
    	curPowerTxt.setFormat(Paths.font("U.ttf"), 26, FlxColor.WHITE, 'right');
    	curPowerTxt.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 1, 1);
        curPowerTxt.text = applyFiller(getString("powerup_current"), [getString("powerup" + curSelect + "_name")]);
        curPowerTxt.y = (black.height - curPowerTxt.height) / 2;
		curPowerTxt.fieldWidth = curMenuTxt.fieldWidth;
		curPowerTxt.x = FlxG.width - (curPowerTxt.width + curMenuTxt.x);
    	curPowerTxt.antialiasing = true;
    	add(curPowerTxt);

		if (PlayState.instance.curSong == "blessing") {
			black.visible = false;
			color.color = 0xFF4E5460;
			powerTxt.font = powerDescTxt.font = curMenuTxt.font = curPowerTxt.font = Paths.font("SourceSans3-Bold.ttf");

			var back = new FunkinSprite();
			var front = new FunkinSprite();

			bg.loadGraphic(Paths.image("states/powerup/roblox/bg"));
			bg.setGraphicSize(0, FlxG.height);
			bg.updateHitbox();
			bg.screenCenter();
			bg.y += black.height;

			for (i => pipe in [back, front]) {
				pipe.loadGraphic(Paths.image("states/powerup/roblox/pipe-" + ["over", "under"][i] + "lay"));
				pipe.setGraphicSize(0, FlxG.height);
				pipe.updateHitbox();
				pipe.antialiasing = true;
				if (i == 0)
					insert(2, pipe);
				else
					add(pipe);

				stupidPipeY = pipe.y + (pipe.height / 3) - 20;
			}
		}
	}

	if (PlayState.instance.curSong != "blessing") {
		for (dir in ['left', 'right']) {
			var pipeBack = new FunkinSprite();
			var pipeFront = new FunkinSprite();

			for (p=>pipe in [pipeBack, pipeFront]) {
				pipeAnim = ["pipeBack", "pipeFront"][p];

				pipe.frames = Paths.getFrames("states/powerup/pipe");
				pipe.addAnim(pipeAnim, pipeAnim, 0, false);
				pipe.playAnim(pipeAnim);
				pipe.updateHitbox();
				pipe.antialiasing = true;

				if (dir == 'right') {
					pipe.flipX = true;
					pipe.x = FlxG.width - pipe.width;
				}

				pipe.y = camPower.height - pipe.height - 75.0;
			}

			insert(2, pipeBack);
			add(pipeFront);

			stupidPipeY = pipeFront.y;
		}
	}

	for (p=>powerUp in powerUps) {
		var power = new FunkinSprite();
		power.loadGraphic(Paths.image("states/powerup/items/" + powerUp[0]));
		if (PlayState.instance.curSong == "blessing")
		{
			power.loadGraphic(Paths.image("states/powerup/roblox/items/" + powerUp[0]));
			power.setGraphicSize(0, 105);
			power.updateHitbox();
		}
		power.antialiasing = true;
		power.ID = p;
		power.y = stupidPipeY + power.height / 2;
		insert(4, power);

		powerGroup.push(power);

		FlxTween.tween(power, {angle: -5}, 1, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	}

	add(powerTxt);
	add(powerDescTxt);

	if (isPause) {
	    for (spr in members) {
			spr.y += camPower.height;
			spr.cameras = [camPower];
		}

		canSelect = false;
		FlxTween.tween(camPower, {"scroll.y": camPower.height}, 1.5, {ease: FlxEase.expoInOut, onComplete: function() {
		    canSelect = true;
        }});
	}
	else {
		CoolUtil.playMusic(Paths.music("powerup"), false, 0, true);
		FlxG.sound.music.fadeIn(0.5, 0, 0.7);

	    addMenuShaders();
	}

	changeSelect(0, true);
}

function update(){
	if (canSelect) {
		if (controls.LEFT_P || controls.RIGHT_P)
			changeSelect((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0), false);

		if (controls.ACCEPT)
			confirmSelect();

		if (controls.BACK)
			goBack();

		if (controls.RESET)
			resetSelect();
	}
}

function changeSelect(select:Int, force:Bool) {
	if (!force) {
		if (select == 0)
			return;

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	var wasSelect:Int = curSelect;
	curSelect = FlxMath.wrap(curSelect + select, 0, powerUps.length-1);

	for (power in powerGroup) {
		FlxTween.cancelTweensOf(power);

		var wasCurrent:Bool = (power.ID == wasSelect);
		var isCurrent:Bool = (power.ID == curSelect);
		var goingLeft = (select < 0);

		power.visible = (isCurrent || wasCurrent);

		if (isCurrent) {
		    power.x = (goingLeft ? -power.width : FlxG.width);
			FlxTween.tween(power, {x: (FlxG.width - power.width) / 2}, 1, {ease: FlxEase.expoOut});
		} else {
		    power.x = (FlxG.width - power.width) / 2;
			FlxTween.tween(power, {x: (goingLeft ? FlxG.width : -power.width)}, 1, {ease: FlxEase.expoOut});
		}
	}

	powerTxt.text = getString("powerup" + curSelect + "_name");
	powerDescTxt.text = getString("powerup" + curSelect + "_desc");
	powerDescTxt.text += " | " + applyFiller(getString("powerup_scoremult"), [powerUps[curSelect][2]]);
}

function confirmSelect() {
	if (FlxG.save.data.curPowerUp == curSelect)
		return;

	FlxG.sound.play(Paths.sound('confirmMenu'));

	FlxG.save.data.curPowerUp = curSelect;

	if (!isPause) {
    	for (spr in powerSquare) {
    		FlxTween.completeTweensOf(spr);

    		FlxTween.tween(spr, {angle: curSelect == 0 ? 0 : 10, "scale.x": 0.9, "scale.y": 0.9}, 1, {ease: FlxEase.expoOut, type: 16});
    		spr.visible = (spr.ID == FlxG.save.data.curPowerUp);
    	}
	}
	else
	    curPowerTxt.text = applyFiller(getString("powerup_current"), [getString("powerup" + curSelect + "_name")]);
}

function resetSelect() {
	curSelect = 0;

	changeSelect(0, true);

	CoolUtil.playMenuSFX(1);

	FlxG.save.data.curPowerUp = curSelect;
	FlxG.save.flush();
	FlxG.switchState(new MainMenuState());
}

function goBack() {
	canSelect = false;

	FlxG.save.flush();
	FlxG.sound.play(Paths.sound('cancelMenu'));

	if (!isPause) {
	    FlxG.sound.music.fadeOut(0.5);

        camPower.fade(FlxColor.BLACK);
    	FlxTween.tween(camPower, {zoom: 0.96}, 1, { ease: FlxEase.sineInOut});

    	new FlxTimer().start(0.5, function(tmr:FlxTimer) {

    		FlxG.switchState(new MainMenuState());
    	});
	}
	else {
	    reloadStrum();

	    FlxTween.tween(camPower, {"scroll.y": 0}, 1.5, {ease: FlxEase.expoInOut, onComplete: function() {
			for (item in members)
				item.kill();

			close();
		}});
	}
}

function reloadStrum() {
    var skin = "";
    var powerNotes = ["note", "fire_notes", "ice_notes", "metal_note", "poison_note", "note"][FlxG.save.data.curPowerUp];

    if (PlayState.instance.curStage == "cataclysmic") {
        skin = "cataclysmic/";
		powerNotes = "mx_" + powerNotes;
	}

	var animArray = ["left", "down", "up", "right"];
    for (i in state.playerStrums.members) {
		if (i.avoid) continue;
		if (i.extra["canChangeTexture"] != null && i.extra["canChangeTexture"] == false) continue;
        var idk = i.animation.name;
		var oldScale = FlxPoint.get(i.scale.x, i.scale.y);
        i.frames = Paths.getFrames("game/notes/" + skin + powerNotes);
        i.animation.addByPrefix('green', 'arrowUP');
        i.animation.addByPrefix('blue', 'arrowDOWN');
        i.animation.addByPrefix('purple', 'arrowLEFT');
        i.animation.addByPrefix('red', 'arrowRIGHT');

    	var strumScale = i.strumLine.strumScale;
    	i.setGraphicSize(Std.int((150 * Flags.DEFAULT_NOTE_SCALE) * strumScale));

        i.animation.addByPrefix('static', 'arrow' + animArray[i.ID].toUpperCase());
        i.animation.addByPrefix('pressed', animArray[i.ID] + ' press', 24, false);
        i.animation.addByPrefix('confirm', animArray[i.ID] + ' confirm', 24, false);
        i.animation.play("static");

		i.updateHitbox();

        i.animation.play(idk);

		i.centerOffsets();
    }

    for (i in state.playerStrums.notes.members) {
		if (i.avoid) continue;
		if (i.extra["canChangeTexture"] != null && i.extra["canChangeTexture"] == false) continue;
		var oldScale = FlxPoint.get(i.scale.x, i.scale.y);
        var idk = i.animation.name;
        i.frames = Paths.getSparrowAtlas("game/notes/" + skin + powerNotes);

        i.animation.addByPrefix(idk, switch(idk) {
            case 'scroll': ['purple', 'blue', 'green', 'red'][i.strumID % 4] + '0';
            case 'hold': ['purple hold piece', 'blue hold piece', 'green hold piece', 'red hold piece'][i.strumID % 4] + "0";
            case 'holdend': ['pruple end hold', 'blue hold end', 'green hold end', 'red hold end'][i.strumID % 4] + '0';
        });

        i.animation.play(idk);
		i.scale.set(oldScale.x, oldScale.y);
        i.updateHitbox();
    }
}
