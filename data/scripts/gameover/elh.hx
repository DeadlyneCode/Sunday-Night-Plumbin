var character;
var deathSFX;
function create() {
    camera.zoom -= 0.3;
    character = new Character(0, 0, "elover");
	character.danceOnBeat = false;
    character.screenCenter();
    character.playAnim("firstDeath");
    character.y -= FlxG.height / 4;

    character.x -= FlxG.width / 8;
    add(character);
}

function update(elapsed:Float) {
    if (character.getAnimName() == "firstDeath") {
        trace(character.globalCurFrame);
        if (character.globalCurFrame == 158){
            character.playAnim("deathLoop", true);
            FlxTween.tween(camera, {zoom: 1}, 2, {ease: FlxEase.quadInOut});
        }
    
        if (character.globalCurFrame == 113){
            camera.flash(FlxColor.WHITE, 1);
        }
    }
}

function confirmGameover()
{
    character.playAnim("deathConfirm", true);
}