import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.assets.ModsFolder;

var lol = true;
public var bloom:CustomShader;

function onCameraMove(){


    if (curCameraTarget == 0){
        if (!lol){
            lol = true;
            defaultCamZoom = 0.85; 
        }
    }
    if (curCameraTarget == 1){
        if (lol){
            lol = false;
            defaultCamZoom = 0.65; 
        }
    }
}
function postCreate() {
  camHUD.alpha = 0; 
}

function create() {
    importScript("data/scripts/hud/HudRoblox");
    if (FlxG.save.data.glow == true) {
        bloom = new CustomShader("glow");
        bloom.size = 3.5; bloom.dim = 1.8;
    }

    boyfriend.forceIsOnScreen = true;
    
    d = new CustomShader('studyRoblox');

    camGame.addShader(d);
   
}

function stepHit(curStep:Int){
    switch(curStep){       
        case 320:
            if (FlxG.save.data.glow == true)
                camGame.addShader(bloom);
        case 448:
            camGame.addShader(null);
    }
}