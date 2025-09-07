import flixel.FlxObject;
import funkin.editors.EditorTreeMenu;
import funkin.backend.MusicBeatState;
import flixel.text.FlxTextBorderStyle;
import funkin.editors.charter.CharterSelection;
import funkin.backend.assets.IModsAssetLibrary;
import funkin.editors.character.CharacterSelection;
import funkin.backend.assets.ModsFolder;

var optionShit:Array<Array<Dynamic>> = [];
var menuItems:FlxTypedGroup<FlxSprite>;
var gameOverEditorIndex = 0;
var curSelected = 0;
var modList = ModsFolder.getModsList();

function create()
{
    camFollow = new FlxObject(FlxG.width / 2, 0, 1, 1);
    add(camFollow);
    for (mod in modList)
    {
        var isModSelected = mod == ModsFolder.currentModFolder;
        var selectedColor = isModSelected ? 0xFF20F873 : 0xFFDF20F8;
        var unselectedColor = isModSelected ? 0xFF11833C : 0xFF82107C;
        optionShit.push([mod, selectedColor, unselectedColor]);
    }
    optionShit.push(["Disable Mods", 0xFFF82061, 0xFF82103C]);

    state.stateScripts.get("menuItems").forEachAlive(function(spr)
    {
        var text = state.stateScripts.get("texts")[spr.ID];
        var outline = state.stateScripts.get("outlines")[spr.ID];
        var daPipe = state.stateScripts.get("pipeLoop")[spr.ID];
        FlxTween.cancelTweensOf(outline);
        FlxTween.cancelTweensOf(text);
        FlxTween.cancelTweensOf(spr);
        FlxTween.cancelTweensOf(daPipe);
        FlxTween.tween(text, {x: FlxG.width + 80}, 1, {
            ease: FlxEase.smootherStepInOut
        });
        FlxTween.tween(outline, {x: FlxG.width + 80}, 1, {
            ease: FlxEase.smootherStepInOut
        });
        FlxTween.tween(spr, {x: FlxG.width}, 1, {
            ease: FlxEase.smootherStepInOut
        });
        FlxTween.tween(daPipe, {x: FlxG.width + spr.width}, 1, {
            ease: FlxEase.smootherStepInOut
        });
    });

    menuItems = new FlxTypedGroup();
    state.add(menuItems);
    menuItems.camera = FlxG.camera;

    for (i in 0...optionShit.length) {
        var menuItem:FlxSprite = new FlxSprite(0, 25 + 175 * i);
        menuItem.scale.set(0.75, 0.75);
        menuItem.loadGraphic(Paths.image('states/mainmenu/pipe-start'));
        menuItem.updateHitbox();
        menuItem.x = FlxG.width;
        menuItem.ID = i;
        menuItem.color = optionShit[i][(i == curSelected) ? 1 : 2];
        menuItems.add(menuItem);

        var menuItem:FunkinSprite = new FunkinSprite(menuItem.x + menuItem.width, menuItem.y, Paths.image('states/mainmenu/pipe-repeat'));
		menuItem.scale.set(950, 0.75);
		menuItem.updateHitbox();
		menuItem.ID = i;
		menuItem.color = optionShit[i][(i == curSelected) ? 1 : 2];
		menuItems.add(menuItem);

        var text = new FlxText(12, FlxG.height, FlxG.width, " " + optionShit[i][0], 64);
        text.setFormat(Paths.font("U.ttf"), 64, FlxColor.WHITE, "left");
        text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2.2);
        text.x = menuItem.x + 80;
        text.y = menuItem.y + (menuItem.height / 2) - (text.height / 2) - 10;
        text.ID = i;
        menuItems.add(text);

        var text = new FlxText(12, FlxG.height, FlxG.width, " " + optionShit[i][0], 64);
        text.setFormat(Paths.font("U.ttf"), 64, FlxColor.WHITE, "left");
        text.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 5);
        text.x = menuItem.x + 80;
        text.y = menuItem.y + (menuItem.height / 2) - (text.height / 2) - 10;
        menuItems.add(text);
        text.ID = i;
        text.color = (i == curSelected) ? 0xFFFFFFFF : 0xFF666666;
    }

    menuItems.forEachAlive(function(spr:FlxSprite) {
        if (spr == null) return;
        var daPos = spr.ID == curSelected ? 325 : 725;
        var posOffset = (spr is FlxText ? 80 : (spr is FunkinSprite ? 90 * 0.75 : 0));
        FlxTween.tween(spr, {x: daPos + posOffset}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
    });
    FlxG.camera.follow(camFollow, null, 0.24);
}

var closing:Bool = false;

function postUpdate()
{
    if (controls.BACK && !closing) {
        closing = true;
        menuItems.forEachAlive(function(spr:FlxSprite) {
            if (spr == null) return;
            FlxTween.cancelTweensOf(spr);
            var daPos = FlxG.width;
            var posOffset = (spr is FlxText ? 80 : (spr is FunkinSprite ? 90 * 0.75 : 0));
            FlxTween.tween(spr, {x: daPos + posOffset}, 1, {ease: FlxEase.smootherStepInOut});
        });

        new FlxTimer().start(1, function (_) {
            state.remove(menuItems);
            for (mem in menuItems.members)
                mem.kill();
        });

        new FlxTimer().start(0.75, function (_) {
            close();
        });

        state.stateScripts.get("menuItems").forEachAlive(function(spr)
        {
            var stateSelected = state.stateScripts.get("curSelected");
            var text = state.stateScripts.get("texts")[spr.ID];
            var outline = state.stateScripts.get("outlines")[spr.ID];
            var daPipe = state.stateScripts.get("pipeLoop")[spr.ID];
            FlxTween.cancelTweensOf(outline);
            FlxTween.cancelTweensOf(text);
            FlxTween.cancelTweensOf(spr);
            FlxTween.cancelTweensOf(daPipe);
            FlxTween.tween(spr, {x: spr.ID == stateSelected ? 650 : 725}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
            FlxTween.tween(daPipe, {x: (spr.ID == stateSelected ? 650 : 725) + spr.width}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
            FlxTween.tween(text, {x: (spr.ID == stateSelected ? 650 : 725) + 80}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
            FlxTween.tween(outline, {x: (spr.ID == stateSelected ? 650 : 725) + 80}, 0.5, {ease: FlxEase.cubeOut, startDelay: spr.ID * 0.2});
        });
    }

    if (controls.ACCEPT && !closing)
    {
        closing = true;
        ModsFolder.switchMod(modList[curSelected]);
    }

	changeItem((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0));
}
var camFollow:FlxObject;

function changeItem(change) {
    if (change == 0) return;
    if (closing) return;
    FlxG.sound.play(Paths.sound('scrollMenu'));
    curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length-1);

    menuItems.forEachAlive(function(spr:FlxSprite) {
        if (spr == null) return;
        FlxTween.cancelTweensOf(spr);
        var daPos = spr.ID == curSelected ? 325 : 725;
        var posOffset = (spr is FlxText ? 80 : (spr is FunkinSprite ? 90 * 0.75 : 0));
        if (spr.ID == curSelected)
        {
            var mid = spr.getGraphicMidpoint();
            camFollow.y = mid.y;
            mid.put();
        }
        FlxTween.tween(spr, {x: daPos + posOffset}, 0.25, {ease: FlxEase.cubeOut});
        if (spr is FlxText)
            FlxTween.color(spr, 0.25, spr.color, (spr.ID == curSelected) ? 0xFFD8D8FF : FlxColor.multiply(0xFFD8D8FF, 0xFF666666), {ease: FlxEase.cubeOut});
        else
            FlxTween.color(spr, 0.25, spr.color, optionShit[spr.ID][(spr.ID == curSelected) ? 1 : 2], {ease: FlxEase.cubeOut});
    });
}