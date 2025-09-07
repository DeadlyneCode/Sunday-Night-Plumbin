import funkin.game.PlayState;
public var bloom:CustomShader;
var lol = false;
/*defaultHudZoom = 0.82;
camHUD.zoom = 0.82;*/

function create(){
    importScript("data/scripts/hud/4l3");
    var newHUD = importScript("data/scripts/hud/HudV2");
    newHUD.set("HudStyle", "hud_victim");

    newHUD.set("HudScale", 0.5);
    newHUD.set("healthBarBGScale", [0.3, 0.8]);
    newHUD.set("healthBarScale", [0.3, 0.8]);
    newHUD.set("HudScorePositionUpscroll", 698);
    newHUD.set("HudScorePositionDownscroll", 692);
    newHUD.set("defaultFontSize", 15);
    newHUD.set("iconP1Offsets", [1045, (!downscroll)? 20: -10]);
    newHUD.set("iconP2Offsets", [125, (!downscroll)? 10: -3]);
    newHUD.set("iconBump", [0.8,0.7]);
    newHUD.set("hudPosMult", [1.05,2]);
    newHUD.set("HudYBGFactor", 1.046);
    newHUD.set("HudYBarFactor", 1.040); 

if (FlxG.save.data.glow == true) {
    bloom = new CustomShader("glow");
    bloom.size = 3.5; bloom.dim = 1.8;
    FlxG.camera.addShader(bloom);
    camHUD.addShader(bloom);
}

    if (FlxG.save.data.tv == true)
        d = new CustomShader('ntsc');
        camGame.addShader(d);
}


/*function onCameraMove(){
       if (curCameraTarget == 0){
           if (!lol){
               lol = true;
               defaultCamZoom = 0.7; 
           }
       }
       if (curCameraTarget == 1){
           if (lol){
               lol = false;
               defaultCamZoom = 0.9; 
           }
       }
   }*/