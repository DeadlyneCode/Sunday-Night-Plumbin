function onCameraMove(camMoveEvent) {
    if (camMoveEvent.strumLine != null && camMoveEvent.strumLine?.characters[0] != null)
        if (!StringTools.contains(camMoveEvent.strumLine.characters[0].animation.name, "sing")) {
            if (__curMulti > 0) {
                camMoveEvent.position.x += Math.sin(time*(30/__curMulti))*__curMulti;
                camMoveEvent.position.y += (Math.sin((time*(30/__curMulti))*2)/2)*(__curMulti*.6);
            }
        }
}

public var idleSpeed:Float = 1;
var __curMulti:Float = 0;
var __moveTheHud = false;
var __angleMulti:Float = 0;
var time:Float = 0;
function update(elapsed:Float) {
    time += elapsed*idleSpeed;

    if (__angleMulti > 0) camGame.angle = lerp(camGame.angle, (-Math.sin(time)*.5)*__angleMulti, 0.1);
    if (__moveTheHud && __angleMulti > 0) {
        camHUD.angle = lerp(camHUD.angle, (Math.sin(time)*.15)*__angleMulti, 0.5);
    }
}

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Idle Cam Movement") {
        __curMulti = params[0];
        __angleMulti = params[1];
        __moveTheHud = params[2] ?? false;
    }
}