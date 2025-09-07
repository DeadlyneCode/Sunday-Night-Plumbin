import flixel.text.FlxTextBorderStyle;

var cutsceneCamText = new FlxCamera();
cutsceneCamText.bgColor = 0;
var cutsceneText;

function postCreate() {
    FlxG.cameras.add(cutsceneCamText, false);
    cutsceneText = new FlxText(0, 600, FlxG.width, "", 36 * 1.75);
    cutsceneText.setFormat(Paths.font("U.ttf"), 18 * 1.75, FlxColor.WHITE, "center");
    cutsceneText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
    cutsceneText.y = 600;
    cutsceneText.antialiasing = true;
    add(cutsceneText);
    cutsceneText.camera = cutsceneCamText;
    camGame.fade(FlxColor.BLACK,0.0000001,false);
}

function destroy() {
    FlxG.cameras.remove(cutsceneCamText);
}

function stepHit(curStep:Int) {
    switch (curStep)
    {
        case 313:
            cutsceneText.text = getString("iceberg_speak_1");
            //here i go

        case 720:
            FlxTween.cancelTweensOf(cutsceneText);
            cutsceneText.alpha = 1;
            cutsceneText.text = getString("iceberg_speak_2");
            // you think this is fun (your english is fun)

        case 736:
            FlxTween.cancelTweensOf(cutsceneText);
            cutsceneText.alpha = 1;
            cutsceneText.text = getString("iceberg_speak_3");
            // you gotta be coo coo crazy

        case 1019:
            FlxTween.cancelTweensOf(cutsceneText);
            cutsceneText.alpha = 1;
            cutsceneText.text = getString("iceberg_speak_4");
            //FIRE!!!!

        case 320 | 732 | 749 | 1024:
            FlxTween.tween(cutsceneText, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
            //hide
    }
}