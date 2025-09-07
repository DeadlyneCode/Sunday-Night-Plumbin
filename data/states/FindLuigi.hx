import flixel.math.FlxPoint;
import funkin.editors.EditorPicker;
import funkin.backend.utils.WindowUtils;

var realPos:FlxPoint;
function create()
{
	var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	add(bg);
	bg.alpha = 0.75;
	realPos = FlxPoint.get();
	FlxG.sound.playMusic(Paths.music("findluigi"));
	window.title = "Find Luigi";

	var madeLuigi = false;
	for (i in 0...300)
	{
		if (madeLuigi)
		{
			var charName = ["mario", "wario", "yoshi"][FlxG.random.int(0, 2)];
			var mario = createCharacter(charName);
			makeCharacterLogic(mario);
			add(mario);
		}
		else
		{
			var luigi = createCharacter("luigi");
			add(luigi);
			makeCharacterLogic(luigi);
			madeLuigi = true;
		}
	}

	var text = new FlxText(0, 0, FlxG.width, "", 64);
	text.setFormat(Paths.font("DS.ttf"), 64, FlxColor.WHITE, "center");
	add(text);
	var timerLength = 15;
	text.text = timerLength;
	timer = new FlxTimer().start(1, function(t) {
		if (t.loopsLeft <= 5)
			text.color = FlxColor.RED;
		text.text = t.loopsLeft;
		if (t.loopsLeft == 0)
		{
			new FlxTimer().start(1, () -> {
				for (char in findLuigiChars) {
					if (char != findLuigiChars[0])
						char.kill();
				}
				onLuigiEnd(false);
			} );
			return;
		}
	}, timerLength);
}

var timer = null;

function onLuigiEnd(success:Bool) {
	timer.cancel();
	foundLuigi = true;
	FlxG.sound.music.stop();
	if (success) {
		FlxG.sound.play(Paths.sound("foundluigi"), 1);
	}
	new FlxTimer().start(1, function(_) {
		CoolUtil.playMusic(Paths.music(menuMusic), true, 0, true);
		FlxG.sound.music.persist = true;
		FlxTween.tween(FlxG.sound.music, {volume: 1}, 1.0, {ease: FlxEase.quadInOut});
		WindowUtils.updateTitle();
		if (success) {
			FlxG.save.data.wonLuigi = true;
			FlxG.save.flush();
			FlxG.state.openSubState(new EditorPicker());
		} else
			close();
	});
}

var findLuigiChars = [];
function makeCharacterLogic(char:FlxSprite) {
	char.extra["moveX"] = FlxG.random.int(char.width / 2, char.width) * (FlxG.random.bool() ? -1 : 1);
	char.extra["moveY"] = FlxG.random.int(char.height / 2, char.height) * (FlxG.random.bool() ? -1 : 1);
	char.extra["multSpeed"] = FlxG.random.float(2, 3);

	char.x = FlxG.random.int(0, FlxG.width - char.width);
	char.y = FlxG.random.int(0, FlxG.height - char.height);
	findLuigiChars.push(char);
}

var foundLuigi = false;
function update() {
	if(FlxG.mouse.justMoved)
	{
		FlxG.mouse.getPosition(realPos);
	   
		if (FlxG.save.data.tv) //Survol correct avec le shader
		{
			realPos.x /= FlxG.width;
			realPos.y /= FlxG.height;
			realPos.x = (realPos.x - 0.5) * 2.0;
			realPos.y = (realPos.y - 0.5) * 2.0;
			realPos.x *= 1.1;	
			realPos.y *= 1.1;	
			realPos.x *= 1.0 + Math.pow((Math.abs(realPos.y) / 5.0), 2.0);
			realPos.y *= 1.0 + Math.pow((Math.abs(realPos.x) / 4.0), 2.0);
			realPos.x = (realPos.x / 2.0) + 0.5;
			realPos.y = (realPos.y / 2.0) + 0.5;
			realPos.x = realPos.x *0.95 + 0.0275;
			realPos.y = realPos.y *0.95 + 0.0275;
			realPos.x *= FlxG.width;
			realPos.y *= FlxG.height;
		}
	}
	if (!foundLuigi) {
		if (FlxG.mouse.justPressed && findLuigiChars[0].overlapsPoint(realPos, true, FlxG.camera)) {
			for (char in findLuigiChars) {
				if (char != findLuigiChars[0])
					char.kill();
			}
			onLuigiEnd(true);
		}

		for (char in findLuigiChars) {
			var moveX = char.extra["moveX"];
			var moveY = char.extra["moveY"];
			var multSpeed = char.extra["multSpeed"];
			char.x += moveX * (FlxG.elapsed * multSpeed);
			char.y += moveY * (FlxG.elapsed * multSpeed);
	
			if (char.x <= 0)
				char.extra["moveX"] *= -1;
			if (char.x >= (FlxG.width - char.width))
				char.extra["moveX"] *= -1;
			if (char.y <= 0)
				char.extra["moveY"] *= -1;
			if (char.y >= (FlxG.height - char.height))
				char.extra["moveY"] *= -1;
		}
	}
}

function createCharacter(charName:String) {
	var char = new FunkinSprite();
	char.frames = Paths.getSparrowAtlas("findluigi");
	char.animation.addByPrefix(charName, charName, 1, false);
	char.animation.play(charName);
	char.scale.set(1.5, 1.5);
	char.updateHitbox();
	return char;
}