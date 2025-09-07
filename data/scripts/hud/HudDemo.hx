import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;
import flixel.util.FlxStringUtil;
import funkin.backend.system.framerate.Framerate;

var icoAnim:Int = 0;
var test2:FlxBar;
var testM:FlxBar;
var youtubegradient:FlxSprite;
var ico2:HealthIcon;
var ico1:HealthIcon;

var newHUD:FlxSprite;
var score:FlxText;
var miss:FlxText;
var iconsX:Float = 0;
var iconsY:Float = 0;
var isAnimatedHUD:Bool = false;

var camYT:FlxCamera;
var timerText:FlxText;

function postCreate() {
    
    camYT = new FlxCamera();
    camYT.bgColor = 0x00000000;
	FlxG.cameras.add(camYT, false);

    healthBar.scale.set(0.5,1);
    healthBarBG.scale.set(0.502,1);
    iconP1.setHealthSteps([[0, 1], [20, 0]]);

    hideDefaultHUDText();
    createTestMBar();
    demoBF();

    Framerate.offset.y = 50;
}

function destroy() {
    Framerate.offset.y = 0;
}


function demoBF(){
    screen = new FlxSprite(20,250).loadGraphic(Paths.image("stages/black/infernal"), true, 220, 200);
    //screen.scale.set(1.4,1.4);
    screen.animation.add("lose", [0,1,2], 0, true);
    screen.animation.play("lose");
    screen.antialiasing = true;
    screen.updateHitbox();
    screen.cameras = [camHUD];
    insert(members.indexOf(healthBar), screen);
    remove(healthBar);
}

function update(elapsed:Float) {
    if (score != null && miss != null) {
        score.text = "S: " + songScore;
        miss.text = " | " + "M: " + misses;
    }

    if (curStage == 'black'){

        if (health > 1.5){
            screen.offset.set(-22, 0);
            screen.animation.curAnim.curFrame = 2;
        }
        if (health < 1.5){
            screen.animation.curAnim.curFrame = 1;
            screen.offset.set(-5, 0);
        }
        if (health < 0.5){
            screen.animation.curAnim.curFrame = 0;
            screen.offset.set(11, -1);
        }
    }
}

function postUpdate() {
    updateTestBars();
  
    if (icoAnim >= 0) {
        icoAnim--;
    }
}

function onPlayerMiss() {
    icoAnim = 20;
}

function adjustHealthBarPosition(yBGFactor:Float, yBarFactor:Float) {
    healthBarBG.y = (FlxG.height / yBGFactor) - (healthBar.height / 1.4);
    healthBar.y = (FlxG.height / yBarFactor) - (healthBar.height / 1.4);
}

function setIconPosition(x:Float, y:Float, baseY:Float) {
    iconsX = x;
    iconsY = y;
    iconP2.y = iconP1.y = baseY + iconsY;
}

function createTestMBar() {
    var meta = PlayState.SONG.meta;
    var title = new FlxText(15, 10, FlxG.width, meta.displayName + " (by " + meta.pause.composer + ") - Sunday Night Plumbin' [OST Vol. 1]");
    title.font = Paths.font("Roboto.ttf");
    title.size = 27;
    title.antialiasing = true;
    add(title);
    title.cameras = [camYT];

    testM = new FlxBar(1900, 450, FlxBarFillDirection.LEFT_TO_RIGHT, 1280, 5, Conductor, 'songPosition', 0, 1);
    testM.screenCenter();
    testM.unbounded = true;
    testM.antialiasing = true;
    testM.createFilledBar(0x18FFFFFF, 0xFFFF0135);
    testM.y = (FlxG.height / 2) + 300;
    testM.x = (FlxG.width / 2) - 639.8;
    add(testM);
    testM.cameras = [camYT];
    testM.value = Conductor.songPosition / Conductor.songDuration;

    youtubegradient = new FlxSprite(testM.x, testM.y).loadGraphic(Paths.image("hud/youtube_gradient"));
    add(youtubegradient);
    youtubegradient.cameras = [camYT];
    youtubegradient.scale.set(1, testM.height);
    youtubegradient.updateHitbox();

    timerText = new FlxText(15, FlxG.height - 40, FlxG.width, "" + Conductor.songPosition + " / " + Conductor.songDuration);
    timerText.font = Paths.font("Roboto.ttf");
    timerText.size = 17;
    timerText.antialiasing = true;
    add(timerText);
    timerText.cameras = [camYT];
    
    for (text in [title, timerText])
        upscaleText(text, 2);
}

function hideDefaultHUDText() {
    remove(scoreTxt);
    remove(missesTxt);
    remove(accuracyTxt);
    remove(comboGroup);
    remove(iconP2);
    remove(iconP1);
    remove(healthBarBG);
}

function updateTestBars() {
    if (inst != null) {
        timerText.text = FlxStringUtil.formatTime(Math.floor(inst.time / 1000), false) + " / " + FlxStringUtil.formatTime(Math.floor(inst.length / 1000), false) + "                                                      " + 
            applyFiller(getString("yt_hud_text"), [songScore, misses]);
        youtubegradient.x = FlxMath.remapToRange(testM.percent, 0, 100, 0, 1) * testM.width + testM.x - youtubegradient.width;
        if (test2 != null && test2.max != inst.length) {
            test2.setRange(0, Math.max(1, inst.length));
        }

        if (testM != null && testM.max != inst.length) {
            testM.setRange(0, Math.max(1, inst.length));
        }
    }
}