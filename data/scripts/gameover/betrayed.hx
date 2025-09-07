var character;
var deathSFX;
function create() {
    camera.zoom -= 0.3;
    character = new Character(0, 0, "bf-luigi-dead");
	character.danceOnBeat = false;
    character.playAnim("firstDeath");
    character.camera = camera;

    deathSFX = FlxG.sound.load(Paths.sound("gameover/IHY"));
    deathSFX.play();

    character.x += FlxG.width / 2;
    add(character);
}

function update(elapsed:Float) {
    if (character.getAnimName() == "firstDeath" && character.isAnimFinished()) {
		character.playAnim("deathLoop", true);
        var point = character.getMidpoint();
        FlxTween.tween(camera, {"scroll.x": point.x - 200 - (FlxG.width / 2), "scroll.y": point.y - 30, zoom: 0.95}, 2, {ease: FlxEase.quadInOut});
    }
}

function confirmGameover()
{
    if (deathSFX != null)
        deathSFX.stop();
    character.playAnim("deathConfirm", true);
}