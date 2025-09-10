import flixel.addons.display.FlxBackdrop;
import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

var lol = true;

var t = new CustomShader('DEVIL');

var isKatana = false;

var cam = 1.25;
var camgf = 0.9;

var hue:Float = 0;

function onCameraMove(){
    if (curCameraTarget == 0 || curCameraTarget == 1){
        if (!lol){
            lol = true;
            defaultCamZoom = cam; 
        }
    }
    if (curCameraTarget == 2){
        if (lol){
            lol = false;
            defaultCamZoom = camgf; 
        }
    }
}

function postCreate(){
    var hud = importScript("data/scripts/hud/HudV2");
    hud.set("HudStyle", "Devil");

    cloud = new FlxBackdrop(Paths.image("stages/devil/cloud"), FlxAxes.X, 0.0, 0.0);
    cloud.setPosition(0, 450);
    cloud.velocity.x = 50;
    insert(members.indexOf(stage.stageSprites["sky"])+1, cloud);

    if (FlxG.save.data.tv == true){
        d = new CustomShader('ntscc');
        camGame.addShader(d);
        camHUD.addShader(d);
        //camGame.addShader(t2);
    }

    if (FlxG.save.data.saturation == true)
        camGame.addShader(t);
        
    if (FlxG.save.data.glow == true) {
        bloom = new CustomShader("glow");
        bloom.size = 2.0; bloom.dim = 2.0;
        camGame.addShader(bloom);
      }

    
    bar = new FlxBar(550,560,FlxBarFillDirection.LEFT_TO_RIGHT, 168,95,null, null,0,10);
    insert(members.indexOf(boyfriend), bar);
    bar.createImageBar(Paths.image("hud/devil/Bullit_bill_empty"), Paths.image("hud/devil/Bullit_bill_bar_full"), FlxColor.BLACK, FlxColor.LIME);


    outline = new FlxSprite(bar.x,bar.y).loadGraphic(Paths.image("hud/devil/Bullit_bill_outline"));
    insert(members.indexOf(boyfriend), outline);

    outline.camera = bar.camera=camHUD;
    bar.alpha = outline.alpha = 0;
    bar.antialiasing = outline.antialiasing= true;

}

var timer= 0;
var numToShoot = 0;
var alphaShit =1;
var timerAlpha =10;
var alphaStuff;
function postUpdate(elapsed:Float) {
    if (controls.getJustPressed("dodge") && numToShoot>=10 && isKatana){
        timer=0.4;
        numToShoot = 0;
        boyfriend.playAnim("shoot");
        health += 0.35;
        dad.playAnim("hit", true);
        FlxG.sound.play(Paths.sound("shoot"));
    }
    timer-= elapsed;

    timerAlpha -= elapsed;
    if (isKatana){
        alphaShit = (timerAlpha<0)?0.4:1;
        bar.value = FlxMath.lerp(bar.value, numToShoot, elapsed*10);
    }
    else
        alphaShit = 0;
    
    alphaStuff= FlxMath.lerp(bar.alpha, alphaShit, elapsed*10);
    bar.alpha = outline.alpha = alphaStuff;
}
function onDadHit(event:NoteHitEvent){
    if (isKatana){
        health -= 0.025;
        event.animCancelled =(timer>0)? true:false;
    }
}
function onPlayerHit(e){
    if (isKatana){

        numToShoot += 1;
        timerAlpha = 10;
    }
}

function isKatanaMode(isOn){
    if(FlxG.save.data.curPowerUp != 3 && isOn == "true")
        isKatana= true;
    else
        isKatana= false;
}
