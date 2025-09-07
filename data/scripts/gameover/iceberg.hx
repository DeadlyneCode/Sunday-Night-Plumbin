var doorLeft:FlxSprite;
var doorRight:FlxSprite;

function create() {
    FlxG.state.persistentDraw = true;

    doorLeft = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/hallways/door"));
    doorRight = new FlxSprite(0, 0).loadGraphic(Paths.image("stages/hallways/door"));
    doorLeft.flipX = true;

    for (door in [doorLeft, doorRight]) {
        door.setGraphicSize(0, FlxG.height);
        door.updateHitbox();
    }

    doorLeft.x = -doorLeft.width;
    doorRight.x = FlxG.width;

    FlxTween.tween(doorLeft, {x: FlxG.width / 2 - doorLeft.width}, 0.7, { ease: FlxEase.quadInOut });
    FlxTween.tween(doorRight, {x: FlxG.width / 2}, 0.7, { ease: FlxEase.quadInOut, onComplete: function() {
        FlxG.state.persistentDraw = false;
    }});

    add(doorLeft);
    add(doorRight);
}

function confirmGameover()
{
    FlxTween.completeTweensOf(doorLeft);
    FlxTween.completeTweensOf(doorRight);
    FlxTween.tween(doorLeft, {x: -doorLeft.width}, 1.3, { ease: FlxEase.quadInOut });
    FlxTween.tween(doorRight, {x: FlxG.width}, 1.3, { ease: FlxEase.quadInOut });

    return true;
}