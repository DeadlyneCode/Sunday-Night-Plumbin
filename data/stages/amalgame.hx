var lol = true;
var t = new CustomShader('amalgam');
var t3 = new CustomShader('ntscc');

var cambf = 0.8;
var camdad = 1.2;
var canShake = false;
var zoomChar = true;
var camauto = true;

function onCameraMove(){
    if (curCameraTarget == 0 && !zoomChar && camauto){
            zoomChar = true;
            FlxTween.tween(FlxG.camera, {zoom: camdad}, 1.5, {ease: FlxEase.quintOut, onComplete: ()->{
                defaultCamZoom = camdad;
            }
            });
 
      }
    if (curCameraTarget == 1 && camauto && zoomChar){
            zoomChar = false;
            FlxTween.tween(FlxG.camera, {zoom: cambf}, 2, {ease: FlxEase.quintOut, onComplete: ()->{
                defaultCamZoom = cambf;
            }
        });
    }

}
// 0, 522, 375
function create(){
    var tier = importScript("data/scripts/hud/4l3a");
    tier.set("pos", 175);

    importScript("data/scripts/hud/hud3313");

    if (FlxG.save.data.saturation == true){
        camGame.addShader(t);
    }
               // stage.stageSprites["bg"].visible= false;

}


if (FlxG.save.data.saturation == true) camGame.addShader(t3);


function onDadHit(){
    if (canShake)
        camGame.shake(0.002, 0.1);
}
function camShit(isDad, x, y){
    if (isDad ==  "true")
        dad.cameraOffset.set(x, y);
    else
        boyfriend.cameraOffset.set(x, y);
}
var canLightBump = false;
var oldRdm=0;
var rdm;
function beatHit(curBeat){
    if(canLightBump){
        if(curBeat %2 == 0){
            rdm = FlxG.random.int(1,4, [oldRdm]);
            stage.stageSprites["light"+rdm].alpha = 1;
            oldRdm = rdm;
        }

    }
}
function update(elapsed:Float) {
    for (i in [stage.stageSprites["light1"], stage.stageSprites["light2"], stage.stageSprites["light3"], stage.stageSprites["light4"]]){
        if(i != null && canLightBump)
        i.alpha = FlxMath.lerp(i.alpha, 0.000001, elapsed);
    }
}
function stepHit(){
    switch(curStep){
        case 126:
            camauto = true;
        case 385:   
            camGame.scroll.set(-650, -200);
            FlxG.camera.followLerp = 0;
            for (i in [stage.stageSprites["bg"]]) i.kill();
            for (i in [stage.stageSprites["plarp2"], stage.stageSprites["pilarP2"], stage.stageSprites["floorP2"], stage.stageSprites["fondP2"]]) i.alpha = 0.000001;
        case 630:
            FlxTween.tween(FlxG.camera, {angle: -30}, 0.8, {ease: FlxEase.backIn});
            FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.8, {ease: FlxEase.backIn});    
        case 640:
            FlxG.camera.angle = -2.5;
            camGame.scroll.set(0, -100);
            FlxG.camera.follow(camFollow, null, 0.03);
            canShake = true;
            cambf = cambf = 1.2;
            camdad = camdad = 0.6;
            dad.alpha = 1;
            for (i in [stage.stageSprites["plarp2"], stage.stageSprites["pilarP2"], stage.stageSprites["floorP2"], stage.stageSprites["fondP2"]]) i.alpha = 1;
            // stage.stageSprites["light1"].alpha = stage.stageSprites["light2"].alpha = stage.stageSprites["light3"].alpha = stage.stageSprites["light4"].alpha = 0.75;
            canLightBump = true;
        case 1400:
            var last = [stage.stageSprites["plarp2"], stage.stageSprites["pilarP2"], stage.stageSprites["floorP2"], stage.stageSprites["fondP2"],  stage.stageSprites["light1"], stage.stageSprites["light2"], stage.stageSprites["light3"], stage.stageSprites["light4"]];
            
            for (i in 0...last.length){
                    FlxTween.tween(last[i], { y: 1500 }, 1.4 + i * 0.2, { ease: FlxEase.backInOut , onComplete: ()->{
                        last[i].destroy();
                        stage.stageSprites["main"].alpha = stage.stageSprites["mid"].alpha = stage.stageSprites["wall"].alpha = 1;
                        dad.setPosition(514, -10);
                        canLightBump = false;
                    }
                });
            }
        case 1423:

            boyfriend.setPosition(-365, 104.5);
            boyfriend.scale.set(0.8,0.8);
    }
}