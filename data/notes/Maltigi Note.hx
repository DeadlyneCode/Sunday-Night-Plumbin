function onPostNoteCreation(e)
{
    if (e.noteType == "Maltigi Note") {
        e.note.avoid = true;
        e.note.offset.set(45, 0);
        e.note.earlyPressWindow = 0.25;
        e.note.latePressWindow = 0.5;

        var height = e.note.height;
        e.note.loadGraphic(Paths.image("states/freeplay/paintings/Earache"));
        e.note.setGraphicSize(height, height);
        e.note.updateHitbox();
        e.note.extra["canChangeTexture"] = false;
    }
}

function onPlayerMiss(event) { /* this is the part of the code that makes it so you can miss it */
	if (event.noteType == "Maltigi Note") {
		event.cancel(true); /* this makes it so you wont take damage from missing the note */
		event.note.strumLine.deleteNote(event.note); /* this deletes the note once you miss it */
	}
}

function onPlayerHit(e) {
    if (e.noteType == "Maltigi Note") {
        health -= 0.5;
        camHUD.zoom += 0.1;
        camHUD.shake(0.02, 0.1);
        misses += 1;
    }
}