import flixel.util.FlxSpriteUtil;
import funkin.options.OptionsMenu;
import funkin.options.TreeMenu;
import funkin.editors.charter.Charter;
import funkin.backend.utils.FunkinParentDisabler;

var button1:FlxSprite;
var button2:FlxSprite;
var button3:FlxSprite;
var text1:FlxText;
var text2:FlxText;
var text3:FlxText;
var topbar:FlxSprite;
var iconBar:FlxSprite;
var bluebarthingy:FlxSprite;

var playerThings:Array<Array<Dynamic>> = [];
var topMenuThingy:Array<Array<Dynamic>> = [];

function doCornerOn(spr, color, roundness) {
	var f = FlxSpriteUtil.drawRoundRect(spr, 0, 0, spr.width, spr.height, roundness, roundness, color, null, null);
	return f;
}

var parentDisabler:FunkinParentDisabler;
var hamburger = state.scripts.get("hamburger");
function create() {
	FlxG.mouse.visible = true;
	add(parentDisabler = new FunkinParentDisabler());
	camera = new FlxCamera(0, 60, FlxG.width, FlxG.height - 60);
	camera.bgColor =  FlxColor.fromRGBFloat(0, 0, 0, 0);
	FlxG.cameras.add(camera, false);
	
	topbar = new FlxSprite(0, -(FlxG.height - 60)).makeGraphic(camera.width, camera.height, 0xAB171717);
	topbar.scrollFactor.set(0, 0);
	add(topbar);

	iconBar = new FlxSprite(0, -(FlxG.height - 50)).makeGraphic((FlxG.width - 72), 60, 0x00FFFFFF);
	add(iconBar);
	iconBar.screenCenter(FlxAxes.X);

	bluebarthingy = new FlxSprite(iconBar.x, iconBar.y + iconBar.height - 10).makeGraphic(iconBar.width / 3, 10, 0x00FFFFFF);
	add(bluebarthingy);

	button2 = new FlxSprite(0, 50).makeGraphic((FlxG.width - 150) / 3, 90, 0x00FFFFFF);
	add(button2);
	button2.screenCenter(FlxAxes.X);

	button1 = new FlxSprite(0, 50).makeGraphic((FlxG.width - 150) / 3, 90, 0x00FFFFFF);
	button1.screenCenter(FlxAxes.X);
	add(button1);
	button1.x -= (button1.width + 40);

	button3 = new FlxSprite(0, 50).makeGraphic((FlxG.width - 150) / 3, 90, 0x00FFFFFF);
	button3.screenCenter(FlxAxes.X);
	add(button3);
	button3.x += (button3.width + 40);

    var meta = PlayState.SONG.meta;
	var pauseData = meta.pause;
	var charnames = ["Catholic Mario", "Princess_GF", "xxxbfxxx", meta.displayName + " / " + pauseData.composer];
	var chars = [state.dad, state.gf, state.boyfriend, null];
	for (i in 0...chars.length)
	{
		var char = chars[i];
		var thing = new FlxSprite(0, 200 + (110 * i)).makeGraphic((FlxG.width - 72), 90, 0x00FFFFFF);
		thing.screenCenter(FlxAxes.X);
		add(thing);
		doCornerOn(thing, 0x307e889e, 10);

		var icon = null;
		if (char != null)
		{
			icon = new FlxSprite().loadGraphic(Paths.image("icons/" + char.icon), true, 150, 150);
			add(icon);
			icon.setGraphicSize(70);
			icon.updateHitbox();
			icon.x = thing.x + 10;
			icon.y = thing.y + 10;
		}

		var textOffset = icon == null ? 30 : 80;
		var name = new FlxText(thing.x + textOffset, 0, thing.width - textOffset, charnames[i], 24);
		name.y =  thing.y + ((thing.height / 2) - (name.height / 2));
		name.font = Paths.font("SourceSans3-Regular.ttf");
		add(name);

		for (spr in [thing, icon, name]) {
			if (spr == null) continue;
			spr.y -= FlxG.height - 60;
			FlxTween.tween(spr, {y: spr.y+(FlxG.height - 60)}, 0.5, {ease: FlxEase.sineInOut});
		}

		playerThings.push([thing, icon, name]);
	}

	text1 = new FlxText(button1.x, 0, button1.width, getString("robloxpause10"), 24);
	text1.y =  button1.y + ((button1.height / 2) - (text1.height / 2));
	text1.font = Paths.font("SourceSans3-Bold.ttf");
	text1.alignment = "center";
	add(text1);

	text2 = new FlxText(button2.x, 0, button2.width, getString("robloxpause11"), 24);
	text2.y =  button2.y + ((button2.height / 2) - (text2.height / 2));
	text2.font = Paths.font("SourceSans3-Bold.ttf");
	text2.alignment = "center";
	add(text2);

	text3 = new FlxText(button3.x, 0, button3.width, getString("robloxpause12"), 24);
	text3.y =  button3.y + ((button3.height / 2) - (text3.height / 2));
	text3.font = Paths.font("SourceSans3-Bold.ttf");
	text3.alignment = "center";
	add(text3);

	for (spr in [button1, button2, button3, text1, text2, text3])
		spr.y -= (FlxG.height - 60);
	for (btn in [button1, button2, button3])
		btn.updateHitbox();
	
	FlxTween.tween(iconBar, {y: 10}, 0.5, {ease: FlxEase.sineInOut});
	FlxTween.tween(bluebarthingy, {y: 10 + iconBar.height - bluebarthingy.height}, 0.5, {ease: FlxEase.sineInOut});
	FlxTween.tween(topbar, {y: 0}, 0.5, {ease: FlxEase.sineInOut});
	for (btn in [button1, button2, button3])
		FlxTween.tween(btn, {y: 90}, 0.5, {ease: FlxEase.sineInOut});
	for (text in [text1, text2, text3])
		FlxTween.tween(text, {y: 90 + ((button1.height / 2) - (text.height / 2))}, 0.5, {ease: FlxEase.sineInOut});
	
	doCornerOn(iconBar, 0xFF4E5460, 10);
	doCornerOn(bluebarthingy, 0xFF00A2FF, 10);
	doCornerOn(button1, 0xFFFFFFFF, 10);

	hamburger.color = 0xFF00A2FF;

	var totalWidth = 0;
	var funnyPlayerIcon = new FlxSprite(50, 16).loadGraphic(Paths.image("hud/PlayersTabIcon"));
	add(funnyPlayerIcon);
	funnyPlayerIcon.scale.set(0.8, 0.8);
	funnyPlayerIcon.updateHitbox();

	var funnyPlayerText = new FlxText(0, 18, 90, getString("robloxpause00"), 24);
	funnyPlayerText.font = Paths.font("SourceSans3-Bold.ttf");
	add(funnyPlayerText);

	totalWidth += funnyPlayerIcon.width;
	totalWidth += funnyPlayerText.width + 10;
	funnyPlayerIcon.x = (iconBar.x + iconBar.width / 6.5) - (totalWidth / 3);
	funnyPlayerText.x = funnyPlayerIcon.x + 5 + funnyPlayerIcon.width;
	topMenuThingy.push([funnyPlayerIcon, funnyPlayerText]);

	totalWidth = 0;

	var funnySettingsIcon = new FlxSprite(50, 18).loadGraphic(Paths.image("hud/GameSettingsTab"));
	add(funnySettingsIcon);
	funnySettingsIcon.updateHitbox();

	var funnySettingsText = new FlxText(0, 20, 100, getString("robloxpause01"), 24);
	funnySettingsText.font = Paths.font("SourceSans3-Bold.ttf");
	add(funnySettingsText);

	totalWidth += funnySettingsIcon.width;
	totalWidth += funnySettingsText.width + 10;
	funnySettingsIcon.x = (iconBar.x + iconBar.width / 2 - 20) - (totalWidth / 3);
	funnySettingsText.x = funnySettingsIcon.x + 5 + funnySettingsIcon.width;
	topMenuThingy.push([funnySettingsIcon, funnySettingsText]);
	funnySettingsIcon.alpha = funnySettingsText.alpha = 0.5;

	totalWidth = 0;

	var funnyPowerUpIcon = new FlxSprite(50, 18).loadGraphic(Paths.image("hud/PowerUpTab"));
	add(funnyPowerUpIcon);
	funnyPowerUpIcon.updateHitbox();

	var funnyPowerUpText = new FlxText(0, 20, 120, getString("robloxpause02"), 24);
	funnyPowerUpText.font = Paths.font("SourceSans3-Bold.ttf");
	add(funnyPowerUpText);

	totalWidth += funnyPowerUpIcon.width;
	totalWidth += funnyPowerUpText.width + 10;
	funnyPowerUpIcon.x = (iconBar.x + (iconBar.width / 6.5) * 5.25) - (totalWidth / 3);
	funnyPowerUpText.x = funnyPowerUpIcon.x + 5 + funnyPowerUpIcon.width;
	topMenuThingy.push([funnyPowerUpIcon, funnyPowerUpText]);
	funnyPowerUpIcon.alpha = funnyPowerUpText.alpha = 0.5;

	for (topbarbtn in topMenuThingy) {
		for (spr in topbarbtn)
		{
			spr.y -= FlxG.height - 60;
			FlxTween.tween(spr, {y: spr.y+(FlxG.height - 60)}, 0.5, {ease: FlxEase.sineInOut});
		}
	}
}

var realPos:FlxPoint = FlxPoint.get();
function update() {
	if (controls.BACK || controls.ACCEPT)
		closeMenu();
	FlxG.mouse.getPositionInCameraView(camera, realPos);
	for (btn in [button1, button2, button3])
		btn.color = btn.overlapsPoint(realPos, true, camera) ? 0xFF00A2FF : 0xFF4E5460;
	if (button1.overlapsPoint(realPos, true, button2.camera) && FlxG.mouse.justPressed)
	{
		hasLoad = true;
		if (PlayState.chartingMode && Charter.undos.unsaved)
			state.saveWarn(false);
		else {
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			if (Charter.instance != null) Charter.instance.__clearStatics();

			// prevents certain notes to disappear early when exiting  - Nex
			state.strumLines.forEachAlive(function(grp) grp.notes.__forcedSongPos = Conductor.songPosition);

			FlxG.switchState(new FreeplayState());
		}
	}
	if (button2.overlapsPoint(realPos, true, button2.camera) && FlxG.mouse.justPressed)
	{
		hasLoad = false;
		parentDisabler.reset();
		state.registerSmoothTransition();
		FlxG.resetState();
	}
	if (button3.overlapsPoint(realPos, true, button2.camera) && FlxG.mouse.justPressed)
	{
		closeMenu();
	}
	var optionIcon = topMenuThingy[1][0];
	var optionText = topMenuThingy[1][1];
	if ((optionIcon.overlapsPoint(realPos, true, optionIcon.camera) || optionText.overlapsPoint(realPos, true, optionText.camera)) && FlxG.mouse.justPressed)
	{
		hasLoad = false;
		lastOptionsState = PlayState;
		FlxG.switchState(new ModState('Options'));
	}
	var powerIcon = topMenuThingy[2][0];
	var powerText = topMenuThingy[2][1];
	if ((powerIcon.overlapsPoint(realPos, true, powerIcon.camera) || powerText.overlapsPoint(realPos, true, powerText.camera)) && FlxG.mouse.justPressed)
	{
		hasLoad = false;
		openSubState(new ModSubState('PowerUpStates'));
	}
}

var canClose:Bool = true;
function closeMenu() {
	if (!canClose) return;
	canClose = false;
	for (player in playerThings)
	{
		var thing = player[0];
		var icon = player[1];
		var name = player[2];
		for (spr in [thing, icon, name]) {
			if (spr == null) continue;
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {y: spr.y-(FlxG.height - 60)}, 0.5, {ease: FlxEase.sineInOut});
		}
	}

	for (topbarbtn in topMenuThingy) {
		for (spr in topbarbtn)
		{
			FlxTween.cancelTweensOf(spr);
			FlxTween.tween(spr, {y: spr.y-(FlxG.height - 60)}, 0.5, {ease: FlxEase.sineInOut});
		}
	}
	//playerThings.push([thing, icon, name]);
	FlxTween.cancelTweensOf(iconBar);
	FlxTween.tween(iconBar, {y: -(FlxG.height - 50)}, 0.5, {ease: FlxEase.sineInOut});
	FlxTween.cancelTweensOf(bluebarthingy);
	FlxTween.tween(bluebarthingy, {y: -(FlxG.height - 50) + iconBar.height - bluebarthingy.height}, 0.5, {ease: FlxEase.sineInOut});
	for (btn in [button1, button2, button3]) {
		FlxTween.cancelTweensOf(btn);
		FlxTween.tween(btn, {y: btn.y-(FlxG.height - 60)}, 0.5, {ease: FlxEase.sineInOut});
	}
	for (text in [text1, text2, text3]) {
		FlxTween.cancelTweensOf(text);
		FlxTween.tween(text, {y: text.y-(FlxG.height - 60)}, 0.5, {ease: FlxEase.sineInOut});
	}
	FlxTween.cancelTweensOf(topbar);
	FlxTween.tween(topbar, {y: -(FlxG.height - 60)}, 0.5, {ease: FlxEase.sineInOut, onComplete: function (_) {
		close();
	}});
}

function onClose() {
	hamburger.color = 0xFFFFFFFF;
	FlxG.cameras.remove(camera, true);
}