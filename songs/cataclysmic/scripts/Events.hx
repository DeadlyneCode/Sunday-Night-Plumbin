var bump = false;
var lol = true;
var intro = true;
function postCreate(){
    camHUD.alpha = 0;
    cpu.characters[1].visible = false;
    camGame.fade(FlxColor.BLACK,0.0000001,false);
}

function onCameraMove(){
    if (intro == false){
        if (curCameraTarget == 0){
            if (!lol){
                lol = true;
                defaultCamZoom = 0.5; 
            }
        }
        if (curCameraTarget == 1){
            if (lol){
                lol = false;
                defaultCamZoom = 0.775; 
            }
        }
    }
    if (intro == true){ //mx
        if (curCameraTarget == 0){
            if (!lol){
                lol = true;
                defaultCamZoom = 0.35; 
            }
        }
        if (curCameraTarget == 1){
            if (lol){
                lol = false;
                defaultCamZoom = 0.6; 
            }
        }
    }
}

function beatHit(curBeat:Int) {
    if (bump == true){
        stage.stageSprites["red"].alpha = 0.8;
        fadeSprite(stage.stageSprites["red"], 0.0, 0.5);
    }
}
function stepHit(curstep:Int){
    switch(curStep) {
        case 64:
            camHUD.alpha = 1;
        case 123:
            defaultCamZoom = 0.4; 
        case 129:
            intro = false;
        case 367:
            defaultCamZoom = 0.65; 
        case 376:
            cpu.characters[0].visible = false;     
        case 383:
            cpu.characters[1].visible = true;     
            updateHealthBarColors();
        case 381:       
            defaultCamZoom = 0.4; 
        case 384:
            setAlphaSprites(["fissure"], 1);
            intro = true;
        case 768:
            bump = true;
    }
}

function updateHealthBarColors() {
    iconP1.setIcon(boyfriend != null ? boyfriend.getIcon() : "face");
    iconP2.setIcon(cpu.characters[1] != null ? cpu.characters[1].getIcon() : "face");

    var leftColor:Int = cpu.characters[1] != null && cpu.characters[1].iconColor != null && Options.colorHealthBar ? cpu.characters[1].iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
    var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
    healthBar.createFilledBar(leftColor, rightColor);
    set_maxHealth(maxHealth); //updates the fucking bar
}