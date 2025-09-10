import Xml;
import Type;
import flixel.math.FlxPoint;
import funkin.options.Options;
import funkin.options.TreeMenu;
import funkin.options.OptionsMenu;
import funkin.options.TreeMenuScreen;
import funkin.options.type.Checkbox;
import funkin.options.type.NumOption;
import funkin.options.type.Separator;
import funkin.options.type.TextOption;
import funkin.options.type.ArrayOption;
import funkin.options.keybinds.KeybindsOptions;
import funkin.options.categories.GameplayOptions;
import funkin.options.categories.AppearanceOptions;
import funkin.backend.utils.ControlsUtil;

var buttons:Array<FlxSprite> = [];
var realPos:FlxPoint;
var fadeBG = new FlxSprite();

var isMouse = false;
var curSelected = 0;

var prevMenuMusic = FlxG.save.data.menuMusicType;
function create()
{
	FlxG.camera.bgColor = 0xFF000000;
	if (FlxG.sound.music == null || !FlxG.sound.music.playing)
	{
		CoolUtil.playMusic(Paths.music(menuMusic), true, 1, true);
		FlxG.sound.music.persist = true;
	}

	realPos = FlxPoint.get();
	updateRPC("In the Options Menu");

	FlxG.mouse.visible = true;
	
	addMenuShaders();

	var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('states/bgm'));
	bg.setGraphicSize(Std.int(bg.width * 1.455));
	bg.updateHitbox();
	bg.scrollFactor.set(0,0);
	bg.screenCenter();
	bg.y = -500;
	bg.angle = -90;
	add(bg);

	var options = [];
	for (o in OptionsMenu.mainOptions) {
		var makeFunny = (v) -> return StringTools.trim(StringTools.replace(v, ">"));
		options.push([makeFunny(o.name), makeFunny(getString(o.name))]);
	}

	options.push(["SNP Options", getString("optionsTree.snpOptions-name")]);
	options.push(null);
	options.push(["Back", getString("optionsTree.back-name")]);

	var f = 0;
	for (i in 0...options.length) {
		var o = options[i];
		if (o == null || o[0] == "optionsTree.miscellaneous-name" || o[0] == "optionsTree.language-name") continue;
		var spr = new FlxSprite().loadGraphic(Paths.image("states/options/button"));
		spr.screenCenter();
		spr.y = 30 + (f * (spr.height * 1.1));
		add(spr);

		var text = new FlxText(spr.x, spr.y, spr.width, o[1], 16);
		text.setFormat(Paths.font("U.ttf"), 64 - (64 / 4), FlxColor.WHITE, "center");
		text.y = spr.y + (spr.height / 2) - (text.height / 2);
		add(text);

		f++;

		spr.ID = buttons.push([spr, text, o[0]]);
	}

	buttons[buttons.length - 1][0].y = FlxG.height - 20 - buttons[buttons.length - 1][0].height;
	buttons[buttons.length - 1][1].y = buttons[buttons.length - 1][0].y + (buttons[buttons.length - 1][0].height / 2) - (buttons[buttons.length - 1][1].height / 2);

	fadeBG.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
	add(fadeBG);
	fadeBG.alpha = 0.001;

	var AssetSource = {
		SOURCE: true,
		MODS: false,
		BOTH: null,
	}
	var xmlPath = Paths.xml("config/options");
	for(source in [AssetSource.SOURCE, AssetSource.MODS]) {
		if (Paths.assetsTree.existsSpecific(xmlPath, "TEXT", source)) {
			var access = Xml.parse(Paths.assetsTree.getSpecificAsset(xmlPath, "TEXT", source));
			if (access != null) {
				var nodeName = getNode(access, "menu").get("name");
				if (nodeName == "SNP Options") {
					var screen = new TreeMenuScreen("", "");
					for (o in parseOptionsFromXML(getNode(access, "menu"))) screen.add(o);
					snpOptions = screen;
				}
			}
		}
	}
	changeSelection(0);
}

function getNode(xml, name) {
	var metaNode = null;
	for (node in xml.elementsNamed(name)) {
		metaNode = node;
		break;
	}
	return metaNode;
}

var updateState = true;

var gameplayOptions = new GameplayOptions();
var appearanceOptions = new AppearanceOptions();
var snpOptions = null;
var curOptionScreen = null;

function postUpdate() {
	fadeBG.alpha = updateState ? 0.001 : 0.75;
	if (!updateState) {
		//IN OPTIONS MODE
		if (controls.BACK)
		{
			if (curOptionScreen != null)
				curOptionScreen.close();

			saveOptions();

			updateState = true;
			return;
		}
		return;
	};
	if(FlxG.mouse.justMoved)
	{
		isMouse = true;
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

	if (controls.DOWN_P || controls.UP_P)
	{
		isMouse = false;
		changeSelection(controls.DOWN_P ? 1 : -1);
	}

	if (controls.BACK)
		exitMenu();

	for (i => b in buttons)
	{
		var spr = b[0];
		var text = b[1];
		var o = b[2];
		var mouseOverlaps = spr.overlapsPoint(realPos, true, spr.camera);
		if (!isMouse)
			mouseOverlaps = curSelected == i;
		else if (mouseOverlaps) {
			curSelected = i;
			changeSelection(0);
		}
	
		text.color = spr.color = mouseOverlaps ? 0xFFFFFFFF : 0xFF818181;
		if (mouseOverlaps && (FlxG.mouse.justReleased && isMouse) || (!isMouse && controls.ACCEPT))
			accept();
	}
}

function changeSelection(change) {
	curSelected = FlxMath.wrap(curSelected + change, 0, buttons.length - 1);
}

function accept() {
	var o = buttons[curSelected][2];
	if (o == "Back")
	{
		exitMenu();
		return;
	}
	curOptionScreen = new ModSubState("substate/optionscreen");
	updateState = false;
	switch (o)
	{
		case "optionsTree.controls-name":
			persistentUpdate = false;
			updateState = true;
			var sub = new KeybindsOptions();
			sub.closeCallback = function()
			{
				persistentUpdate = true;
				updateState = true;
			}
			openSubState(sub);
			curOptionScreen = null;
			return;

		case "optionsTree.gameplay-name":
			curOptionScreen.data = {screen: gameplayOptions};

		case "optionsTree.appearance-name":
			curOptionScreen.data = {screen: appearanceOptions};

		case "SNP Options":
			curOptionScreen.data = {screen: snpOptions};
	}
	openSubState(curOptionScreen);
}

function saveOptions() {
	FlxG.save.flush();
	Options.save();
	Options.applySettings();
}

function exitMenu() {
	var oldState = lastOptionsState;
	lastOptionsState = null;
	saveOptions();
	if (prevMenuMusic != FlxG.save.data.menuMusicType) {
		updateMenuMusic();
		CoolUtil.playMusic(Paths.music(menuMusic), true, 0, true);
		FlxG.sound.music.persist = true;
	}
	setLang(FlxG.save.data.language);
	FlxG.switchState((oldState != null) ? Type.createInstance(oldState, []) : new MainMenuState());
}

function parseOptionsFromXML(xml) {
	var options = [];

	for(node in xml.elements()) {
		
		if (node.exists("if"))
		{
			var ifNode = node.get("if");
			if (Reflect.field(FlxG.save.data, ifNode) == null || !Reflect.field(FlxG.save.data, ifNode))
				continue;
		}

		var doesTranslationExist = node.exists("translation");
		var name = doesTranslationExist ? getString("snpOptions_" + node.get("translation") + "_title") : (node.get("name") ?? "No Name.");
		var desc = doesTranslationExist ? getString("snpOptions_" + node.get("translation") + "_desc") : (node.get("desc") ?? "No Desc.");
		if (node.exists("consuption"))
			desc += " (" + getString("snpOptions_shaderConsuption_" + node.get("consuption")) + ")";

		switch(node.nodeName) {
			case "text":
				options.push(new TextOption(name, name == "" ? "" : desc, () -> {}));

			case "checkbox":
				options.push(new Checkbox(name, desc, node.get("id"), null, FlxG.save.data));

			case "number":
				var step = node.exists("change") ? Std.parseFloat(node.get("change")) : (node.exists("step") ? Std.parseFloat(node.get("step")) : null);
				options.push(new NumOption(name, desc, Std.parseFloat(node.get("min")), Std.parseFloat(node.get("max")), step, node.get("id"), null, FlxG.save.data));
			
			case "separator":
				options.push(new Separator(node.exists("height") ? Std.parseFloat(node.get("height")) : 67));
			
			case "choice":
				var optionOptions:Array<Dynamic> = [];
				var optionDisplayOptions:Array<String> = [];

				for(choice in node.elements()) {
					optionOptions.push(choice.get("value"));
					var doesTranslationExist = choice.exists("translation");
					optionDisplayOptions.push(doesTranslationExist ? getString("snpOptions_" + choice.get("translation")) : choice.get("name"));
				}

				if(optionOptions.length > 0)
					options.push(new ArrayOption(name, desc, optionOptions, optionDisplayOptions, node.get("id"), null, FlxG.save.data));
		}
	}

	return options;
}