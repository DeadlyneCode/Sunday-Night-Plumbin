var character;
var deathSFX;
function create() {
    camera.zoom -= 0.3;
    character = new Character(0, 0, "bf_eggover");
	character.danceOnBeat = false;
    character.screenCenter();
    character.playAnim("firstDeath");
    character.y -= FlxG.height / 4;

    character.x -= FlxG.width / 8;
    add(character);
}

function update(elapsed:Float) {
    if (character.getAnimName() == "firstDeath" && character.isAnimFinished()) {
		character.playAnim("deathLoop", true);
        FlxTween.tween(camera, {zoom: 1}, 2, {ease: FlxEase.quadInOut});
    }
}

function confirmGameover()
{
    character.playAnim("deathConfirm", true);
}