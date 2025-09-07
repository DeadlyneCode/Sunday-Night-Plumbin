function postCreate() {
    camGame.fade(FlxColor.BLACK,0.0000001,false);
    camHUD.alpha = 0;
}

function stepHit(){
    switch(curStep){
        case 60:
            fadeSprite(camHUD, 1, 1);
        case 386:
            strumLines.members[0].characters[0].scrollFactor.set(0.9, 0.9);
            FlxTween.tween(strumLines.members[0].characters[0], {y: strumLines.members[0].characters[0].y -60}, 3, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});
            stage.stageSprites["effectb"].alpha = 0.5;
    }
}

