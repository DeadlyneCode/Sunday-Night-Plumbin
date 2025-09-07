var time:Float = 0;
var timer = 0;
var numShit = 1;

function postCreate(){
    var newHUD = importScript("data/scripts/hud/HudV2");
    newHUD.set("HudStyle", "hud_mx");
    newHUD.set("HudScale", 1);
    newHUD.set("HudScorePositionUpscroll", 683);
    newHUD.set("HudScorePositionDownscroll", 678);
    newHUD.set("defaultFontSize", 18);

    newHUD.set("HudAnimated", true);


    if (FlxG.save.data.tv == true) {
        d = new CustomShader('ntscc');
        camGame.addShader(d);

        t = new CustomShader('old tv');
        camGame.addShader(t);
    }
}