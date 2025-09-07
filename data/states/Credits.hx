import Date;
import flixel.math.FlxPoint;
import hxvlc.flixel.FlxVideo;

var data = Json.parse(Assets.getText(Paths.file("data/states/credits.json")));

var buttons:Array<FlxSprite> = [];
var devsCategory:Map<String, Array<FlxSprite>> = [];
var curSelected = 0;
var oversprite:FlxSprite;
var fade:FlxSprite;
var creditsBar:FlxSprite;
var backBtn:FlxSprite;
var broName:FlxText;
var broDesc:FlxText;
var t = new CustomShader('tv');
var t2 = new CustomShader('IHY');

var twitter = new FlxSprite();
var bluesky = new FlxSprite();

var windowPosX = 0;
var windowPosY = 0;

var music:FlxSound = new FlxSound();
function create() {
	windowPosX = window.x;
	windowPosY = window.y;
	music = FlxG.sound.play(Paths.music("creditMusic"));
	music.volume = 0;
	music.fadeIn(0.5, 0, 0.7);
	music.looped = true;
	updateRPC("In the Credits Menu");
	realPos = FlxPoint.get();

	FlxG.mouse.visible = true;

	if (FlxG.save.data.tv)
		FlxG.camera.addShader(t);

	if (FlxG.save.data.saturation)
	 FlxG.camera.addShader(t2);

	var bg = new FlxSprite().loadGraphic(Paths.image("states/credits/menu/bg"));
	add(bg);
	var daZonePos = 0;
	for (i in 0...data.categories.length)
	{
		var category = data.categories[i];
		var buton = new FlxSprite(0, 181 * i).loadGraphic(Paths.image("states/credits/menu/"+ category.cat), true, 517, 302);
		buttons.push(buton);
		buton.animation.add("idle", [0], 0, true);
		buton.animation.add("select", [1], 0, true);
		daZonePos = FlxG.width - buton.width;
		buton.scale.set(0.6, 0.6);
		buton.updateHitbox();
		buton.ID = i;
		add(buton);

		var devsArray = [];

		var daZoneWidth = (FlxG.height - 50);
		var numCols = 3;
		var offsetPos = FlxPoint.get();
		if (category.devs.length > 9) {
			numCols = 4;
			offsetPos.x -= 120;
			offsetPos.y += 60;
		}
		var numLines = category.devs.length == 9 ? 3 : Math.floor(category.devs.length / 3) + 1;
		var daWidth = daZoneWidth/3;
		for (j in 0...category.devs.length)
		{
			var dev = category.devs[j];
			var leDev = new FlxSprite();
			leDev.ID = i;
			leDev.loadGraphic(Paths.image("states/credits/"+ dev.image));
			leDev.setGraphicSize(daWidth);
			leDev.updateHitbox();
			
			var column = Math.floor(j % numCols);
			var line = Math.floor(j / numCols);

			leDev.x = daZonePos / 1.65;
			leDev.y = (FlxG.height / numLines) - leDev.height;
			leDev.x += column*(leDev.width+10)+offsetPos.x;
			leDev.y += line*(leDev.height+10)+offsetPos.y;

			add(leDev);
			devsArray.push(leDev);
		}

		devsCategory.set(category.cat, devsArray);
	}
	changeSelection(0);

	fade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	fade.alpha = 0.001;
	add(fade);
	oversprite = new FlxSprite();
	add(oversprite);
	oversprite.visible = false;

	creditsBar = new FlxSprite().makeGraphic(500, FlxG.height, 0xFF000000);
	creditsBar.x = FlxG.width;
	add(creditsBar);

	broName = new FlxText(FlxG.width + 15, 30, creditsBar.width - 30, "bro", 60);
	broName.font = Paths.font("U.ttf");
	broName.alignment = "center";
	add(broName);

	backBtn = new FlxSprite(FlxG.width + 30, 30).loadGraphic(Paths.image("states/credits/menu/back"));
	add(backBtn);

	broDesc = new FlxText(FlxG.width + 15, 100, creditsBar.width - 30, "blah", 30);
	broDesc.font = Paths.font("U.ttf");
	broDesc.alignment = "center";
	add(broDesc);

	twitter = new FlxSprite().loadGraphic(Paths.image("states/credits/menu/twitter"));
	twitter.x = FlxG.width + 250 - (twitter.width / 2);
	add(twitter);

	bluesky = new FlxSprite().loadGraphic(Paths.image("states/credits/menu/bluesky"));
	bluesky.x = FlxG.width + 250 - (bluesky.width / 2);
	add(bluesky);

	youtube = new FlxSprite().loadGraphic(Paths.image("states/credits/menu/youtube"));
	youtube.x = FlxG.width + 250 - (youtube.width / 2);
	add(youtube);

	tenna = new FlxSprite();
	tenna.frames = Paths.getSparrowAtlas("states/credits/menu/tenna");
	tenna.animation.addByPrefix("idle", "tenna idle", 60);
	tenna.animation.play("idle");
	tenna.scale.set(1.25, 1.25);
	tenna.updateHitbox();
	tenna.y = FlxG.height - tenna.height;
	tenna.x = FlxG.width + 250 - (tenna.width / 2);
	add(tenna);
}

var tenna;

var canMove = true;
var canCoolMove = true;
var coolMode = false;
var oldScale = 0;
var oldX = 0;
var oldY = 0;
var realPos:FlxPoint;

var curDevData = {};
var videoPlaying = false;
var video:FlxVideo;

var shakeItensity = 0;
function update(elapsed) {
	if (shakeItensity > 0)
	{
		window.x = windowPosX + FlxG.random.float(-shakeItensity, shakeItensity) * 2.5;
		window.y = windowPosY + FlxG.random.float(-shakeItensity, shakeItensity) * 2.5;
	}
	if(FlxG.mouse.justMoved)
	{
		FlxG.mouse.getPosition(realPos);
	   
		if (FlxG.save.data.tv) //Survol correct avec le shader
		{
			realPos.x /= FlxG.width;
			realPos.y /= FlxG.height;
			realPos.x = (realPos.x - 0.5) * 2.0;
			realPos.y = (realPos.y - 0.5) * 2.0;
			realPos.x *= 1.1;	
			realPos.y *= 1.1;	
			realPos.x *= 1.0 + Math.pow((Math.abs(realPos.y) / 5.0), 2.0);
			realPos.y *= 1.0 + Math.pow((Math.abs(realPos.x) / 4.0), 2.0);
			realPos.x = (realPos.x / 2.0) + 0.5;
			realPos.y = (realPos.y / 2.0) + 0.5;
			realPos.x = realPos.x *0.95 + 0.0275;
			realPos.y = realPos.y *0.95 + 0.0275;
			realPos.x *= FlxG.width;
			realPos.y *= FlxG.height;
		}
	}

	var lerpVal:Float = FlxMath.bound(elapsed * 9.6, 0, 1);
	for (btn in buttons)
	{
		var pos = -25;
		if (btn.overlapsPoint(realPos, true, FlxG.camera))
		{
			pos = 0;
			if (FlxG.mouse.justPressed && canMove)
				changeSelection(btn.ID);
		}
		if (canMove)
			btn.x = FlxMath.lerp(btn.x, pos, lerpVal);
	}
	if (controls.BACK && canMove && !videoPlaying)
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, false);
		music.fadeOut(0.7);
		FlxTween.tween(FlxG.camera, {zoom:  1.04 }, 1, { ease: FlxEase.sineInOut, onComplete: function() {
			FlxG.switchState(new MainMenuState());
		}});
		canMove = false;
		FlxG.sound.play(Paths.sound('cancelMenu'));
	}
	if (coolMode)
	{
		if (twitter.overlapsPoint(realPos) && FlxG.mouse.justPressed && Reflect.hasField(curDevData, "twitter"))
			CoolUtil.openURL("https://x.com/" + curDevData.twitter);
		if (bluesky.overlapsPoint(realPos) && FlxG.mouse.justPressed && Reflect.hasField(curDevData, "bluesky"))
			CoolUtil.openURL("https://bsky.app/profile/" + curDevData.bluesky);
		if (youtube.overlapsPoint(realPos) && FlxG.mouse.justPressed && Reflect.hasField(curDevData, "youtube"))
			CoolUtil.openURL("https://youtube.com/" + curDevData.youtube);
		if (((backBtn.overlapsPoint(realPos) && FlxG.mouse.justPressed) || controls.BACK) && canCoolMove)
		{
			canCoolMove = false;
			curDevData = {};
			FlxTween.tween(fade, {alpha: 0.001}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(broName, {x: FlxG.width + 15}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(broDesc, {x: FlxG.width + 15}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(creditsBar, {x: FlxG.width}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(backBtn, {x: FlxG.width + 30}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(twitter, {x: FlxG.width + 250 - (twitter.width / 2)}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(bluesky, {x: FlxG.width + 250 - (bluesky.width / 2)}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(youtube, {x: FlxG.width + 250 - (youtube.width / 2)}, 1, {ease: FlxEase.expoOut});
			FlxTween.tween(oversprite, {x: oldX, y: oldY, "scale.x": oldScale, "scale.y": oldScale}, 1, {ease: FlxEase.expoOut, onComplete: function(_)
			{
				oversprite.visible = false;
				for (category => portraits in devsCategory)
					for (dev in portraits)
						dev.alpha = 1;
	
				coolMode = false;
				canMove = true;
				canCoolMove = true;
			}});
			if (oldMusicTime != 0)
			{
				FlxTween.tween(tenna, {x: FlxG.width + 250 - (tenna.width / 2)}, 1, {ease: FlxEase.expoOut});
				music.stop();
				music = FlxG.sound.play(Paths.music("creditMusic"));
				music.looped = true;
				music.play(oldMusicTime);
				oldMusicTime = 0;
			}
		}
	}
	if (((backBtn.overlapsPoint(realPos) && FlxG.mouse.justPressed) || (controls.BACK || controls.ACCEPT)) && videoPlaying)
	{
		video.stop();
		videoPlaying = false;
		video.dispose();
		music.fadeIn(0.5, 0, 0.7);
		FlxG.removeChild(video);
	}
	for (icon in [twitter, bluesky, youtube, backBtn])
	{
		var neededScale = icon.overlapsPoint(realPos, true, FlxG.camera) ? 1 : 0.75;
		icon.scale.x = icon.scale.y = FlxMath.lerp(icon.scale.x, neededScale, lerpVal);
	}
	for (category => portraits in devsCategory) {
		for (dev in portraits) {
			var devAlpha = 0.9;
			var devScale = 0.5;
			if (dev.overlapsPoint(realPos, true, FlxG.camera) && dev.visible && canMove) {
				devAlpha = 1;
				devScale = 0.6;
				if (FlxG.mouse.justPressed) {
					canMove = false;
					canCoolMove = false;
					coolMode = true;

					oldScale = dev.scale.x;
					oldX = dev.x;
					oldY = dev.y;

					dev.alpha = 0.001;
					oversprite.visible = true;
					oversprite.loadGraphic(dev.graphic);
					oversprite.offset.set(dev.offset.x, dev.offset.y);
					oversprite.scale.set(dev.scale.x, dev.scale.y);
					oversprite.x = dev.x;
					oversprite.y = dev.y;
					
					var jsonName = dev.graphic.key;
					jsonName = StringTools.replace(jsonName, "assets/images/states/credits/", "");
					jsonName = StringTools.replace(jsonName, ".png", "");
					var devData = {};

					for (category in data.categories)
						for (dev in category.devs)
							if (dev.image == jsonName && category.cat == curCategory)
								devData = dev;

					curDevData = devData;

					broName.text = devData.name;
					broDesc.text = devData.description;

					var totalHeight = broName.height + broDesc.height;

					var icons:Array<FlxSprite> = [];

					if (Reflect.hasField(devData, "twitter")) {
						twitter.visible = true;
						icons.push(twitter);
					} else {
						twitter.visible = false;
					}

					if (Reflect.hasField(devData, "bluesky")) {
						bluesky.visible = true;
						icons.push(bluesky);
					} else {
						bluesky.visible = false;
					}

					if (Reflect.hasField(devData, "youtube")) {
						youtube.visible = true;
						icons.push(youtube);
					} else {
						youtube.visible = false;
					}

					var spacing:Float = 20;
					var totalWidth:Float = 0;

					for (icon in icons) {
						totalWidth += icon.width;
					}
					totalWidth += spacing * (icons.length - 1);

					var startX:Float = FlxG.width - 500 + (creditsBar.width - totalWidth) / 2;

					for (i in 0...icons.length) {
						var icon = icons[i];
						var targetX = startX;
						for (j in 0...i) {
							targetX += icons[j].width + spacing;
						}
						FlxTween.tween(icon, {x: targetX}, 1, {ease: FlxEase.expoOut});
					}

					if (icons.length > 0) {
						totalHeight += icons[0].height + 10;
					}

					if (curDevData.sfx != null)
						FlxG.sound.play(Paths.sound(curDevData.sfx), 1);

					if (curDevData.name == "Playeah")
					{
						new FlxTimer().start(30, function (_) {
							if (curDevData.name == "Playeah")
							{
								music.fadeOut(0.7);
								video = new FlxVideo();
								var videoName = "alarmo";
								var date = Date.now();
								if (date.getDate() == 14 && date.getMonth() == 6)
									videoName = "alarmofr";
								video.load(Assets.getPath(Paths.video(videoName)));
								video.onEndReached.add(function()
								{
									videoPlaying = false;
									video.dispose();
									music.fadeIn(0.5, 0, 0.7);
									FlxG.removeChild(video);
								});
								FlxG.addChildBelowMouse(video);
								videoPlaying = true;
								video.play();
							}
						});
					} else if (curDevData.name == "Furo")
					{
						new FlxTimer().start(5, function (_) {
							if (curDevData.name == "Furo")
							{
								music.fadeOut(0.7);
								video = new FlxVideo();
								var videoName = "bomb";
								video.load(Assets.getPath(Paths.video(videoName)));
								var shaking = false;
								video.onTimeChanged.add(function(time)
								{
									if (Math.floor(time / 10) >= 280 && !shaking)
									{
										shaking = true;
										FlxTween.num(30, 0, 3.2, {ease: FlxEase.circOut}, function(v)
										{
											shakeItensity = v;
										});
									}
								});
								video.onEndReached.add(function()
								{
									videoPlaying = false;
									video.dispose();
									music.fadeIn(0.5, 0, 0.7);
									FlxG.removeChild(video);
								});
								FlxG.addChildBelowMouse(video);
								videoPlaying = true;
								video.play();
							}
						});
					} else if (curDevData.name == "Raynnard")
					{
						new FlxTimer().start(5, function (_) {
							if (curDevData.name == "Raynnard")
							{
								music.fadeOut(0.7);
								video = new FlxVideo();
								var videoName = "op";
								video.load(Assets.getPath(Paths.video(videoName)));
								video.onEndReached.add(function()
								{
									videoPlaying = false;
									video.dispose();
									music.fadeIn(0.5, 0, 0.7);
									FlxG.removeChild(video);
								});
								FlxG.addChildBelowMouse(video);
								videoPlaying = true;
								video.play();
							}
						});
					} else if (curDevData.name == "Deadlyne" && curSelected == 2)
						{
							new FlxTimer().start(1, function (_) {
								if (curDevData.name == "Deadlyne" && curSelected == 2)
								{
									music.fadeOut(0.7);
									video = new FlxVideo();
									var videoName = "hehe";
									video.load(Assets.getPath(Paths.video(videoName)));
									video.onEndReached.add(function()
									{
										videoPlaying = false;
										video.dispose();
										music.fadeIn(0.5, 0, 0.7);
										FlxG.removeChild(video);
									});
									FlxG.addChildBelowMouse(video);
									videoPlaying = true;
									video.play();
								}
							});
					} else if (curDevData.name == "Cloud")
					{
						oldMusicTime = music.time;
						music.stop();
						music = FlxG.sound.load(Paths.music("tenna"));
						music.looped = true;
						music.play();
						FlxTween.tween(tenna, {x: FlxG.width - 250 - (tenna.width / 2)}, 1, {ease: FlxEase.expoOut});
					}

					broName.y = (FlxG.height / 2) - (totalHeight / 2);
					broDesc.y = broName.y + broName.height;
					youtube.y = bluesky.y = twitter.y = broDesc.y + broDesc.height + 10;

					FlxTween.tween(broName, {x: FlxG.width - 485}, 1, {ease: FlxEase.expoOut});
					FlxTween.tween(broDesc, {x: FlxG.width - 485}, 1, {ease: FlxEase.expoOut});
					FlxTween.tween(creditsBar, {x: FlxG.width - 500}, 1, {ease: FlxEase.expoOut});
					FlxTween.tween(backBtn, {x: FlxG.width - 470}, 1, {ease: FlxEase.expoOut});
					FlxTween.tween(fade, {alpha: 0.8}, 1, {ease: FlxEase.expoOut});
					FlxTween.tween(oversprite, {x: 260, y: 250, "scale.x": 1, "scale.y": 1}, 1, {ease: FlxEase.expoOut, onComplete: function(_) {
						canCoolMove = true;
					}});
				}
			}
			if (canMove) {
				dev.scale.x = dev.scale.y = FlxMath.lerp(dev.scale.x, devScale, lerpVal);
				dev.alpha = FlxMath.lerp(dev.alpha, devAlpha, lerpVal);
			}
		}
	}
}

var oldMusicTime = 0;
var curCategory = "";
function changeSelection(change = 0) {
	curSelected = change;
	for (category => portraits in devsCategory)
		for (dev in portraits) {
			if (curSelected == dev.ID)
				curCategory = category;
			dev.visible = curSelected == dev.ID;
		}

	for (btn in buttons)
		btn.animation.play(curSelected == btn.ID ? "select" : "idle");
}