var fadeTimer = 0; 
var fadeOut = false;

function postCreate() {
    newHUD = new FlxSprite(0, -200).loadGraphic(Paths.image('hud/WHUD'));
    newHUD.cameras = [camHUD];
    newHUD.screenCenter(FlxAxes.X);
    newHUD.scale.set(0.5,0.5);
    insert(members.indexOf(iconP2), newHUD);

    arrow = new FlxSprite(0, -55).loadGraphic(Paths.image('hud/fleche'));
    arrow.cameras = [camHUD];
    arrow.screenCenter(FlxAxes.X);
    arrow.origin.set(arrow.origin.x, arrow.origin.y-70);
    arrow.scale.set(0.25,0.35);
    insert(members.indexOf(iconP2), arrow);

    if (downscroll)
    {
        newHUD.y = 415;
        arrow.y = newHUD.y - 25;
    }

    doIconBop = false;
    hideDefaultHUDText();

}

function postUpdate() {
    iconP2.setPosition(newHUD.x + 175, downscroll ? 600 : -35); 
    iconP2.scale.set(0.9, 0.9);

    var neededAngle = (60 * (health - 1));
    arrow.angle = FlxMath.lerp(arrow.angle, neededAngle, FlxG.elapsed * 20);

    if (health >= 1.8) {
        fadeTimer += FlxG.elapsed; 
        if (fadeTimer >= 3) { 
            fadeOut = true;
        }
    } else if (health <= 1) {
        fadeTimer = 0; 
        fadeOut = false; // Arrêter le fade out
    } else {
        fadeTimer = 0; 
    }

    if (fadeOut) {
        newHUD.alpha = FlxMath.lerp(newHUD.alpha, 0, FlxG.elapsed * 2);
        arrow.alpha = FlxMath.lerp(arrow.alpha, 0, FlxG.elapsed * 2);
        iconP2.alpha = FlxMath.lerp(iconP2.alpha, 0, FlxG.elapsed * 2);
    } else if (health <= 1) {
        newHUD.alpha = FlxMath.lerp(newHUD.alpha, 1, FlxG.elapsed * 2);
        arrow.alpha = FlxMath.lerp(arrow.alpha, 1, FlxG.elapsed * 2);
        iconP2.alpha = FlxMath.lerp(iconP2.alpha, 1, FlxG.elapsed * 2);
    }

    if (health >= 1.5) iconP2.animation.curAnim.curFrame = 1;
    else if (health <= 0.5) iconP2.animation.curAnim.curFrame = 2;
    else iconP2.animation.curAnim.curFrame = 0;
}

function hideDefaultHUDText() {
    for (i in [scoreTxt, missesTxt, accuracyTxt, comboGroup, healthBar, healthBarBG, iconP1])
        remove(i);
}