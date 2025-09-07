import funkin.editors.SaveSubstate;
import flixel.math.FlxPoint;
import openfl.geom.Rectangle;
import openfl.ui.MouseCursor;
import funkin.editors.ui.UIUtil;
import openfl.display.BitmapData;
import funkin.editors.ui.UITopMenu;
import flixel.input.keyboard.FlxKey;
import funkin.backend.utils.WindowUtils;
import funkin.editors.ui.UISubstateWindow;
import flixel.addons.display.FlxGridOverlay;

var topMenuSpr:UITopMenu;

function createGrid(CellWidth:Int, CellHeight:Int, Width:Int, Height:Int):BitmapData
{
    var grid:BitmapData = new BitmapData(Width, Height, true, 0x70FFFFFF);
    var y:Int = 0;
    var borderSize = 2;

    while (y + CellHeight <= Height)
    {
        var x:Int = 0;

        while (x + CellWidth <= Width)
        {
            // Fill cell excluding 1px border
            grid.fillRect(new Rectangle(x + borderSize, y + borderSize, CellWidth - borderSize, CellHeight - borderSize), 0x0000EEFF);
            x += CellWidth;
        }

        y += CellHeight;
    }

    return grid;
}    

var smbCam:FlxCamera;
var uiCamera:FlxCamera;
function create() {
	smbCam = FlxG.camera;
	smbCam.zoom = 0.88;
    smbCam.scroll.set(87, -50);
	uiCamera = new FlxCamera();
	uiCamera.bgColor = 0;
	FlxG.cameras.add(uiCamera, false);

	topMenu = [
		{
			label: "File",
			childs: [
				{
					label: "Save",
					keybind: [FlxKey.CONTROL, FlxKey.S],
					onSelect: _file_save
				},
				null,
				{
					label: "Exit",
					onSelect: _file_exit
				}
			]
		}
	];

	topMenuSpr = new UITopMenu(topMenu);
	topMenuSpr.cameras = [uiCamera];
	add(topMenuSpr);

    var itemSelect = new FlxSprite();
    itemSelect.y = topMenuSpr.bHeight;
    itemSelect.loadGraphic(Paths.image('editors/charter/strumline-info-bg'));
    itemSelect.scale.set(FlxG.width, 0.5);
    itemSelect.updateHitbox();
	itemSelect.cameras = [uiCamera];
    add(itemSelect);
    
    var gridSize = getBlockSize();
    var grid = createGrid(gridSize, gridSize, FlxG.width * 10, FlxG.height);
    var gridSprite = new FlxSprite(0, 0, grid);
    add(gridSprite);

    var centerSpritesX = function(sprites:Array<FlxSprite>, screenWidth:Float, padding:Float = 10):Void {
        if (sprites.length == 0) return;
    
        var totalWidth:Float = (sprites.length * sprites[0].width) + ((sprites.length - 1) * padding);
        var startX:Float = (screenWidth - totalWidth) / 2; // Center alignment
    
        for (i in 0...sprites.length) {
            sprites[i].x = startX + (i * (sprites[i].width + padding));
        }
    }
    

    var anims = [
        "ground", "block", "usedblock", "cloud_1", "cloud_2",
        "cloud_3", "cloud_4", "cloud_5", "cloud_6", "solidblock",
        "pipe_1", "pipe_2", "pipe_3", "pipe_4", "itemblock",
        "bush1_1", "bush1_2", "bush1_3", "bush1_4", "bush1_5",
        "bush1_6", "bush2_1", "bush2_2", "bush2_3", "sky",
        "event_block", "barrier"
    ];
    
    for (i in 0...anims.length)
    {
        var boxHeight = itemSelect.height * 0.7;
        var box = new FunkinSprite(0, itemSelect.y + ((itemSelect.height * 0.22) / 2)).makeGraphic(boxHeight, boxHeight, 0x40FFFFFF);
        box.cameras = [uiCamera];
        box.extra["id"] = i;
        box.extra["anim"] = anims[i];
        boxSprites.push(box);
        add(box);
    }
    centerSpritesX(boxSprites, FlxG.width, 5);

    for (i in 0...boxSprites.length)
    {
        var box = boxSprites[i];
        var item = makeSpriteSheet();
        item.animation.play(anims[i]);
        item.cameras = [uiCamera];
        var blockScale = 0.7;
        item.scale.set(getBlockScale() * blockScale, getBlockScale() * blockScale);
        item.updateHitbox();
        item.x = box.x + ((box.width - item.width) / 2);
        item.y = box.y + ((box.height - item.height) / 2);
        add(item);
        box.extra["item"] = item;
    }

	WindowUtils.suffix = " (SMB. Editor)";

    mouseBlock = makeSpriteSheet();
    mouseBlock.alpha = 0.5;
    add(mouseBlock);

    var levelData = convertDataFileToLevelData();
    for (y in 0...levelData.length)
    {
        var row = levelData[y];
        for (x in 0...row.length)
        {
            var blockName = row[x];
            var insertedBlock = makeSpriteSheet();
            insertedBlock.animation.play(blockName);
            insertedBlock.x = x * getBlockSize();
            insertedBlock.y = y * getBlockSize();
            insert(0, insertedBlock);
            var blockDataArray = blockData[y] ?? [];
            blockDataArray[x] = [blockName, insertedBlock];
            blockData[y] = blockDataArray;
            if (blockName == "event_block") {
                for (eventBlock in eventBlocks)
                {
                    var eventBlockPos = eventBlock[0];
                    if (eventBlockPos.x == x && eventBlockPos.y == y)
                    {
                        insertedBlock.extra["eventBlockData"] = eventBlock[1];
                        break;
                    }
                }
            }
        }
    }
}
var boxSprites = [];
var mouseBlock:FlxSprite;

function makeSpriteSheet() {
    var spr = new FunkinSprite();
    spr.loadGraphic(Paths.image('smbtileset'), true, 16, 16);

    spr.animation.add("ground", [0], 0, false);
    spr.animation.add("block", [1], 0, false);
    spr.animation.add("usedblock", [2], 0, false);
    spr.animation.add("cloud_1", [3], 0, false);
    spr.animation.add("cloud_2", [4], 0, false);
    spr.animation.add("cloud_3", [5], 0, false);
    spr.animation.add("cloud_4", [6], 0, false);
    spr.animation.add("cloud_5", [7], 0, false);
    spr.animation.add("cloud_6", [8], 0, false);
    spr.animation.add("solidblock", [9], 0, false);
    spr.animation.add("pipe_1", [10], 0, false);
    spr.animation.add("pipe_2", [11], 0, false);
    spr.animation.add("pipe_3", [12], 0, false);
    spr.animation.add("pipe_4", [13], 0, false);
    spr.animation.add("itemblock", [14, 15, 16, 15, 14, 14, 14], 6,  true);
    spr.animation.add("bush1_1", [17], 0, false);
    spr.animation.add("bush1_2", [18], 0, false);
    spr.animation.add("bush1_3", [19], 0, false);
    spr.animation.add("bush1_4", [20], 0, false);
    spr.animation.add("bush1_5", [21], 0, false);
    spr.animation.add("bush1_6", [22], 0, false);
    spr.animation.add("bush2_1", [23], 0, false);
    spr.animation.add("bush2_2", [24], 0, false);
    spr.animation.add("bush2_3", [25], 0, false);
    spr.animation.add("sky", [26], 0, false);
    spr.animation.add("event_block", [27], 0, false);
    spr.animation.add("barrier", [28], 0, false);

    spr.scale.set(getBlockScale(), getBlockScale());
    spr.updateHitbox();

    return spr;
}

var selectedBlock = 0;
var blockData:Array<Array<Dynamic>> = [];

var nextScroll:FlxPoint = FlxPoint.get(87,0);
function update(elapsed:Float) {
	if(FlxG.keys.justPressed.ANY)
		UIUtil.processShortcuts(topMenu);

    if (FlxG.mouse.y >= 0) {
        var nearestBlockPos = getNearestBlockPos(FlxG.mouse.x, FlxG.mouse.y);

        if (FlxG.keys.pressed.CONTROL) {
            mouseBlock.visible = false;
            if (FlxG.mouse.pressed)
                nextScroll.set(Math.max(87, nextScroll.x - FlxG.mouse.deltaScreenX), nextScroll.y);
            currentCursor = MouseCursor.HAND;
        } else {
            if (FlxG.mouse.pressedRight)
            {
                if (blockData[nearestBlockPos.y] != null && blockData[nearestBlockPos.y][nearestBlockPos.x] != null)
                {
                    var daBlock = blockData[nearestBlockPos.y][nearestBlockPos.x];
                    if (daBlock[0] == "event_block")
                    {
						var daSubState = new UISubstateWindow(true, "popups/SMBEventBlock");
                        daSubState.openCallback = function () {
                            daSubState.stateScripts.set("daBlock", daBlock);
                        };
                        openSubState(daSubState);
                    }
                }
                mouseBlock.visible = false;
                currentCursor = MouseCursor.ARROW;
            } else {
                currentCursor = MouseCursor.BUTTON;
                mouseBlock.visible = true;
            }
        }

        mouseBlock.x = nearestBlockPos.x * getBlockSize();
        mouseBlock.y = nearestBlockPos.y * getBlockSize();

        if (FlxG.mouse.pressed && mouseBlock.visible)
        {
            var blockDataArray = blockData[nearestBlockPos.y] ?? [];
            var blockAnim = boxSprites[selectedBlock].extra["anim"];
            if ((blockDataArray[nearestBlockPos.x] ?? null) == null)
            {
                var insertedBlock = makeSpriteSheet();
                insertedBlock.animation.play(blockAnim);
                insertedBlock.x = nearestBlockPos.x * getBlockSize();
                insertedBlock.y = nearestBlockPos.y * getBlockSize();
                insert(0, insertedBlock);
                blockDataArray[nearestBlockPos.x] = [blockAnim, insertedBlock];
            } else if (blockDataArray[nearestBlockPos.x][0] != blockAnim) {
                blockDataArray[nearestBlockPos.x][0] = blockAnim;
                blockDataArray[nearestBlockPos.x][1].animation.play(blockAnim);
            }
            blockData[nearestBlockPos.y] = blockDataArray;
        }
    } else {
        mouseBlock.visible = false;
        currentCursor = MouseCursor.ARROW;
    }
    
    for (box in boxSprites)
    {
        var mousePos = FlxG.mouse.getPositionInCameraView(uiCamera);
        var overlaps = box.overlapsPoint(mousePos, true, uiCamera);
        box.alpha = (overlaps || selectedBlock == box.extra["id"]) ? 1 : 0.3;
        if (overlaps) {
            currentCursor = MouseCursor.BUTTON;
            if (FlxG.mouse.justPressed) {
                selectedBlock = box.extra["id"];
                mouseBlock.animation.play(box.extra["anim"], true);
            }
        }
    }

    smbCam.scroll.set(
		lerp(smbCam.scroll.x, nextScroll.x, 0.35),
		smbCam.scroll.y
	);
}

function _file_exit(_) {
	var state = new MainMenuState();
	FlxG.switchState(state);
}

var eventBlocks:Array<Dynamic> = [];

function convertDataFileToLevelData()
{
    var levelData = [];

    var levelDataFile = Assets.getText("assets/data/smblvldata.txt");
    var splittedData = levelDataFile.split("|");
    for (block in splittedData)
    {
        var blockData = block.split(";");
        var blockName = blockData[0];
        var blockPosX = Std.parseInt(blockData[1]);
        var blockPosY = Std.parseInt(blockData[2]);

        var rowData = levelData[blockPosY] ?? [];
        rowData[blockPosX] = blockName;
        levelData[blockPosY] = rowData;

        if (blockName == "event_block")
        {
            var eventBlockData = [Std.parseInt(blockData[3]), blockData[4]];
            var eventBlockPos = FlxPoint.get(blockPosX, blockPosY);
            eventBlocks.push([eventBlockPos, eventBlockData]);
        }
    }

    return levelData;
}

function _file_save(_) {
    var fileData = "";
    for (y in 0...blockData.length)
    {
        var row = blockData[y] ?? [];
        for (x in 0...row.length)
        {
            var block = row[x];
            var sepSuffix = (x == row.length - 1 ? "" : "|");
            if (block != null) {
                if (block[0] == "event_block")
                {
                    var eventBlockData = block[1].extra["eventBlockData"];
                    sepSuffix = ";" + eventBlockData[0] + ";" + eventBlockData[1] + sepSuffix;
                }
                fileData += block[0] + ";" + x + ";" + y + sepSuffix;
            }
        }
        fileData += (y == blockData.length - 1 ? "" : "|");
    }
    openSubState(new SaveSubstate(fileData, {
        defaultSaveFile: 'smblvldata.txt'
    }));
	return;
}

function getBlockPos(x:Float, y:Float):FlxPoint {
    return FlxPoint.get(x * getBlockSize(), y * getBlockSize());
}

function getBlockScale():Float {
    return 3;
}

function getBlockSize():Float {
    return 16 * getBlockScale();
}

function getBlockPosFromActualPos(x:Float, y:Float):FlxPoint {
    return FlxPoint.get(x / getBlockSize(), y / getBlockSize());
}

function getNearestBlockPos(x:Float, y:Float):FlxPoint {
    var actualBlockPos = getBlockPosFromActualPos(x, y);
    var roundedBlockBelowPos = FlxPoint.get(Math.floor(actualBlockPos.x), Math.floor(actualBlockPos.y));
    return roundedBlockBelowPos;
}