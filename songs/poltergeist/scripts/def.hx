import flixel.addons.display.FlxBackdrop;
import flixel.tween.FlxTween;
import flixel.tween.FlxEase;
import flixel.util.FlxGradient;

var lol = true;
var camauto = true;
var cambf = 0.95;
var camdad = 0.55;  
var canShake = false;
var zoomChar = true;
var isTweening = false;
var run:FunkinSprite;
var isBoyfriendAttached = false; 

var TWEEN_DOWN_TIME = 0.1;
var TWEEN_UP_TIME = 0.1;
var TWEEN_DOWN_Y = 998;
var TWEEN_UP_Y = 980;
var FRAME_EVENTS = [6, 11, 17, 1];

function create() {
    pont = new FlxBackdrop(Paths.image("stages/manor/pont"), 1, -10, 0);
    pont.velocity.set(-1200, 0);
    pont.antialiasing = true;
    pont.scale.set(0.7, 0.7);
    pont.y = 500;
    pont.alpha = 0.000001;
    insert(members.indexOf(stage.stageSprites["phasedeux-1"]) + 1, pont);

    trace(dad.y);//305.5
    dad.y = 900;
    dad.alpha = 0.000001;



    fond2 = new FlxBackdrop(Paths.image("stages/manor/phase4-2"), 1, 300, 0);
    fond2.velocity.set(-200, 0);
    fond2.antialiasing = true;
    fond2.scale.set(1.2, 1.2);
    fond2.y = 650;
    fond2.scrollFactor.set(0.6, 0.6);
    fond2.alpha = 0.00000001;
    insert(members.indexOf(pont) - 1, fond2);

    fond3 = new FlxBackdrop(Paths.image("stages/manor/phase4-3"), 1, 500, 0);
    fond3.velocity.set(-100, 0);
    fond3.antialiasing = true;
    fond3.scale.set(2, 2);
    fond3.y = 500;
    fond3.scrollFactor.set(0.7, 0.7);
    fond3.alpha = 0.00000001;
    insert(members.indexOf(fond2) - 1, fond3);

    fond4 = new FlxBackdrop(Paths.image("stages/manor/phase4-4"), 1, -10, 0);
    fond4.velocity.set(-90, 0);
    fond4.antialiasing = true;
    fond4.scale.set(1.5, 1.5);
    fond4.y = -180;
    fond4.scrollFactor.set(0.5, 0.5);
    fond4.alpha = 0.00000001;
    insert(members.indexOf(dad) - 1, fond4);

    windo = new FlxBackdrop(Paths.image("stages/manor/windowphase4"), 1, 1000, 0);
    windo.velocity.set(-90, 0);
    windo.antialiasing = true;
    windo.scale.set(0.4, 0.4);
    windo.y = 500;
    windo.alpha = 0.00000001;
    insert(members.indexOf(fond3) - 1, windo);

    fond1 = new FlxBackdrop(Paths.image("stages/manor/phase4-1"), 1, 1500, 0);
    fond1.velocity.set(-350, 0);
    fond1.antialiasing = true;
    fond1.scale.set(1.5, 1.5);
    fond1.y = 500;
    fond1.scrollFactor.set(0.85, 0.85);
    fond1.alpha = 0.00000001;
    insert(members.indexOf(fond2) + 1, fond1);

    pontdev = new FlxBackdrop(Paths.image("stages/manor/pontdev"), 1, -10, 0);
    pontdev.velocity.set(-1650, 0);
    pontdev.antialiasing = true;
    pontdev.scale.set(0.7, 0.7);
    pontdev.y = 790;
    pontdev.alpha = 0.000001;
    pontdev.scrollFactor.set(1.25, 1.25);
    add(pontdev);

    pontDER = new FlxBackdrop(Paths.image("stages/manor/pont"), 1, -10, 0);
    pontDER.velocity.set(-800, 0);
    pontDER.antialiasing = true;
    pontDER.scale.set(0.5, 0.5);
    pontDER.y = 100;
    pontDER.scrollFactor.set(1.5, 1.5);
    pontDER.flipY = true;
     pontDER.alpha = 0.000001;
    insert(members.indexOf(pont) - 1, pontDER);

    run = new FunkinSprite(869, 880, Paths.image("stages/manor/run"));
    run.antialiasing = true;
    run.scale.set(0.7, 0.7);
    run.animation.addByPrefix('idle', 'run', 24, true);
    run.animation.play('idle');
    insert(members.indexOf(boyfriend) + 1, run);
    run.alpha = 0.000001;


    fond = FlxGradient.createGradientFlxSprite(1000, 1500, [FlxColor.TRANSPARENT, 0xFF65AE9C], 1, 0);
    fond.updateHitbox();
    fond.setPosition(800,0);
    fond.blend = 0;
    fond.angle = 90;
    fond.alpha = 0;
    insert(members.indexOf(dad)+1,fond);


}

function postCreate() {
    camGame.scroll.set(400, -200);
    FlxG.camera.followLerp = 0;
}
var stopLight = true;
function  beatHit(curBeat){
    if(curBeat %4==0 && !stopLight)
        fond.alpha = 1;
}

function update(elapsed:Float) {
    fond.alpha = FlxMath.lerp(fond.alpha, 0.000001, elapsed*2);
    if (run.animation.curAnim != null && !isTweening && run.alpha > 0) {
        var currentFrame = run.animation.curAnim.curFrame;
        if (currentFrame == FRAME_EVENTS[0] || currentFrame == FRAME_EVENTS[2]) descendrapide();
        else if (currentFrame == FRAME_EVENTS[1] || currentFrame == FRAME_EVENTS[3]) montelent();
    }
    if (isBoyfriendAttached) {
        boyfriend.x = run.x+3;
        boyfriend.y = run.y;
    }
}

function descendrapide() {
    isTweening = true;
    FlxTween.tween(run, { y: TWEEN_DOWN_Y }, TWEEN_DOWN_TIME, {
        ease: FlxEase.sineOut,
        onComplete: function(twn:FlxTween) { isTweening = false; }
    });
}

function montelent() {
    isTweening = true;
    FlxTween.tween(run, { y: TWEEN_UP_Y }, TWEEN_UP_TIME, {
        ease: FlxEase.sineIn,
        onComplete: function(twn:FlxTween) { isTweening = false; }
    });
}

function onCameraMove() {
    if (curCameraTarget == 0 && camauto && !zoomChar) {
        FlxTween.cancelTweensOf(FlxG.camera);
        zoomChar = true;
        FlxTween.tween(FlxG.camera, { zoom: camdad }, 1.5, { ease: FlxEase.quintOut, onComplete: ()->{
            defaultCamZoom = camdad; 
        }
        });
    }
    else if (curCameraTarget == 1 && camauto && zoomChar) {
        zoomChar = false;
        FlxTween.cancelTweensOf(FlxG.camera);
        FlxTween.tween(FlxG.camera, { zoom: cambf }, 3, { ease: FlxEase.quintOut, onComplete: ()->{
           defaultCamZoom = cambf; 
        }
        });
    }
     
}

function stepHit(curStep:Int) {
    switch(curStep) {
        case 0:
            FlxTween.tween(FlxG.camera.scroll, {y: 550}, 14, {type:  FlxTween.ONESHOOT, ease: FlxEase.quadInOut});
        case 119:
            fadeSprite(camHUD, 1, 0.6);
        case 204:
            FlxTween.tween(dad,{y:305.5}, 7.5, {ype: FlxTween.ONESHOOT, ease: FlxEase.quadInOut});
            FlxTween.tween(dad,{alpha:1}, 5.5, {ype: FlxTween.ONESHOOT, ease: FlxEase.quadInOut});
        case 288:
            stopLight = false;
            FlxG.camera.follow(camFollow, null, 0.03);
        case 285:
           // FlxG.camera.follow(camFollow, null, 0.03);
        case 533:
            var sprites = [stage.stageSprites["1"], stage.stageSprites["3"], stage.stageSprites["4"], stage.stageSprites["2"], stage.stageSprites["6"]];
            FlxTween.tween(FlxG.camera, { angle: -10, zoom: 0.8 }, 1, { ease: FlxEase.backIn });
            FlxTween.tween(FlxG.camera.scroll, { y: 800 }, 1, { ease: FlxEase.backIn });
            
            for (i in 0...sprites.length) FlxTween.tween(sprites[i], { y: 1500 + (i == 4 ? 500 : 0) }, 1.4 + i * 0.2, { ease: FlxEase.backInOut });
            new FlxTimer().start(0.2,()->{
                camGame.fade(FlxColor.BLACK, 0.5, false);
            });
        case 544: //Phase 2
            var phase1 = [stage.stageSprites["1"], stage.stageSprites["3"], stage.stageSprites["4"], stage.stageSprites["2"], stage.stageSprites["6"]];
            var phase2 = [stage.stageSprites["phasedeux-1"], stage.stageSprites["phasedeux-3"], stage.stageSprites["phasedeux-4"]];
            for (s in phase1) s.kill();
            for (s in phase2) s.alpha = 1;
            stage.stageSprites["phasedeux-light"].alpha = 0.6;
            camGame.scroll.set(500, 0);
            FlxG.camera.followLerp = 0;
            stopLight = true;
            camdad = 0.55;
            //defaultCamZoom = 0.7;
            FlxTween.tween(FlxG.camera.scroll, { y: 400 }, 8, { ease: FlxEase.quadInOut });
            camauto = true;
            FlxG.camera.angle = 0;
            camGame.fade(FlxColor.BLACK, 8, true);

       case 607:    
            FlxG.camera.follow(camFollow, null, 0.03);
        case 1047:
            var phasedeux = [stage.stageSprites["phasedeux-1"], stage.stageSprites["phasedeux-light"], stage.stageSprites["phasedeux-3"], stage.stageSprites["phasedeux-4"]];
            FlxTween.tween(FlxG.camera.scroll, { y: 1200 }, 1, { ease: FlxEase.backIn });
            new FlxTimer().start(0.4,()->{
                camGame.fade(FlxColor.BLACK, 0.5, false);
            });
            for (i in 0...phasedeux.length) FlxTween.tween(phasedeux[i], { y: 1500 }, 1.4 + i * 0.2, { ease: FlxEase.backInOut });

        case 1057:
            FlxTween.tween(dad, { x: dad.x + 100 ,y:100+dad.y}, 4, { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut });
            var phasedeux = [stage.stageSprites["phasedeux-1"], stage.stageSprites["phasedeux-light"], stage.stageSprites["phasedeux-3"], stage.stageSprites["phasedeux-4"]];
            for (s in phasedeux) s.kill();
            FlxTween.tween(run, { x: boyfriend.x + 100 }, 4, { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut });
            pont.alpha = 1;
            pontdev.alpha = 1;
     
            camGame.fade(FlxColor.BLACK, 1, true);
            run.alpha = 1;
            isBoyfriendAttached = true; // Activer le suivi de run
            boyfriend.x = run.x; // Aligner boyfriend sur run
            boyfriend.y = run.y ;
            camGame.scroll.set(500, 500);

        case 1312:
            FlxG.camera.followLerp = 0;
            camGame.fade(FlxColor.BLACK, 2.4, false);
            FlxTween.tween(run, { x: 2600 }, 2.8, { ease: FlxEase.quadInOut });
            FlxTween.tween(FlxG.camera.scroll, { x: 1200 }, 1.6, { ease: FlxEase.quadInOut });
            FlxTween.tween(FlxG.camera, { zoom: 0.7 }, 2.8, { ease: FlxEase.quadInOut });
            FlxTween.tween(dad, { y: 1200, x: -600 }, 2.8, { ease: FlxEase.quadInOut });

        case 1335: //Phase 3

            camGame.scroll.set(600, 600);
            FlxTween.tween(FlxG.camera.scroll, { y: 100 }, 28, { ease: FlxEase.sineInOut });
            cambf = 0.95;
            camdad = 0.50;


        case 1342: //Phase 3
            camGame.fade(FlxColor.BLACK, 4.4, true);
            var hideSprites = [pont, pontdev, run, stage.stageSprites["phase3-2"], stage.stageSprites["phase3-1"]];
            for (s in hideSprites) s.alpha = 0.00000001;

        
            boyfriend.alpha = 1;
            boyfriend.setPosition(boyfriend.x-20 , boyfriend.y);
            isBoyfriendAttached = false; 
            var showSprites = [stage.stageSprites["phase3-2"], stage.stageSprites["phase3-1"]];
            for (s in showSprites) s.alpha = 1;
            FlxTween.tween(stage.stageSprites["light"], {alpha:0.45 ,y:-100}, 4, {ease:FlxEase.sineInOut});

  
        case 1597:  
            
           FlxG.camera.follow(camFollow, null, 0.03);
        case 1727:
            FlxTween.tween(stage.stageSprites["light"], {alpha:0}, 1.2,{ease:FlxEase.sineInOut});
            var phase3Sprites = [stage.stageSprites["phase3-2"], stage.stageSprites["phase3-1"]];
            for (s in phase3Sprites) s.kill();
            var showSprites = [pont, pontdev, run, fond1, fond2, fond3, fond4, windo];
            for (s in showSprites) s.alpha = 1;
            dad.y= dad.y -800;
            dad.x= dad.x -400;


            isBoyfriendAttached = true; // reactive le suivi
            FlxG.camera.fade(FlxColor.BLACK, 1, true);
            camGame.scroll.set(500, 500);
            FlxTween.tween(dad, { x: dad.x + 100 ,y:100+dad.y}, 4, { type: FlxTween.PINGPONG, ease: FlxEase.quadInOut });
        case 1729:
            remove(strumLines.members[0].characters[0]);
            insert(members.indexOf(boyfriend)-8,strumLines.members[0].characters[0]);
        case 2020:
            FlxTween.cancelTweensOf(dad);
            FlxTween.tween(dad, { x: dad.x -2900}, 7, { type: FlxTween.ONESHOOT, ease: FlxEase.quadInOut });
            FlxTween.tween(dad, {y:dad.y+1200}, 7, { type: FlxTween.ONESHOOT, ease: FlxEase.quadInOut });
        case 2064:
            FlxG.camera.followLerp = 0;
            FlxTween.tween(run, { x: 2600 }, 4, { ease: FlxEase.quadInOut });
            camGame.fade(FlxColor.BLACK, 4, false);
            
    }
}