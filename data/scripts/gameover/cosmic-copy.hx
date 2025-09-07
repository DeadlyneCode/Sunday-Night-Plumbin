var character;
function create() {
    camera.zoom -= 0.3;
    character = new Character(0, 0, "bfover");
	character.danceOnBeat = false;
    character.playAnim("firstDeath");
    character.camera = camera;

    character.x += FlxG.width / 2;
    add(character);
}

function update(elapsed:Float) {
    if (character.getAnimName() == "firstDeath" && character.isAnimFinished()) {
		character.playAnim("deathLoop", true);
        var point = character.getMidpoint();
        FlxTween.tween(camera, {"scroll.x": point.x - 300 - (FlxG.width / 2), "scroll.y": point.y - 60, zoom: 0.95}, 2, {ease: FlxEase.quadInOut});
    }
}

function confirmGameover()
{
    character.playAnim("deathConfirm", true);
}