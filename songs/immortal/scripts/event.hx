import openfl.geom.ColorTransform;
import funkin.backend.system.GraphicCacheSprite;

var ncm:Bool = false;
var leDadDeTaGrandMere:FlxSprite;
var finalBump = false;

function postCreate() {
    camHUD.alpha = 0;
    stage.stageSprites["lumb2"].alpha = stage.stageSprites["lumb"].alpha = 0;
    camGame.fade(FlxColor.BLACK,0.0000001,false);

    leDadDeTaGrandMere = new FlxSprite();
    leDadDeTaGrandMere.frames = Paths.getSparrowAtlas("stages/immortal/trans");
    leDadDeTaGrandMere.animation.addByPrefix("idle", "transition", 24);
    leDadDeTaGrandMere.x = dad.x - 500;
    leDadDeTaGrandMere.y = dad.y - 500;
    leDadDeTaGrandMere.alpha = 0.00001;
    leDadDeTaGrandMere.scale.set(1.25, 1.25);
    leDadDeTaGrandMere.updateHitbox();
    add(leDadDeTaGrandMere);

    preCache = new GraphicCacheSprite();
    preCache.cache(Paths.image('stages/immortal/toadfire'));
}

function msknLeToad(baseX:Float, daX:Float, time:Float, toLeft:Bool) {
    var elToad = new FlxSprite();
    elToad.frames = Paths.getSparrowAtlas("stages/immortal/toadfire");
    elToad.animation.addByPrefix("idle", "toadfire", 24);
    elToad.animation.play("idle");
    elToad.flipX = toLeft;
    elToad.x = baseX;
    elToad.y = toLeft ? (dad.y - 200) : dad.y;
    var daScale = toLeft ? 1.25 : 1.5;
    elToad.scale.set(daScale, daScale);
    elToad.updateHitbox();
    if (toLeft)
    {
        insert(members.indexOf(dad), elToad);
    } else {
        add(elToad);
    }
    FlxTween.tween(elToad, {x: daX}, time);
    toads.push(elToad);
}

var toads:Array<FlxSprite> = [];

function stepHit(curStep:Int) {
    switch(curStep) { 
        case 251:
            fadeSprite(camHUD, 1, 0.6);
        case 980:
            dad.alpha = 0.00001;
            leDadDeTaGrandMere.alpha = 1;
            leDadDeTaGrandMere.animation.play("idle");
        case 1024:
            for (i in 0...15)
            {
                new FlxTimer().start(i * 0.3, () -> {
                    var left = FlxG.random.bool(25);
                    var right = FlxG.random.bool(25);
        
                    var broDelay = FlxG.random.float(0, 0.15);
        
                    if (left) {
                        new FlxTimer().start(broDelay, () -> {
                            msknLeToad(3500, -1500, 4.5, true);
                        });
                    }
                    if (right) {
                        new FlxTimer().start(broDelay, () -> {
                            msknLeToad(-1500, 3500, 5, false);
                        });
                    }
                });
            }
            dad.alpha = 1;
            leDadDeTaGrandMere.alpha = 0.00001;
            leDadDeTaGrandMere.animation.stop();
            leDadDeTaGrandMere.kill();
            killSprites(["sol", "solov", "ciel", "montagne"]);
            setAlphaSprites(["solf", "solfov", "cielf", "montagnef", "lum", "lumf"], 1);
            setAlphaSprites(["fire4", "fire3", "fire6", "firetransition", "solf"], 1);
            moveAndFadeSprite(stage.stageSprites["firetransition"], 2000, 1, 0, 1);
        case 1084:
            stage.stageSprites["firetransition"].kill();
        case 1856:
            ncm = true;
            FlxG.camera.follow(camFollow, null, 0.004);
            setAlphaSprites(["lumb2", "lumb"], 0.5);
            tweenSprite(stage.stageSprites["fire4"], {y: -200}, 15);
            tweenSprite(stage.stageSprites["fire5"], {y: 500, alpha: 1}, 23);
            tweenSprite(stage.stageSprites["fire2"], {y: 200, alpha: 1}, 23);
        case 2125:
            FlxG.camera.follow(camFollow, null, 0.01);
        case 2162:
            for (toad in toads)
            {
                remove(toad);
                toad.kill();
                toad.destroy();
            }
            MemoryUtil.clearMajor();
            setAlphaSprites(["fire2","fire3", "fire5","fire4", "solfov"], 0.0000001);
            killSprites(["lumf", "lumb2", "solf", "cielf", "montagnef", "fire6", "lumf", "lum"]);
        case 2163:
            boyfriend.colorTransform.color = 0xFFA90000;
            dad.colorTransform.color = 0xFFA90001;
            boyfriend.x = boyfriend.x + 750;
            for (colo in [stage.stageSprites["lumb"], stage.stageSprites["fire2"], stage.stageSprites["fire4"], stage.stageSprites["fire5"], stage.stageSprites["fire3"]]){
                colo.color = FlxColor.RED;
            }
            defaultCamZoom = 0.35;
            strumLines.members[3].characters[0].kill();
            strumLines.members[2].characters[0].kill(); 
        case 2151:
            stage.stageSprites["lumb"].scale.set(5, 5);
        case 2432:
            dad.colorTransform = new ColorTransform();
            boyfriend.colorTransform = new ColorTransform();
            setAlphaSprites(["fire2","fire3", "fire5","fire4"], 1);    
        case 2686:
            killSprites(["lumb","fire2", "fire4", "fire5", "fire3"]);  
            boyfriend.alpha = 0.00001;
            camGame.scroll.set(400, 500);
            FlxG.camera.followLerp = 0;
        case 2948:
            FlxTween.tween(dad, {alpha:0}, 5);
        case 2960:
            FlxG.camera.followLerp = 0;
        case 3007:
            tweenSprite(stage.stageSprites["cbg"], {alpha: 1}, 6);
        case 3008:
            
            dad.alpha = 0.00001;
        case 3035:
            boyfriend.alpha = 1;
            camGame.scroll.set(650, 700);
            dad.x = dad.x - 150;
            dad.y = dad.y + 450;
            boyfriend.x = boyfriend.x - 800;
            boyfriend.y = boyfriend.y + 350;
        case 3068:
            FlxG.camera.follow(camFollow, null, 0.03);  
            dad.cameraOffset.set(dad.cameraOffset.x+400, dad.cameraOffset.y-300);
            boyfriend.cameraOffset.set(boyfriend.cameraOffset.x-300, boyfriend.cameraOffset.y-200);
            dad.alpha = 1;
        case 3456:
            finalBump = true;
        case 3583:
            finalBump = false;
            camGame.fade(FlxColor.BLACK,6,false);
    }
}


function measureHit(curBeat:Int){
    if (ncm){
        FlxTween.tween(stage.stageSprites["lumb"],{y: 260}, 0.5, {ease: FlxEase.elasticOut});
        stage.stageSprites["lumb"].alpha = 0.9;

        FlxTween.tween(stage.stageSprites["lumb2"],{y: 260}, 0.5, {ease: FlxEase.elasticOut});
        stage.stageSprites["lumb2"].alpha = 0.9;

        for (roh in [stage.stageSprites["lumb"]]){

          FlxTween.tween(stage.stageSprites["lumb"],{y: 200}, 0.9, { ease: FlxEase.linear});
          FlxTween.tween(roh,{alpha: 0.5}, 1);

    }   
    for (roh in [stage.stageSprites["lumb2"]]){

        FlxTween.tween(stage.stageSprites["lumb2"],{y: 200}, 0.9, {ease: FlxEase.linear});
        FlxTween.tween(roh,{alpha: 0.5}, 1);
    }}
}  


/*
function beatHit(curBeat:Int) {
    if (ncm) {
        stage.stageSprites["lumb"].alpha = 0.9;
        stage.stageSprites["lumb2"].alpha = 0.6;
    }
    if (finalBump && curBeat % 2 == 0) {
        camGame.shake(0.03, 0.2);
        stage.stageSprites["cbg"].alpha = 0.8;
    }
}
*/





function update(elapsed:Float) {
    if (finalBump) {
        stage.stageSprites["cbg"].alpha = FlxMath.lerp(stage.stageSprites["cbg"].alpha, 1, elapsed* 4);
    }
}