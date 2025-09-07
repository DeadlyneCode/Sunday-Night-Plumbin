import flixel.addons.display.FlxBackdrop;
import funkin.savedata.FunkinSave;

//var txtGroup:FlxGroup();
var txtOPP = ["score", "miss"];
var scLerp:Int = 0;
var missLerp = 0;

var options:Array<Dynamic> = ["exit", "retry"];
var buttons:FlxSpriteGroup;

var curSelect:Int = 0;
var canSelect:Bool = false;

var score:Int = PlayState.instance.songScore;
var misses:Int = PlayState.instance.misses;

var rankMusic:FlxSound;
var rankJingle:FlxSound;

var txtGroup:FlxGroup;
var rating:String = "F";
//score and miss speed and scale
	var lerpSpeed1 = 2;
	var lerpSpeed2 = 1;
	var canLerp = false;
	var validsc1 = false;
	var validsc2 = false;

function create() {
	camScore = new FlxCamera();
	FlxG.cameras.add(camScore, false);

	d = new CustomShader('flouv2');
	d.Size = 3;

	scoreBG = new FunkinSprite(0, 0);
	scoreBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
	scoreBG.screenCenter();
	scoreBG.scale.set(5, 5);
	scoreBG.cameras = [camScore];
	add(scoreBG);

	var panorama = new FlxBackdrop(Paths.image("states/score/motif"));
	panorama.velocity.x = 25;
	panorama.velocity.y = 10;
	panorama.alpha = 0.2;
	panorama.cameras = [camScore];
	panorama.blend = 0;
	panorama.scale.set(0.7, 0.7);
	add(panorama);

	//panorama.shader(d);
	panorama.shader = d;

	var black = new FunkinSprite(485, 50, Paths.image("states/score/base"));
	black.antialiasing = true;
	black.cameras = [camScore];
	add(black);

	var icon = new FunkinSprite(1000, 32, Paths.image((state.curSong != "heartless")? "states/score/bf-icon":"states/score/pico-icon" ));
	icon.scale.set(0.65, 0.65);
	icon.antialiasing = true;
	icon.cameras = [camScore];
	add(icon);

	var rank = new FunkinSprite(1055, 312.5, Paths.image("states/score/rank"));
	rank.antialiasing = true;
	rank.cameras = [camScore];
	add(rank);

	var yellowUp = new FunkinSprite(485, 50, Paths.image("states/score/bar"));
	yellowUp.antialiasing = true;
	yellowUp.cameras = [camScore];
	add(yellowUp);

	flag = new FunkinSprite(200, 525, Paths.image("states/score/flag"));
	flag.antialiasing = true;
	flag.cameras = [camScore];
	flag.scale.set(0.6, 0.6);
	flag.animation.addByPrefix("normal", "flag");
	flag.animation.play("normal");
	add(flag);

	var yellowBottom = new FunkinSprite(475, 550).loadGraphic(Paths.image("states/score/bottom"));
	yellowBottom.antialiasing = true;
	yellowBottom.cameras = [camScore];
	add(yellowBottom);
	
	title = new FlxText(yellowUp.x+35,yellowUp.y+10,5000, getString("results_title"),60);
	add(title);
	title.setFormat(Paths.font("U.ttf"), 70, 0xFF282828, "left");
	title.antialiasing = true;
	title.cameras = [camScore];
	title.updateHitbox();

	txtGroup = new FlxGroup();
	txtGroup.cameras =  [camScore];

	cubeGroup = new FlxGroup();
	cubeGroup.cameras =  [camScore];

	for (s=>stat in ["score", "misses"]) {
		var box:FunkinSprite = new FunkinSprite(500 - 12.5 * s, 210 + 125 * s, Paths.image("states/score/bar"));
		box.scale.set(0.9, 0.75);
		box.updateHitbox();
		box.antialiasing = true;
		box.cameras = [camScore];
		cubeGroup.add(box);

		label = new FunkinText(box.x + 15,box.y + 10, box.width, applyFiller(getString("results_" + stat), ["0"]),40);
		txtGroup.add(label);
		label.cameras = [camScore];
		label.setFormat(Paths.font("U.ttf"), 48, 0xFF282828, "left");
		label.alpha = box.alpha = 0;
		label.antialiasing = true;


		label.scale.set(1.2, 1.2);
		box.scale.set(1.2, 1.2);


	}

	buttons = new FlxSpriteGroup();
	buttons.cameras = [camScore];
	add(buttons);

	for (o=>option in options) {
		var button:FunkinSprite = new FunkinSprite(525 + 332.5 * o, 575, Paths.image("states/score/button"));
		button.antialiasing = true;
		button.ID  = o;
		buttons.add(button);

		var label:FunkinText = new FunkinText(button.x, button.y + 10, button.width, getString("results_" + option));
		label.setFormat(Paths.font("U.ttf"), 48, 0xFF282828, "center");
		label.ID = o;
		label.antialiasing = true;
		buttons.add(label);
	}

	changeColor();
	changeSelect(0, true);
	add(cubeGroup);
	add(txtGroup);
	

	new FlxTimer().start(0.75, ()->{
		canLerp = true;
		FlxG.sound.play(Paths.sound("score1"));
	});
	new FlxTimer().start(3, ()->{
		lerpSpeed1 = 5;

	});

	rating = PlayState.instance.curRating.rating;
	if (score < 0 || rating == "[N/A]")
		rating = "F";

	rankTxt = new FunkinText(rank.x + 30,rank.y + 27.5, rank.width, rating, 40);
	add(rankTxt);
	rankTxt.cameras = [camScore];
	rankTxt.setFormat(Paths.font("SuperMario256.ttf"), 102, 0xFF282828, "left");
	rankTxt.scale.set(1.2, 1.2);
	rankTxt.alpha = 0; 

	var flagpole = new FlxSprite(207.5, 155).loadGraphic(Paths.image('states/score/flagpole'));
	flagpole.scale.set(0.65, 0.65);
	flagpole.cameras = [camScore];
	flagpole.updateHitbox();
	add(flagpole);

	bf = new FunkinSprite((state.curSong == "heartless")? 250:-180, (state.curSong == "heartless")?600:425);
	if(state.curSong == "heartless"){
		bf.loadSprite(Paths.image('states/score/pico'));
		bf.flipX = true;
		bf.animateAtlas.anim.addBySymbol('loop', 'loop', 24, true);
	}

	else
		bf.loadSprite(Paths.image('states/score/bf'));
	bf.animateAtlas.anim.addBySymbol('onTop', (state.curSong != "heartless")?'anim/s':'start', 24, false);
	bf.animateAtlas.anim.addBySymbol('middle', (state.curSong != "heartless")?'anim/b' :'start', 24, false);
	bf.animateAtlas.anim.addBySymbol('bottom', (state.curSong != "heartless")?'anim/c' :'start', 24, false);
	bf.animateAtlas.anim.addBySymbol('fall', (state.curSong != "heartless")?'anim/d' :'start', 24, false);
	if(state.curSong != "heartless"){
		bf.addOffset("middle", 400, 400);
		bf.addOffset("fall", 0, -90);
		bf.alpha = 0.000000001;
	}

	bf.antialiasing = true;
	bf.cameras = [camScore];
	bf.scale.set(0.6, 0.6);
	bf.updateHitbox();
	if(state.curSong == "heartless"){
		bf.playAnim("onTop");
		insert(members.indexOf(flagpole)-10, bf);
	}

	else
	add(bf);
}
var frame:Int;

function postUpdate(elapsed:Float) {
	if(canLerp)
		lerpSC(elapsed);
	if(validsc2 && validsc1)
		setRank(elapsed);
	frame++;
}

function lerpSC(elapsed){
	var sc = score-1;
	var ms = misses-1;
	//scale and lerp shit
	scLerp = FlxMath.lerp(scLerp, score, elapsed*lerpSpeed1);
	txtGroup.members[0].text = applyFiller(getString("results_score"), [Math.round(scLerp)]);
	for (i in [cubeGroup.members[0], txtGroup.members[0]]){
		i.alpha = 1;
		i.scale.set(FlxMath.lerp(i.scale.x, 1, elapsed*8),FlxMath.lerp(i.scale.y, 1, elapsed*8));
	}

	if(scLerp >= sc){
		missLerp = FlxMath.lerp(missLerp, misses, elapsed*8);
		txtGroup.members[1].text = applyFiller(getString("results_misses"), [Math.round(missLerp)]);
	}

	if(missLerp == misses)
		validsc2 = true;

	//audio Shit gestion
	if (scLerp < sc && frame>4){
		FlxG.sound.play(Paths.sound("scoret"));
		frame = 0;
	}
	if(scLerp >= sc && !validsc1){
		validsc1 = true;
		FlxG.sound.play(Paths.sound("score2"));
		cubeGroup.members[1].alpha = txtGroup.members[1].alpha = 1;
	}

		for (i in [cubeGroup.members[1], txtGroup.members[1]]){
			if(i.alpha == 1)
				i.scale.set(FlxMath.lerp(i.scale.x, 1, elapsed*8),FlxMath.lerp(i.scale.y, 1, elapsed*8));
		}
	if (missLerp < ms && validsc1 && frame>4){
			FlxG.sound.play(Paths.sound("scoret"));
			frame = 0;
	}

	if(missLerp >= ms)
		validsc2 = true;
	if (controls.ACCEPT){
		canLerp = false;
		validsc2 = validsc1 = true;
	}
}
//verif var
	var canPlayAnim = true;
	var showRank = true;
function setRank(elapsed){
	canSelect = true;
	txtGroup.members[0].text = applyFiller(getString("results_score"), [score]);
	txtGroup.members[1].text = applyFiller(getString("results_misses"), [misses]);
	for (i in [cubeGroup.members[1], txtGroup.members[1], cubeGroup.members[0], txtGroup.members[0]]){
			i.scale.set(FlxMath.lerp(i.scale.x, 1, elapsed*8),FlxMath.lerp(i.scale.y, 1, elapsed*8));
			i.alpha = 1;
	}
	if(showRank){
		showRank = false;
		new FlxTimer().start(1,()->{
			FlxG.sound.play(Paths.sound("score3"));
			rankTxt.alpha = 1;
		});
	}
	if(rankTxt.alpha == 1)
		rankTxt.scale.set(FlxMath.lerp(rankTxt.scale.x, 1, elapsed*8),FlxMath.lerp(rankTxt.scale.y, 1, elapsed*8));


	if(canPlayAnim){
		canPlayAnim = false;
		new FlxTimer().start((state.curSong == "heartless")?1.45:1.3,()->{
			bf.alpha = 1;
			switch(state.curRating.rating){
				case "S++"|"S"|"A":
					
					bf.playAnim((state.curSong != "heartless")?"onTop":"loop");
					rankJingle = FlxG.sound.load(Paths.sound('Sjingle'));
                    rankMusic = FlxG.sound.load(Paths.sound('S'));
                    rankJingle.play();
					rankMusic.looped = true;
                    rankJingle.onComplete = rankMusic.play;
					FlxTween.tween(flag, {y: 156}, 0.7, {ease: FlxEase.quadOut});
				case "B"|"C":
					bf.playAnim((state.curSong != "heartless")?"middle":"loop");
                    rankMusic = FlxG.sound.load(Paths.sound('good'));
                    rankMusic.play();
					FlxTween.tween(flag, {y: 185}, 0.7, {ease: FlxEase.quadOut});
				case "D"|"E":
					bf.playAnim((state.curSong != "heartless")?"bottom":"loop");
                    rankMusic = FlxG.sound.load(Paths.sound('mid'));
                    rankMusic.play();
					FlxTween.tween(flag, {y: 340}, 1, {ease: FlxEase.quadOut});
				case "F":
					bf.playAnim((state.curSong != "heartless")?"fall":"loop");
					rankJingle = FlxG.sound.load(Paths.sound('bad intro'));
                    rankMusic = FlxG.sound.load(Paths.sound('bad'));
					FlxTween.tween(flag, {y: 510}, 0.8, {ease: FlxEase.quintOut});
					//510 = F 0.8 
					//340 = D/E 1 
					//185 = B/C 0.7 
				default:
					bf.playAnim((state.curSong != "heartless")?"fall":"loop");
					rankJingle = FlxG.sound.load(Paths.sound('bad intro'));
                    rankMusic = FlxG.sound.load(Paths.sound('bad'));
					rankMusic.play();
			}
		});
	}

	
}
function update(elapsed) {
	if (canSelect) {
		if (controls.LEFT_P || controls.RIGHT_P)
			changeSelect((controls.LEFT_P ? -1 : 0) + (controls.RIGHT_P ? 1 : 0), false);
		if (controls.ACCEPT)
			confirmSelect();
	}
}

function changeSelect(select:Int, force:Bool) {
	if (!force) {
		if (select == 0)
			return;

		CoolUtil.playMenuSFX();
	}

	curSelect = FlxMath.wrap(curSelect + select, 0, options.length-1);

	for (spr in buttons) {
	  if (spr.ID == curSelect) { 
			FlxTween.tween(spr.scale, {x: 1.075, y: 1.075}, 0.2, {ease: FlxEase.quadInOut});
			FlxTween.tween(spr, {alpha: 1}, 0.2, {ease: FlxEase.quadInOut});
	  
    }else{
			FlxTween.tween(spr.scale, {x: 1.0, y: 1.0}, 0.2, {ease: FlxEase.quadInOut});
			FlxTween.tween(spr, {alpha: 0.75}, 0.2, {ease: FlxEase.quadInOut});
		}
	}
}

function confirmSelect() {

	if (rankMusic != null)
		rankMusic.stop();
	if (rankJingle != null)
    	rankJingle.stop();

	canSelect = false;

	CoolUtil.playMenuSFX(1);

	for (spr in buttons)
		if (curSelect == spr.ID)
			FlxTween.tween(spr.scale, {x: 1, y: 1}, 1, { ease: FlxEase.backInOut});

	FlxG.cameras.remove(camScore, true);

	new FlxTimer().start(1.1, ()-> {
		switch (options[curSelect]) {
			case 'exit':
				switch(state.curSong){
					case "poltergeist":
					if(FlxG.save.data.hasFinishedPolter == false){
						FlxTween.tween(FlxG.sound.music, {volume: 0}, 1.0, {ease: FlxEase.quadInOut});
							FlxG.camera.fade(FlxColor.BLACK, 1.2, false, ()->{
						PlayState.instance.endSong();
							FlxG.switchState(new ModState('thanksToPlay'));
						});
					}
					else
							PlayState.instance.endSong();
					default:
                    PlayState.instance.endSong();
				}			
			case 'retry':
				PlayState.instance.endSong();
				FlxG.resetState();
				
		}
	});
}


function changeColor() {
	var fadeColor = FlxColor.fromString(PlayState.SONG.meta.end.fadeColor);

	var colors:Array<Int> = [
		FlxColor.fromString(PlayState.SONG.meta.end.startColor),
		FlxColor.fromString(PlayState.SONG.meta.end.midColor),
		FlxColor.fromString(PlayState.SONG.meta.end.endColor)
	];

	scoreBG.color = fadeColor;

	var currentIndex:Int = 0;

	var fadeToNextColor;
	fadeToNextColor = function() {
		currentIndex = (currentIndex + 1) % colors.length;
		var nextColor = colors[currentIndex];

		FlxTween.color(scoreBG, 2, scoreBG.color, nextColor, {
			type: FlxTween.ONESHOT,
			onComplete: fadeToNextColor
		});
	};
	fadeToNextColor();
}