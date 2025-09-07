import funkin.game.Character;

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Shake") {
        var num = eventEvent.event.params[0];
        var dur = eventEvent.event.params[1];

        FlxG.camera.shake(num, dur, null, true, null); 
    }
}