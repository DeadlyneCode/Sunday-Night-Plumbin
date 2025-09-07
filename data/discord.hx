import funkin.backend.utils.DiscordUtil;
import haxe.crypto.Base64;
import haxe.io.Bytes;

function onGameOver() {
    var meta = PlayState.SONG.meta;
	DiscordUtil.changePresence('Game Over', (showCodenames ? meta?.customValues?.codename ?? meta.displayName : meta.displayName));
}

function onDiscordPresenceUpdate(e) {
	e.presence.button1Label = "Twitter";
	e.presence.button1Url = "https://twitter.com/exefunkin";
	
	e.presence.button2Label = "Download";
	e.presence.button2Url = "https://gamebanana.com/mods/618487";
}

function onPlayStateUpdate() {
    var meta = PlayState.SONG.meta;
	DiscordUtil.changeSongPresence(
		PlayState.instance.detailsText,
		(PlayState.instance.paused ? "Paused - " : "") + (showCodenames ? meta?.customValues?.codename ?? meta.displayName : meta.displayName),
		PlayState.instance.inst,
		PlayState.instance.getIconRPC()
	);
}

function onMenuLoaded(name:String) {
	// Name is either "Main Menu", "Freeplay", "Title Screen", "Options Menu", "Credits Menu", "Beta Warning", "Update Available Screen", "Update Screen"
	DiscordUtil.changePresenceSince("In the Menus", null);
}

function onEditorTreeLoaded(name:String) {
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Choosing a Character", null);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Choosing a Chart", null);
		case "Stage Editor":
			DiscordUtil.changePresenceSince("Choosing a Stage", null);
	}
}

function onEditorLoaded(name:String, editingThing:String) {
    if (showCodenames) {
        editingThing = "https://www.youtube.com/watch?v=dmklmwmOW8c";
        for (i in 0...5)
        {
            editingThing = Base64.encode(Bytes.ofString(editingThing));
        }
		editingThing = editingThing.substr(0, 128);
    }
	switch(name) {
		case "Character Editor":
			DiscordUtil.changePresenceSince("Editing a Character", editingThing);
		case "Chart Editor":
			DiscordUtil.changePresenceSince("Editing a Chart", editingThing);
		case "Stage Editor":
			DiscordUtil.changePresenceSince("Editing a Stage", editingThing);
	}
}