import funkin.backend.system.GraphicCacheSprite;

var t = new CustomShader('test');

var maxClones = 4;
var clonePool:Array<Character> = [];
var zommingTurn = true;

function postCreate(){

	var newHUD = importScript("data/scripts/hud/HudV2");
    newHUD.set("HudStyle", "hud_cosmic");

	preCache = new GraphicCacheSprite();
    preCache.cache(Paths.image('characters/clone'));

	FlxG.camera.followLerp = 0.04;
	cameraMovementStrength = 30;
	cameraRotate = false;


	if (FlxG.save.data.saturation == true)
		camGame.addShader(t);

	var rocks = stage.stageSprites["rock1"];
	var rocks2 = stage.stageSprites["rock2"];
	var rock3 = stage.stageSprites["rock3"];
	var platGF = stage.stageSprites["ground gf"];
	var plat1 = stage.stageSprites["ground1"];
	var plat2 = stage.stageSprites["ground2"];
	var platclone1 = stage.stageSprites["ground cosmic1"];
	var platclone2 = stage.stageSprites["ground cosmic2"];
	var color = stage.stageSprites["filtre"];
	var fondnoir = stage.stageSprites["fondnoir"];
	var cosmic1 = strumLines.members[0].characters[0];
	var cosmic2 = strumLines.members[0].characters[1];
	

	for (d in strumLines.members[0].characters) {
		d.zoomFactor = 1.1;
	}
	gf.zoomFactor = 0.9;

	plat1.flipX = true;

	FlxTween.tween(rocks, { y: 405}, 2.5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(rock2, { y: 605}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(rock3, { y: 305}, 3, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

	FlxTween.tween(boyfriend, { y: 505}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(cosmic1, { y: 585}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(cosmic2, { y: 585}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(gf, { y: 400}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(dad, { y: 605}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(platGF, { y: 900}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(plat1, { y: 1240}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(plat2, { y: 1240}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
    
	cosmic2.alpha = 0.000001;

	plat2.forceIsOnScreen = true;
	platclone1.forceIsOnScreen = true;
	platclone2.forceIsOnScreen = true;

    var spacing = 50;

	for (i in 0...maxClones) {
		var clone = new Character(dad.x - (i + 1) * spacing, dad.y, "cosmic clone", false);
		clone.scale.set(0.7, 0.7);
		clone.forceIsOnScreen = true;
		clone.zoomFactor = 0.9;
		clone.scrollFactor.set(0.8,0.8);
		clone.alpha = 0.0000001;
		clonePool.push(clone);
		insert(members.indexOf(platGF), clone);
	}

	//ici
	clonePool[0].setPosition(-445, 445);
	clonePool[1].setPosition(-200, 445);
	clonePool[2].setPosition(1950, 445);
	clonePool[3].setPosition(2200, 445);
	clonePool[2].flipX = clonePool[3].flipX = true;
}
function stepHit(){
	var platclone1 = stage.stageSprites["ground cosmic1"];
	var platclone2 = stage.stageSprites["ground cosmic2"];

	switch(curStep){
		case 1024:
			FlxTween.tween(platclone2, { y: 950}, 5, { ease: FlxEase.sineInOut});
			FlxTween.tween(platclone1, { y: 950}, 5, { ease: FlxEase.sineInOut});
		case 1079:
			FlxTween.tween(platclone2, { y: 975}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
			FlxTween.tween(platclone1, { y: 975}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
			for (i in clonePool){
				FlxTween.tween(i, { y: 475}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
			}
		case 1119:
			strumLines.members[0].characters[1].alpha = 1;
			strumLines.members[0].characters[0].alpha = 0;
			FlxTween.tween(fondnoir, { alpha: 0.3}, 0.3, { ease: FlxEase.sineInOut});
			FlxG.camera.followLerp = 0;
			FlxTween.tween(FlxG.camera.scroll, {x: 30, y:550}, 1, {type:  FlxTween.ONESHOOT, ease: FlxEase.quintOut});
			for (i in clonePool){
				i.alpha = 1;
				i.playAnim("hi");
			}
		case 1144:	
			FlxTween.tween(fondnoir, { alpha: 0}, 2, { ease: FlxEase.sineInOut});
		case 1824:
			for (i in clonePool){
				i.playAnim("dance");
			}
		case 2240:	
			FlxTween.tween(fondnoir, { alpha: 0.1}, 0.3, { ease: FlxEase.sineInOut});

		case 2255:	
			FlxTween.tween(fondnoir, { alpha: 0.2}, 0.3, { ease: FlxEase.sineInOut});
		case 2271:	
			FlxTween.tween(fondnoir, { alpha: 0.3}, 0.3, { ease: FlxEase.sineInOut});
		case 2287:	
			FlxTween.tween(fondnoir, { alpha: 0.1}, 0.5, { ease: FlxEase.sineInOut});
		case 2304:
			FlxG.camera.followLerp = 0;
			FlxTween.tween(fondnoir, { alpha: 0.4}, 0.3, { ease: FlxEase.sineInOut});
			FlxTween.tween(FlxG.camera.scroll, {x: 0}, 3.5, {type:  FlxTween.ONESHOOT, ease: FlxEase.quintOut});
			FlxTween.tween(FlxG.camera.scroll, {y: 550}, 3.5, {type:  FlxTween.ONESHOOT, ease: FlxEase.quintOut});



			for (c=>clone in clonePool) {
        	  var isB:Bool = (c==1 || c==2);
        	  clone.playAnim(isB ? "dancedieb" : "dancedie");
			}

	}
}

function onEvent(e){
	if (e.event.name == "Change Character"){
		new FlxTimer().start(5, function(tmr:FlxTimer) {
			FlxTween.tween(dad, { y: 585}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
		});
	}
}



function onCameraMove(){
    if (curCameraTarget == 0){
        if (!zommingTurn){
            zommingTurn = true;
            defaultCamZoom = 0.5; 
        }
    }
    if (curCameraTarget == 1){
        if (zommingTurn){
            zommingTurn = false;
            defaultCamZoom = 0.4; 
        }
    }
}

function onCountdown(event) {
	event.soundPath = 'intro/cosmic/' + event.soundPath;
}

function postUpdate(elapsed:Float) {
	if (downscroll)
		for (i in [iconP1, iconP2])
			if (i != null)
				i.y += 10;
}