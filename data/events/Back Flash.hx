import funkin.game.Character;


function onEvent(eventEvent) {
    if (eventEvent.event.name == "Back Flash") {

        var blend = eventEvent.event.params[5];
        var color = eventEvent.event.params[0];
        var color2 = eventEvent.event.params[4];
        var ease = eventEvent.event.params[0];
        var in = eventEvent.event.params[1];
        var time = eventEvent.event.params[2];
        var alpha2 = eventEvent.event.params[3];

        white = new FlxSprite(0, 0).makeSolid(5000, 5000, color2);
        white.screenCenter();
        white.alpha = 0;
        insert(members.indexOf(boyfriend), white);

        white.alpha = alpha2;
        white.blend = blend;
        FlxTween.cancelTweensOf(FlxG.camera);
        FlxTween.tween(white, {alpha: 0}, time, {ease: CoolUtil.flxeaseFromString(ease, in) });
    }
}