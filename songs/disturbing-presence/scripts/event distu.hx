function onCountdown(event){
    event.cancel();
    introLength = 0;
}



function postCreate(){
    strumLines.members[3].characters[0].visible = false;
    strumLines.members[3].characters[0].scale.set(1.5,1.5);
    strumLines.members[3].characters[0].x = strumLines.members[3].characters[0].x - 250;
    camHUD.alpha = 0;
    //stage.stageSprites["black2"].alpha = 1;
    bf2.alpha = 0;
    //FlxG.camera.zoom = 0.6;
    camGame.fade(FlxColor.BLACK,0.0000001,false);
    dad.shader = soRetro;
    soRetro.uBlocksize = [1, 1];
}

var bf2 = strumLines.members[1].characters[1];
var soRetro = new CustomShader("lowquality");

function stepHit(curStep:Int){
    switch(curStep){

        case 262 | 266 | 272 | 364 | 794 | 1152: //pixel off
            soRetro.uBlocksize = [1, 1];

        case 261 | 265 | 360 | 1144: //pixel state 1
            soRetro.uBlocksize = [3, 3];

        case 260 | 264 | 268 | 792 | 1148: //pixel state 2
            soRetro.uBlocksize = [7, 7];

        case 0:
            /*FlxTween.tween(FlxG.camera.scroll, {y: 0}, 11, {type:  FlxTween.ONESHOOT, ease: FlxEase.quadInOut});
            FlxTween.tween(FlxG.camera.scroll, {x: -800}, 11, {type:  FlxTween.ONESHOOT, ease: FlxEase.quadInOut});*/
            //camGame.scroll.set(-200,-100);
            /*FlxTween.tween(stage.stageSprites["blackbg"], {alpha: 0.9}, 11, { ease: FlxEase.linear});
            FlxTween.tween(stage.stageSprites["black2"], {alpha: 0}, 5, {
                ease: FlxEase.linear
            });*/
        case 151:
            stage.stageSprites["black"].alpha = 1;

            camGame.scroll.set(-725);
	        FlxG.camera.followLerp = 0;
            strumLines.members[0].characters[0].visible = false;
            strumLines.members[3].characters[0].visible = true;
            stage.stageSprites["black2"].alpha = 0;
        case 153:
            stage.stageSprites["black2"].alpha = 1;
        case 155:
            stage.stageSprites["black2"].alpha = 0;
        case 156:
            stage.stageSprites["black2"].alpha = 1;
        case 157:
            stage.stageSprites["black2"].alpha = 0;
        case 158:
            stage.stageSprites["black2"].alpha = 1;
        case 159:
            stage.stageSprites["black2"].alpha = 0;
	        FlxG.camera.followLerp = 0.03;
            stage.stageSprites["black"].alpha = 0;
            strumLines.members[0].characters[0].visible = true;
            strumLines.members[3].characters[0].visible = false;
            FlxTween.tween(camHUD, {alpha: 1}, 5, {
                ease: FlxEase.linear
            });
        case 601:
                stage.stageSprites["black"].alpha = 1;
    
                camGame.scroll.set(-725);
                FlxG.camera.followLerp = 0;
                strumLines.members[0].characters[0].visible = false;
                strumLines.members[3].characters[0].visible = true;
                
                stage.stageSprites["black2"].alpha = 0;
        case 602:
                stage.stageSprites["black2"].alpha = 1;
        case 603:
                stage.stageSprites["black2"].alpha = 0;
        case 604:
                stage.stageSprites["black2"].alpha = 1;
        case 605:
                stage.stageSprites["black2"].alpha = 0;
        case 606:
                stage.stageSprites["black2"].alpha = 1;
        case 607:
                stage.stageSprites["black2"].alpha = 0;
                FlxG.camera.followLerp = 0.03;
                stage.stageSprites["black"].alpha = 0;
                strumLines.members[0].characters[0].visible = true;
                strumLines.members[3].characters[0].visible = false;
                FlxTween.tween(camHUD, {alpha: 1}, 5, {
                    ease: FlxEase.linear
                });
        case 631:
                    stage.stageSprites["black"].alpha = 1;
        
                    camGame.scroll.set(-725);
                    FlxG.camera.followLerp = 0;
                    strumLines.members[0].characters[0].visible = false;
                    strumLines.members[3].characters[0].visible = true;
                    
                    stage.stageSprites["black2"].alpha = 0;
        case 632:
                    stage.stageSprites["black2"].alpha = 1;
        case 633:
                    stage.stageSprites["black2"].alpha = 0;
        case 634:
                    stage.stageSprites["black2"].alpha = 1;
        case 635:
                    stage.stageSprites["black2"].alpha = 0;
        case 636:
                    stage.stageSprites["black2"].alpha = 1;
        case 637:
                    stage.stageSprites["black2"].alpha = 0;
                    FlxG.camera.followLerp = 0.03;
                    stage.stageSprites["black"].alpha = 0;
                    strumLines.members[0].characters[0].visible = true;
                    strumLines.members[3].characters[0].visible = false;
                    FlxTween.tween(camHUD, {alpha: 1}, 5, {
                        ease: FlxEase.linear
                    });  
        case 1279:
            strumLines.members[3].characters[0].visible = true;
            strumLines.members[3].characters[0].alpha = 0;
            bf2.x = -320;
            FlxTween.tween(bf2, {alpha: 1}, 15, {ease: FlxEase.linear});
            camGame.scroll.set(-725, 175);
            defaultCamZoom = FlxG.camera.zoom = 0.4; 
	        FlxG.camera.followLerp = 0;
            stage.stageSprites["black"].alpha = 1;
            remove(bf2);
            insert(members.indexOf(dad), bf2);
            strumLines.members[0].characters[0].visible = false;
            strumLines.members[2].characters[0].visible = false;

            FlxTween.tween(FlxG.camera, {zoom: 0.65}, 25, {ease: FlxEase.sineInOut});
        case 1505:
            strumLines.members[3].characters[0].scale.set(0.6, 0.6);
        case 1548: 

            FlxTween.tween(strumLines.members[3].characters[0].scale, {x:1, y:1}, 30, {ease:FlxEase.sineInOut} );
            FlxTween.tween(strumLines.members[3].characters[0], {alpha: 1}, 12, {ease: FlxEase.sineInOut});   
            
        case 1567:  
            //FlxTween.tween(FlxG.camera, {zoom: 0.3}, 2.5, {ease: FlxEase.quintInOut});
            //new FlxTimer().start(1.5, function(tmr:FlxTimer){
           //     defaultCamZoom =  0.3; 
           // });
  

            FlxTween.tween(bf2.scale, {x:1.3, y:1.3}, 1, {ease:FlxEase.sineOut});

            FlxTween.tween(bf2, {alpha: 0}, 1.5, {ease: FlxEase.sineOut});
            //defaultCamZoom = FlxG.camera.zoom = 0.3; 
            //camGame.scroll.set(-725);
        

        case 1888:


            stage.stageSprites["black"].alpha = 0;
            defaultCamZoom = 0.5; 
            strumLines.members[0].characters[0].visible = true;
            strumLines.members[3].characters[0].visible = false;
            strumLines.members[2].characters[0].visible = true;
            FlxG.camera.followLerp = 0.03;
    }
}

