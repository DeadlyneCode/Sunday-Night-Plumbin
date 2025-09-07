import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxStringUtil;
import funkin.backend.scripting.events.DrawEvent;
import funkin.backend.utils.AudioAnalyzer;

var songsToPlay = [
//  [OSTVolume, "File Name",                              "Song Display Name",                  "Composer",                                    ShowsDistoBG, Color         ],
    [1,         "../songs/immortal/song/Inst",            "Immortal",                           "Deadlyne & Dislamp",                          false,        FlxColor.WHITE],
    [1,         "../songs/betrayed/song/Inst",            "Betrayed",                           "Legacy",                                      false,        FlxColor.WHITE],
    [1,         "../songs/cataclysmic/song/Inst",         "Cataclysmic",                        "Dislamp & Wariofucker69",                     false,        FlxColor.WHITE],
    [1,         "../songs/cosmic-copy/song/Inst",         "Cosmic Copy",                        "Dislamp",                                     false,        FlxColor.WHITE],
    [1,         "../songs/infernal/song/Inst",            "Infernal",                           "Gnaw",                                        false,        FlxColor.WHITE],
    [1,         "../songs/cracked-egg/song/Inst",         "Cracked Egg",                        "Legacy",                                      false,        FlxColor.WHITE],
    [1,         "../songs/iceberg/song/Inst",             "Iceberg",                            "Deadlyne & Dislamp",                          false,        FlxColor.WHITE],
    [1,         "../songs/silent/song/Inst",              "Silent",                             "Deadlyne & ParadoxPulse",                     false,        FlxColor.WHITE],
    [1,         "../songs/disturbing-presence/song/Inst", "Disturbing Presence",                "ParadoxPulse & Deadlyne",                     true,         FlxColor.WHITE],
    [1,         "../songs/blessing/song/Inst",            "Blessing",                           "Calitsuki",                                   false,        0xFF405EE6  ],
    [1,         "../songs/golden-hammer/song/Inst",       "Golden Hammer",                      "Dislamp",                                     false,        0xFFFFAE00  ],
    [1,         "../songs/fatal rap/song/Inst",           "Fatal Rap",                          "Gnaw & Dislamp",                              false,        0xFFC58843  ],
    [1,         "../songs/heartless/song/Inst",           "Heartless",                          "Deadlyne, Gnaw & Calitsuki",                  false,        0xFFFF0000  ],
    [1,         "../songs/poltergeist/song/Inst",         "Poltergeist",                        "Dislamp, Calitsuki, Deadlyne & Mr Moustache", false,        0xFF8940FF  ],
    [1,         "../songs/earache/song/Inst",             "Earache",                            "Dislamp & Legacy",                            false,        0xFF40FF40  ],
    [1,         "../music/pauseMusic",                    "Pause Music",                        "JustAnto",                                    false,        0xFF1BADEC  ],
    [1,         "../music/distoPauseMusic",               "Pause Music\n(Disturbing Presence)", "JustAnto",                                    true,         FlxColor.WHITE],
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

var songName;
var musicianText;
var bg:FlxBackdrop;
var distoBG:FlxBackdrop;
function create() {
    distoBG = new FlxBackdrop(Paths.image("states/loading/grid-evil"), FlxAxes.XY);
    distoBG.rotation = -4.3;
    distoBG.velocity.set(25, 0);
    distoBG.antialiasing = true;
    add(distoBG);

    bg = new FlxBackdrop(Paths.image("states/loading/grid"), FlxAxes.XY);
    bg.rotation = -4.3;
    bg.velocity.set(25, 0);
    bg.antialiasing = true;
    add(bg);

    grpBars = new FlxSpriteGroup();
	add(grpBars);

    var spike = new FlxBackdrop(Paths.image("states/loading/spike"), FlxAxes.X);
    spike.x -= 10;
    spike.antialiasing = true;
    add(spike);

    var spikeBG = new FunkinSprite(0, FlxG.height + spike.height).makeSolid(FlxG.width, 90, 0xFFFFFFFF);
    add(spikeBG);

    spike.y = FlxG.height - spikeBG.height;
    spikeBG.y = spike.y + spike.height;

    var skewShader = new CustomShader("skew");
    
    skewShader.data.vertexXOffset.value = [0, 0, -5, -5];
    skewShader.data.vertexYOffset.value = [0, -100, 0, -100];

    var barSize = Std.int((1 / barCount) * FlxG.width);
    for (i in 0...barCount)
	{
		var spr = new FlxSprite(barSize * i, 0).makeGraphic(barSize, FlxG.height - 90, 0xA20D121D);
		grpBars.add(spr);
	}

    songName = new FlxText(100, 270, FlxG.width, "");
    songName.setFormat(Paths.font("WonderBold.ttf"), 98 * 0.9, FlxColor.WHITE, "left", "outline", FlxColor.BLACK);
    add(songName);
    songName.antialiasing = true;
    songName.shader = skewShader;

    durationText = new FlxText(songName.x, songName.y + songName.height, FlxG.width, "");
    durationText.setFormat(Paths.font("Wonder.ttf"), 48, FlxColor.WHITE, "left", "outline", FlxColor.BLACK);
    add(durationText);
    durationText.antialiasing = true;
    durationText.shader = skewShader;

    musicianText = new FlxText(40, spike.y + 30, FlxG.width, "Sunday Night Plumbin' OST [VOL " + songsToPlay[0][0] + "]");
    musicianText.setFormat(Paths.font("Wonder.ttf"), 28, FlxColor.BLACK, "left", "outline", FlxColor.BLACK);
    add(musicianText);
    musicianText.antialiasing = true;
    upscaleText(musicianText, 2);

    for (textToHide in [songName, durationText])
        textToHide.alpha = 0.001;

    new FlxTimer().start(0.5, () -> {
        playMusic();
    });

}
var durationText = null;
var analyzer:AudioAnalyzer;
var analyzerLevelsCache:Array<Float>;
var analyzerTimeCache:Float;
var barCount = 40;

function update(elapsed:Float) {
    if (controls.BACK) {
		FlxG.sound.play(Paths.sound('cancelMenu'));
		FlxG.switchState(new MainMenuState());
	}
}

function min(x, y)
{
    return x > y ? y : x;
}

var curSong = 0;
function playMusic() {
    var playDaMusic = null;
    playDaMusic = function () {
        var songData = songsToPlay[curSong];
        trace(curSong, songData);
        if (songData == null) return;
        var showsDistoBG = songData[4] ?? false;
        var newColor = songData[5] ?? FlxColor.WHITE;
        if (showsDistoBG)
            FlxTween.tween(bg, {alpha: 0.001}, 1, {ease: FlxEase.quadInOut});
        for (textToShow in [songName, durationText])
            FlxTween.tween(textToShow, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
        FlxTween.color(bg, 1, bg.color, newColor, {ease: FlxEase.quadInOut});
        songName.text = songData[2];
        songName.y = 270;
        if (songName.height > 150)
            songName.y -= songName.height * 0.3;
        durationText.y = songName.y + songName.height;
        musicianText.text = "Sunday Night Plumbin' OST [VOL " + songData[0] + "] - Song by " + songData[3];
        new FlxTimer().start(0.5, () -> {
            FlxG.sound.playMusic(Paths.music(songData[1]));
            FlxG.sound.music.looped = false;
            analyzer = new AudioAnalyzer(FlxG.sound.music, 1024);

            new FlxTimer().start(FlxG.sound.music.length / 1000, (t) -> {
                for (textToHide in [songName, durationText])
                    FlxTween.tween(textToHide, {alpha: 0.001}, 0.5, {ease: FlxEase.quadInOut});
                FlxTween.tween(bg, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
                new FlxTimer().start(0.5, () -> {
                    curSong ++;
                    playDaMusic(); 
                });
            });
        });
    }
    playDaMusic();
}

function update(elapsed) {
    if (controls.BACK)
        FlxG.switchState(new MainMenuState());
    
    durationText.text = FlxStringUtil.formatTime(FlxG.sound.music.time/1000, false) + " / " + FlxStringUtil.formatTime(FlxG.sound.music.length/1000, false);

    if (analyzer != null && FlxG.sound.music.playing) {
		var time = FlxG.sound.music.time;
		if (analyzerTimeCache != time)
			analyzerLevelsCache = analyzer.getLevels(analyzerTimeCache = time, FlxG.sound.volume == 0 || FlxG.sound.muted ? 0 : 1, barCount, analyzerLevelsCache, CoolUtil.getFPSRatio(0.4), -65, -10, 500, 20000);
	}
	else {
		if (analyzerLevelsCache == null) analyzerLevelsCache = [];
		analyzerLevelsCache.resize(barCount);
		for (i in 0...analyzerLevelsCache.length) analyzerLevelsCache[i] = 0;
	}

    for (i in 0...min(grpBars.members.length, analyzerLevelsCache.length)) {
        grpBars.members[i].scale.y = lerp(grpBars.members[i].scale.y, analyzerLevelsCache[i], 0.3);
        grpBars.members[i].updateHitbox();
        grpBars.members[i].y = (FlxG.height - grpBars.members[i].height) - 90;
    }
}