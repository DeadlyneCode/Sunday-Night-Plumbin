import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import funkin.backend.utils.ControlsUtil;

var cutsceneCamText = new FlxCamera();
cutsceneCamText.bgColor = 0;
var subtitleThing;
var warningText;
var dodgeKey = CoolUtil.keyToString(ControlsUtil.getControl(controls, "dodge").inputs[0].inputID);

function postCreate() {
    FlxG.cameras.add(cutsceneCamText, false);
    subtitleThing = new FlxText(0, 600, FlxG.width, "", 36 * 1.75);
    subtitleThing.setFormat(Paths.font("U.ttf"), 18 * 1.75, FlxColor.WHITE, "center");
    subtitleThing.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
    subtitleThing.y = 600;
    subtitleThing.antialiasing = true;
    add(subtitleThing);
    subtitleThing.camera = cutsceneCamText;
    
    warningText = new FlxText(0,0,-1, "", 40);
    warningText.text = getString("heartless_bulletwarning1");
    warningText.font = Paths.font("U.ttf");
    warningText.alpha = 0;
    warningText.camera= camHUD;
    warningText.screenCenter();
    add(warningText);
    
    
}

function destroy() {
    FlxG.cameras.remove(cutsceneCamText);
}

function stepHit(curStep:Int) {
    switch (curStep)
    {
        case 1288:
            subtitleThing.text = getString("heartless_speak1");
            subtitleThing.alpha = 1;
            //then
            
        case 1296:
            FlxTween.cancelTweensOf(subtitleThing);
            subtitleThing.text = getString("heartless_speak2");
            subtitleThing.alpha = 1;
            //then face
            
        case 1304:
            FlxTween.cancelTweensOf(subtitleThing);
            subtitleThing.text = getString("heartless_speak3");
            subtitleThing.alpha = 1;
            //then face me

        case 1316:
            FlxTween.cancelTweensOf(subtitleThing);
            subtitleThing.alpha = 1;
            subtitleThing.text = getString("heartless_speak4");
            // jjust  

        case 1322:
            FlxTween.cancelTweensOf(subtitleThing);
            subtitleThing.alpha = 1;
            subtitleThing.text = getString("heartless_speak5");
            // jjust one

        case 1328:
            FlxTween.cancelTweensOf(subtitleThing);
            subtitleThing.alpha = 1;
            subtitleThing.text = getString("heartless_speak6");
            // jjust one more time pretty please :D 

        case 1294 | 1303 | 1320 | 1326 | 1338:
            FlxTween.tween(subtitleThing, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
            //hide

        case 1344:

        warningText.applyMarkup(applyFiller(getString("heartless_bulletwarning1"), [dodgeKey]),
            [
                new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF44), "*")
            ]
        );

        if(FlxG.save.data.curPowerUp != 3)
        {
            FlxTween.tween(warningText, {alpha:1},0.5);
            new FlxTimer().start(2, ()->{
                FlxTween.tween(warningText, {alpha:0},0.5);
            });
        }
    }
}