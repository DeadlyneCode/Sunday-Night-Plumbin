
import flixel.util.FlxTimer;

var mex:FlxSprite;


function postCreate() {
    mex = new FlxSprite(0,-75).loadGraphic(Paths.image('stages/cataclysmic/mxalpha'));
    mex.screenCenter(FlxAxes.X);
    mex.scale.set(0.9, 0.9);
    insert(members.indexOf(boyfriend), mex); 
    mex.cameras = [camHUD];
    mex.alpha = 0; 
}

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Jumpscare") {
        var time = eventEvent.event.params[0];
        var shake = eventEvent.event.params[1];
        mex.alpha = 1;
        camHUD.shake(0.01, time);

        for (hud in [iconP1, iconP2, healthBarBG, healthBar, newHUD, score]) {
            hud.alpha = 0;
        }

        new FlxTimer().start(time, function(tmr:FlxTimer) {

            for (hud in [iconP1, iconP2, healthBarBG, healthBar, newHUD, score]) {
                hud.alpha = 1;
            }

            mex.alpha = 0;
        });
    }
}

