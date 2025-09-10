import Mario;
import flixel.group.FlxSpriteGroup;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import funkin.backend.scripting.events.DrawEvent;
import funkin.backend.system.Controls.Control;
import funkin.editors.ui.UIState;

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
    spr.animation.add("event_block", [26], 0, false);
    spr.animation.add("barrier", [26], 0, false);

    spr.scale.set(mario.getBlockScale(), mario.getBlockScale());
    spr.updateHitbox();

    return spr;
}

var mario;

function update(elapsed) {
    var marioCam = mario.getCam();
    var marioCamPos = marioCam.pos;
    FlxG.camera.scroll.set(marioCamPos.x, marioCamPos.y);
    FlxG.camera.zoom = marioCam.zoom;
    mario.update(elapsed);

    if (controls.DEV_ACCESS)
        FlxG.switchState(new UIState(true, "smbEditor"));
}


function convertDataFileToLevelData()
{
    var levelData = [];
    var eventBlocks = [];

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

    return [levelData, eventBlocks];
}

function onImmortalPipe() {
    if (!mario.died && mario.physicsVelocity.y == 0)
    {
        mario.died = true;
        var newXPos = mario.getBlockPos(46.5, 0).x; //hardcoded sorry
        var newYPos = mario.y + (mario.height * 2);


        FlxTween.tween(mario, {x: newXPos}, 0.5, {onComplete: function (_) {
		    FlxG.sound.play(Paths.sound('retro/pipe'));
            FlxTween.tween(mario, {y: newYPos}, 1, {onComplete: function () {
                FlxG.save.data.curPowerUp = 0;
                FlxG.save.flush();
                PlayState.loadSong("Immortal-Old", "normal");
                FlxG.switchState(new PlayState());
            }});
        }});
    }
}

var blockPositions = [];

function getInputsFor(control:Control):Array<Int>
{
    var list = [];

    for (input in controls.getActionFromControl(control).inputs)
    {
        if (input.device == FlxInputDevice.KEYBOARD || input.deviceID == id)
            list.push(input.inputID);
    }
    return list;
}

function create() {
    FlxG.camera.bgColor = 0xFFFFA200;
    mario = new Mario(0, 0);
    FlxG.sound.playMusic(Paths.music("smb"));
    
    var lvl = convertDataFileToLevelData();
    var levelData = lvl[0];
    var eventBlocks = lvl[1];
    for (i in 0...levelData.length)
    {
        for (j in 0...levelData[i].length)
        {
            var blockName = levelData[i][j];
            if (blockName == "sky") continue;
            var blockPos = mario.getBlockPos(j, i);
            blockPositions.push([blockPos, blockName, StringTools.contains(blockName, "pipe_")]);
        }
    }
    
    var keybinds = {
        left: getInputsFor(Control.LEFT),
        down: getInputsFor(Control.DOWN),
        up: getInputsFor(Control.UP),
        right: getInputsFor(Control.RIGHT),
        jump: getInputsFor(Control.ACCEPT),
        run: [FlxKey.SHIFT, FlxKey.CONTROL],
        die: getInputsFor(Control.RESET),
    }
    
    var spawnPoint = mario.getBlockPos(3.5, 12);
    mario.spawn(spawnPoint, levelData, eventBlocks, keybinds);
    blockSize = mario.getBlockSize();
    drawingBlock = makeSpriteSheet();

	addMenuShaders();
}

var blockSize = 0;
var drawingBlock;
var _unDrawnSprs = [];
function shouldShowBlock(pos) { //lags the game for some reason
    return pos + blockSize > FlxG.camera.scroll.x && pos < FlxG.camera.scroll.x + FlxG.camera.width;
}

function draw(event:DrawEvent) {
    _unDrawnSprs.resize(0);
    var sprPos = 0;
    for (drawData in blockPositions)
    {
        var blockPos = drawData[0];

        //if (!shouldShowBlock(blockPos.x)) continue;

        var drawOnTop = drawData[2];
        if (!drawOnTop) {

            var blockName = drawData[1];
            drawingBlock.setPosition(blockPos.x, blockPos.y);
            drawingBlock.animation.play(blockName);
            drawingBlock.draw();
        } else
            _unDrawnSprs.push(drawData);
    }
    mario.draw();
    for (drawData in _unDrawnSprs)
    {
        var blockPos = drawData[0];
        var blockName = drawData[1];

        drawingBlock.setPosition(blockPos.x, blockPos.y);
        drawingBlock.animation.play(blockName);
        drawingBlock.draw();
    }
}