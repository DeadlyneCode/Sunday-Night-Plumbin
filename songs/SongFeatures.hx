import funkin.backend.utils.WindowUtils;

function postCreate() {
    var meta = PlayState.SONG.meta;
    WindowUtils.suffix = " | " + meta.displayName + WindowUtils.suffix;

    //window.borderless = true;
    //camHUD.visible = false;
}

function destroy() {
    WindowUtils.suffix = "";
}

function onCountdown(event){
    if (curSong != "cosmic-copy"){
        introLength = 0;
        event.cancel();
    }
}

//V-SLICE scoring and health
function update(elapsed:Float)
{
    if (!player.cpu) {
        var notesPerSides = [null, null, null, null];
        player.notes.forEach((note) -> {
            if (notesPerSides[note.strumID] == null)
                notesPerSides[note.strumID] = note;
        });
        var givingHealth = false;
        for (data=>note in notesPerSides)
        {
            if (note == null) continue;
            if (player.__pressed[note.strumID] && note.isSustainNote && note.canBeHit && !note.tooLate)
            {
                songScore += (250 * elapsed) * scoreMult;
                if (!givingHealth)
                    player.addHealth((6.0 / 100.0) * maxHealth * elapsed);
                givingHealth = true;
            }
        }
    }
}

function scoreNotePBOT(msTiming:Float)
{
    var absTiming:Float = Math.abs(msTiming);

    if (absTiming > 160)
    {
        return -100;
    } else if (absTiming < 5) {
        return 500; 
    } else {
        var factor:Float = 1.0 - (1.0 / (1.0 + Math.exp(-0.080 * (absTiming - 54.99))));
        var score:Int = Std.int(500 * factor + 9);
        return score;
    }
}

function onPlayerHit(e)
{
    if (e.note.isSustainNote)
    {
        e.healthGain = 0;
        /*var ratio = (FlxG.elapsed * 20);
        var toAdd = ((6.0 / 100.0) * maxHealth) * ratio;
        e.note.strumLine.addHealth(toAdd);
        songScore += 250 * ratio;*/
    } else {
        e.score = scoreNotePBOT(Conductor.songPosition - e.note.strumTime) * scoreMult;
        switch (e.rating)
        {
          case 'sick':
            e.healthGain = (1.5 / 100.0) * maxHealth;
          case 'good':
            e.healthGain = (0.75 / 100.0) * maxHealth;
          case 'bad':
            e.healthGain = 0;
          case 'shit':
            e.healthGain = (-1 / 100.0) * maxHealth;
        }
    }
}