var luigi = strumLines.members[0].characters[0];
var luigi2 = strumLines.members[0].characters[1];
var bf = strumLines.members[1].characters[0];
var bf2 = strumLines.members[1].characters[1];

function postCreate() {
    camGame.scroll.set(-200, 1400);
    FlxG.camera.followLerp = 0;
        luigi2.visible = false;
        bf2.visible = false;
        bf2.y = 1450;
        luigi2.x = 150;
        camHUD.alpha = 0;
        camGame.fade(FlxColor.BLACK,0.0000001,false);
}

function beatHit(curBeat:Int) {
    stage.stageSprites["lum"].alpha = 0.5;
    fadeSprite(stage.stageSprites["lum"], 0.4, 0.4);
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1:
            fadeSprite(camHUD, 1, 2);
        case 11:
            FlxG.camera.follow(camFollow, null, 0.03);
        case 272:
            camGame.scroll.set(100, 1200);
            FlxG.camera.followLerp = 0;
            FlxG.camera.angle = 0;
            toggleCharacters(true);
            setAlphaSprites(["bg"], 0);
            setAlphaSprites(["end"], 1);
            setAlphaSprites(["feu1", "feu2", "feu3", "feu4", "pont"], 0);
        case 456:
            FlxTween.tween(bf2, { x: 2000}, 1, {ease: FlxEase.quadIn});
            FlxTween.tween(luigi2, { x: -1000}, 1, {ease: FlxEase.quadIn});
            FlxTween.tween(stage.stageSprites["end"], {y: -1000}, 1, {
                ease: FlxEase.quadIn, 
                onComplete: function(k) {
                    killSprites(["end", luigi2, bf2]);
                }
            });
        case 464:
            FlxG.camera.follow(camFollow, null, 0.03);
            toggleCharacters(false);
            setAlphaSprites(["bg", "feu1", "feu2", "feu3", "feu4", "pont"], 1);
        case 864:
            moveSprites(["ff1", "ff2", "ff3"], {y: "+3000"}, 15);
            moveSprites(["ff4", "ff5"], {y: "+3000"}, 13);
        case 992:
            killSprites(["ff1", "ff2", "ff3","ff4", "ff5"]);
            moveSprites(["boo", "boo2", "boo4", "boo6"], {x: "+5000"}, 30);
            moveSprites(["boo1", "boo3", "boo5"], {x: "-5000"}, 30);
        case 1280:    
            camHUD.alpha = 0;
    }
}

function toggleCharacters(isSwitched:Bool) {
    luigi2.visible = isSwitched;
    bf2.visible = isSwitched;
    luigi.visible = !isSwitched;
    bf.visible = !isSwitched;
}