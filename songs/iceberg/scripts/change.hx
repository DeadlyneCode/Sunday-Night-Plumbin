function create(){
    dad.alpha = 0.001; //comme ca flixel le laisse dans le cache
    mur = new FlxSprite(0, -750);
    mur.frames = Paths.getSparrowAtlas("stages/hallways/bgw");
    mur.animation.addByPrefix("mur", "loop", 19);
    mur.animation.play("mur");
    insert(members.indexOf(dad), mur);
}

function stepHit(curStep:Int){
    switch (curStep){
        case 311: 
            FlxTween.tween(dad, {alpha: 1}, 0.2, {ease: FlxEase.linear});
            //FlxTween.tween(dad.scale, {x:0.7, y:0.7}, 0.5, { ease: FlxEase.sineInOut} );
            FlxTween.tween(stage.stageSprites["effect"], {alpha: 0.3}, 1, {ease: FlxEase.linear});
        case 1024:
            FlxTween.tween(camHUD, {alpha: 0}, 2.5, {ease: FlxEase.linear});
    }
}