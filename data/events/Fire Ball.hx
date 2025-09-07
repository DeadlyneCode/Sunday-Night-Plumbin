import flixel.effects.FlxFlicker;
import flixel.util.FlxAxes;
import funkin.backend.utils.ControlsUtil;
import funkin.game.Character;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxTextBorderStyle;

var lava:FlxSprite;
var isDodging:Bool = false;
var gotHit:Bool = false;
var dodgeAlt = false;
var hitbox:FlxSprite;
var prevDodge = false;
function gravityEasing(t) {
    // The second comment is going to translate for those who don't speak french

    // J'aime bien expoIn donc je le prends comme base d'acceleration
    // I like expoIn so I'm going to use it as an acceleration base
    var expoInValue = FlxEase.expoIn(t);
    
    // Après la on va faire un easing qui ressemble à la gravité de la terre pour que ca rende assez naturel
    // After that we're going to make an easing that looks like earth's gravity so it looks natural
    var gravityValue = t * t * (3 - 2 * t);  // Tema l'easing de fou // That easing is crazy
    
    // Ease de transition entre expoIn et la gravité
    // Transition easing between expoIn and gravity
    var smoothTransition = t * t * (3 - 2 * t);  

    //On applique toute la merde ensemble
    //We apply all the shit together
    return expoInValue * (1 - smoothTransition) + gravityValue * smoothTransition;
}

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Warning Fire Ball" && FlxG.save.data.curPowerUp != 3) {
        prevDodge = true;
    }
    if (eventEvent.event.name == "Fire Ball" && FlxG.save.data.curPowerUp != 3) {
        //dodgeAlt = false;
        lava.angle = 0;
        gotHit = false;
        FlxTween.tween(lava, {y: 1000}, 0.5, {ease: FlxEase.smoothStepOut, onComplete: function(_) {
            gotHit = false;
            dodgeAlt = true;
        }});

        FlxTween.tween(lava, {angle: 180}, 0.5, {ease: FlxEase.circInOut, startDelay: 0.3});

        new FlxTimer().start(0.7, function(_) {

            FlxTween.linearMotion(lava, lava.x, 1000, lava.x, hitbox.y + 700, 0.7, true, {ease: gravityEasing, onComplete: ()->{
                dodgeAlt = false;
                new FlxTimer().start(0.2,()->{
                    prevDodge = false;
                    releasedSpace();
                });

            }});
        });
    }
}

var cutsceneCamText = new FlxCamera();
cutsceneCamText.bgColor = 0;
var cutsceneText;
function postCreate(){
    hitbox = new FlxSprite(900, 1850).makeGraphic(200, 200, FlxColor.WHITE);
    add(hitbox);
    hitbox.updateHitbox();
    hitbox.alpha = 0.001;

    lava = new FlxSprite();
    lava.frames = Paths.getSparrowAtlas('stages/betrayed/lava');
    lava.animation.addByPrefix('lava', 'lava', 24, true);
    lava.animation.play('lava');
    lava.scale.set(0.6, 0.6);
    lava.updateHitbox();
    lava.angle = 0;
    add(lava);
    lava.setPosition(hitbox.x + (hitbox.width / 2) - (lava.width / 2), hitbox.y + 700);

    FlxG.cameras.add(cutsceneCamText, false);
    cutsceneText = new FlxText(0, 600, FlxG.width, "", 36 * 1.75);
    cutsceneText.setFormat(Paths.font("U.ttf"), 18 * 1.75, FlxColor.WHITE, "center");
    cutsceneText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
    cutsceneText.y = 600;
    cutsceneText.antialiasing = true;
    cutsceneText.alpha = 0.001;
    add(cutsceneText);
    cutsceneText.camera = cutsceneCamText;
}

function destroy() {
    FlxG.cameras.remove(cutsceneCamText);
}

function stepHit(curStep:Int) {
    switch (curStep)
    {
        case 13:
            var dodgeKey = CoolUtil.keyToString(ControlsUtil.getControl(controls, "dodge").inputs[0].inputID);

            cutsceneText.applyMarkup(applyFiller(getString("betrayed_dodge_bind"), [dodgeKey]),
                [
                    new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF44), "*")
                ]
            );
            FlxTween.tween(cutsceneText, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});

        case 48:
            FlxTween.tween(cutsceneText, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
    }
}

var presingSpace:Bool = false;
var forceRelease:Bool = false;
var delay = 100;

function gotHitCallback() {
    if (gotHit)
        return;

    gotHit = true;
    health -= 0.4;
    boyfriend.color = 0xFFFE6B82;
    FlxG.sound.play(Paths.sound('fireHit'));
    new FlxTimer().start(0.3, function (_) {
        boyfriend.color = 0xFFFFFFFF;
    });
    trace("skill issue");
}
function update(elapsed){
    if (prevDodge){
        if (!isDodging && lava.overlaps(hitbox))
            gotHitCallback();

        if (controls.getJustPressed("dodge") && delay<=0) {
            delay = 100;
            presingSpace = true;
            forceRelease = false;
            isDodging = true;
            boyfriend.playAnim((dodgeAlt)?'dodgeAlt':'dodge', true);
            new FlxTimer().start(1.2, function(tmr:FlxTimer)
            {
                forceRelease = true;
            });
        }

    delay -= elapsed * 200;
    if (boyfriend.animation.curAnim.name != "dodge" && boyfriend.animation.curAnim.name != "dodgeAlt" ) {
        releasedSpace();
    }

    }
    else{
        if (controls.getJustPressed("dodge")){
            releasedSpace();
            boyfriend.playAnim('singRIGHTmiss', true);
            FlxG.sound.play(Paths.sound('missnote1'), 0.5);
            health -= 0.05;
        }

    }
}

function onPlayerHit(event) if (presingSpace) event.animCancelled = true;
function onPlayerMiss(event) if (presingSpace) event.animCancelled = true;

function releasedSpace(){
    if (!presingSpace )
        return; 

    forceRelease = false;
    presingSpace = false;

    isDodging = false;
}

//haaiiiii Furo!!!!
//🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶
//wtf was that bro
// deadlyne ferme ta grosse gueule stp merciiiii :3 (furo confirm)