//import flixel.util.FlxAxes;
import flixel.util.FlxStringUtil;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxTextBorderStyle;

var zommingTurn = true;

var clouds:FlxBackdrop;
var timeTxt:FunkinText;
var hud = importScript("data/scripts/hud/HudV2");
function create(){


    panorama = new FlxBackdrop(Paths.image("stages/die/cloud"), 1, -10, 0);
    panorama.velocity.set(-30, 0);
    panorama.antialiasing = true;
    panorama.scale.set("0.6","0.6");
    panorama.alpha = 0.5;
    insert(members.indexOf(stage.stageSprites["ciel2"])+1, panorama);

    var timeBar:FunkinSprite = new FunkinSprite(0.0, -25.0);
    timeBar.loadGraphic(Paths.image('hud/timebar-wario'));
    timeBar.antialiasing = true;
    timeBar.cameras = [camHUD];
    timeBar.scale.set("0.7","0.7");
    timeBar.screenCenter(FlxAxes.X);
    insert(members.indexOf(dad), timeBar);

    timeTxt = new FunkinText(585, 15, "null", 32);
    timeTxt.text = "--:--";
    if (downscroll) timeTxt.y = 40;
    timeTxt.setFormat(Paths.font("F.ttf"), 50, FlxColor.GREEN, "center");
    timeTxt.borderSize = 2;
    timeTxt.antialiasing = true;
    timeTxt.cameras = [camHUD];
    add(timeTxt);
}

function postCreate(){
    hud.set("HudStyle", "hud_wario");
    hud.set("defaultFontColor", FlxColor.GREEN);
    hud.set("defaultFont", "F.ttf");
    hud.set("defaultBorderStyle", "none");
    healthBar.flipX = healthBarBG.flipX = true;
}

function onCameraMove(){
    if (curCameraTarget == 0){
        if (!zommingTurn){
            zommingTurn = true;
            defaultCamZoom = 1.5; 
        }
    }
    if (curCameraTarget == 1){
        if (zommingTurn){
            zommingTurn = false;
            defaultCamZoom = 1; 
        }
    }
}

var timer:Float;

function update(elapsed) {
    var timeRemaining = Std.int(((inst.length - Conductor.songPosition) / 1000.0) - 10.0);

    if (timeRemaining >= 0) {
        timeTxt.text = FlxStringUtil.formatTime(timeRemaining, false);
    }

    if (timeRemaining == 10)
        FlxTween.tween(timeTxt, {alpha: 0}, 0.15, {type: FlxTween.PINGPONG, ease: FlxEase.backIn});

    if (timeRemaining == 0) {
        FlxTween.tween(timeTxt, {alpha: 1}, 0.05, {type: FlxTween.PINGPONG, ease: FlxEase.backIn});
    }

}

function postUpdate(elapsed:Float) {
    hud.set("iconP1Offsets", [0, 0]);
    hud.set("iconP2Offsets", [1100, 0]);
    iconP1.flipX = iconP2.flipX = true;
}

