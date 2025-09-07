var firstText = true;
var tbh:FlxSound = new FlxSound();
var num=2;
function create() {
	text = new FlxText(0, 120, FlxG.width - 50, getString("credits1"));
	text.setFormat(Paths.font("U.ttf"), 32, FlxColor.WHITE, "center");
	text.updateHitbox();
	text.antialiasing = true;
	text.alpha = 0;
	add(text);
	text.screenCenter();

	text2 = new FlxText(0, 50, FlxG.width - 50, getString("credits2"));
	text2.setFormat(Paths.font("U.ttf"), 32, FlxColor.WHITE, "center");
	text2.updateHitbox();
	text2.antialiasing = true;
	text2.alpha = 0;
	add(text2);
	text2.screenCenter();

	text3 = new FlxText(0, 50, FlxG.width - 50, getString("credits3"));
	text3.setFormat(Paths.font("U.ttf"), 32, FlxColor.WHITE, "center");
	text3.updateHitbox();
	text3.antialiasing = true;
	text3.alpha = 0;
	add(text3);
	text3.screenCenter();


	cake = new FlxSprite(0, 50).loadGraphic(Paths.image("theEnd"));
	cake.updateHitbox();
	cake.antialiasing = true;
	cake.alpha = 0;
	add(cake);
	cake.screenCenter();

	FlxTween.tween(text, {alpha:1},1);
	for (i in ["snp end", "snp end intro"]){
	    tbh.loadEmbedded(Paths.music("thanks/"+i), true, true);
	}
	FlxG.sound.play(Paths.music("thanks/snp end intro"),FlxG.sound.volume, false, null, false, ()->{

	    CoolUtil.playMusic(Paths.music("thanks/snp end"), true, 1, true);
	    FlxG.sound.music.persist = true;
	    fadeText(text, 0, text2, 1);
		new FlxTimer().start(2, ()->{
			firstText= false;
		});
	});

}
function fadeText(txt1, num, txt2,num2){
	FlxTween.tween(txt1, {alpha:num},1, {onComplete: ()->{
			
		    FlxTween.tween(txt2, {alpha:num2},1);
		}});
	}
function update(elapsed:Float) {
	if(controls.ACCEPT && !firstText){
		num+=1;
	       switch(num){
			case 3:
				fadeText(text2, 0, text3, 1);
			case 4:
				fadeText(text3, 0, cake, 1);
			case 5:
				FlxG.switchState(new TitleState());
				FlxG.save.data.hasFinishedPolter = true;
				FlxG.save.flush();
		}

		
	}

}