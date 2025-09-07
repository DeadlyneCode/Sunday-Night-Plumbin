import flixel.text.FlxTextBorderStyle;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;


var icoAnim:Int = 0;
public var ico2:HealthIcon;
public var ico1:HealthIcon;

public var newHUD:FlxSprite;
public var score:FlxText;
public var miss:FlxText;
var iconsX:Float = 0;
var iconsY:Float = 0;

public var isAnimatedHUD:Bool = false;

function postCreate() {

    healthBar.scale.set(0.5,1);
    healthBarBG.scale.set(0.502,1);
    iconP1.setHealthSteps([[0, 1], [20, 0]]);
    
    configureHUD("hud_smw", 0.65, 0.65, false);
    if(downscroll)
        adjustHealthBarPosition(0.935, 0.93);
    else
        adjustHealthBarPosition(0.974, 0.97);
    setIconPosition(15, 15, FlxG.height - 150);
}


function update(elapsed:Float) {
    if (score != null && miss != null) {
        score.text = "S: " + songScore;
        miss.text = " | " + "M: " + misses;
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

  
    if (icoAnim >= 0) {
        icoAnim--;
    }
}

function beatHit(curBeat) {
    daIconScale += 0.15;
}

function onPlayerMiss() {
    icoAnim = 20;
}

function configureHUD(name:String, scaleX:Float, scaleY:Float, animated:Bool) {
    isAnimatedHUD = animated;
    newHUD = new FlxSprite(0, 0);
    
    if (isAnimatedHUD) {
        newHUD.frames = Paths.getSparrowAtlas('hud/' + name);
        newHUD.animation.addByPrefix('barmx', 'barmx0', 24, true);
        newHUD.animation.play('barmx');
    } else
        newHUD.loadGraphic(Paths.image('hud/' + name));
    
    newHUD.screenCenter();
    newHUD.scale.set(scaleX, scaleY);
    newHUD.cameras = [camHUD];
    if (downscroll) newHUD.flipY = true;
    newHUD.y = (FlxG.height / 1.07) - (newHUD.height -230);
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


function hideDefaultHUDText() {
    remove(scoreTxt);
    remove(missesTxt);
    remove(accuracyTxt);
    remove(comboGroup);
}

function createCustomHUDText() {
    var yPosition = downscroll ? 800 : 830;
    
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

function setIconPositions() {
    var yPosition = downscroll ? 650 : 655;
    iconP1.setPosition(1130, yPosition); 
	iconP2.setPosition(0, iconP1.y); 
    iconP1.animation.curAnim.curFrame = (iconP1.health >= 0.2 ? 0 : 1);
    iconP2.animation.curAnim.curFrame = (iconP2.health >= 0.2 ? 0 : 1);
    iconP1.animation.curAnim.curFrame += (icoAnim > 0 ? 2 : 0);
}
