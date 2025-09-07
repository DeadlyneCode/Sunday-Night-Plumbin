import funkin.editors.ui.UIText;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UIColorwheel;
import funkin.editors.charter.Charter;

var characterMeta = {};

function getCharacterMeta() {
	var meta = {};
	var charMeta = state.stateScripts.get("newCharacterMeta");
	if (charMeta == null) {
		var charXML = Character.getXMLFromCharName(state.character);
		var metaNode = null;
		for (node in charXML.elementsNamed("meta")) {
			metaNode = node;
			break;
		}
		for (node in metaNode.elements()) {
			Reflect.setField(meta, node.get("field"), node.get("value"));
		}

		return meta;
	}

	return charMeta;
}

function create() {
	winTitle = "Edit Character Metadata";
	winWidth = 310;
	winHeight = 150;

	characterMeta = getCharacterMeta();
	trace(characterMeta);
}

function saveMeta() {
	var newCharMeta = {};
	newCharMeta.staticHoldNotes = staticHoldNotesCheck.checked ? "true" : "false";
	state.stateScripts.set("newCharacterMeta", newCharMeta);
}

var staticHoldNotesCheck:UICheckbox;
function postCreate() {
	function addLabelOn(ui, text:String)
		add(new UIText(ui.x, ui.y - 24, 0, text));
	
	staticHoldNotesCheck = new UICheckbox(windowSpr.x + 20, windowSpr.y + 50, "Character Hold Note Static", characterMeta.staticHoldNotes == "true");
	add(staticHoldNotesCheck);

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