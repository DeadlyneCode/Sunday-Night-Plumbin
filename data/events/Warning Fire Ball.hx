var imgwar:FlxSprite;

function onEvent(eventEvent) {
    if (eventEvent.event.name == "Warning Fire Ball" && FlxG.save.data.curPowerUp != 3) {
        imgwar.visible = true;
        FlxG.sound.play(Paths.sound("warning-fire-ball"), 0.7);
    } else if(eventEvent.event.name == "Fire Ball") {
        imgwar.visible = false;
    } else {
        new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                imgwar.visible = false;
            });
    }
}

function postCreate() {
    imgwar = new FlxSprite();
	imgwar.frames = Paths.getSparrowAtlas('stages/betrayed/warning');
    imgwar.animation.addByPrefix('war', 'warning', 24, true);
	imgwar.animation.play('war', false);
	imgwar.antialiasing = false;
	imgwar.cameras = [camHUD];
    imgwar.visible = false;
	imgwar.updateHitbox();
    imgwar.screenCenter();
	add(imgwar);


    FlxG.sound.load(Paths.sound("warning-fire-ball"));
}