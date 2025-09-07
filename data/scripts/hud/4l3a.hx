var pos = 450;

function postCreate() {
    staticCam = new FlxCamera();
    staticCam.bgColor = 0x00000000;
    FlxG.game.addChildAt(staticCam.flashSprite, FlxG.game.getChildIndex(camHUD.flashSprite)+1);
    FlxG.cameras.list.insert(camHUD.ID + 1, staticCam);

    staticCam.ID = camHUD.ID + 1;
    //FlxG.cameras.cameraAdded.dispatch(staticCam);

    for (i in 0...2){
     bar = new FlxSprite(1000 *i).makeSolid(160, FlxG.width, FlxColor.BLACK);
     add(bar);
     bar.ID = i;
     bar.cameras = [staticCam];
     switch(bar.ID){
         case 0:
             
         case 1:
             bar.setPosition(1120,0);
     }
    }

    for (strum in playerStrums.members) {
        strum.scrollFactor.set(1, 1);
    }

    for (mem in members)
        if (mem.camera == camHUD)
            mem.scrollFactor.set(1, 1);
}

function destroy() {
    FlxG.cameras.remove(staticCam);
}