import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;
import funkin.backend.utils.MemoryUtil;
import openfl.display.BitmapData;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

function makeCircle(x, y, radius, color) {
	var spr = new FlxSprite(x, y).makeGraphic(radius, radius, 0x00FFFFFF);
	var f = FlxSpriteUtil.drawCircle(spr, radius / 2, radius / 2, radius / 2, 0xFFFFFFFF, null, null);
    spr.antialiasing = true;
    spr.color = color;
	return spr;
}

var data = Json.parse(Assets.getText(Paths.file("data/GalleryData.json")));

var yearText:FlxText;
var circles:Array<FlxSprite> = [];
var yearGroups:Array<FlxGroup> = [];
var selection:FlxSprite;
var mouseSelection:FlxSprite;

var artName:FlxText;
var artistName:FlxText;
var descText:FlxText;
var artSprites:Array<FlxSprite> = [];

var scrollBar:FlxSprite;
var scrollBarBG:FlxSprite;
function create() {
	updateRPC("Watching the Gallery");
    CoolUtil.playMusic(Paths.music("galleryMusic"), false, 0, true);
    FlxG.sound.music.fadeIn(0.5, 0, 0.7);
    add(FlxGradient.createGradientFlxSprite(FlxG.width / 2, FlxG.height, [0xFFC7B191, 0xFFE7D8B7, 0xFFDABF95, 0xFFDABF95, 0xFFA78966], 1, 0, true)).scrollFactor.set(0, 0);

    var bg2 = FlxGradient.createGradientFlxSprite(FlxG.width / 2, FlxG.height, [0xFFC7B191, 0xFFE7D8B7, 0xFFDABF95, 0xFFDABF95, 0xFFA78966], 1, 0, true);
    bg2.flipX = true;
    bg2.x = FlxG.width / 2;
    bg2.scrollFactor.set(0, 0);
    add(bg2);
    yearText = new FlxText(0, 20, FlxG.width / 2, "");
    yearText.setFormat(Paths.font("WonderBold.ttf"), 36, 0xFF371705, "center", "outline", FlxColor.BLACK);
    yearText.antialiasing = true;
    yearText.scrollFactor.set(0, 0);
    add(yearText);
    upscaleText(yearText, 2);

    add(new FlxSprite(FlxG.width / 4 - (200 / 2), 70).makeGraphic(200, 3, 0xFF371705)).scrollFactor.set(0, 0);
    var r = 10, n = data.length, step = (2 * r) + 8;
    var w = (n - 1) * step + (2 * r);
    var x0 = (FlxG.width / 4) - (w / 2) + step / 5;

    for (i in 0...n) {
        var c = makeCircle(x0 + step * i, 90, r, 0xFF371705);
        c.scrollFactor.set(0, 0);
        add(c);
        circles.push(c);
    }

    artName = new FlxText(FlxG.width / 2, 20, FlxG.width / 2, "Artwork Name");
    artName.setFormat(Paths.font("WonderBold.ttf"), 36, 0xFF371705, "center", "outline", FlxColor.BLACK);
    artName.antialiasing = true;
    add(artName);
    upscaleText(artName, 2);

    artistName = new FlxText(FlxG.width / 2, 80, FlxG.width / 2, "Artist Name");
    artistName.setFormat(Paths.font("Wonder.ttf"), 24, 0xFF371705, "center", "outline", FlxColor.BLACK);
    artistName.antialiasing = true;
    add(artistName);
    upscaleText(artistName, 2);

    descText = new FlxText(FlxG.width / 2 + 50, 120, FlxG.width / 2 - 100, "Description");
    descText.setFormat(Paths.font("Wonder.ttf"), 24, 0xFF371705, "center", "outline", FlxColor.BLACK);
    descText.antialiasing = true;
    add(descText);
    upscaleText(descText, 2);

    add(new FlxSprite(FlxG.width / 4 + FlxG.width / 2 - (400 / 2), 70).makeGraphic(400, 3, 0xFF371705));

	selection = new FlxSprite(130, 145).makeGraphic((FlxG.width / 2) - (130 * 2), 40, 0x00FFFFFF);
    FlxSpriteUtil.drawRoundRect(selection, 0, 0, selection.width, selection.height, selection.height, selection.height, 0xFF461703, null, null);
    FlxGradient.overlayGradientOnFlxSprite(selection, selection.width - selection.height, selection.height, [0xFF461703, 0xFF7A1B01, 0xFF461703], selection.height / 2, 0, 1, 0);
    add(selection);
    selection.antialiasing = true;
    selection.scrollFactor.set(0, 0);

	mouseSelection = new FlxSprite(130, 245).makeGraphic((FlxG.width / 2) - (130 * 2), 40, 0x00FFFFFF);
    FlxSpriteUtil.drawRoundRect(mouseSelection, 0, 0, mouseSelection.width, mouseSelection.height, mouseSelection.height, mouseSelection.height, 0xFF461703, null, null);
    FlxGradient.overlayGradientOnFlxSprite(mouseSelection, mouseSelection.width - mouseSelection.height, mouseSelection.height, [0xFF461703, 0xFF7A1B01, 0xFF461703], mouseSelection.height / 2, 0, 1, 0);
    add(mouseSelection);
    mouseSelection.alpha = 0.75;
    mouseSelection.visible = false;
    mouseSelection.antialiasing = true;
    mouseSelection.scrollFactor.set(0, 0);

    for (yearData in data)
    {
        var group = new FlxGroup();
        add(group);
        yearGroups.push(group);
        
        for (i => artwork in yearData)
        {
            var artName = new FlxText(150, 150 + (i * 55), (FlxG.width / 2) - (150 * 2), artwork.name);
            artName.setFormat(Paths.font("Wonder.ttf"), 24, 0xFF371705, "left", "outline", FlxColor.BLACK);
            upscaleText(artName, 2);
            artName.scrollFactor.set(0, 0);
            group.add(artName);
        }
    }

    scrollBarBG = new FlxSprite(FlxG.width - 20, 0).makeGraphic(20, FlxG.height, 0xFF371705);
    scrollBarBG.scrollFactor.set(0, 0);
    add(scrollBarBG);

    scrollBar = new FlxSprite(FlxG.width - 20, 0).makeGraphic(20, 1, 0xFF7A1B01);
    scrollBar.scrollFactor.set(0, 0);
    add(scrollBar);

    changeYearSelection(0);

	realPos = FlxPoint.get();
}

var scrollCamY = 0;
var scrollLimit = 0;

var realPos:FlxPoint;
function update(elapsed:Float) {
    if (scrollLimit > 0)
    {
        scrollCamY -= (FlxG.mouse.wheel * 50);
        scrollCamY = Math.max(0, Math.min(scrollLimit, scrollCamY));
        FlxG.camera.scroll.y = lerp(FlxG.camera.scroll.y, scrollCamY, 0.2);

        scrollBar.scale.y = FlxG.height * (FlxG.height / (scrollLimit + FlxG.height));
        scrollBar.updateHitbox();
        scrollBar.y = (FlxG.camera.scroll.y / (scrollLimit + FlxG.height)) * FlxG.height;
    }

    var overlapsAButton = false;
    mouseSelection.visible = false;

    if(FlxG.mouse.justMoved)
	    FlxG.mouse.getPosition(realPos);

    for (i => circle in circles)
    {
        if (circle.overlapsPoint(realPos, true, FlxG.camera)) {
            overlapsAButton = true;
            if (FlxG.mouse.justPressed && curYearSelect != i) {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                curYearSelect = i;
                changeYearSelection(0);
            }
        } else
            circle.scale.set(1, 1);
    }

    for (i => text in yearGroups[curYearSelect].members) {
        text.color = 0xFF371705;

        if (text.overlapsPoint(realPos, true, FlxG.camera)) {
            mouseSelection.visible = true;
            mouseSelection.x = text.x - 20;
            mouseSelection.y = text.y - 5;
            overlapsAButton = true;
            text.color = 0xFFF2DCCE;
            if (FlxG.mouse.justPressed && curSelected != i) {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                curSelected = i;
                changeSelection(0);
            }
        }
        
        if (i == curSelected)
            text.color = 0xFFF2DCCE;
    }
    if (controls.LEFT_P || controls.RIGHT_P) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeYearSelection(controls.LEFT_P ? -1 : 1);
    }

    if (controls.UP_P || controls.DOWN_P) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeSelection(controls.UP_P ? -1 : 1);
    }

    if (controls.BACK) {
        selectedSomethin = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxG.switchState(new MainMenuState());
        FlxG.sound.music.fadeOut(0.5);
    }
    Mouse.cursor = overlapsAButton ? MouseCursor.BUTTON : MouseCursor.ARROW;
}

function destroy()
{
    Mouse.cursor = MouseCursor.ARROW;
	clearAssets();
    MemoryUtil.clearMajor();
}

var curYearSelect = 0;
var curSelected = 0;
function changeYearSelection(change)
{
    curYearSelect = FlxMath.wrap(curYearSelect + change, 0, data.length - 1);
    
    for (i => circle in circles)
        circle.alpha = (i == curYearSelect) ? 1 : 0.5;
    
    for (i => group in yearGroups)
        group.visible = (i == curYearSelect);
    
    yearText.text = ["Coolrash", "MX", "IHY Luigi", "Cosmic Mario", "Demonic Mario", "Wario Apparition", "Gilbert", "Victim#1", "Catholic Mario", "JP", "Wario Die", "Maltigi", "Mario n Luigi Opinion (scrapped)", "Silent", "Poltergeist", "Heartless", "BF n GF", "Others"][curYearSelect];

    curSelected = 0;
    changeSelection(0);
}

function changeSelection(change) {
    curSelected = FlxMath.wrap(curSelected + change, 0, data[curYearSelect].length - 1);

    scrollCamY = 0;
    FlxG.camera.scroll.y = scrollCamY;

    var text = yearGroups[curYearSelect].members[curSelected];
    selection.x = text.x - 20;
    selection.y = text.y - 5;

    var artwork = data[curYearSelect][curSelected];
    artName.text = artwork.name;
    artistName.text = applyFiller(getString("gallery_author"), [artwork.artist]);
    descText.text = artwork.description;
    descText.updateHitbox();
    for (spr in artSprites) {
        remove(spr);
        spr.destroy();
    }

    var prevY = descText.y + descText.height + 20;
    for (i => img in artwork.images) {
        var artSpr = new FlxSprite(FlxG.width / 2 + 50, prevY).loadGraphic(getAsset("states/gallery/" + img));
        CoolUtil.setUnstretchedGraphicSize(artSpr, (FlxG.width / 2) - 100, FlxG.height, false);
        artSpr.updateHitbox();
        artSpr.antialiasing = true;
        add(artSpr);
        artSpr.x = FlxG.width / 2 + 50 + ((FlxG.width / 2 - 100) - artSpr.width) / 2;
        artSprites.push(artSpr);
        prevY = artSpr.y + artSpr.height + 20;
        scrollLimit = artSpr.y + artSpr.height - FlxG.height + 50;
    }

    scrollBar.visible = scrollBarBG.visible = (scrollLimit > 0);
}

inline function destroyGraphic(graphic:FlxGraphic)
{
	// free some gpu memory
	if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null)
		graphic.bitmap.__texture.dispose();
	FlxG.bitmap.remove(graphic);
}

var assetStore:Map<String, FlxGraphic> = [];
function getAsset(path:String):FlxGraphic {
	var coolPath = Paths.image(path);

	var graphic:FlxGraphic = null;
	if (assetStore.exists(path))
		graphic = assetStore.get(path);
	else {
		if (Assets.exists(coolPath))
		{
			var bitmap = BitmapData.fromFile(Assets.getPath(coolPath));
			if (bitmap.image != null) {
				bitmap.lock();
				if (bitmap.__texture == null)
				{
					bitmap.image.premultiplied = true;
					bitmap.getTexture(FlxG.stage.context3D);
				}
				bitmap.getSurface();
				bitmap.disposeImage();
				bitmap.image.data = null;
				bitmap.image = null;
				bitmap.readable = true;
			}
			graphic = FlxGraphic.fromBitmapData(bitmap, false, path, true);
		} else
			graphic = FlxGraphic.fromRectangle(1, 1, FlxColor.TRANSPARENT, false, path);
			
		graphic.persist = true;
		graphic.destroyOnNoUse = false;
		assetStore.set(path, graphic);
	}

	return graphic;
}

function clearAssets() {
	for (asset => graphic in assetStore)
		destroyGraphic(graphic);
}