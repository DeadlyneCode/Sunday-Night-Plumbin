import funkin.backend.assets.ModsFolder;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIDropDown;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UITextBox;

import sys.io.File;
import sys.FileSystem;

var daBlock;
var blockData = [0, ""];

function create() {
	winTitle = 'Editing Event Block';
	
	winWidth = 450;
	winHeight = 170;
}

function addLabelOn(ui, text:String, offset:Int = 24)
	add(new UIText(ui.x, ui.y - (offset ?? 24), 0, text));


function postCreate() {
    if (daBlock[1].extra["eventBlockData"] != null)
        blockData = daBlock[1].extra["eventBlockData"];

    var eventTypes = ["On-Touch", "On Keypress: LEFT", "On Keypress: DOWN", "On Keypress: UP", "On Keypress: RIGHT", "On Keypress: JUMP"];
	var eventType = new UIDropDown(windowSpr.x + 15, windowSpr.y + 65, 240, 32, eventTypes);
	add(eventType);
	addLabelOn(eventType, "Event Type");
    eventType.setOption(blockData[0] ?? 0);
    
	var functionName = new UITextBox(eventType.x + eventType.bWidth + 15, eventType.y, "", 190);
	add(functionName);
	addLabelOn(functionName, "HScript Function Name");
    functionName.label.text = blockData[1] ?? "";

	var saveButton = new UIButton(windowSpr.x + windowSpr.bWidth - 20, windowSpr.y + windowSpr.bHeight - 16 - 32, "Save", function() {
        blockData = [eventType.index, functionName.label.text];
        daBlock[1].extra["eventBlockData"] = blockData;
		close();
	}, 75);
	add(saveButton);
	saveButton.frames = Paths.getFrames("editors/ui/grayscale-button");
	saveButton.color = 0xFF00FF00;
	saveButton.x -= saveButton.bWidth;

	var closeButton = new UIButton(saveButton.x - 20, saveButton.y, "Cancel", function() {
		close();
	}, 75);
	add(closeButton);
	closeButton.frames = Paths.getFrames("editors/ui/grayscale-button");
	closeButton.color = 0xFFFF0000;
	closeButton.x -= closeButton.bWidth;
}