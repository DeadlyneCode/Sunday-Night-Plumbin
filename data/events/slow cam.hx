import funkin.game.Character;
import flixel.util.FlxAxes;
import flixel.effects.FlxFlicker;

function onEvent(eventEvent) {
    if (eventEvent.event.name == "slow cam") {
        var curcamspeed = eventEvent.event.params[0];
        FlxG.camera.followLerp = curcamspeed;
    }
}