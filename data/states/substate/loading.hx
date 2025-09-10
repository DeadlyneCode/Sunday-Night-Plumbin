import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxAngle;
import flixel.math.FlxRect;
import funkin.backend.MusicBeatState;

var tips = 
    ["immortal" => [getString("immortal_intro")],
    "betrayed" => [getString("betrayed_intro"), getString("betrayed_intro2")],
    "cataclysmic" => [getString("cataclyscmic_intro"), getString("cataclyscmic_intro2"), getString("cataclyscmic_intro3")],
    "cosmic-copy" => [getString("cosmic_copy_intro"), getString("cosmic_copy_intro2")],
    "infernal" => [getString("infernal_intro"), getString("infernal_intro2"), getString("infernal_intro3")],
    "iceberg" => [getString("iceberg_intro"), getString("iceberg_intro2")],
    "disturbing-presence" => [getString("disturbing_presence_intro"), getString("disturbing_presence_intro2"), getString("disturbing_presence_intro3"), getString("disturbing_presence_intro4")],
    "cracked-egg" => [getString("cracked_egg_intro"), getString("cracked_egg_intro2")],
    "blessing" => [getString("blessing_intro")],
    "golden-hammer" => [getString("golden_hammer_intro")],
    "fatal rap" => [getString("fatal_rap_intro")],
    "earache" => [getString("earache_intro"), getString("earache_intro2")],
    "heartless" => [getString("heartless_intro"), getString("heartless_intro2")],
    "silent" => [getString("silent_intro"), getString("silent_intro2"), getString("silent_intro3")],
    "poltergeist" => [getString("poltergeist_intro"), getString("poltergeist_intro2"), getString("poltergeist_intro3")]
];

function getColorData(color)
{
    var data = {};

    data.color = color;

    data.red = (color >> 16) & 0xff;
    data.green = (color >> 8) & 0xff;
    data.blue = color & 0xff;
    data.alpha = (color >> 24) & 0xff;

    data.redFloat = data.red / 255;
    data.greenFloat = data.green / 255;
    data.blueFloat = data.blue / 255;
    data.alphaFloat = data.alpha / 255;
    return data;
}

var followText = null;
var songName;
function create()
{
	camera = new FlxCamera();
	camera.bgColor =  FlxColor.fromRGBFloat(0, 0, 0, 0);
	FlxG.cameras.add(camera, false);

    var chart = PlayState.SONG;

    var closeToPoint = data.closeToPoint;
    var currentMusic = data.currentMusic;
    followText = data.followText;

	var a = new CustomShader("circle");
	a.data.uResolution.value = [FlxG.width, FlxG.height];
	a.data.uCenter.value = [closeToPoint.x, closeToPoint.y];
	a.uRadius = FlxG.width;

    camera.addShader(a);

    var bg = new FlxBackdrop(Paths.image("states/loading/grid" + (chart.meta.name == "Disturbing-presence" ? "-evil" : "")), FlxAxes.XY);
    bg.rotation = -4.3;
    bg.velocity.set(25, 0);
    bg.antialiasing = true;
    add(bg);

    bg.color = switch (chart.meta.name)
    {
        case "Blessing":
            FlxColor.CYAN;
        case "Golden-Hammer":
            0xFFFFAE00;
        case "Fatal rap":
            0xFFC58843;
        case "Heartless":
            var col1 = getColorData(0xFFFF0000);
            var col2 = getColorData(0xFF1A1F28);
            FlxColor.fromRGBFloat(col1.redFloat / col2.redFloat, col1.greenFloat / col2.greenFloat, col1.blueFloat / col2.blueFloat);
        case "Poltergeist":
            0xFF9A5BFF;
        case "Earache":
            0xFF40FF40;
        default:
            FlxColor.WHITE;
    }

    FlxTween.tween(a, {uRadius: 150}, 1, {ease: FlxEase.sineOut});
    new FlxTimer().start(1, () ->  {
        FlxTween.cancelTweensOf(a);
        FlxTween.tween(a, {uRadius: 0}, 1.5, {ease: FlxEase.backInOut});
    });

    var skewShader = new CustomShader("skew");
    
    skewShader.data.vertexXOffset.value = [0, 0, -5, -5];
    skewShader.data.vertexYOffset.value = [0, -100, 0, -100];

    songName = new FlxText(100, 270, FlxG.width, followText.text);
    songName.setFormat(Paths.font("WonderBold.ttf"), 98, FlxColor.WHITE, "left", "outline", FlxColor.BLACK);
    songName.antialiasing = true;
    add(songName);
    songName.antialiasing = true;
    songName.shader = skewShader;
    songName.clipRect = new FlxRect(-songName.width, 0, songName.width, songName.height);
    if (songName.height > 150)
        songName.y -= songName.height * 0.3;

    updateRPC("Preparing Song", (showCodenames ? chart?.meta?.customValues?.codename ?? chart.meta.displayName : chart.meta.displayName));

    var composerText = new FlxText(songName.x, songName.y + songName.height, FlxG.width, PlayState.SONG.meta.pause.composer);
    composerText.setFormat(Paths.font("Wonder.ttf"), 48, FlxColor.WHITE, "left", "outline", FlxColor.BLACK);
    add(composerText);
    composerText.antialiasing = true;
    composerText.shader = skewShader;
    composerText.clipRect = new FlxRect(-composerText.width, 0, composerText.width, composerText.height);

    var spike = new FlxBackdrop(Paths.image("states/loading/spike"), FlxAxes.X);
    spike.x -= 10;
    spike.y = FlxG.height;
    spike.antialiasing = true;
    add(spike);

    var spikeBG = new FunkinSprite(0, FlxG.height + spike.height).makeSolid(FlxG.width, 90, 0xFFFFFFFF);
    spikeBG.camera = camera;
    spikeBG.antialiasing = true;
    add(spikeBG);

    var allTips = tips.get(PlayState.SONG.meta.name.toLowerCase());
    var randomTip = allTips[FlxG.random.int(0, allTips.length - 1)];

    var tipText = new FlxText(40, spike.y + 30, FlxG.width, randomTip);
    tipText.setFormat(Paths.font("Wonder.ttf"), 28, FlxColor.BLACK, "left", "outline", FlxColor.BLACK);
    add(tipText);
    tipText.antialiasing = true;

    upscaleText(tipText, 2);

    new FlxTimer().start(2.5, () -> {
        var updateClip = function () {
            songName.clipRect = songName.clipRect;
            composerText.clipRect = composerText.clipRect;
        };
        FlxTween.tween(songName.clipRect, {x: 0}, 2, {ease: FlxEase.expoOut});
        FlxTween.tween(composerText.clipRect, {x: 0}, 2, {ease: FlxEase.expoOut, onStart: updateClip, onUpdate: updateClip, onCompete: updateClip});
    });

    new FlxTimer().start(3.2, () -> {
        var yToRemove = spikeBG.height;
        FlxTween.tween(spike, {y: spike.y - yToRemove}, 1, {ease: FlxEase.circOut});
        FlxTween.tween(spikeBG, {y: spikeBG.y - yToRemove}, 1, {ease: FlxEase.circOut});
        FlxTween.tween(tipText, {y: tipText.y - yToRemove}, 1, {ease: FlxEase.circOut});

        new FlxTimer().start(5, () -> {
            MusicBeatState.skipTransOut = true;
            FlxG.camera.visible = false;
	        a.data.uCenter.value = [FlxG.width / 2, FlxG.height / 2];
            FlxTween.cancelTweensOf(currentMusic);
            FlxTween.tween(currentMusic, {volume: 0}, 0.7, {ease: FlxEase.sineOut});
            FlxTween.tween(a, {uRadius: FlxG.width}, 1, {ease: FlxEase.sineOut, onComplete: () -> {
                close();
                FlxG.switchState(new PlayState());
            }});
        });
    });

	FlxG.sound.play(Paths.sound("songStart"), 2);
}

function update(elapsed:Float) {
    if (followText != null && songName != null && songName.text != followText.text)
        songName.text = followText.text;
}

function onClose() {
	FlxG.cameras.remove(camera, true);
}