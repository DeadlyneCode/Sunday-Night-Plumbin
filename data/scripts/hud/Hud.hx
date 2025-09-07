import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;
import funkin.game.PlayState;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.util.FlxSpriteUtil;

var test:Int = 0;
public var test2:FlxBar;
public var testM:FlxBar;
public var test4:FlxSprite;
public var ico2:HealthIcon;
public var ico1:HealthIcon;

public var newHUD:FlxSprite;
public var score:FlxText;
public var miss:FlxText;
var iconsX:Float = 0;
var iconsY:Float = 0;

public var isAnimatedHUD:Bool = false;

function postCreate() {
    comboGroup.visible = false;
    healthBar.scale.set(0.5,1);
    healthBarBG.scale.set(0.502,1);
    iconP1.setHealthSteps([[0, 1], [20, 0]]);
    
    switch (curStage) {
        case 'immortal':
            configureHUD("hudc", 0.67, 0.67, false);
            adjustHealthBarPosition(1.04, 1.035);
            setIconPosition(15, 15, FlxG.height - 150);
            
        case 'cataclysmic':
            configureHUD("hud_mx", 1, 1, true);
            adjustHealthBarPosition(1.045, 1.04);
            
        case 'hallways':
            healthBar.visible = healthBarBG.visible = false;
            adjustHealthBarPosition(1.045, 1.035);
            
        case 'black':
            demoBF();
            hideDefaultHUDText();
            remove(iconP2);
            remove(iconP1);
            remove(healthBarBG);
            remove(healthBar);
            createTestMBar();
            createTestCircle();
            
        default:
            time();
            configureHUD("hud", 0.67, 0.67, false);
            adjustHealthBarPosition(1.075, 1.069);
            setIconPosition(15, 15, FlxG.height - 150);
    }
}


function demoBF(){
    screen = new FlxSprite(90,250).loadGraphic(Paths.image("stages/black/infernal"), true, 220, 200);
    //screen.scale.set(1.4,1.4);
    screen.animation.add("lose", [0,1,2], 0, true);
    screen.animation.play("lose");
    screen.antialiasing = true;
    screen.updateHitbox();
    screen.cameras = [camHUD];
    insert(members.indexOf(healthBar), screen);
}

function update(elapsed:Float) {
    if (score != null && miss != null) {
        score.text = "S: " + songScore;
        miss.text = " | " + "M: " + misses;
    }

    if (curStage == 'black'){

        if (health > 1.5){
            screen.offset.set(-27, 0);
            screen.animation.curAnim.curFrame = 2;
        }
        if (health < 1.5){
            screen.animation.curAnim.curFrame = 1;
            screen.offset.set(-5, 0);
        }
        if (health < 0.5){
            screen.animation.curAnim.curFrame = 0;
            screen.offset.set(17, -1);
        }
    }
}

var daIconScale:Float = 1;

function postUpdate() {
    daIconScale = lerp(daIconScale, 1, 0.33 / 2);

    iconP1.scale.set(daIconScale, daIconScale);
    if (curStage == "disto") {
        iconP2.scale.set(1, 1);
    } else {
        iconP2.scale.set(daIconScale, daIconScale);
    }
    
    setIconPositions();
    updateTestBars();
  
    if (test >= 0) {
        test--;
    }
}

function beatHit(curBeat) {
    daIconScale += 0.15;
}

function onPlayerMiss() {
    test = 20;
}

function configureHUD(name:String, scaleX:Float, scaleY:Float, animated:Bool) {
    isAnimatedHUD = animated;
    newHUD = new FlxSprite(0, 0).loadGraphic(Paths.image('hud/' + name));
    
    if (isAnimatedHUD) {
        newHUD.frames = Paths.getSparrowAtlas('hud/' + name);
        newHUD.animation.addByPrefix('barmx', 'barmx0', 24, true);
        newHUD.animation.play('barmx');
    }
    
    newHUD.screenCenter();
    newHUD.scale.set(scaleX, scaleY);
    newHUD.cameras = [camHUD];
    if (downscroll) newHUD.flipY = true;
    newHUD.y = (FlxG.height / 1.07) - (newHUD.height / 2);
    insert(members.indexOf(healthBarBG), newHUD);
    
    hideDefaultHUDText();
    createCustomHUDText();
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
    testM = new FlxBar(1900, 450, FlxBarFillDirection.LEFT_TO_RIGHT, 1280, 10, Conductor, 'songPosition', 0, 1);
    testM.screenCenter();
    testM.createFilledBar(FlxColor.GRAY, FlxColor.RED);
    testM.y = (FlxG.height / 2) + 340;
    testM.x = (FlxG.width / 2) - 639.8;
    add(testM);
    testM.cameras = [camHUD];
    testM.value = Conductor.songPosition / Conductor.songDuration;
}

function createTestCircle() {
    test4 = new FlxSprite(0, 605);
    test4.makeGraphic(200, 200, 0x00000000);
    FlxSpriteUtil.drawCircle(test4, 100, 100, 10, FlxColor.RED);
    add(test4);
    test4.x = (FlxG.width / 2) + 239.8;
    test4.cameras = [camHUD];
}

function hideDefaultHUDText() {
    scoreTxt.visible = false;
    missesTxt.visible = false;
    accuracyTxt.visible = false;
}

function createCustomHUDText() {
    var yPosition = downscroll ? 680 : 685;
    
    score = new FlxText(465, yPosition, 0, "", 60, 0xFF000000);
    score.setFormat(Paths.font("SuperMario256.ttf"), 30, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    score.cameras = [camHUD];
    score.borderSize = 2;
    insert(members.indexOf(healthBar) + 1, score);

    miss = new FlxText(622, yPosition, 0, "", 60, 0xFF000000);
    miss.setFormat(Paths.font("SuperMario256.ttf"), 30, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    miss.cameras = [camHUD];
    miss.borderSize = 2;
    insert(members.indexOf(healthBar) + 1, miss);
}

function time() {
    test2 = new FlxBar(1900, 450, FlxBarFillDirection.LEFT_TO_RIGHT, 220, 15, Conductor, 'songPosition', 0, 1);
    test2.screenCenter();
    test2.y = (FlxG.height / 2) - 340;
    test2.x = (FlxG.width / 2) - 100.8;
    add(test2);
    test2.cameras = [camHUD];
}

function setIconPositions() {
    if (!downscroll) {
        iconP1.x = FlxG.width - 150 / 2 + iconsX - iconP1.width / 2;
        iconP1.y = FlxG.height - (150 * 0.5) - (iconP1.height / 2) + iconsY;

        iconP2.x = 150 / 2 - iconP2.width / 2 - iconsX;
        iconP2.y = FlxG.height - (150 * 0.5) - (iconP2.height / 2) + iconsY;
    } else {
        iconP1.x = FlxG.width - 150 / 2 + iconsX - iconP1.width / 2;
        iconP1.y = FlxG.height - (150 * 0.4) - (iconP1.height / 2) + iconsY;

        iconP2.x = 150 / 2 - iconP2.width / 2 - iconsX;
        iconP2.y = FlxG.height - (150 * 0.4) - (iconP2.height / 2) + iconsY;
    }

    iconP1.animation.curAnim.curFrame = (iconP1.health >= 0.2 ? 0 : 1);
    iconP2.animation.curAnim.curFrame = (iconP2.health >= 0.2 ? 0 : 1);
    iconP1.animation.curAnim.curFrame += (test > 0 ? 2 : 0);
}

function updateTestBars() {
    if (testM != null) {
        folow();
    }
    if (inst != null) {
        if (test2 != null && test2.max != inst.length) {
            test2.setRange(0, Math.max(1, inst.length));
        }

        if (testM != null && testM.max != inst.length) {
            testM.setRange(0, Math.max(1, inst.length));
        }
    }
}

function folow() {
    var offset = 105;
    var center = FlxG.width / 2;
    if (testM != null) {
        center = testM.x + testM.width * FlxMath.remapToRange(testM.percent, 100, 0, 1, 0);
    }
    test4.x = center - offset;
}
