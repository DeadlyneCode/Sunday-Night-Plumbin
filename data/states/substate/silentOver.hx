import funkin.backend.MusicBeatState;

var canSelect:Bool = false;

var camCrash:FlxCamera;

var adrSectors:Array<Array<String>> = [
    ["PC", "AT", "A0", "A3", "T2", "T5", "S0", "S3", "S6", "T9", "S8"],
    ["SR", "V0", "A1", "T0", "T3", "T6", "S1", "S4", "S7", "GP", "RA"],
    ["VA", "V1", "A2", "T1", "T4", "T7", "S2", "S5", "T8", "SP", "MM"]
];

var crashBG:FunkinSprite;

var titleThread:FunkinText;
var fpscrTxt:FunkinText;

function create() {
    camCrash = new FlxCamera();
    camCrash.bgColor = 0x00000000;
	FlxG.cameras.add(camCrash, false);

    var padding:Float = 25;

    crashBG = new FunkinSprite();
    crashBG.makeGraphic(960 - (2 * padding), 720 - (2 * padding), 0xFF000000);
    crashBG.screenCenter();
    crashBG.camera = camCrash;
    add(crashBG);

    titleThread = new FunkinText();
    titleThread.text = "THREAD: 4" + "  " + fakeErrorName();
    formatText(titleThread);
    titleThread.x = crashBG.x + 16;
    titleThread.y = crashBG.y + 16;
    add(titleThread);

    var sectorsTxts:Array<Array<FunkinText>> = [];

    for (st=>sectors in adrSectors) {
        var padWidth:Float = crashBG.width - (titleThread.x - crashBG.x) * 2;
        var intendedPos = padWidth / 3 * st;

        var sectorTxts:Array<FunkinText> = [];
        sectorsTxts.push(sectorTxts);

        for (s=>sector in sectors) {
            var sectorTxt:FunkinText = new FunkinText();
            sectorTxt.text = sector + ":" + fakeSectorDump();
            formatText(sectorTxt);
            sectorTxt.x = titleThread.x + intendedPos;
            add(sectorTxt);

            sectorTxts.push(sectorTxt);

            if (s == 0)
                sectorTxt.y = titleThread.y + titleThread.height + 4;
            else {
                var prvSectorTxt:FunkinText = sectorTxts[s-1];

                if (s == 1)
                    sectorTxt.y = prvSectorTxt.y + prvSectorTxt.height + 8;
                else
                    sectorTxt.y = prvSectorTxt.y + prvSectorTxt.height;
            }
        }
    }

    var lastSector:FunkinText = sectorsTxts[0][sectorsTxts[0].length-1];

    fpscrTxt = new FunkinText();
    fpscrTxt.text = "FPSCR:" + fakeSectorDump() + "  " + "(NULL OBJECT REFERENCE)";
    formatText(fpscrTxt);
    fpscrTxt.x = titleThread.x;
    fpscrTxt.y = lastSector.y + lastSector.height + 8;
    add(fpscrTxt);

    var floatTxts:Array<FunkinText> = [];

    for (fs in 0...31) {
        var padWidth:Float = crashBG.width - (titleThread.x - crashBG.x) * 2;
        var intendedPos = padWidth / 3 * (fs % 3);

        var sectorTxt:FunkinText = new FunkinText();
        sectorTxt.text = "F" + CoolUtil.addZeros(fs, 2);
        sectorTxt.text += ":" + fakeFloatDump();
        formatText(sectorTxt);
        sectorTxt.x = titleThread.x + intendedPos;
        add(sectorTxt);

        floatTxts.push(sectorTxt);

        if (fs < 3)
            sectorTxt.y = fpscrTxt.y + fpscrTxt.height + 8;
        else {
            var prvSectorTxt:FunkinText = floatTxts[fs-3];
            sectorTxt.y = prvSectorTxt.y + prvSectorTxt.height;
        }
    }

    startIntro();
}

function startIntro() {
    camCrash.alpha = 0;

    var toadSound:FlxSound = new FlxSound();
    toadSound.loadEmbedded(Paths.sound("aToad"), false, true, () -> {
        camCrash.alpha = 0.85;
        canSelect = true;
    });

    for (cam in [PlayState.instance.camGame, PlayState.instance.camHUD])
        cam.shake(0.005, toadSound.length / 1000);

    toadSound.play();
}

function update() {
    if (canSelect && (controls.ACCEPT || controls.BACK))
        finishOver();
}

function finishOver() {
    canSelect = false;

    var goToFP:Bool = controls.BACK;

    camCrash.alpha = 1.0;
    camCrash.fade(FlxColor.BLACK, 0);

    // FlxG.sound.play(Paths.sound(goToFP ? "off-n64" : "reset-n64"));
    FlxG.sound.play(Paths.sound("reset-n64"));

    new FlxTimer().start(1.0, function(_) {
        MusicBeatState.skipTransOut = true;
        FlxG.switchState(goToFP ? new FreeplayState() : new PlayState());
    });
}

function onClose() {
	FlxG.cameras.remove(camCrash, true);
}

function formatText(text:FunkinText) {
    text.setFormat(Paths.font("PublicPixel.ttf"), 20, 0xFFFFFFFF);
    text.textField.antiAliasType = 0;
    text.textField.sharpness = 400;
    text.camera = camCrash;
}

function fakeErrorName():String {
    var messages:Array<String> = ["BLUEBALLED", "GET GUD", "TOO SCARED?"];

    return "(" + messages[FlxG.random.int(0, messages.length-1)] + ")";
}

function fakeSectorDump():String {
    var randomValue:String = Std.string(FlxG.random.int());

    return StringTools.hex(randomValue, 8) + "H";
}

function fakeFloatDump():String {
    if (FlxG.random.bool(10))
        return "---------";

    var stupidSign:String = (FlxG.random.bool(10) ? "-" : "+");

    var firstRandom:String = Std.string(FlxG.random.int(0, 9));
    firstRandom += "." + CoolUtil.addZeros(Std.string(FlxG.random.int(0, 999)), 3);

    var secondRandom:String = Std.string(FlxG.random.int(0, 5));
    secondRandom = CoolUtil.addZeros(secondRandom, 2);

    return stupidSign + firstRandom + "E" + secondRandom;
}
