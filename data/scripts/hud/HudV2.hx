import flixel.text.FlxTextBorderStyle;

var icoAnim:Int = 0;
public var ico2:HealthIcon;
public var ico1:HealthIcon;

public var newHUD:FlxSprite;
public var score:FlxText;
static var scoreSuffix = "";
var iconsX:Float = 0;
var iconsY:Float = 0;

public var isAnimatedHUD:Bool = false;

var HudStyle = "";
var HudScale = 0.67;
var HudAnimated = false;
var HudIconsX = 15;
var HudIconsY = 15;
var HudIconsBaseY = FlxG.height - 150;
var HudBGPosOffset = 0;

var defaultFont:String = "SuperMario256.ttf"; 
var defaultFontSize:Int = 30;
var defaultFontColor:Int = FlxColor.WHITE;
var defaultBorderColor:Int = FlxColor.BLACK;
var defaultBorderStyle:Int = FlxTextBorderStyle.OUTLINE;
var textY:Float = 0;


var HudYBGFactor = 1.075;
var HudYBarFactor = 1.069;

var iconP1Offsets = [1185, 0];
var iconP2Offsets = [-20, 0];

var healthBarBGScale = [0.5,1];
var healthBarScale = [0.502,1];

doIconBop = false;
var scoreLerp = 0;

var hudPosMult = [1.07, 2];

public var finishedHUDInit = false;
function postCreate() {
    if (finishedHUDInit) return;
    if (HudStyle == null)
        HudStyle = "hud";

    healthBar.scale.set(healthBarScale[0],healthBarScale[1]);
    healthBarBG.scale.set(healthBarBGScale[0],healthBarBGScale[1]);
    iconP1.setHealthSteps([[0, 1], [20, 0]]);
    
    configureHUD(HudStyle ?? "hud", HudScale, HudScale, HudAnimated);
    adjustHealthBarPosition(HudYBGFactor, HudYBarFactor);
    setIconPosition(HudIconsX, HudIconsY, HudIconsBaseY);
    finishedHUDInit = true;

    updateIconPositions = setIconPositions;
}

var iconBump = [1.1, 1];
function update(elapsed) {
    scoreLerp = FlxMath.lerp(scoreLerp, songScore, elapsed*20);
    if (score != null) {
        score.text = applyFiller(getString("hud_text"), [Math.round(scoreLerp) + scoreSuffix, misses]);
    }

    if (curStage == "disto") {
        iconP2.scale.set(1, 1);
    }

    for (i in [iconP1, iconP2]){
        var lerped = lerp(i.scale.x, iconBump[0], 0.33 / 2);
        i.scale.set(lerped, lerped);
    }
  
    if (icoAnim >= 0) {
        icoAnim -= elapsed;
    }
}

function beatHit(curBeat) {
    for (i in [iconP1, iconP2]){
        i.scale.set(iconBump[1], iconBump[1]);
    }
}

function onPlayerMiss() {
    icoAnim = 20/60;
}

function configureHUD(name:String, scaleX:Float, scaleY:Float, animated:Bool) {
    isAnimatedHUD = animated;
    newHUD = new FlxSprite(0, 0).loadGraphic(Paths.image('hud/' + name));
    
    if (isAnimatedHUD) {
        newHUD.frames = Paths.getSparrowAtlas('hud/' + name);
        newHUD.animation.addByPrefix('barmx', 'barmx0', 24, true);
        newHUD.animation.play('barmx');
        newHUD.antialiasing = true;
    }
    
    newHUD.screenCenter(FlxAxes.X);
    newHUD.scale.set(scaleX, scaleY);
    newHUD.cameras = [camHUD];
    if (downscroll) newHUD.flipY = true;
    newHUD.y = (FlxG.height / hudPosMult[0]) - (newHUD.height / hudPosMult[1]) + HudBGPosOffset;
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

var HudScorePositionDownscroll = 680;
var HudScorePositionUpscroll = 685;

function createCustomHUDText() {
    var yPosition = downscroll ? HudScorePositionDownscroll : HudScorePositionUpscroll - textY;
    
    score = new FlxText(healthBarBG.x, yPosition, healthBarBG.width, "", 60, 0xFF000000);
    score.setFormat(Paths.font(defaultFont),defaultFontSize,defaultFontColor,"center",defaultBorderStyle,defaultBorderColor);
    score.cameras = [camHUD];
    score.borderSize = 2;
    score.antialiasing = true;
    insert(members.indexOf(healthBar) + 1, score);
    score.alignment = "center";
}

function setIconPositions() {
    var healthBarPercent = healthBar.percent;
    iconP1.health = healthBarPercent / 100;
    iconP2.health = 1 - (healthBarPercent / 100);
    if (!downscroll) {
        //iconP1.x = FlxG.width - 150 / 2 + iconsX - iconP1.width / 2;
        iconP1.y = FlxG.height - (150 * 0.5) - (iconP1.height / 2) + iconsY;

        //iconP2.x = 150 / 2 - iconP2.width / 2 - iconsX;
        iconP2.y = FlxG.height - (150 * 0.5) - (iconP2.height / 2) + iconsY;
    } else {
        //iconP1.x = FlxG.width - 150 / 2 + iconsX - iconP1.width / 2;
        iconP1.y = FlxG.height - (150 * 0.4) - (iconP1.height / 2) + iconsY;

        //iconP2.x = 150 / 2 - iconP2.width / 2 - iconsX;
        iconP2.y = FlxG.height - (150 * 0.4) - (iconP2.height / 2) + iconsY;
    }
    iconP1.x = iconP1Offsets[0];
    iconP1.y += iconP1Offsets[1];

    iconP2.x = iconP2Offsets[0];
    iconP2.y += iconP2Offsets[1];

    iconP1.animation.curAnim.curFrame = (iconP1.health >= 0.2 ? 0 : 1);
    iconP2.animation.curAnim.curFrame = (iconP2.health >= 0.2 ? 0 : 1);
    iconP1.animation.curAnim.curFrame += (icoAnim > 0 ? 2 : 0);
}