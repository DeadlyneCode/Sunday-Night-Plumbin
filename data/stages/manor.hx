var t3 = new CustomShader('ntscc');

function postCreate() {
    var hud = importScript("data/scripts/hud/HudV2");
    hud.set("HudStyle", "Game_Boy");
    hud.set("HudScorePositionUpscroll", 692);  

    camGame.fade(FlxColor.BLACK,0.0000001,false);

}

function create(){
    d = new CustomShader("studyRoblox"); 
    camGame.addShader(d);

    camHUD.alpha = 0;

    if (FlxG.save.data.tv == true){

        camGame.addShader(t3);
    }
}
