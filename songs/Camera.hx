public var defaultCameraMovementStrength = 20;
public var cameraMovementStrength = defaultCameraMovementStrength;

var cameraOffsetX = 0;
var cameraOffsetY = 0;

static final healthLerp:Float;

function update() {
    healthBar.unbounded = true;
}

function postUpdate(elapsed){
    healthLerp = FlxMath.lerp(healthLerp, health,0.15);
    healthBar.value = healthLerp;
}
var focusIsDad = false;
function onCameraMove(e){
    if (curCameraTarget == -1)
        return;
    var character = strumLines.members[curCameraTarget].characters[0];
    var anim = character.getAnimName();
    switch(anim){
        case "singLEFT"|"singLEFT-alt": cameraOffsetX = -cameraMovementStrength; cameraOffsetY = 0;
        case "singDOWN"|"singDOWN-alt": cameraOffsetY = cameraMovementStrength; cameraOffsetX = 0;
        case "singUP"|"singUP-alt": cameraOffsetY = -cameraMovementStrength; cameraOffsetX = 0;
        case "singRIGHT"|"singRIGHT-alt": cameraOffsetX = cameraMovementStrength; cameraOffsetY = 0;
        default: cameraOffsetX = cameraOffsetY = 0;
    }

    e.position.x += cameraOffsetX;
    e.position.y += cameraOffsetY;
}