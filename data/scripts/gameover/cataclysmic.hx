var character;
var deathSFX;
var redFlash;
function create() {
    redFlash = new FlxSprite(-500, -500).makeGraphic(FlxG.width / 0.2, FlxG.height / 0.2, 0xFF580B31);
    add(redFlash);
    redFlash.alpha = 0.001;
    redFlash.scrollFactor.set(0, 0);

    camera.zoom -= 0.3;
    character = new Character(0, 0, "bf-mx-dead");
	character.danceOnBeat = false;
    character.playAnim("firstDeath");

    deathSFX = FlxG.sound.load(Paths.sound("gameover/MXGAMEOVER"));
    deathSFX.play();

    character.x += FlxG.width / 2;
}

function postCreate() {
    add(character);
}

var shakeFrames = [1, 10, 23, 36, 49, 64, 78, 92, 104];
var lastShakeFrame = -1;
function update(elapsed:Float) {
    if (character.getAnimName() == "firstDeath")
    {
        if (shakeFrames.indexOf(character.globalCurFrame) != -1 && lastShakeFrame != character.globalCurFrame)
        {
            FlxTween.cancelTweensOf(redFlash);
            redFlash.alpha = 0.5;
            FlxTween.tween(redFlash, {alpha: 0.001}, 0.5, {ease: FlxEase.quadOut});
            lastShakeFrame = character.globalCurFrame;
            camera.shake(0.05, 0.2);
        }
        if (character.isAnimFinished()) {
            character.playAnim("deathLoop", true);
            var point = character.getMidpoint();
            FlxTween.tween(camera, {"scroll.x": point.x - (FlxG.width / 1.5) - 50, "scroll.y": point.y + 40, zoom: 1}, 2, {ease: FlxEase.quadInOut});
        }  
    }
}

function confirmGameover()
{
    if (deathSFX != null)
        deathSFX.stop();

    character.playAnim("deathConfirm", true);
}