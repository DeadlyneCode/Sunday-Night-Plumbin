import flixel.input.keyboard.FlxKey;
import flixel.util.FlxPoint;

class Mario extends FlxSprite {
    public static var keybinds = {};

    private static var WALK_SPEED:Float = 560;
    private static var RUN_SPEED:Float = 660;
    private static var INITIAL_JUMP_VELOCITY:Float = -750;
    private static var GRAVITY:Float = 1800;
    private static var GROUND_ACCELERATION:Float = 5000;
    private static var GROUND_DECELERATION:Float = 3000;
    private static var AIR_ACCELERATION:Float = 500*2.5;
    private static var AIR_DECELERATION:Float = 700*2.5;
    private static var MAX_JUMP_HOLD_TIME:Float = 0.5;
    private static var GRAVITY_WHILE_JUMPING:Float = GRAVITY * .65;
    private static var GRAVITY_WHILE_FALLING:Float = GRAVITY * 1.2;

    private var physicsVelocity:FlxPoint;
    private var isGrounded:Bool;
    private var isJumping:Bool;
    private var levelData:Array<Array<String>>;
    private var eventBlocks:Array<Dynamic>;
    private var died:Bool = false;
    private var collidableBlocks:Array<String> = ["ground", "itemblock", "usedblock", "block", "solidblock", "pipe_1", "pipe_2", "pipe_3", "pipe_4", "barrier"];

    private var spr:FunkinSprite;

    override public function new(x:Float, y:Float) {
        super(x, y);
        makeGraphic(getBlockSize() * 0.95, getBlockSize() * 1.1, 0xFFFF0000);
        physicsVelocity = FlxPoint.get(0, 0);
        isGrounded = false;
        isJumping = false;

        spr = new FunkinSprite();
        spr.frames = Paths.getAsepriteAtlas("states/retro/bf");
        spr.scale.set(getBlockScale(), getBlockScale());
        spr.updateHitbox();
        spr.addAnim("idle", "idle0", 6, true);
        spr.addAnim("walk", "walk0", 12, true);
        spr.addAnim("run", "walk0", 18, true);
        spr.addAnim("jump", "Jump0", 1, true);

        for (a in ["idle", "walk", "run", "jump"])
            spr.addOffset(a, 0, getBlockSize() * 0.3);

        spr.playAnim("idle");
    }

    override public function draw()
    {
        spr.x = x;
        spr.y = y;
        //super.draw();
        spr.draw();
    }

    public function spawn(point:FlxPoint, daLevel:Array<Array<String>>, events:Array<Dynamic>, keybind) {
        setPosition(point.x, point.y);
        levelData = daLevel;
        keybinds = keybind;
        eventBlocks = events;
    }

    public function getBlockPos(x:Float, y:Float):FlxPoint {
        return FlxPoint.get(x * getBlockSize(), y * getBlockSize());
    }

    public function getBlockScale():Float {
        return 3;
    }

    public function getBlockSize():Float {
        return 16 * getBlockScale();
    }

    public function getBlockPosFromActualPos(x:Float, y:Float):FlxPoint {
        return FlxPoint.get(x / getBlockSize(), y / getBlockSize());
    }

    public function getBlockAtPos(blockPos:FlxPoint):String {
        if (blockPos.x < 0 || blockPos.x >= levelData[0].length || blockPos.y < 0 || blockPos.y >= levelData.length) {
            return "sky";
        }
        return levelData[Std.int(blockPos.y)][Std.int(blockPos.x)];
    }

    private var camX:Float = 0;
    private var camY:Float = 0;
    private var camZoom:Float = 1;
    public function getCam() {
        return {pos: FlxPoint.get(camX, camY), zoom: camZoom};
    }

    private function updateHorizontalMovement(left:Bool, right:Bool, run:Bool, elapsed:Float):Void {
        var targetSpeed:Float = run ? RUN_SPEED : WALK_SPEED;
        var acceleration:Float = isGrounded ? GROUND_ACCELERATION : AIR_ACCELERATION;
        var deceleration:Float = isGrounded ? GROUND_DECELERATION : AIR_DECELERATION;

        if (!isGrounded)
        {
            spr.playAnim("jump", false);
        } else {
            if (left || right) {
                spr.flipX = left;
                spr.playAnim(run ? "run" : "walk", false);
            }
        }

        if (left) {
            physicsVelocity.x = Math.max(-targetSpeed, physicsVelocity.x - acceleration * elapsed);
        } else if (right) {
            physicsVelocity.x = Math.min(targetSpeed, physicsVelocity.x + acceleration * elapsed);
        } else {
            if (spr.animation.curAnim.name != "idle" && isGrounded)
                spr.playAnim("idle");

            if (physicsVelocity.x > 0) {
                physicsVelocity.x = Math.max(0, physicsVelocity.x - deceleration * elapsed);
            } else if (physicsVelocity.x < 0) {
                physicsVelocity.x = Math.min(0, physicsVelocity.x + deceleration * elapsed);
            }
        }
    }

    private function sign(value:Float):Int {
        return (value > 0) ? 1 : (value < 0) ? -1 : 0;
    }

    private function handleHorizontalCollisions(elapsed:Float):Void {
        var step:Float = Math.abs(physicsVelocity.x * elapsed);
        var direction:Int = Std.int(sign(physicsVelocity.x));

        while (step > 0) {
            var moveBy:Float = Math.min(step, getBlockSize() / 1.5);
            var nextX:Float = x + moveBy * direction;

            var blockPos = getBlockPosFromActualPos(
                direction < 0 ? nextX - 1 : nextX + width + 1,
                y + height / 2
            );
            var roundedBlockPos = FlxPoint.get(Math.floor(blockPos.x), Math.floor(blockPos.y));
            var block = getBlockAtPos(roundedBlockPos);

            if (collidableBlocks.indexOf(block) != -1) {
                var blockEdge = getBlockPos(roundedBlockPos.x, roundedBlockPos.y).x;
                if (direction < 0)
                    x = blockEdge + getBlockSize();
                else
                    x = blockEdge - width;
                physicsVelocity.x = 0;
                return;
            }

            x = nextX;
            step -= moveBy;
        }
    }

    private var jumpHoldTime:Float = 0;

    private function updateJump(jump:Bool, elapsed:Float):Void {
        if (isGrounded && jump && !isJumping) {
            physicsVelocity.y = INITIAL_JUMP_VELOCITY;
            isJumping = true;
            jumpHoldTime = 0;
		    FlxG.sound.play(Paths.sound('retro/jump'));
        }

        if (isJumping) {
            if (jump && jumpHoldTime < MAX_JUMP_HOLD_TIME) {
                jumpHoldTime += elapsed;
                physicsVelocity.y = INITIAL_JUMP_VELOCITY + GRAVITY_WHILE_JUMPING * jumpHoldTime;
            }/* else
                isJumping = false;*/
        }

        if (isGrounded) {
            isJumping = false;
            jumpHoldTime = 0;
        }
    }

    private function applyGravity(elapsed:Float) {
        var physicsAffluense = ((physicsVelocity.y >= -50 && sign(physicsVelocity.y) != 0) ? GRAVITY_WHILE_FALLING : (!isJumping ? GRAVITY : GRAVITY_WHILE_JUMPING));
        physicsVelocity.y = physicsVelocity.y + (physicsAffluense) * elapsed;
    }

    private function updatePhysics(elapsed:Float) {
        x += physicsVelocity.x * elapsed;
        y += physicsVelocity.y * elapsed;
    }

    public function die():Void {
        if (died) return;

        visible = false;

        FlxG.sound.music.pause();
        FlxG.sound.play(Paths.sound("smb_died"));

        new FlxTimer().start(1.5, function(_) {
            FlxTween.num(camX, Math.max(-150, x - FlxG.width / 2), 2, {ease: FlxEase.quadOut}, (t) -> {
                camX = t;
            });
            FlxTween.num(camY, Math.min(70, y - FlxG.height / 2), 2, {ease: FlxEase.quadOut}, (t) -> {
                camY = t;
            });
            FlxTween.num(camZoom, 1.3, 2, {ease: FlxEase.quadOut}, (t) -> {
                camZoom = t;
            });
        });

        new FlxTimer().start(5, function(_) {
            var maltigi = new FlxSprite(0, 0).loadGraphic(Paths.image('states/freeplay/paintings/Earache'));
            maltigi.scale.set(0, 0);
            maltigi.updateHitbox();
            maltigi.scrollFactor.set();
            maltigi.screenCenter();
            FlxG.state.add(maltigi);
            FlxTween.tween(maltigi, {"scale.x": 0.35, "scale.y": 0.35}, 0.2, {ease: FlxEase.circOut});

            new FlxTimer().start(0.2 + 0.1, function(_) {
                FlxG.sound.play(Paths.sound("scream"), 1).persist = true;
                FlxG.camera.shake(0.025, 3, true);

                new FlxTimer().start(3, function(_) {
                    FlxG.save.data.curPowerUp = 0;
                    FlxG.save.flush();
                    PlayState.loadSong("Earache", "normal");
                    FlxG.switchState(new PlayState());
                });
            });
        });
        died = true;
    }

    private function checkEventBlockCollision(left, down, up, right, jump):Void {
        var blockPos = getBlockPosFromActualPos(x + width / 2, y + height / 2);
        var roundedBlockPos = FlxPoint.get(Math.floor(blockPos.x), Math.floor(blockPos.y));
        var block = getBlockAtPos(roundedBlockPos);

        if (block == "event_block") {
            for (eventBlock in eventBlocks) {
                var eventBlockPos = eventBlock[0];
                var roundedEventBlockPos = FlxPoint.get(Math.floor(eventBlockPos.x), Math.floor(eventBlockPos.y));

                if (!roundedBlockPos.equals(roundedEventBlockPos)) continue;

                var eventBlockData = eventBlock[1];
                var eventType = eventBlockData[0];
                var functionName = eventBlockData[1];

                var conditions = [left, down, up, right, jump];

                if (eventType == 0 || conditions[eventType - 1] == true) {
                    FlxG.state.stateScripts.call(functionName);
                }
            }
        }
    }

    override public function update(elapsed:Float):Void {
        if (died) {
            super.update(elapsed);
            spr.update(elapsed);
            return;
        }

        if (FlxG.keys.anyPressed(keybinds.die) || y >= FlxG.height) {
            die();
            super.update(elapsed);
            spr.update(elapsed);
            return;
        }

        
        spr.update(elapsed);

        var moveLeft = FlxG.keys.anyPressed(keybinds.left);
        var moveRight = FlxG.keys.anyPressed(keybinds.right);
        var down = FlxG.keys.anyPressed(keybinds.down);
        var up = FlxG.keys.anyPressed(keybinds.up);
        var jump = FlxG.keys.anyPressed(keybinds.jump);
        var run = FlxG.keys.anyPressed(keybinds.run);

        checkEventBlockCollision(moveLeft, down, up, moveRight, jump);

        updateHorizontalMovement(moveLeft, moveRight, run, elapsed);
        updateJump(jump, elapsed);
        handleHorizontalCollisions(elapsed);
        applyGravity(elapsed);

        var nextY = y + (physicsVelocity.y * elapsed);
        var blockBelowPos = getBlockPosFromActualPos(x + width / 2, nextY + height);
        var roundedBlockBelowPos = FlxPoint.get(Math.floor(blockBelowPos.x), Math.floor(blockBelowPos.y));
        var blockBelow = getBlockAtPos(roundedBlockBelowPos);

        if (collidableBlocks.indexOf(blockBelow) != -1) {
            var groundY = getBlockPos(roundedBlockBelowPos.x, roundedBlockBelowPos.y).y;
            if (nextY + height >= groundY) {
                y = groundY - height;
                physicsVelocity.y = 0;
                isGrounded = true;
            } else {
                y = nextY;
            }
        } else {
            isGrounded = false;
            y = nextY;
        }

        var blockAbovePos = getBlockPosFromActualPos(x + width / 2, y - 1);
        var roundedBlockAbovePos = FlxPoint.get(Math.floor(blockAbovePos.x), Math.floor(blockAbovePos.y));
        var blockAbove = getBlockAtPos(roundedBlockAbovePos);

        if (collidableBlocks.indexOf(blockAbove) != -1) {
            var ceilingY = getBlockPos(roundedBlockAbovePos.x, roundedBlockAbovePos.y).y + getBlockSize();
            if (y <= ceilingY) {
                y = ceilingY;
                physicsVelocity.y = 0;
            }
        }

        var newCamPos = (x - width - (FlxG.width / 2.5));
        if (camX < newCamPos) {
            camX = Math.max(0, newCamPos);
        }
        x = Math.max(FlxG.camera.scroll.x, x);

        super.update(elapsed);
    }
}