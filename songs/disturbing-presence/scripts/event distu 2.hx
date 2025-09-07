import lime.media.openal.AL;

//OPENAL VALUES || DONT TOUCH
var FILTER_TYPE = 0x8001;
var FILTER_LOWPASS = 0x0001;
var LOWPASS_GAINHF = 0x0002;
var DIRECT_FILTER = 0x20005;

var filter = AL.createFilter();

function setCutoffPercent(percent:Float)
{
    var sounds = [inst, vocals];
    for (strumLine in strumLines.members) {
        sounds.push(strumLine.vocals);
    }

    for (snd in sounds)
    {
        if (snd == null || !snd.playing) continue;

        var audioSource = snd._channel.__source;
        var handle = audioSource.__backend.handle;

        lastCutoff = percent;
        AL.filteri(filter, FILTER_TYPE, FILTER_LOWPASS);
        AL.filterf(filter, LOWPASS_GAINHF, percent);
        AL.sourcei(handle, DIRECT_FILTER, filter);
    }
}

function update(elapsed:Float) {
    if (health <= 0.85 && health > 0)
    {
        var minCutOff = 0.1;
        var cutOffPercent = Math.max(minCutOff, Math.min(1, FlxMath.remapToRange(health, 0.8, 0.2, 1, minCutOff)));
        setCutoffPercent(cutOffPercent);
    }
	//trace(AL.getErrorString());
}

function onStartSong() {
    var audioSource = inst._channel.__source;
    var handle = audioSource.__backend.handle;
    AL.sourcei(handle, DIRECT_FILTER, filter);
}