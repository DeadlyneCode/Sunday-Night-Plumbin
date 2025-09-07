import flixel.addons.effects.FlxTrail;

var devil_cut = strumLines.members[0].characters[1];
var devil = strumLines.members[0].characters[0];

var epic = false;
var toAdd:Bool = false;

var trail:FlxTrail;
var outerTrail:FlxTrail;

function postCreate() {
    camGame.scroll.set(-150, 100);
    FlxG.camera.followLerp = 0;

    devil_cut.y = 760;
    devil_cut.x = devil_cut.x - 67;
    devil_cut.alpha = 0.001;
    
    trail = new FlxTrail(dad, null, 25, 8, 0.7, 0.08);
    trail.color = 0xFFFF0000;

    outerTrail = new FlxTrail(dad, null, 30, 10, 0.6, 0.05);
    outerTrail.color = 0xFFFF4444;

    camGame.fade(FlxColor.BLACK,0.0000001,false);

    camHUD.alpha = 0;

}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 0:
            stage.stageSprites["lum"].alpha = 0;
        case 31:
            FlxTween.tween(camGame.scroll, {y: 525}, 7.5, {ease: FlxEase.cubeInOut});
        case 129:
            FlxG.camera.follow(camFollow, null, 0.03);
            fadeSprite(camHUD, 1, 1);
        case 1288:
            devil_cut.alpha = 1;
            devil.alpha = 0.0001;
        case 1344:
            devil_cut.alpha = 0;
            devil.alpha = 1;
        case 1664:
            epic = true;
        case 1984:
            epic = false;

            PlayState.instance.members.remove(trail, true);
            PlayState.instance.members.remove(outerTrail, true);
        case 1985:
            stage.stageSprites["lum"].alpha = 0.0000001;
        case 2240:
            stage.stageSprites["lum"].alpha = 0.4;
        case 2250:
            moveSprites(["toad marchr1", "toad marchr2"], {x: "-300"}, 50);
            moveSprites(["toad marchrm"], {x: "-300"}, 70);
            moveSprites(["toad marchl1", "toad marchl2"], {x: "+1200"}, 50);
            moveSprites(["toad marchlm"], {x: "+1200"}, 70);
    }
}

function beatHit(curBeat:Int) {
    trace(curBeat);
    if (epic == true) {
        FlxTween.cancelTweensOf(stage.stageSprites["lum"]);
        stage.stageSprites["lum"].alpha = 0.5;
        FlxTween.tween(stage.stageSprites["lum"], {alpha: 0.2}, 0.5, {ease: FlxEase.quadIn});
    }
}

function update(elapsed) {

	if(epic && !toAdd) {
		toAdd = true;
		PlayState.instance.insert(PlayState.instance.members.indexOf(dad), trail);
        PlayState.instance.insert(PlayState.instance.members.indexOf(dad), outerTrail);
	}
}