import flixel.text.FlxTextBorderStyle;

var cutsceneCamText = new FlxCamera();
cutsceneCamText.bgColor = 0;
var cutsceneText;

function postCreate() {
    FlxG.cameras.add(cutsceneCamText, false);
    cutsceneText = new FlxText(0, 650, FlxG.width, "", 36 * 1.75);
    cutsceneText.setFormat(Paths.font("U.ttf"), 24 * 1.75, FlxColor.WHITE, "center");
    cutsceneText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
    cutsceneText.y = 650;
    cutsceneText.antialiasing = true;
    add(cutsceneText);
    cutsceneText.camera = cutsceneCamText;
}

function destroy() {
    FlxG.cameras.remove(cutsceneCamText);
}

function stepHit(curStep:Int) {
    switch (curStep)
    {
        case 372:
            cutsceneText.text = getString("blessing_speak_1");
            // Do you like Jesus?

        case 390:
            FlxTween.cancelTweensOf(cutsceneText);
            cutsceneText.alpha = 1;
            cutsceneText.text = getString("blessing_speak_2");

            // Have you accepted Jesus into your life?

        case 409:
            FlxTween.cancelTweensOf(cutsceneText);
            cutsceneText.alpha = 1;
            cutsceneText.text = getString("blessing_speak_3");
            // Jesus loves every one of us 

        case 421:
            cutsceneText.text = getString("blessing_speak_4");
            // Get informed by Jesus our lord

        case 442:
            FlxTween.cancelTweensOf(cutsceneText);
            cutsceneText.alpha = 1;
            cutsceneText.text = getString("blessing_speak_5");
            // Jesus accepts all sinners

        case 385 | 406 | 440 | 454:
            FlxTween.tween(cutsceneText, {alpha: 0}, 0.5, {ease: FlxEase.quadInOut});
            //hide
    }
}