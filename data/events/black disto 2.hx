import funkin.game.Character;

function postCreate(){
 blackd = new FlxSprite(0, 0).makeSolid(7000, 7000, FlxColor.BLACK);
 blackd.screenCenter();
 blackd.alpha = 0;
 insert(members.indexOf(dad), blackd);
}
function onEvent(eventEvent) {
    if (eventEvent.event.name == "black disto") {
        var ease = eventEvent.event.params[0];
        var in = eventEvent.event.params[1];
        var time = eventEvent.event.params[2];
        var alpha2 = eventEvent.event.params[3];
        FlxTween.cancelTweensOf(blackd);
        FlxTween.tween(blackd, {alpha: alpha2}, time, {ease: CoolUtil.flxeaseFromString(ease, in) });
    }
}