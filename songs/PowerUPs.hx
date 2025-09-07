public var scrollSpeedModif = 1;
public var scoreMult:Float = 1;
var resist:Float = 7;
var currentScrollSpeed:Float = 0;

function create(){
    hasLoad = true;
    currentScrollSpeed = SONG.scrollSpeed;
    onModifierChange();
}

function getScoreMult() {
    switch (FlxG.save.data.curPowerUp) {
        case 0: //normal
            return 1;
        case 1: //fire
            return 1.5;
        case 2: //ice
            return 0.5;
        case 3: //invincible
            return -99;
        case 4: //oneshot
            return 2;
        case 5: //retro
            return 1;
    }
}

function earacheCheck() {
    if (FlxG.save.data.curPowerUp == 5) //retro mushroom
    {
        if (curSong != "earache" && curSong != "immortal-old") {
			FlxG.switchState(new ModState("smb"));
        }
    }
}

function onModifierChange() {
    scoreMult = getScoreMult();
    earacheCheck();
    scrollSpeedModif = ((FlxG.save.data.curPowerUp == 1) ? 1.5 : ((FlxG.save.data.curPowerUp == 2) ? 0.5 : 1));
    scrollSpeed = currentScrollSpeed * scrollSpeedModif;
    scoreSuffix = (scoreMult < 0 || scoreMult == 1) ? "" : " (x" + scoreMult + ")";
}

function postCreate(){
    remove(PlayState.instance.stage);
    earacheCheck();
}

function onPlayerMiss(event) {
    if((FlxG.save.data.curPowerUp == 4)){
        health = 0;
        gameOver(boyfriend);
    }
    if (FlxG.save.data.curPowerUp == 3){
        event.healthGain = 0;
    } 
}

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Scroll Speed Change") {
        eventEvent.cancel();
        if (scrollSpeedTween != null)
            scrollSpeedTween.cancel();

		if (eventEvent.event.params[0] == false) {
            currentScrollSpeed = eventEvent.event.params[1];
            onModifierChange();
        } else {
            scrollSpeedTween = FlxTween.num(currentScrollSpeed, eventEvent.event.params[1], (Conductor.stepCrochet / 1000) * eventEvent.event.params[2], {ease: CoolUtil.flxeaseFromString(eventEvent.event.params[3], eventEvent.event.params[4])}, function (value) {
                currentScrollSpeed = value;
                onModifierChange();
            });
        }
	}
}