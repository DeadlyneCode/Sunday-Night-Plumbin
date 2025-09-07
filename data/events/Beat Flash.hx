import funkin.game.Character;

function postCreate(){
    t = new CustomShader('glowbeat');
    camGame.addShader(t);

    t.Size = 0;
    t.dim = 2;
}

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Beat Flash" &&  FlxG.save.data.flashing == true) {


        t.Size = 0;
        t.dim = 2;
        var alpha = eventEvent.event.params[3];
        var in = eventEvent.event.params[1];
        var ease = eventEvent.event.params[0];
        var time = eventEvent.event.params[2];


        FlxTween.num(alpha, 2, time, {ease: CoolUtil.flxeaseFromString(ease, in)}, (val:Float) -> {t.dim = val;});
    }
}