import funkin.game.Character;

var t:CustomShader;

function postCreate() {
    t = new CustomShader('distoflash');
    camGame.addShader(t);

    t.Size = 0;
    t.dim = 0; // pas d'effet au départ
}

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Disto Flash" && FlxG.save.data.flashing == true) {
        var ease = eventEvent.event.params[0];
        var easeIn = eventEvent.event.params[1];
        var time = eventEvent.event.params[2];

        t.dim = 1; // effet instantané

        FlxTween.num(1, 0, time, { ease: CoolUtil.flxeaseFromString(ease, easeIn) },
            (val:Float) -> t.dim = val
        );
    }
}
