import flixel.tweens.FlxTweenType;

var t:CustomShader;
var time:Float = 0;

function onCameraMove() {
    if (curCameraTarget == 0) {
       defaultCamZoom = 0.775; 
    }
    if (curCameraTarget == 1) {
        defaultCamZoom = 0.67; 
    }
}

function postUpdate(elapsed:Float) {
	if (FlxG.save.data.tv == true){
		time += elapsed;
        d.iTime = time;
        c.iTime = time;
    }
}

function postCreate() {
    importScript("data/scripts/hud/Hud64");
    if (FlxG.save.data.saturation == true) {
        t = new CustomShader('test2');

        //b = new CustomShader('old tv');

        t.blend = 1;
        camGame.addShader(t);
        
        //camHUD.addShader(b);
    }

    if (FlxG.save.data.tv == true) {
        d = new CustomShader('ntscc'); //effet vhs
        o = new CustomShader('old tv'); //distorsion fish-eye
        c = new CustomShader('tvc');

            
        camGame.addShader(d);
        camGame.addShader(o);
        camGame.addShader(c);
    }
    camHUD.zoom = 0.775;
    defaultHudZoom = 0.775;

    dad.zoomFactor = 0.5;
    boyfriend.origin.set(-5, 189);
    FlxTween.tween(boyfriend.scale, {x: 0.75, y:0.75}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.circlInOut});
    stage.stageSprites["jambe"].origin.set(200, 50);
    FlxTween.tween( stage.stageSprites["jambe"].scale, {x: 0.75, y:0.75}, 1, {type: FlxTweenType.PINGPONG, ease: FlxEase.circlInOut});
}

function stepHit(curStep:Int){
    switch (curStep){
        case 311:
            //t.blend = 0;
            if (FlxG.save.data.saturation == true)
                FlxTween.num(1, 0.4, 0.5, { easing: FlxEase.quintIn }, function(tweenVal){
                    t.blend = tweenVal;
                });
        case 449:
            if (FlxG.save.data.saturation == true)
                FlxTween.num(0, 1, 0.2, { easing: FlxEase.quintIn }, function(tweenVal){
                    t.blend = tweenVal;
                });
        case 511:
            if (FlxG.save.data.saturation == true)
                FlxTween.num(1, 0.4, 0.2, { easing: FlxEase.quintIn }, function(tweenVal){
                    t.blend = tweenVal;
                });
    }
}