import funkin.backend.system.framerate.Framerate;
import funkin.options.TreeMenuScreen;
import funkin.editors.EditorTreeMenu;
import funkin.editors.ui.UIState;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.options.type.TextOption;

static var GameoverEditor_song = "<NONE>";

function create() {
    bgType = "charter";

	Framerate.offset.y = 60;

	var list = getList();
	addMenu(main = new TreeMenuScreen("Gameover Editor", "Select a gameover to modify."));
	for (i in list) main.add(i);
}

function getList() {
    freeplayList = FreeplaySonglist.get(false);

	var a = [];

	for(s in freeplayList.songs) {
		a.push(new TextOption(s.name, "Press ACCEPT to choose a gameover to edit.", " >", function() {
			GameoverEditor_song = s.name;
			FlxG.switchState(new UIState(true, "gameovereditor/GameoverEditor"));
		}, s.parsedColor));
	}

	return a;
}