import flixel.addons.display.FlxBackdrop;
import funkin.backend.MusicBeatGroup;

import openfl.ui.MouseCursor;
import openfl.ui.Mouse;

var isPico:Bool = state.curSong == "heartless";

var camResult:FlxCamera;

var curResult:ResultRating;

var isMouse:Bool = false;
var cursorPos:FlxPoint = FlxPoint.get();
var cursorPrvPos:FlxPoint = FlxPoint.get();

var curSelect:Int = 0;
var canSelect:Bool = true;
var options:Array<String> = ["exit", "retry"];
var perfInfos:Array<String> = ["score", "misses"];

var rankMusic:FlxSound;

var colorBg:FunkinSprite;

var player:FunkinSprite;

var rankTxt:FunkinText;

var resultBoard:MusicBeatGroup;
var perfTxts:Array<Array<FlxBasic>> = [];
var buttons:Array<FlxBasic> = [];

function create()  {
	camResult = new FlxCamera();
	FlxG.cameras.add(camResult, false);

	var resultRatings:Array<ResultRating> = [
		new ResultRating(0, "fall", 0, "bad", 4961.5),
		new ResultRating(0.5, "bottom", 48, "meh"),
		new ResultRating(0.8, "middle", 250, "good"),
		new ResultRating(0.9, "onTop", 1800, "super", 4646),
	];

	curResult = resultRatings[0];

	for (e in resultRatings) {
		if (e.percent <= PlayState.instance.accuracy)
			curResult = e;
	}

	if (curResult.music != null) {
		rankMusic = FlxG.sound.load(Paths.music('result/' + curResult.music));
		rankMusic.looped = true;
    
		if (curResult.loopTime != null)
			rankMusic.loopTime = curResult.loopTime;
	}

	colorBg = new FunkinSprite();
	colorBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
	colorBg.scrollFactor.set();
	colorBg.camera = camResult;
	add(colorBg);

	flou = new CustomShader('flouv2');
	flou.Size = 3;

	var motif = new FlxBackdrop();
	motif.loadGraphic(Paths.image("states/score/motif"));
	motif.setGraphicSize(motif.width * 0.7);
	motif.updateHitbox();
	motif.velocity.x = 25;
	motif.velocity.y = 10;
	motif.alpha = 0.2;
	motif.blend = 0;
	motif.shader = flou;
	motif.antialiasing = true;
	motif.camera = camResult;
	add(motif);

	resultBoard = new MusicBeatGroup();
	resultBoard.camera = camResult;
	add(resultBoard);

	var black:FunkinSprite = new FunkinSprite();
	black.loadSprite(Paths.image("states/score/base"));
	black.antialiasing = true;
	resultBoard.add(black);

	var bottom:FunkinSprite = new FunkinSprite();
	bottom.loadSprite(Paths.image("states/score/bottom"));
	bottom.x = black.x - 8;
	bottom.y = black.y + black.height + 8;
	bottom.antialiasing = true;
	resultBoard.add(bottom);

	var titleBar:FunkinSprite = new FunkinSprite();
	titleBar.loadSprite(Paths.image("states/score/bar"));
	titleBar.x = black.x;
	titleBar.y = black.y;
	titleBar.antialiasing = true;
	resultBoard.add(titleBar);

	var titleTxt:FunkinText = new FunkinText();
	titleTxt.setFormat(Paths.font("U.ttf"), 70, 0xFF282828, "left");
	titleTxt.fieldWidth = titleBar.width;
	titleTxt.text = getString("results_title");
	titleTxt.x = titleBar.x + 32;
	titleTxt.y = titleBar.y + (titleBar.height - titleTxt.height) / 2 - 8;
	titleTxt.antialiasing = true;
	resultBoard.add(titleTxt);

	var icon:FunkinSprite = new FunkinSprite();
	icon.loadSprite(Paths.image("states/score/icons/" + (isPico ? "pico" : "bf")));
	icon.setGraphicSize(icon.width * 0.65);
	icon.updateHitbox();
	icon.x = black.x + black.width - (icon.width + 28);
	icon.y = black.y + 32;
	icon.antialiasing = true;
	resultBoard.add(icon);

	var rankBg:FunkinSprite = new FunkinSprite();
	rankBg.loadSprite(Paths.image("states/score/rank"));
	rankBg.x = black.x + black.width - (icon.width + 20);
	rankBg.y = black.y + black.height - (rankBg.height + 75);
	rankBg.antialiasing = true;
	resultBoard.add(rankBg);

	var rank = PlayState.instance.curRating.rating;
	if (PlayState.instance.score < 0 || rank == "[N/A]")
		rank = "F";
	if (rank == "S++" || rank == "S+")
		rank = "S";

	rankTxt = new FunkinText();
	rankTxt.setFormat(Paths.font("U.ttf"), 108, 0xFF282828, "center");
	rankTxt.text = rank;
	rankTxt.x = rankBg.x + (rankBg.width - rankTxt.width) / 2;
	rankTxt.y = rankBg.y + (rankBg.height - rankTxt.height) / 2 - 6;
	rankTxt.antialiasing = true;
	resultBoard.add(rankTxt);

	for (p=>perfInfo in perfInfos) {
		var perfBg:FunkinSprite = new FunkinSprite();
		perfBg.loadSprite(Paths.image("states/score/bar"));
		perfBg.setGraphicSize(perfBg.width * 0.9, perfBg.height * 0.75);
		perfBg.updateHitbox();
		perfBg.x = titleBar.x - (8 * p);
		perfBg.y = titleBar.y + titleBar.height + 32 + (perfBg.height + 25) * p;

		var perfTxt = new FunkinText();
		perfTxt.setFormat(Paths.font("U.ttf"), 48, 0xFF282828, "left");
		perfTxt.text = applyFiller(getString("results_" + perfInfo), ["0"]);
		perfTxt.fieldWidth = perfBg.width;
		perfTxt.x = perfBg.x + 32;
		perfTxt.y = perfBg.y + (perfBg.height - perfTxt.height) / 2 - 6;

		for (spr in [perfBg, perfTxt]) {
			spr.antialiasing = true;
			resultBoard.add(spr);
		}

		perfTxts.push([perfBg, perfTxt]);
	}

	for (o=>option in options) {
		var button:FunkinSprite = new FunkinSprite();
		button.loadSprite(Paths.image("states/score/button"));
		button.y = bottom.y + (bottom.height -  button.height) / 2;

		// I love wacky math /s
        var intendSpace = (bottom.width - button.width * options.length) / (options.length + 1);
        button.x = bottom.x + intendSpace + (o * (button.width + intendSpace));

		var text:FunkinText = new FunkinText(button.x, button.y, button.width);
		text.setFormat(Paths.font("U.ttf"), 48, 0xFF282828, "center");
		text.text = getString("results_" + option);
		text.updateHitbox();
		text.y = button.y + ((button.height - text.height) / 2) - 5;
		
		for (spr in [button, text]) {
			spr.antialiasing = true;
			spr.ID = o;
			resultBoard.add(spr);
		}

		buttons.push([button, text]);
	}

	resultBoard.x = FlxG.width - (resultBoard.width + 25);
	resultBoard.screenCenter(FlxAxes.Y);

	var flagPole:FunkinSprite = new FunkinSprite();
	flagPole.loadSprite(Paths.image("states/score/flagpole"));
	flagPole.scale.set(0.65, 0.65);
	flagPole.updateHitbox();
	flagPole.x = (resultBoard.x - flagPole.width) / 2;
	flagPole.y = FlxG.height - (flagPole.height + 8);
	flagPole.antialiasing = true;
	flagPole.camera = camResult;
	add(flagPole);

	var flag:FunkinSprite = new FunkinSprite();
	flag.loadSprite(Paths.image("states/score/flag"));
	flag.addAnim("flag", "flag", 24, true);
	flag.playAnim("flag");
	flag.setGraphicSize(flag.width * 0.6);
	flag.updateHitbox();
	flag.x = flagPole.x + 32;
	flag.y = flagPole.y + flagPole.height - (flag.height + 75);
	flag.antialiasing = true;
	flag.camera = camResult;
	insert(members.indexOf(flagPole)-1, flag);

	FlxTween.tween(flag, {y: FlxMath.bound(flag.y - curResult.flagY, flagPole.y + 24, flag.y)}, 0.7, {ease: FlxEase.quartOut});

	player = new FunkinSprite();
	player.loadSprite(Paths.image('states/score/characters/' + (isPico ? "pico" : "bf")));
	player.scale.set(0.6, 0.6);
	player.antialiasing = true;
	player.camera = camResult;
	insert(members.indexOf(flagPole) + (isPico ? -2 : 1), player);

	if (!isPico) {
		player.setPosition(flagPole.x - 390, flagPole.y + 250);
		player.addAnim('onTop', 'anim/s', 24, false);
		player.addAnim('middle', 'anim/b', 24, false);
		player.addAnim('bottom', 'anim/c', 24, false);
		player.addAnim('fall',	'anim/d', 24, false);

		player.addOffset("middle", 400, 400);
		player.addOffset("bottom", 4, -50);
		player.addOffset("fall", 0, -150);
	}
	else {
		player.setPosition(flagPole.x + 50, flagPole.y + 425);
		player.flipX = true;
		
		player.addAnim('pico',	'start', 24, false);
		player.addAnim('pico-loop', 'loop', 24, true);

		player.playAnim("pico");
	}

	FlxG.mouse.getScreenPosition(camResult, cursorPrvPos);

	startIntro();
}

function startIntro() {
	updateColor();

	rankTxt.alpha = 0;

	for (e in perfTxts) for (f in e)
		f.alpha = 0;

	var t:Int = 0;

	if (!isPico)
		player.alpha = 0;

	var showRank:Void->Void = () ->  {
		
		rankTxt.scale.set(1.2, 1.2);
		FlxTween.tween(rankTxt.scale, {x: 1.0, y: 1.0}, 0.15, {ease: FlxEase.quintOut,
			onStart: () -> rankTxt.alpha = 1,
			onComplete: () -> {
				FlxG.sound.play(Paths.sound("result/score" + (t-1)));

				if (!isPico) {
					player.alpha = 1;
					player.playAnim(curResult.animation);
				}

				new FlxTimer().start(0.005, ()->{
					rankMusic.play();
				});
			}
		});
	}

	var tweenResults:Void->Void;
	tweenResults = () -> {
		var dumbFrame:Float = 0;

		var intendedValue:Int = [PlayState.instance.songScore, PlayState.instance.misses][t];
		var intendedTime:Float = FlxMath.bound((intendedValue / 10000) * 2, 0.01, 4);

		FlxTween.num(0, intendedValue, intendedTime, {ease:FlxEase.sineInOut,
			onStart: () -> for (e in perfTxts[t]) e.alpha = 1,
			onUpdate: (tween) -> {
				dumbFrame += FlxG.elapsed * 50;

				if (dumbFrame > 4) {
					FlxG.sound.play(Paths.sound("result/scoreTween"));
					dumbFrame = 0;
				}
			},
			onComplete: () -> {
				FlxG.sound.play(Paths.sound("result/score" + (t+1)));

				for (p=>perfTxt in perfTxts[t]) {
					var perfScale:Array<Float> = [perfTxt.scale.x, perfTxt.scale.y];

					perfTxt.scale.set(perfScale[0] * 1.075, perfScale[1] * 1.075);
					FlxTween.tween(perfTxt.scale, {x: perfScale[0], y: perfScale[1]}, 0.75, {ease: FlxEase.quintOut, onComplete: () -> {
						if (p == 1) {
							t++;

							if (t < perfTxts.length)
								tweenResults();
							else
								showRank();
						}
					}
				});
			}
		}},
			(val:Float) -> {
				perfTxts[t][1].text = applyFiller(getString("results_" + perfInfos[t]), [Math.fround(val)]);
		});
	};

	tweenResults();
}

function update(elapsed:Float) {
	FlxG.mouse.getScreenPosition(camResult, cursorPos);

	if (canSelect) {
		if (cursorPos.x != cursorPrvPos.x || cursorPos.y != cursorPrvPos.y)
            scrollMouse();

        if (controls.LEFT_P || controls.RIGHT_P)
			changeSelect((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0));

		if (controls.ACCEPT && !isMouse)
            confirmSelect();

		if (FlxG.mouse.justPressed && isMouseOverlapSometing())
			confirmSelect();
	}

    Mouse.cursor = isMouseOverlapSometing() ? MouseCursor.BUTTON : MouseCursor.ARROW;


	updateCovers();
}

function scrollMouse() {
    isMouse = true;

    cursorPrvPos.set(cursorPos.x, cursorPos.y);
}

function changeSelect(select:Int = 0, force:Bool = false) {
	var nextSelect:Int = FlxMath.wrap(curSelect + select, 0, options.length-1);

	if (!force) {
		if (select == 0)
			return;

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
    
	if (!isMouse)
		curSelect = nextSelect;
    
	isMouse = false;
}

function updateCovers():Void {
	for (button in buttons) {
		var spr = button[0];
		var text = button[1];

		var intendedScale:Float = 1.0;
		var intendedAlpha:Float = 0.75;

		var overlapFix:Bool = 

		var isSelect:Bool = !isMouse && (spr.ID == curSelect);
        var isOverlap:Bool = isMouse && mouseOverlapFix(spr);

		if ((isSelect || isOverlap) && canSelect) {
			intendedScale = 1.075;
			intendedAlpha = 1.0;
		}

		if (isOverlap)
			curSelect = spr.ID;

		spr.alpha = lerp(spr.alpha, intendedAlpha, 12 / 60);
		spr.scale.x = spr.scale.y = lerp(spr.scale.x, intendedScale, 12 / 60);

		text.alpha = spr.alpha;
		text.scale.x = text.scale.y = spr.scale.x;
    }
}

function updateColor() {
	var fadeColor = FlxColor.fromString(PlayState.SONG.meta.end.fadeColor);

	var colors:Array<Int> = [
		FlxColor.fromString(PlayState.SONG.meta.end.startColor),
		FlxColor.fromString(PlayState.SONG.meta.end.midColor),
		FlxColor.fromString(PlayState.SONG.meta.end.endColor)
	];

	colorBg.color = fadeColor;

	var colorIndex:Int = 0;

	var fadeToNextColor;
	fadeToNextColor = () -> {
		colorIndex = (colorIndex+1) % colors.length;
		var nextColor = colors[colorIndex];

		FlxTween.color(colorBg, 2, colorBg.color, nextColor, {
			type: FlxTween.ONESHOT,
			onComplete: fadeToNextColor
		});
	};

	fadeToNextColor();
}

// Fix the stupid ass overlap issue due to the custom camera
function mouseOverlapFix(object:FlxBasic)
	return (object.x + object.width > cursorPos.x) && (object.x < cursorPos.x) && (object.y + object.height > cursorPos.y) && (object.y < cursorPos.y);

// Check if at least one button is overlap
function isMouseOverlapSometing() {
	if (!isMouse)
		return false;

	for (button in buttons)
		if (mouseOverlapFix(button[0]))
			return true;

	return false;
}

function confirmSelect() {
	canSelect = false;

	if (rankMusic != null)
		rankMusic.stop();

	FlxG.sound.play(Paths.sound('confirmMenu'));

	FlxG.cameras.remove(camResult, true);

	new FlxTimer().start(1.1, ()-> { switch (options[curSelect]) {
		case "exit":
			if (state.curSong == "poltergeist" && !FlxG.save.data.hasFinishedPolter) {
				FlxTween.tween(FlxG.sound.music, {volume: 0}, 1.0, {ease: FlxEase.quadInOut});
				FlxG.camera.fade(FlxColor.BLACK, 1.2, false, ()->{
					PlayState.instance.endSong();
					FlxG.switchState(new ModState('thanksToPlay'));
				});
			}
			else
				PlayState.instance.endSong();

		case "retry":
			PlayState.instance.endSong();
			FlxG.resetState();
	}});
}

class ResultRating {
	var percent:Float;
	var animation:String;
	var music:String;
	var loopTime:Float;
	var flagY:Float;

	public function new(?percent:Float, ?animation:String, ?flagY:Float, ?music:String, ?loopTime:Float) {
		this.percent = percent;
		this.animation = animation;
		this.flagY = flagY;
		this.music = music;
		this.loopTime = loopTime;
	}
}