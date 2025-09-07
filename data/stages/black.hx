import funkin.backend.utils.AudioAnalyzer;
import flixel.group.FlxSpriteGroup;

var abotViz:FlxSpriteGroup;
var analyzer:AudioAnalyzer;
var analyzerLevelsCache:Array<Float>;
var analyzerTimeCache:Float;
var barCount = FlxG.width / 32;

function postCreate(){
    camGame.scroll.set(-225, 150);
	FlxG.camera.followLerp = 0;
    importScript("data/scripts/hud/HudDemo");
    boyfriend.visible = false;
}

function insertCam(NewCamera, Position, DefaultDrawTarget) {
    final childIndex = FlxG.game.getChildIndex(FlxG.cameras.list[Position].flashSprite);
	FlxG.game.addChildAt(NewCamera.flashSprite, childIndex);

	FlxG.cameras.list.insert(Position, NewCamera);
	if (DefaultDrawTarget)
		FlxG.cameras.defaults.push(NewCamera);

	for (i in Position...FlxG.cameras.list.length)
		FlxG.cameras.list[i].ID = i;

    FlxG.cameras.defaults = FlxG.cameras.defaults;
    FlxG.cameras.list = FlxG.cameras.list;

	FlxG.cameras.cameraAdded.dispatch(NewCamera);

    return NewCamera;
}

function create() {
    camVis = new FlxCamera();
    insertCam(camVis, 0, false);
    FlxG.camera.bgColor = 0x00FFFFFF;

    grpBars = new FlxSpriteGroup();
    grpBars.camera = camVis;
	insert(0, grpBars);

    var barSize = (1 / barCount) * FlxG.width;
    for (i in 0...barCount)
	{
		var spr = new FunkinSprite(Std.int(Std.int(barSize) * i), 0).makeGraphic(Std.int(barSize), FlxG.height, 0x27ff0000);
        spr.scrollFactor.set();
        spr.scale.y = 0;
		grpBars.add(spr);
	}
}

function onStartSong()
{
    analyzer = new AudioAnalyzer(FlxG.sound.music, 256);
}

function min(x, y)
{
    return x > y ? y : x;
}

function update(elapsed) {
    if (analyzer != null && FlxG.sound.music.playing) {
		var time = FlxG.sound.music.time;
		if (analyzerTimeCache != time)
			analyzerLevelsCache = analyzer.getLevels(analyzerTimeCache = time, FlxG.sound.volume == 0 || FlxG.sound.muted ? 0 : 1, barCount, analyzerLevelsCache, CoolUtil.getFPSRatio(0.4), -65, -10, 500, 20000);
	}
	else {
		if (analyzerLevelsCache == null) analyzerLevelsCache = [];
        if (analyzerLevelsCache.length != barCount) analyzerLevelsCache.resize(barCount);
		for (i in 0...analyzerLevelsCache.length) if (analyzerLevelsCache[i] != 0) analyzerLevelsCache[i] = 0;
	}

    for (i in 0...min(grpBars.members.length, analyzerLevelsCache.length)) {
        grpBars.members[i].scale.y = lerp(grpBars.members[i].scale.y, analyzerLevelsCache[i], 0.5);
        grpBars.members[i].updateHitbox();
        grpBars.members[i].y = FlxG.height - grpBars.members[i].height;
    }
}

function destroy() {
    camVis.destroy();
}