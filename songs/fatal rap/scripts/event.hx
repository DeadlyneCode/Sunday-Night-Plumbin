
var bump = false;

function onCountdown(event){
    event.cancelled = true;
} 

function create(){
    camGame.fade(FlxColor.BLACK,0.0000001,false);
    bird = new FunkinSprite(340, 155);
	bird.loadSprite(Paths.image("stages/die/pige"));
    bird.antialiasing = true;
    bird.alpha = 0.001;
    bird.scrollFactor.set(0.9, 0.9);
    bird.animation.addByPrefix('idlee', 'idle', 24, false);
    bird.animation.addByPrefix('go', 'arrive', 20, false);
    bird.animation.addByPrefix('bye', 'bye', 24, false);
    bird.addOffset("go", -3, 12);
    insert(members.indexOf(stage.stageSprites["bg"])+1, bird);
} 

function beatHit(curBeat:Int) {
    if (bump == true)
        bird.playAnim('idlee');
}


function postCreate(){
    camHUD.alpha = 0;
    camGame.scroll.set(-250, -200);
    FlxG.camera.followLerp = 0;

    fade = new FlxSprite();
    fade.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    add(fade);
    fade.alpha = 0;
    fade.cameras = [camHUD];
}

function stepHit(curStep:Int){
    switch(curStep){       
        case 1: 
            FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1}, 15, {ease: FlxEase.quadInOut});
            FlxTween.tween(stage.stageSprites["ciel2"], {alpha: 0}, 200, {ease: FlxEase.linear});
            FlxTween.tween(stage.stageSprites["filtre2"], {alpha: 0}, 200, {ease: FlxEase.linear});
            FlxTween.tween(FlxG.camera.scroll, {y: 0}, 10, {type:  FlxTween.ONESHOOT, ease: FlxEase.quadOut});
            FlxTween.tween(FlxG.camera.scroll, {x: -100}, 10, {type:  FlxTween.ONESHOOT, ease: FlxEase.quadOut});
        case 65:
            FlxG.camera.follow(camFollow, null, 0.03);
            FlxTween.tween(camHUD, {alpha: 1}, 0.6, {ease: FlxEase.linear}); 
            
            
            
        case 923:
            bird.alpha = 1;
            bird.playAnim('go');
            new FlxTimer().start(1.4, function(tmr:FlxTimer){
                bird.setPosition(420, 240);
                bird.playAnim('idlee');
                bump = true;
            });
        case 1710:
            bird.stopAnim('idle');
            bump = false;
        case 1715:
            bird.setPosition(375, 185);
            bird.playAnim('bye');
        case 1744:
            FlxTween.tween(fade, {alpha: 1}, 2, {ease: FlxEase.linear});  
    }
}

