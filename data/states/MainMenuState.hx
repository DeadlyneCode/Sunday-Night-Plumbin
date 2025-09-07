import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.options.OptionsMenu;
import funkin.savedata.FunkinSave;

var curSelected:Int = 0;
var selectedSomethin:Bool = false;
var selectGallery:Bool = false;

var optionShit:Array<Array<Dynamic>> = [
	[0xFF559E7E, 0xFF386852],
	[0xFF559E7E, 0xFF386852],
	[0xFF559E7E, 0xFF386852],
	[0xFF4137B7, 0xFF282372]
];

var pipeLoop:Array<FlxSprite> = [];
var texts:Array<FlxText> = [];
var outlines:Array<FlxText> = [];
var menuItems:FlxTypedGroup<FlxSprite>;

var galleryBtn:FlxSprite;

var glitchShader;
function create() {
	updateRPC("In the Main Menu");
	hasLoad = true;

	addMenuShaders();

	if (FlxG.sound.music == null || !FlxG.sound.music.playing) {
		CoolUtil.playMusic(Paths.music(menuMusic), true, 0, true);
		FlxG.sound.music.persist = true;
	}
	FlxTween.tween(FlxG.sound.music, {volume: 1}, 1.0, {ease: FlxEase.quadInOut});

	var titleBG = new FlxSprite().loadGraphic(Paths.image('states/tilte/titlebg'));
	titleBG.scale.set(0.6, 0.6);
	titleBG.screenCenter();
	titleBG.x = -1400;
	titleBG.scrollFactor.set(0, 0);
	add(titleBG);

	var titleCloud = new FlxBackdrop(Paths.image('states/tilte/cloud'), 0, 0, true, false, 0, 0);
	titleCloud.velocity.set(-25, 0);
	titleCloud.scrollFactor.set(0.6, 0);
	titleCloud.y = -100;
	add(titleCloud);
	titleCloud.x = TitleState_cloudX;

	bg = new FlxSprite(-80).loadGraphic(Paths.image('states/bgm-sep'));
	bg.updateHitbox();
	bg.screenCenter();
	bg.scrollFactor.set(0, 0);
	add(bg);

	if (FlxG.save.data.curPowerUp == 5) {
		glitchShader = new CustomShader("glitch");
		glitchShader.negativity = 0;
		glitchShader.binaryIntensity = 1000;
		

		var fps = 24;
		new FlxTimer().start(1/fps, (t) -> {
			glitchShader.binaryIntensity = FlxG.random.float(4, 6) * 1.5;
			t.reset(1/fps);
		});
	}

	menuItems = new FlxTypedGroup();
	add(menuItems);

	for (i in 0...optionShit.length) {
		var pipeStart:FlxSprite = new FlxSprite(0, 25 + 175 * i);
		pipeStart.scale.set(0.75, 0.75);
		pipeStart.loadGraphic(Paths.image('states/mainmenu/pipe-start'));
		pipeStart.updateHitbox();
		pipeStart.x = FlxG.width;
		pipeStart.ID = i;
		pipeStart.color = optionShit[i][(i == curSelected) ? 0 : 1];
		menuItems.add(pipeStart);
		pipeStart.scrollFactor.set(0, 0);
		
		var menuItem:FlxSprite = new FlxSprite(pipeStart.x + pipeStart.width, pipeStart.y);
		menuItem.scale.set(600, 0.75);
		menuItem.loadGraphic(Paths.image('states/mainmenu/pipe-repeat'));
		menuItem.updateHitbox();
		menuItem.ID = i;
		menuItem.color = optionShit[i][(i == curSelected) ? 0 : 1];
		add(menuItem);
		menuItem.scrollFactor.set(0, 0);
		pipeLoop.push(menuItem);

		var text = new FlxText(12, FlxG.height, FlxG.width, " " + getString("mainmenu" + i), 64);
		text.setFormat(Paths.font("U.ttf"), 64, FlxColor.WHITE, "left");
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2.2);
		text.x = menuItem.x + 80;
		text.y = menuItem.y + (menuItem.height / 2) - (text.height / 2) - 10;
		add(text);
		text.scrollFactor.set(0, 0);
		outlines.push(text);

		var textShadow = new FlxText(12, FlxG.height, FlxG.width, " " + getString("mainmenu" + i), 64);
		textShadow.setFormat(Paths.font("U.ttf"), 64, FlxColor.WHITE, "left");
		textShadow.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 5);
		textShadow.x = menuItem.x + 80;
		textShadow.y = menuItem.y + (menuItem.height / 2) - (textShadow.height / 2) - 10;
		add(textShadow);
		textShadow.scrollFactor.set(0, 0);
		texts.push(textShadow);
		textShadow.color = (i == curSelected) ? 0xFFD8D8FF : FlxColor.multiply(0xFFD8D8FF, 0xFF666666);

		if (i == 0 && FlxG.save.data.curPowerUp == 5) {
			for (i in [pipeStart, menuItem])
				i.shader = glitchShader;
		}
	}

	changeItem(0);

	menuItems.forEach(function(spr:FlxSprite) {
		var text = texts[spr.ID];
		var outline = outlines[spr.ID];
		var daLoop = outlines[spr.ID];
		var daPipe = pipeLoop[spr.ID];
		for (i in [text, daPipe, outline, spr])
			FlxTween.cancelTweensOf(i);
		FlxTween.tween(spr, {x: spr.ID == curSelected ? 650 : 725}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
		FlxTween.tween(text, {x: (spr.ID == curSelected ? 650 : 725) + 80}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
		FlxTween.tween(outline, {x: (spr.ID == curSelected ? 650 : 725) + 80}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
		FlxTween.tween(daPipe, {x: (spr.ID == curSelected ? 650 : 725) + spr.width}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
	});

	if (FunkinSave.getSongHighscore("Poltergeist", "normal").score > 0) {
		galleryBtn = new FlxSprite(-300, 540);
		galleryBtn.frames = Paths.getSparrowAtlas("states/mainmenu/gallery");
		galleryBtn.animation.addByPrefix("idle", "unselected", 0, false);
		galleryBtn.animation.addByPrefix("hover", "selected", 0, false);
		galleryBtn.animation.play("idle");
		add(galleryBtn);
		galleryBtn.scrollFactor.set(0, 0);
		FlxTween.tween(galleryBtn, {x: (250 - galleryBtn.width) / 2}, 1.0, {ease: FlxEase.cubeOut, startDelay: 0.2});
	}
}

var realPos:FlxPoint = FlxPoint.get();
function update(elapsed:Float) {
	if (!selectedSomethin) {
		if (controls.DEV_ACCESS) {
			persistentUpdate = false;
			persistentDraw = true;
			openSubState((!FlxG.save.data.wonLuigi || FlxG.save.data.alwaysLuigi) ? new ModSubState('FindLuigi') : new EditorPicker());
		}

		if (FlxG.keys.justPressed.B) {
			FlxG.switchState(new ModState('visualizer'));
		}

		if (FlxG.keys.justPressed.Y) {
			FlxTween.tween(FlxG.sound.music, {volume: 0}, 1.0, {ease: FlxEase.quadInOut, onComplete:()->{
				FlxG.switchState(new ModState('thanksToPlay'));
				}
			});
		}

		if (controls.SWITCHMOD) {
			openSubState(new ModSubState('ModSwitcherSNP'));
			persistentUpdate = false;
			persistentDraw = true;
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

		if (galleryBtn != null)
		{
			var galleryBtnScale = 0.8;
			if (galleryBtn.overlapsPoint(realPos) || selectGallery)
			{
				if (galleryBtn.animation.curAnim.name == "idle")
					galleryBtn.animation.play("hover");
				if (FlxG.mouse.justPressed)
					FlxG.switchState(new ModState('GalleryState'));

				galleryBtnScale = 1;
			} else if (galleryBtn.animation.curAnim.name == "hover" || selectGallery == false)
				galleryBtn.animation.play("idle");

			galleryBtn.scale.x = galleryBtn.scale.y = FlxMath.lerp(galleryBtn.scale.x, galleryBtnScale, FlxMath.bound(elapsed * 9.6, 0, 1));
			
			if(controls.LEFT_P){
				curSelected = -2;
				changeItem(0);
				selectGallery = true;
				FlxG.sound.play(Paths.sound('scrollMenu'));
			}

			if(selectGallery == true && controls.RIGHT_P){
				selectGallery = false;
				curSelected = 0;
				changeItem(0);
			}
		}

		if ((controls.UP_P || controls.DOWN_P) && curSelected != -2) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeItem(controls.UP_P ? -1 : 1);
		}

		if (controls.BACK) {
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new TitleState());
		}

		if (controls.ACCEPT) {
			switch (curSelected) {
				case 3:
					FlxG.camera.fade(FlxColor.BLACK, 1.2, false);
					FlxTween.tween(FlxG.camera, {zoom: 1.1}, 1.5, {ease: FlxEase.sineInOut});

				default:
					FlxG.camera.fade(FlxColor.BLACK, 1.2, false);
					FlxTween.tween(FlxG.camera, {zoom: 1.1}, 1.5, {ease: FlxEase.sineInOut});
					FlxTween.tween(FlxG.sound.music, {volume: 0}, 1.0, {ease: FlxEase.quadInOut});
			}

			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));

			menuItems.forEach(function(spr:FlxSprite) {
				if (curSelected != spr.ID) {
					var text = texts[spr.ID];
					var outline = outlines[spr.ID];
					var daPipe = pipeLoop[spr.ID];
					for (i in [text, daPipe, outline, spr])
						FlxTween.cancelTweensOf(i);
					FlxTween.tween(text, {x: FlxG.width + 80}, 1, {
						ease: FlxEase.smootherStepInOut,
						onComplete: function(twn:FlxTween) {
							text.kill();
						}
					});
					FlxTween.tween(outline, {x: FlxG.width + 80}, 1, {
						ease: FlxEase.smootherStepInOut,
						onComplete: function(twn:FlxTween) {
							outline.kill();
						}
					});
					FlxTween.tween(spr, {x: FlxG.width}, 1, {
						ease: FlxEase.smootherStepInOut,
						onComplete: function(twn:FlxTween) {
							spr.kill();
						}
					});
					FlxTween.tween(daPipe, {x: FlxG.width + spr.width}, 1, {
						ease: FlxEase.smootherStepInOut,
						onComplete: function(twn:FlxTween) {
							spr.kill();
						}
					});
				

				}
			});
			new FlxTimer().start(1.2, function(tmr:FlxTimer) {
				switch (curSelected) {
					case 0:
						FlxG.switchState(FlxG.save.data.curPowerUp == 5 ? new ModState("smb") : new FreeplayState());
					case 1:
						FlxG.switchState(new ModState('PowerUpStates'));
					case 2:
						FlxG.switchState(new ModState('Credits'));
					case 3:
						FlxG.switchState(new ModState('Options'));
					case -2:
						FlxG.switchState(new ModState('GalleryState'));
				}
			});
		}
	}
}

function changeItem(change) {
	if (curSelected != -2){
		curSelected += change;
		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
	}

	menuItems.forEach(function(spr:FlxSprite) {
		var text = texts[spr.ID];
		var daPipe = pipeLoop[spr.ID];
		var outline = outlines[spr.ID];
		for (i in [text, daPipe, outline, spr])
			FlxTween.cancelTweensOf(i);
		FlxTween.color(spr, 0.25, spr.color, optionShit[spr.ID][(spr.ID == curSelected) ? 0 : 1], {ease: FlxEase.cubeOut});
		FlxTween.color(daPipe, 0.25, daPipe.color, optionShit[spr.ID][(spr.ID == curSelected) ? 0 : 1], {ease: FlxEase.cubeOut});
		FlxTween.color(text, 0.25, text.color, (spr.ID == curSelected) ? 0xFFD8D8FF : FlxColor.multiply(0xFFD8D8FF, 0xFF666666), {ease: FlxEase.cubeOut});
		FlxTween.tween(daPipe, {x: (spr.ID == curSelected ? 650 : 725) + spr.width}, 0.25, {ease: FlxEase.cubeOut});
		FlxTween.tween(spr, {x: spr.ID == curSelected ? 650 : 725}, 0.25, {ease: FlxEase.cubeOut});
		FlxTween.tween(text, {x: (spr.ID == curSelected ? 650 : 725) + 80}, 0.25, {ease: FlxEase.cubeOut});
		FlxTween.tween(outline, {x: (spr.ID == curSelected ? 650 : 725) + 80}, 0.25, {ease: FlxEase.cubeOut});
	});
}
