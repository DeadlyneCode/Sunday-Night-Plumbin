function postCreate(){
    var hud = importScript("data/scripts/hud/HudV2");
    hud.set("HudStyle", "hud_maltigi2");
    hud.set("defaultFontColor", FlxColor.RED);
    hud.set("defaultFont", "me.ttf");
    hud.set("defaultFontSize", 36);
    hud.set('textY', 7.5);

    boyfriend.alpha = 0;

if (FlxG.save.data.tv == true)

    d = new CustomShader('ntscc');

    
    camGame.addShader(d);
    camHUD.addShader(d);
}

function stepHit(){
    switch(curStep){
        case 1713:
            dad.visible = false;
    }
}

var lol = true;

function onCameraMove(){
    if (curCameraTarget == 0){
        if (!lol){
            lol = true;
            defaultCamZoom = 0.5; 
        }
    }
    if (curCameraTarget == 1){
        if (lol){
            lol = false;
            defaultCamZoom = 0.6; 
        }
    }
}