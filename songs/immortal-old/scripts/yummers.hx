import lime.media.openal.AL;

var soRetro = new CustomShader("lowquality");
var soRetroHUD = new CustomShader("lowquality");
var hypercam;

function onNoteHit(e){
    if (e.noteType == "what" && !e.note.isSustainNote) {
        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.03;
    }
}

function stepHit(curStep:Int) {
    if (curStep == 388)
        camZoomingStrength = 0;
    else if (curStep == 526)
        camZoomingStrength = 1;
}

function create() {
    hypercam = new FlxSprite().loadGraphic(Paths.image("unregistered-hypercam"));
    add(hypercam);
    hypercam.camera = camHUD;
    if (downscroll)
        hypercam.y = FlxG.height - hypercam.height;
    soRetro.uBlocksize = [10, 10];
    soRetroHUD.uBlocksize = [3, 3];
    camGame.addShader(soRetro);
    camHUD.addShader(soRetroHUD);
}

var FILTER_TYPE = 0x8001;
var FILTER_BANDPASS = 0x0003;
var LOWPASS_GAIN = 0x0001;
var LOWPASS_GAINHF = 0x0002;
var DIRECT_FILTER = 0x20005;
var filter = AL.createFilter();

function onStartSong() {
    var audioSource = inst._channel.__source;
    var handle = audioSource.__backend.handle;
    AL.filteri(filter, FILTER_TYPE, FILTER_BANDPASS);
    AL.filterf(filter, LOWPASS_GAIN, 2.5);
    AL.filterf(filter, LOWPASS_GAINHF, 0);
    AL.sourcei(handle, DIRECT_FILTER, filter);
}