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
    spr.animation.add("arrow_1", [14], 0, false);
    spr.animation.add("arrow_2", [15], 0, false);
    spr.animation.add("arrow_3", [16], 0, false);
    spr.animation.add("arrow_4", [17], 0, false);
    spr.animation.add("bush1_1", [18], 0, false);
    spr.animation.add("bush1_2", [19], 0, false);
    spr.animation.add("bush1_3", [20], 0, false);
    spr.animation.add("bush1_4", [21], 0, false);
    spr.animation.add("bush1_5", [22], 0, false);
    spr.animation.add("bush1_6", [23], 0, false);
    spr.animation.add("bush2_1", [24], 0, false);
    spr.animation.add("bush2_2", [25], 0, false);
    spr.animation.add("bush2_3", [26], 0, false);
    spr.animation.add("sky", [27], 0, false);
    spr.animation.add("event_block", [27], 0, false);
    spr.animation.add("barrier", [27], 0, false);

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

var shouldStartMaltigi = true;
function setEaracheRun()
{
    if (!shouldStartMaltigi) return;
    shouldStartMaltigi = false;

    mario.disableControls = true;
    var data = getColorData(FlxG.camera.bgColor);
    var wantedColor = getColorData(0xFF010101);

    var curRed = data.redFloat;
    var curGreen = data.greenFloat;
    var curBlue = data.blueFloat;

    var twnDur = 5;
    var tweenEase = FlxEase.quadInOut;
    FlxTween.num(curRed, wantedColor.redFloat, twnDur, {ease: tweenEase}, (v) -> {
        curRed = v;
    });
    FlxTween.num(curGreen, wantedColor.greenFloat, twnDur, {ease: tweenEase}, (v) -> {
        curGreen = v;
    });
    FlxTween.num(curBlue, wantedColor.blueFloat, twnDur, {ease: tweenEase}, (v) -> {
        curBlue = v;
        FlxG.camera.bgColor = FlxColor.fromRGBFloat(curRed, curGreen, curBlue);
    });

    FlxTween.tween(FlxG.sound.music, {volume: 0}, 2, {ease: FlxEase.quadInOut});
    new FlxTimer().start(2.5, () -> {
        FlxTween.tween(mario.camPos, {x: mario.getBlockPos(65, 0).x}, 4.5, {ease: FlxEase.quartInOut});
        new FlxTimer().start(5.5, () -> {
            var maltigi = new FlxSprite(0, 0).loadGraphic(Paths.image('states/freeplay/paintings/Earache'));
            maltigi.scale.set(0.25, 0.25);
            maltigi.updateHitbox();
            var maltiWidth = maltigi.width;
            maltigi.scale.set(0, 0);
            maltigi.updateHitbox();
            maltigi.x = mario.getBlockPos(75, 0).x;
            maltigi.screenCenter(FlxAxes.Y);
            maltigi.y += 50; 
            add(maltigi);
            FlxTween.tween(maltigi, {"scale.x": 0.25, "scale.y": 0.25}, 0.2, {ease: FlxEase.circOut});

            new FlxTimer().start(0.2 + 0.1, function(_) {
                FlxG.sound.play(Paths.sound("scream"), 0.25).persist = true;
                FlxG.sound.playMusic(Paths.music("smb-run"));
                FlxG.camera.shake(0.0125, 3, true);

                new FlxTimer().start(3, () -> {
                    var t = null;
                    FlxTween.tween(mario.camPos, {x: mario.x - mario.width - (FlxG.width / 2.5)}, 0.5, {ease: FlxEase.quadInOut, onComplete: () ->  {
                        mario.disableControls = false;
                    }});

                    var runText = new FunkinSprite(0, 0, Paths.image("states/retro/RUN-" + FlxG.save.data.language));
                    runText.addAnim("idle", "idle", 24, true);
                    runText.playAnim("idle");
                    runText.screenCenter(FlxAxes.X);
                    runText.y = 50;
                    runText.scrollFactor.set();
                    add(runText);
                    runText.alpha = 0.001;
                    runText.moves = true;

                    FlxTween.tween(runText, {alpha: 1}, 0.5, {ease: FlxEase.quadInOut});

                    var fuckinDie = function()
                    {
                        if (mario.isEaracheDeath) return;
                        mario.isEaracheDeath = true;
                        mario.die();
                        FlxG.sound.music.play();
                        FlxTween.tween(FlxG.sound.music, {volume: 0.4}, 0.5);
                        mario.spr.alpha = 0;

                        runText.acceleration.y = FlxG.random.int(200, 300);
                        runText.angularVelocity = -(FlxG.random.int(10, -10) * 3);
                        runText.velocity.set(FlxG.random.float(-5, 5), -FlxG.random.int(140, 160));
                    };
                    t = FlxTween.tween(maltigi, {x: mario.getBlockPos(164.25, 0).x}, 6.5, {onUpdate: () -> {
                        var doesBFTouch = ((maltigi.x + maltiWidth) - (mario.spr.x + mario.spr.width)) >= 300;
                        if (doesBFTouch) {
                            //t.cancel();
                            fuckinDie();
                        }
                    }, onComplete: fuckinDie});
                });
            });
        });
    });
}

function destroy() {
    FlxG.camera.bgColor = 0xFF000000;
}

function onImmortalPipe() {
    if (!mario.died && mario.physicsVelocity.y == 0)
    {
        mario.died = true;
        var newXPos = mario.getBlockPos(59.5, 0).x; //hardcoded sorry
        var newYPos = mario.y + (mario.height * 1.5);

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
        var blockName = drawData[1];
        if (blockName == null) continue;

        var drawOnTop = drawData[2];
        if (!drawOnTop) {
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