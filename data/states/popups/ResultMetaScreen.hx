import funkin.editors.ui.UIText;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIColorwheel;
import funkin.editors.charter.Charter;

var endMeta = null;

function create() {
	winTitle = "Edit Result Screen Metadata";
	winWidth = 660;
	winHeight = 410;

	FlxG.sound.music.pause();
	Charter.instance.vocals.pause();

	endMeta = PlayState.SONG.meta.end;
	if (endMeta == null)
		endMeta = {
			fadeColor: "FFFFFF",
			startColor: "FFFFFF",
			midColor: "FFFFFF",
			endColor: "FFFFFF",
		}
}

var fadeColor:UIColorwheel;
var startColor:UIColorwheel;
var midColor:UIColorwheel;
var endColor:UIColorwheel;

function saveMeta() {
	var saveMeta = PlayState.SONG.meta;
	
	endMeta.fadeColor = fadeColor.curColorString;
	endMeta.startColor = startColor.curColorString;
	endMeta.midColor = midColor.curColorString;
	endMeta.endColor = endColor.curColorString;
	saveMeta.end = endMeta;
	PlayState.SONG.meta = saveMeta;
}

function postCreate() {
	function addLabelOn(ui, text:String)
		add(new UIText(ui.x, ui.y - 24, 0, text));

	fadeColor = new UIColorwheel(windowSpr.x + 20, windowSpr.y + 60, FlxColor.fromString(endMeta.fadeColor));
	add(fadeColor);
	addLabelOn(fadeColor, "Fade Color");

	startColor = new UIColorwheel(fadeColor.x, fadeColor.y + fadeColor.bHeight + 30, FlxColor.fromString(endMeta.startColor));
	add(startColor);
	addLabelOn(startColor, "1st Color");

	midColor = new UIColorwheel(fadeColor.x + fadeColor.bWidth + 20, fadeColor.y, FlxColor.fromString(endMeta.midColor));
	add(midColor);
	addLabelOn(midColor, "2nd Color");

	endColor = new UIColorwheel(midColor.x, startColor.y, FlxColor.fromString(endMeta.endColor));
	add(endColor);
	addLabelOn(endColor, "3rd Color");

	var saveButton = new UIButton(windowSpr.x + windowSpr.bWidth - 20, windowSpr.y + windowSpr.bHeight - 20, "Save & Close", function() {
		saveMeta();
		close();
	}, 125);
	add(saveButton);
	saveButton.x -= saveButton.bWidth;
	saveButton.y -= saveButton.bHeight;

	var closeButton = new UIButton(saveButton.x - 20, saveButton.y, "Close", function() {
		close();
	}, 125);
	add(closeButton);
	closeButton.color = 0xFFFF0000;
	closeButton.x -= closeButton.bWidth;
}