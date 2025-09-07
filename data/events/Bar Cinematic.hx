import funkin.game.Character;
import funkin.game.Note;
//event spécifique to SNP depends de l' hud  de snp sinon l'event crash ca reste un wip


function postCreate(){
    staticCam = new FlxCamera();
    staticCam.bgColor = 0x00000000;
    // FlxG.cameras.add(staticCam, true);

    FlxG.game.addChildAt(staticCam.flashSprite, FlxG.game.getChildIndex(camHUD.flashSprite)+1);

    FlxG.cameras.list.insert(camHUD.ID + 1, staticCam);

    staticCam.ID = camHUD.ID + 1;
    FlxG.cameras.cameraAdded.dispatch(staticCam);

    var daHeight = 90;
    barTop = new FlxSprite(0, 0).makeSolid(FlxG.width, daHeight*2, FlxColor.BLACK);
    barTop.screenCenter(FlxAxes.X);
    barTop.y -= barTop.height;
    barTop.cameras = [staticCam];
    add(barTop);

    barBot = new FlxSprite(0,0).makeSolid(FlxG.width, daHeight*2, FlxColor.BLACK);
    barBot.screenCenter(FlxAxes.X);
    barBot.y = FlxG.height;
    barBot.cameras = [staticCam];
    add(barBot);
}

function onEvent(eventEvent) {
    
    if (eventEvent.event.name == "Bar Cinematic") {
        var time = (eventEvent.event.params[1] ? Conductor.crochet/1000 : 1)*eventEvent.event.params[0];
        var show_bars:Bool = eventEvent.event.params[2];
        var hide_hud:Bool = eventEvent.event.params[3];
        var hide_opp_strum:Bool = eventEvent.event.params[4];
        var hide_player_strum:Bool = eventEvent.event.params[5];
        var ease = eventEvent.event.params[6];
        var in = eventEvent.event.params[7];
        
        FlxTween.tween(barTop, {y:show_bars ? -barTop.height/2 : -barTop.height}, time, {ease: CoolUtil.flxeaseFromString(ease, in)});
        FlxTween.tween(barBot, {y:FlxG.height - (show_bars ? barBot.height/2 : 0)}, time, {ease: CoolUtil.flxeaseFromString(ease, in)});

        var easeFunc = CoolUtil.flxeaseFromString(ease, in);
        for (hud in [iconP1, iconP2, healthBarBG, healthBar]){
            FlxTween.tween(hud, {alpha: hide_hud ? 0 : 1}, time, {ease: easeFunc});
        }

        try {
            for (hud in [newHUD, score])
                FlxTween.tween(hud, {alpha: hide_hud ? 0 : 1}, time, {ease: easeFunc});
        } catch (e:Dynamic) {
            // If newHUD or score is not defined, we ignore the error
        }

        for(daStrum in cpuStrums.members) {
                FlxTween.tween(daStrum, {alpha: hide_opp_strum ? 0 : 1, y: show_bars ? barTop.height/2 + 25 : 50}, time, {ease: CoolUtil.flxeaseFromString(ease, in)});
        }
        for (daNote in cpuStrums.notes.members) {
            FlxTween.tween(daNote, {alpha:  hide_opp_strum ? 0 : 1}, time, {ease: CoolUtil.flxeaseFromString(ease, in)});
        }

        for(daStrum in playerStrums.members) {
            FlxTween.tween(daStrum, {alpha:  hide_player_strum ? 0 : 1, y: show_bars ? barTop.height/2 + 25 : 50}, time, {ease: CoolUtil.flxeaseFromString(ease, in)});
        }
        for (daNote in playerStrums.notes.members) {
            FlxTween.tween(daNote, {alpha:  hide_player_strum ? 0 : 1}, time, {ease: CoolUtil.flxeaseFromString(ease, in)});
        }
    }
}