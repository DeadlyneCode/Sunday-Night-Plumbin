import flixel.util.FlxTimer;

function postCreate()
{
	var gayNotes = [];
	for (struml in strumLines.members)
	{
		struml.onNoteUpdate.add(function(e) {
			var daNote = e.note;
			if (daNote.noteType == "SpookyNote")
			{
				e.__updateHitWindow = false;
				if (-(Conductor.songPosition - daNote.strumTime) < 800 && !gayNotes.contains(daNote)) {
					var oldTime = daNote.strumTime;
					daNote.extra["strumTime"] = oldTime;
					daNote.strumTime = Conductor.songPosition;
					daNote.alpha = 0;
					FlxTween.tween(daNote, {strumTime: oldTime, alpha: 1}, 2, {ease: FlxEase.expoOut});
					gayNotes.push(daNote);
				}
				
				daNote.canBeHit = (daNote.extra["strumTime"] > daNote.strumLine.__updateNote_songPos - (PlayState.instance.hitWindow * daNote.latePressWindow)
				&& daNote.extra["strumTime"] < daNote.strumLine.__updateNote_songPos + (PlayState.instance.hitWindow * daNote.earlyPressWindow));

				if (daNote.extra["strumTime"] < daNote.strumLine.__updateNote_songPos - PlayState.instance.hitWindow && !daNote.wasGoodHit)
					daNote.tooLate = true;
			} else if (daNote.isSustainNote) {
				daNote.alpha = 0.6;
			}
		});
	}
}
