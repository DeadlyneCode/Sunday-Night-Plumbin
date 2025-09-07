import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;

public var bloom:CustomShader;

var shake:Bool = false;
public var lol = true;



function create(){
       public var albert = stage.stageSprites["Albert"];
       public var hubert = stage.stageSprites["hubert"];

       var hud = importScript("data/scripts/hud/HudV2");
       hud.set("HudStyle", "gilberthud");

       public var ciel = stage.stageSprites["ciel"];
       public var plat = stage.stageSprites["platforms"];
       var roc1 = stage.stageSprites["roc1"];

       rock1 = new FlxBackdrop(Paths.image("stages/disto/caillou_1"), 1, 10, 0);
       rock1.velocity.x = FlxG.random.int(100, 500)/2;
       insert(members.indexOf(ciel), rock1);
       rock1.y = -900;

       rock2 = new FlxBackdrop(Paths.image("stages/disto/caillou_2"), 1, 600, 0);
       rock2.velocity.x = FlxG.random.int(100, 200)/2;
       insert(members.indexOf(ciel), rock2);
       rock2.y = 400;

       rock3 = new FlxBackdrop(Paths.image("stages/disto/caillou_3"), 1, 1100, 0);
       rock3.velocity.x = FlxG.random.int(100, 800)/2;
       insert(members.indexOf(ciel), rock3);
       rock3.y = 0;

       //stage.stageSprites["var"].animation.play("ton anim");
       
       plat.angle = gf.angle = -5;

       /*plat.y = -230;
       plat.angle = 5;
       gf.y = -440;
       gf.x = 260;
       gf.angle = 5;*/
       FlxTween.tween(plat, { y: -230, angle: 5}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(gf, { x: 260, y: -460, angle: 5}, 5, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

       ciel.x = -1000;
       ciel.angle = 15;
	FlxTween.tween(ciel, { y: -760}, 4, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(ciel, { x: -500}, 10, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(ciel, { angle: -15}, 30, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});

	FlxTween.tween(rock1, { angle: -15}, 10, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(rock1, { y: -1000}, 10, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(rock2, { angle: -15}, 20, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(rock2, { y: 300}, 20, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(rock3, { angle: -15}, 30, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
	FlxTween.tween(rock3, { y: -100}, 30, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});



      


  if (FlxG.save.data.glow == true) {
      bloom = new CustomShader("glow");
      bloom.size = 3.5; bloom.dim = 1.8;
      FlxG.camera.addShader(bloom);
      camHUD.addShader(bloom);
}

      d = new CustomShader('studyRoblox');
      camGame.addShader(d);


    
}

function postCreate()
{
       u = new CustomShader('black');
       uu = new CustomShader('blackico');
       bf.shader = u;
       iconP1.shader = uu;
       healthBar.createFilledBar(0xFF000000,0xFFFFFFFF);
       //newHUD.loadGraphic(Paths.image('hud/' + "gilberthud"));
}

/*function beatHit(){
       if(curBeat % 2  == 0 && shake){
              FlxTween.tween(FlxG.camera, {angle: 0.5},1.5 * (1 / (Conductor.bpm / 60)* gfSpeed) , {ease: FlxEase.quadInOut});
          }
       
       if(curBeat % 2  != 0 && shake){
              FlxTween.tween(FlxG.camera, {angle: -0.5},1.5 * (1 / (Conductor.bpm / 60)* gfSpeed) , {ease: FlxEase.quadInOut});
       }
}*/



function postUpdate(elapsed) {
       
       if (shake){
              FlxG.camera.shake(0.005, null, null, true, null); 
              
       }

}

function stepHit(curStep:Int){
       switch(curStep){
              case 150:
                     shake = true;
              case 159:
                     shake = false;
              case 1887:
                     shake = true;
                     for (cancelT in [stage.stageSprites["platforms"], stage.stageSprites["ciel"], gf]){
                            FlxTween.cancelTweensOf(cancelT); 
                     }
              

              case 1889:
                     for (the_rock in [rock1,rock2,rock3]){
                            the_rock.velocity.x = 0;
                            FlxTween.tween(the_rock, {alpha: 0}, 1, {ease: FlxEase.sineInOut, onComplete: kill});
                     }
                     rock1.velocity.y = FlxG.random.int(100, 500);
                     rock2.velocity.y = FlxG.random.int(100, 200);
                     rock3.velocity.y = FlxG.random.int(100, 800);

                     FlxTween.tween(stage.stageSprites["ciel"], {alpha: 0}, 2);
                     for (ntm in [stage.stageSprites["platforms"], stage.stageSprites["ciel"], stage.stageSprites["main"], stage.stageSprites["hubert"], stage.stageSprites["Albert"], stage.stageSprites["platform2"], stage.stageSprites["platform3"], gf]){
                            FlxTween.tween(ntm, {y: 2000}, 5, {ease: FlxEase.sineInOut, onComplete: kill2});
                     }
                     boucle("1");
                     boucle("2");
                     boucle("3");
                     
              case 1910: 
                     trace(stage.stageSprites["fogback"]);
                     FlxTween.tween(stage.stageSprites["fogback"], {alpha: 0}, 2);

              case 2000: 
                     trace(stage.stageSprites["fog"]);
                     FlxTween.tween(stage.stageSprites["fog"], {alpha: 0}, 2);
              case 2432: 
                     camHUD.alpha = 0;
       }
   }

function kill(){
       for (ro in [rock1, rock2, rock3]){
              ro.kill();
       }
       
}
function kill2(){
       for (pt2 in [stage.stageSprites["platforms"], stage.stageSprites["ciel"], stage.stageSprites["main"], gf, stage.stageSprites["Albert"], stage.stageSprites["hubert"], stage.stageSprites["platform2"], stage.stageSprites["platform3"]]){
              pt2.kill();
       }
}

function boucle(daNum:String){
       stage.stageSprites["roc" + daNum].y = -2000;
       FlxTween.tween(stage.stageSprites["roc" + daNum], {y: 900},FlxG.random.int(1, 2), {onComplete: function(twn){ boucle(daNum);}});
       stage.stageSprites["roc" + daNum].x =FlxG.random.int(-900, 600);
}