function stepHit(curStep:Int){
       switch(curStep){     
              case 0:
                     FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, 5, {ease: FlxEase.sineOut});

                     FlxTween.tween(camGame.scroll, {y: 100}, 7, {ease: FlxEase.sineInOut});

                     camGame.scroll.set(-90, -100);
                     FlxG.camera.followLerp = 0;
                                         
              case 32:
                     FlxTween.tween(FlxG.camera, {zoom: 1.8}, 2, {ease: FlxEase.sineInOut});

                     //FlxTween.tween(camGame.scroll, {y: 100}, 1, {ease: FlxEase.sineInOut});

                     FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, 1.8, {ease: FlxEase.sineInOut});
              case 47:
                     camGame.scroll.set(480, -50);
                     stage.stageSprites["house"].alpha = 0;  
              case 49:   
                     FlxTween.tween(FlxG.camera, {zoom: 0.9}, 2.5, {ease: FlxEase.sineOut});
                     FlxTween.tween(stage.stageSprites["black"], {alpha: 0}, 2, {ease: FlxEase.sineOut});

              case 64:     
                     FlxTween.tween(camHUD, {alpha: 1}, 3, {ease: FlxEase.sineOut});
                     FlxG.camera.follow(camFollow, null, 0.03);  
              case 320:
                     stage.stageSprites["white"].alpha = 1;
                     FlxTween.tween(stage.stageSprites["white"], {alpha: 0}, 11, {ease: FlxEase.sineOut});
                     stage.stageSprites["shadow"].alpha = 0.21;
                     stage.stageSprites["door"].alpha = 1;
                     stage.stageSprites["black"].alpha = 0;
                     boyfriend.alpha = 0;
                     gf.alpha = 0;
                     stage.stageSprites["bg"].alpha = 0;
                     camGame.scroll.set(-100, 50);
                     FlxG.camera.followLerp = 0;
              case 447:     
                     stage.stageSprites["black"].alpha = 1;
              case 448:
                     stage.stageSprites["shadow"].alpha = 0;
                     stage.stageSprites["door"].alpha = 0;
                     dad.alpha = 0;
                     boyfriend.alpha = 1;
                     gf.alpha = 1;
                     dad.alpha = 1;
                     stage.stageSprites["bg"].alpha = 1;
                     FlxG.camera.follow(camFollow, null, 0.03);
              case 460:
                     stage.stageSprites["black"].alpha = 0;

       }
}