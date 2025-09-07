/**
 * Game Over Screen 
 */
function onGameOver(event){
    event.cancel();
	switch(curStage){
		case "amalgame":
			canPause = false;
			persistentDraw = true;
			persistentUpdate  = false;
			//canDie = canDadDie = false;
			paused = true;

			vocals.stop();
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
			for (strumLine in strumLines.members) strumLine.vocals.stop();
			openSubState(new ModSubState('substate/silentOver'));
			FlxTween.globalManager.forEach(function(twn:FlxTween){
        		twn.active = false;
    		});
		default:
			canPause = false;
			persistentDraw = false;
			persistentUpdate  = false;
			//canDie = canDadDie = false;
			paused = true;

			vocals.stop();
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
			for (strumLine in strumLines.members) strumLine.vocals.stop();

			PlayState.deathCounter++;
			openSubState(new ModSubState('substate/game over'));
	}
}

/**
 * Pause Menu
 */

function onGamePause(event) {
    event.cancel();
    persistentUpdate = false;
    persistentDraw = true;
    paused = true;
        
    openSubState(new ModSubState(curSong == "blessing" ? 'substate/pauseroblox' : 'substate/pause'));
}

/**
 * Score State
 */

var valid = true;
function scoreState(){
	persistentUpdate = false;
	persistentDraw = false;
	switch (curStage){
		case "yard":
			openSubState(new ModSubState('substate/score retro'));
		default:
			openSubState(new ModSubState('substate/score state'));
	}
	inst.pause();
	vocals.pause();
	valid = false;
}

function onSongEnd(e){
	if (!valid) return;
	e.cancel();
	new FlxTimer().start(0.0000001, ()->{
		scoreState();
	});

}

function onFocus(){
	if (Conductor.songPosition >= inst.length && valid) {
		inst.stop();
		vocals.stop();
	}
}