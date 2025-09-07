import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;
var t:CustomShader;
var time:Float = 0;
var lol = true;





function create() {
    importScript("data/scripts/hud/4l3");
    var newHUD = importScript("data/scripts/hud/HudV2");
    newHUD.set("HudStyle", "jp_hud");

    newHUD.set("HudScale", 0.5);
    newHUD.set("healthBarBGScale", [0.3, 0.8]);
    newHUD.set("healthBarScale", [0.3, 0.8]);
    newHUD.set("HudScorePositionUpscroll", 698);
    newHUD.set("HudScorePositionDownscroll", 692);
    newHUD.set("defaultFontSize", 15);
    newHUD.set("iconP1Offsets", [1040, (!downscroll)? 20: 0]);
    newHUD.set("iconP2Offsets", [135, (!downscroll)? 10: -3]);
    newHUD.set("iconBump", [0.8,0.7]);
    newHUD.set("hudPosMult", [1.05,2]);
    newHUD.set("HudYBGFactor", 1.046);
    newHUD.set("HudYBarFactor", 1.040); 


       stage.stageSprites["faisceauu"].alpha = 0; 
       stage.stageSprites["faisceauu2"].alpha = 0; 


       
       stage.stageSprites["faisceauu_stage"].origin.y = -2000; 
       stage.stageSprites["faisceauu"].origin.y = 2000; 
       stage.stageSprites["faisceauu2"].origin.y = 2000; 

       FlxTween.tween(stage.stageSprites["faisceauu"], {angle:stage.stageSprites["faisceauu"].angle-23,}, 6, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});
       FlxTween.tween(stage.stageSprites["faisceauu2"], {angle:stage.stageSprites["faisceauu2"].angle+36,}, 6, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});

       FlxTween.tween(stage.stageSprites["faisceauu_stage"], {y:stage.stageSprites["faisceauu_stage"].y +156,}, 2, {type:FlxTween.PINGPONG, ease:FlxEase.sineInOut});

       FlxTween.tween(stage.stageSprites["rond"].scale, {x:2.15, y:2.15}, 2, { type:FlxTween.PINGPONG, ease:FlxEase.sineInOut} );

}

ncm = false;



var zoomChar = true;

function onCameraMove(){
    if (curCameraTarget == 0){
        if (!zoomChar){
            zoomChar = true;
                FlxTween.tween(stage.stageSprites["faisceauu_stage"], {angle: 10,}, 1.8, { ease:FlxEase.quintInOut});
                FlxTween.tween(stage.stageSprites["rond"], {x: 20,}, 1.8, { ease:FlxEase.quintInOut});

        }
    }
    if (curCameraTarget == 1){
        if (zoomChar){
            zoomChar = false;
                    FlxTween.tween(stage.stageSprites["faisceauu_stage"], {angle: -15,}, 1.8, {ease:FlxEase.quintInOut});
                    FlxTween.tween(stage.stageSprites["rond"], {x: 1865,}, 1.8, { ease:FlxEase.quintInOut});

            
        }
    }
}


function measureHit(curBeat:Int){
    if (ncm){
        FlxTween.tween(stage.stageSprites["faisceauu"],{y: 260}, 0.5, {type:  FlxTween.ONESHOOT, ease: FlxEase.elasticOut});
        stage.stageSprites["faisceauu"].alpha = 0.8;

        FlxTween.tween(stage.stageSprites["faisceauu2"],{y: 260}, 0.5, {type:  FlxTween.ONESHOOT, ease: FlxEase.elasticOut});
        stage.stageSprites["faisceauu2"].alpha = 0.8;

        for (roh in [stage.stageSprites["faisceauu"]]){

          FlxTween.tween(stage.stageSprites["faisceauu"],{y: 200}, 0.8, {type:  FlxTween.ONESHOOT, ease: FlxEase.linear});
          FlxTween.tween(roh,{alpha: 0.5}, 1);
    }   
    for (roh in [stage.stageSprites["faisceauu2"]]){

        FlxTween.tween(stage.stageSprites["faisceauu2"],{y: 200}, 0.8, {type:  FlxTween.ONESHOOT, ease: FlxEase.linear});
        FlxTween.tween(roh,{alpha: 0.5}, 1);
    }}
}
   
function postCreate() {
       camHUD.alpha = 0;

    if (FlxG.save.data.tv == true) {
        t = new CustomShader('ntscc');
        camGame.addShader(t);
    }
}

function postUpdate(elapsed:Float) {
		time += elapsed;
        t.iTime = time;
}



function stepHit(curstep:Int){
       switch(curStep) {
              case 1 :
                FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, 6, {ease: FlxEase.linear});
              case 1280:
                stage.stageSprites["faisceauu"].alpha = 1; 
                stage.stageSprites["faisceauu2"].alpha = 1; 
                ncm = true;
              case 1599:

              FlxTween.tween(stage.stageSprites["faisceauu_stage"], {alpha: 0.9,}, 5, { ease:FlxEase.quintOut});
              FlxTween.tween(stage.stageSprites["rond"], {alpha: 0.2,}, 5, { ease:FlxEase.quintOut});

              
       }
}