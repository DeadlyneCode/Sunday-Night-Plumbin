import haxe.io.Path;
import Xml;
import funkin.backend.assets.ModsFolder;
import sys.FileSystem;
import sys.io.File;

var pressCount:Int = -1;

var imgs = [
    "states/warning/flower",
    "states/warning/boo",
    "states/warning/hat",
];
var imgData = [];

var allLangsAvaillable = [];
var selectThingShader;
var langTitle;
var langDesc;
var langSelect;
var curLang = 0;
function create() {
    var langPath = ModsFolder.modsPath + ModsFolder.currentModFolder + "/languages/";
    for (i => file in FileSystem.readDirectory(langPath))
    {
        var fileContent = File.getContent(langPath + file);
        var langFile = Xml.parse(fileContent).firstElement();
        var fileName = Path.withoutExtension(file);
        allLangsAvaillable[i] = [fileName, langFile.get("name"), langFile];
        if (fileName == FlxG.save.data.language)
            curLang = i;
    }

    var selectedThing = new FlxSprite().loadGraphic(Paths.image("states/options/layout"));
    add(selectedThing);
    selectedThing.screenCenter(FlxAxes.X);
    selectedThing.y = FlxG.height - selectedThing.height - 100;
    selectedThing.antialiasing = true;

    selectThingShader = new CustomShader("optionSelection");
    selectThingShader.time = 0;
    selectedThing.shader = selectThingShader;

    langTitle = new FlxText(selectedThing.x + 20, selectedThing.y + 20, selectedThing.width - 20, "");
    langTitle.setFormat(Paths.font("U.ttf"), 36, FlxColor.WHITE, "left");
    add(langTitle);

    langDesc = new FlxText(langTitle.x, langTitle.y + langTitle.height + 10, langTitle.fieldWidth, "");
    langDesc.setFormat(Paths.font("U.ttf"), 24, FlxColor.WHITE, "left");
    add(langDesc);

    langSelect = new FlxText(langTitle.x - 20, (langTitle.y + langDesc.y) / 2 - 10, langTitle.fieldWidth, formatTextOption());
    langSelect.setFormat(Paths.font("U.ttf"), 48, FlxColor.WHITE, "right");    
    add(langSelect);

    for (i=>data in imgs)
    {
        var offset = i * FlxG.width;

        var text = new FlxText(0, 120, FlxG.width, getString("warning" + i + "_title"));
        text.setFormat(Paths.font("U.ttf"), 32 * 2.3, FlxColor.WHITE, "center");
        text.updateHitbox();
        text.antialiasing = true;
        text.alpha = 0;
        add(text);
        text.screenCenter(FlxAxes.X);
        text.x += offset;

        var text2 = new FlxText(0, 200, FlxG.width / 1.2, getString("warning" + i + "_desc"));
        text2.setFormat(Paths.font("F.ttf"), (24 * 3) / 1.5, FlxColor.WHITE, "center");
        text2.updateHitbox();
        text2.antialiasing = true;
        text2.alpha = 0;
        add(text2);
        text2.screenCenter(FlxAxes.X);
        text2.x += offset;

        var image = new FlxSprite(0, 0).loadGraphic(Paths.image(data));
        image.scale.scale(1/2, 1/2);
        image.updateHitbox();
        image.antialiasing = true;
        image.alpha = 0;
        image.screenCenter(FlxAxes.X);
        image.y = 900;
        image.x += offset;
        add(image);
        if (i == 0) {
            image.scale.set(0.35, 0.35);
            image.y = 500;
        }

        FlxTween.tween(text, {alpha: 1}, 3, {ease: FlxEase.quadOut});

        FlxTween.tween(text.scale, {x: 1 / 1.5, y: 1 / 1.5}, 0.8, {
            ease: FlxEase.backOut,
            onComplete: function(twn:FlxTween) {
                FlxTween.tween(text2, {alpha: 1}, 4);
                FlxTween.tween(image, {alpha: 1}, 5, {ease: FlxEase.quadOut});
                FlxTween.tween(image, {y: i == 0 ? 290 : 410}, 1, {
                    ease: FlxEase.quadOut
                });
            }
        });
        new FlxTimer().start(1.5, () -> {canPress = true;});

        imgData.push([text, text2, image]);
    }

    for (langStuff in [selectedThing, langTitle, langDesc, langSelect])
    {
        langStuff.alpha = 0.001;
        FlxTween.tween(langStuff, {alpha: 1}, 1, {ease: FlxEase.quadOut, startDelay: 1.5, onComplete: function()
        {
            pressCount = 0;
        }});
    }

    enter = new FlxSprite(1100,550).loadGraphic(Paths.image("states/warning/enter"));
    enter.scrollFactor.set(0, 0);
    enter.antialiasing = true;
    add(enter);

    function makeSide(x, y, sizex, sizey, color)
    {
        var bleh = new FlxSprite(x, y).makeGraphic(sizex, sizey, color);
        bleh.scrollFactor.set(0, 0);
        add(bleh);
        return bleh;
    }
    
    var sizeOfShit = 3;
    makeSide(0, 0, FlxG.width, (50 + sizeOfShit), 0xFF000000);
    makeSide(0, 0, 50 + sizeOfShit, FlxG.height, 0xFF000000);
    makeSide(FlxG.width-(50 + sizeOfShit), 0, 50 + sizeOfShit, FlxG.height, 0xFF000000);
    makeSide(0, FlxG.height-(50 + sizeOfShit), FlxG.width, 50 + sizeOfShit, 0xFF000000);

    makeSide(25, 25, FlxG.width - 50, sizeOfShit, 0xFF808080);
    makeSide(25, 25, sizeOfShit, FlxG.height - 50, 0xFF808080);
    makeSide(FlxG.width - (25 + sizeOfShit), 25, sizeOfShit, FlxG.height - 50, 0xFF808080);
    makeSide(25, FlxG.height - (25 + sizeOfShit), FlxG.width - 50, sizeOfShit, 0xFF808080);

    makeSide(50, 50, FlxG.width - 100, sizeOfShit, 0xFFFFFFFF);
    makeSide(50, 50, sizeOfShit, FlxG.height - 100, 0xFFFFFFFF);
    makeSide(FlxG.width - (50 + sizeOfShit), 50, sizeOfShit, FlxG.height - 100, 0xFFFFFFFF);
    makeSide(50, FlxG.height - (50 + sizeOfShit), FlxG.width - 100, sizeOfShit, 0xFFFFFFFF);

    pressCount = 0;
    FlxG.sound.play(Paths.sound('warning'));

    changeLang(0);
}

function formatTextOption() {
    var currentOptionString = "";
    if((curLang > 0))
        currentOptionString += "< ";
    else
        currentOptionString += "  ";

    currentOptionString += allLangsAvaillable[curLang][1];

    if(!(curLang >= allLangsAvaillable.length - 1))
        currentOptionString += " >";

    return currentOptionString;
}

function getRealString(string) {
    var langXML = allLangsAvaillable[curLang][2];
    var gotTranslated = string;
    for (elem in langXML.elements())
    {
        if (elem.nodeName == string)
            gotTranslated = elem.get("value");
    }
    return fixUpText(gotTranslated);
}

function changeLang(change) {
    curLang = ((curLang + change) < 0 ? 0 : ((curLang + change) > allLangsAvaillable.length - 1 ? allLangsAvaillable.length - 1 : curLang + change));

    FlxG.save.data.language = allLangsAvaillable[curLang][0];
    FlxG.save.flush();
	setLang(FlxG.save.data.language);

    langTitle.text = getRealString("snpOptions_language_title");
    langDesc.text = getRealString("snpOptions_language_desc");
    for (i=>img in imgData)
    {
        var text = img[0];
        var text2 = img[1];
        text.text = getRealString("warning" + i + "_title");
        text2.text = getRealString("warning" + i + "_desc");
    }
    langSelect.text = formatTextOption();
}

var canPress = false;
function update(elapsed:Float) {
    selectThingShader.time += elapsed;
    enter.visible = canPress;
    if ((controls.LEFT_P || controls.RIGHT_P) && pressCount == 0)
    {
        changeLang(controls.LEFT_P ? -1 : 1);
    }
    if (controls.ACCEPT && canPress) {
        FlxG.sound.play(Paths.sound('confirmMenu'));
        canPress = false;
        switch(pressCount) {
            case (imgs.length - 1):
                FlxG.camera.fade(FlxColor.BLACK, 1.25, false);
                FlxTween.tween(FlxG.camera, {zoom: 1.5}, 1.4, {ease: FlxEase.sineInOut});
                
                new FlxTimer().start(1.4, function(tmr:FlxTimer) {
                    if (FlxG.save.data.showCutscene)
                        FlxG.switchState(new ModState('CutsceneState'));
                    else
                        FlxG.switchState(new TitleState());
                });

            default:
                pressCount++;
                FlxTween.tween(FlxG.camera.scroll, { x: FlxG.width * pressCount }, 1, { ease: FlxEase.quadOut, onComplete: () -> canPress = true });
        }
    }
}
