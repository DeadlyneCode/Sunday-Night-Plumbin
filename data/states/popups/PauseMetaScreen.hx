import funkin.editors.ui.UIText;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UITextBox;
import funkin.editors.ui.UIButtonList;
import funkin.editors.charter.Charter;
import funkin.editors.extra.PropertyButton;

var pauseMeta = null;

function create() {
	winTitle = "Edit Pause Metadata";
	winWidth = 650;
	winHeight = 460;

	FlxG.sound.music.pause();
	Charter.instance.vocals.pause();

	pauseMeta = PlayState.SONG.meta.pause;
	if (pauseMeta == null)
		pauseMeta = {
			composer = "No Composer";
			imageChangeData = [];
			image = "placeholder";
		}
}

var iconTextBox:UITextBox;
var composerTextBox:UITextBox;
var customPropertiesButtonList:UIButtonList;
var iconSprite:FlxSprite;

function updateCharacterPreview(newChar) {
	if (iconSprite == null) add(iconSprite = new FlxSprite());
    iconSprite.loadGraphic(Paths.image("states/pause/" + newChar));
	iconSprite.antialiasing = true;

	iconSprite.setGraphicSize(-1, 460 - (iconTextBox.y + iconTextBox.bHeight + 72));
	iconSprite.updateHitbox();
	iconSprite.setPosition(iconTextBox.x + 8, (iconTextBox.y + iconTextBox.bHeight + 8));
}

function saveMeta() {
	var saveMeta = PlayState.SONG.meta;
	
	var changingPortrait = [];
	for (vals in customPropertiesButtonList.buttons.members) {
		changingPortrait.push({step: vals.propertyText.label.text, newImage: vals.valueText.label.text});
	}
	pauseMeta.composer = composerTextBox.label.text;
	pauseMeta.image = iconTextBox.label.text;
	pauseMeta.imageChangeData = changingPortrait;
	saveMeta.pause = pauseMeta;
	PlayState.SONG.meta = saveMeta;
}

function postCreate() {
	function addLabelOn(ui, text:String)
		add(new UIText(ui.x, ui.y - 24, 0, text));

	composerTextBox = new UITextBox(windowSpr.x + 20, windowSpr.y + 60, pauseMeta.composer, 290);
	add(composerTextBox);
	addLabelOn(composerTextBox, "Composer");

	customPropertiesButtonList = new UIButtonList(composerTextBox.x, composerTextBox.y + composerTextBox.bHeight + 30, 290, 316, '', FlxPoint.get(280, 35), null, 5);
	customPropertiesButtonList.frames = Paths.getFrames('editors/ui/inputbox');
	customPropertiesButtonList.cameraSpacing = 0;
	customPropertiesButtonList.addButton.callback = function() {
		customPropertiesButtonList.add(new PropertyButton("step", "new pause image", customPropertiesButtonList));
	}
	for (val in pauseMeta.imageChangeData) {
		customPropertiesButtonList.add(new PropertyButton(val.step, val.newImage, customPropertiesButtonList));
	}
	add(customPropertiesButtonList);
	addLabelOn(customPropertiesButtonList, "Changing Portraits");

	iconTextBox = new UITextBox(composerTextBox.x + composerTextBox.bWidth + 20, windowSpr.y + 60, pauseMeta.image, 290);
	iconTextBox.onChange = (newIcon:String) -> {updateCharacterPreview(newIcon);}
	add(iconTextBox);
	addLabelOn(iconTextBox, "Pause Portrait");

	updateCharacterPreview(pauseMeta.image);

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