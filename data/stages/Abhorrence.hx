public var bloom:CustomShader;
var t = new CustomShader('IHY');

public var test: String;
var charList2:Map<String, Character> = [];
var numShit = 1;

function choseChar(){
  switch(curStage){
      case "Abhorrence":
          test = "bf burn";
      default:
          test = "bf-dead";
  }
}
  function create(){
    FlxG.camera.followLerp = 0.04;
    cameraMovementStrength = 30;
    var hud = importScript("data/scripts/hud/HudV2");
    hud.set("HudStyle", "hud_smw");

    preloadChar = new Character(450,-170, test, true, false, false);
    preloadChar.drawComplex(FlxG.camera); // Push to GPU
    preloadChar.visible = false;
    charList2.set(test, preloadChar);


    for  (i in [stage.stageSprites["ff1"], stage.stageSprites["ff2"], stage.stageSprites["ff3"]])
		FlxTween.tween(i.scale, {x:4, y:4}, 10, { ease: FlxEase.sineInOut, type:FlxTween.PINGPONG});

    for  (y in [stage.stageSprites["boo1"], stage.stageSprites["boo3"], stage.stageSprites["boo5"]])
		y.flipX = true;

    for  (u in [stage.stageSprites["ff4"], stage.stageSprites["ff5"]])
		FlxTween.tween(u.scale, {x:2, y:2}, 10, { ease: FlxEase.sineInOut, type:FlxTween.PINGPONG});

  if (FlxG.save.data.glow == true) {
    bloom = new CustomShader("glow");
    bloom.size = 8.0; bloom.dim = 1.8;
    FlxG.camera.addShader(bloom);
    camHUD.addShader(bloom);
  }

if (FlxG.save.data.saturation == true)
    camGame.addShader(t);

}