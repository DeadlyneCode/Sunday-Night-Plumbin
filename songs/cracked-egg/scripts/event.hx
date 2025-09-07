function create(){
    bb = new FlxSprite().loadGraphic(Paths.image("stages/victim/effectg"));
	bb.screenCenter();
	bb.alpha = 0;
	bb.scale.set(1.0,1.0);
    bb.cameras = [camHUD];
    stage.stageSprites["last"].visible = false;
    stage.stageSprites["2part"].visible = false;
    stage.stageSprites["mic"].visible = false;

    insert(0,bb);
    
    evilRedOverlay = new FlxSprite().loadGraphic(Paths.image("stages/victim/evilRedOverlay"));
	evilRedOverlay.scale.set(0.75, 1.0);
	evilRedOverlay.screenCenter();
	evilRedOverlay.alpha = 0;
    evilRedOverlay.cameras = [camHUD];
    add(evilRedOverlay);
    camGame.fade(FlxColor.BLACK,0.0000001,false);
}

var floatingBF = false;

function postUpdate(elapsed:Float) {
    if (floatingBF)
    {
        boyfriend.angle = Math.sin((Conductor.songPosition / 1200) * (Conductor.bpm / 60) * -1) * 3;
        var offsets = boyfriend.getAnimOffset(boyfriend.getAnimName());
        boyfriend.offset.y = offsets.y + Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60)) * 15;
    }
}

var headBopTween:FlxTween;
function stepHit(){

    if (curStep >= 1280 && curStep <= 1840 && curBeat % 4 == 0)
    {
        evilRedOverlay.alpha = 0.4;
        FlxTween.tween(evilRedOverlay, {alpha: 0}, 0.6);

        if(headBopTween != null)
        {
            headBopTween.finish();
            camHUD.scroll.y = 0;
        }
        
        var moveAmount = downscroll ? -20 : 20;
        camHUD.scroll.y += moveAmount;
        headBopTween2 = FlxTween.tween(camHUD.scroll, {y: 0}, 0.6, {ease: FlxEase.cubeOut}); 
    }

    switch(curStep){
        case 544:
            FlxTween.tween(bb.scale, {x:0.85, y:0.85}, 0.5, { ease: FlxEase.sineInOut} );
            FlxTween.tween(bb, {alpha: 1}, 0.3, {ease: FlxEase.linear});
        case 572:
            dad.x = dad.x + 400;
            stage.stageSprites["ombremario"].x = 1180;
        case 576:
            FlxTween.tween(bb.scale, {x:2.0, y:2.0}, 0.5, { ease: FlxEase.sineInOut} );
            FlxTween.tween(bb, {alpha: 0}, 2, {ease: FlxEase.linear});
        case 720:
            FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.linear});
        case 752:
            stage.stageSprites["mic"].visible =stage.stageSprites["2part"].visible = true;
            for (part1 in [stage.stageSprites["victom_ground"], stage.stageSprites["bg"], stage.stageSprites["ombre"], stage.stageSprites["ombremario"], bb]){
                part1.kill();
            }
            FlxTween.tween(camHUD, {alpha: 1}, 0.5, {ease: FlxEase.linear});
            FlxTween.tween(stage.stageSprites["mic"], {angle:5},0.5, {type:FlxTween.PINGPONG, ease: FlxEase.sineInOut});
            for (i in [boyfriend,  stage.stageSprites["mic"]]){
                FlxTween.tween(i, {y:900},10, {type:FlxTween.ONESHOOT, ease: FlxEase.sineInOut});
            }
            boyfriend.setPosition(1500,1100);
            dad.setPosition(1000,200);
            dad.scale.set(1.5,1.5);
            for (i in [dad,  stage.stageSprites["2part"]]){
                FlxTween.tween(i.scale, {x: 0.7, y:0.7},20, {ease: FlxEase.sineInOut});
            }
            FlxTween.tween(stage.stageSprites["2part"], {y:-500},20, {ease: FlxEase.sineInOut});
            FlxTween.tween(dad, {y:-400},20, {ease: FlxEase.sineInOut});
        case 940:
            for (i in [boyfriend,stage.stageSprites["mic"]])
                FlxTween.tween(i, {y:2000}, 2, {ease: FlxEase.sineInOut});
            FlxG.camera.followLerp = 0;  
        case 962:
            for (i in [stage.stageSprites["2part"], stage.stageSprites["mic"]]){
                i.kill();
            }
            camGame.scroll.set(1050, 1100);
	        FlxG.camera.followLerp = 0;
            floatingBF = true;
            boyfriend.y = boyfriend.y + 1300;
        case 1126:
            camGame.scroll.set(225, -250);
            FlxG.camera.followLerp = 0;
        case 1128:
            remove(boyfriend);
            camGame.scroll.set(1175, -250);
            dad.setPosition(2000,-100);
        case 1276:
            stage.stageSprites["effectb"].scale.set(1, 1.3);
            dad.setPosition(dad.x + 650, dad.y - 300);
        case 1280:
            FlxG.camera.followLerp = 0;
            camGame.scroll.set(400, 100);
            stage.stageSprites["last"].visible = true;
        case 1840: //bye bye !!
            FlxTween.tween(dad.scale, {x: 0.3, y: 0.3}, 5, {ease: FlxEase.cubeIn});
            FlxTween.tween(dad, {alpha: 0}, 5, {ease: FlxEase.sineInOut});
    }
}