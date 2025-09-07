import funkin.backend.assets.ModsFolder;
import funkin.editors.ui.UIText;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UIButton;
import funkin.editors.ui.UIDropDown;
import funkin.editors.ui.UICheckbox;
import funkin.editors.ui.UINumericStepper;
import funkin.editors.ui.UIAutoCompleteTextBox;

import sys.io.File;
import sys.FileSystem;

var undos;
function create() {
	undos = FlxG.state.stateScripts.get("undos");
	winTitle = 'Editing Gameover data';
	
	winWidth = 700;
	winHeight = 450;
}

function addLabelOn(ui, text:String, offset:Int = 24)
	add(new UIText(ui.x, ui.y - (offset ?? 24), 0, text));

function addTitle(x, y, text:String)
	add(new UIText(x, y, 0, text, 36));

function getFolderContent(folderName, subFolder = "") {
	var allFiles = [];
	var addFolder = null; addFolder = function (folderName, subFolder = "") {
		var subFol = subFolder ?? "";
		var fol = "mods/" + ModsFolder.currentModFolder + "/" + folderName + "/" + subFol;
		subFol = (subFol != "" ? subFol + "/" : "");
		var folderFiles = FileSystem.readDirectory(fol);
		for (i in 0...folderFiles.length) {
			if (allFiles.contains(subFol + folderFiles[i])) continue;
			if (FileSystem.isDirectory(fol + folderFiles[i])) {
				addFolder(folderName, folderFiles[i]);
			} else {
				var extensionsToRemove = ["png", "ogg", "mp4", "xml"];
				for (ext in extensionsToRemove) {
					if (StringTools.endsWith(folderFiles[i], "." + ext)) {
						folderFiles[i] = folderFiles[i].substring(0, folderFiles[i].length - 4);
					}
				}
				allFiles.push(subFol + folderFiles[i]);
			}
		}
	}
	addFolder(folderName, subFolder);
	return allFiles; 
}

function postCreate() {
	addTitle(windowSpr.x + 20, windowSpr.y + 40, "Global Options");
	var gameoverType = new UIDropDown(windowSpr.x + 15, windowSpr.y + 110, 160, 32, ["PNG", "Video", "Scripted"]);
	add(gameoverType);
	addLabelOn(gameoverType, "Gameover Type");

	var deathSfx = new UIAutoCompleteTextBox(gameoverType.x + gameoverType.bWidth + 15, gameoverType.y, "", 190);
	add(deathSfx);
	addLabelOn(deathSfx, "Death SFX");

	var deathMusic = new UIAutoCompleteTextBox(deathSfx.x + deathSfx.bWidth + 15, deathSfx.y, "", 190);
	add(deathMusic);
	addLabelOn(deathMusic, "Death Music");

	var sfxDelay = new UINumericStepper(deathMusic.x + deathMusic.bWidth + 15, deathMusic.y, 1, 0.1, 2, 0, 10, 82);
	add(sfxDelay);
	addLabelOn(sfxDelay, "SFX\nDelay", 36);

	var musicDelay = new UINumericStepper(sfxDelay.x + sfxDelay.bWidth + 15, sfxDelay.y, 1, 0.1, 2, 0, 10, 82);
	add(musicDelay);
	addLabelOn(musicDelay, "Music\nDelay", 36);

	var retrySFX = new UIAutoCompleteTextBox(gameoverType.x, gameoverType.y + gameoverType.bHeight + 32, "", 190);
	add(retrySFX);
	addLabelOn(retrySFX, "Retry SFX");

	var scriptName = new UIAutoCompleteTextBox(retrySFX.x + retrySFX.bWidth + 15, retrySFX.y, "", 190);
	add(scriptName);
	addLabelOn(scriptName, "Script Name");
	scriptName.suggestItems = getFolderContent("data/scripts");
	
	retrySFX.suggestItems = getFolderContent("sounds");
	deathSfx.suggestItems = getFolderContent("sounds");
	deathMusic.suggestItems = getFolderContent("music");

	addTitle(windowSpr.x + 20, retrySFX.y + retrySFX.height + 36, "PNG Options");
	
	var fadeDurationStepper;

	var fadeCheckbox = new UICheckbox(windowSpr.x + 20, retrySFX.y + retrySFX.height + 96, "Fade from black", true);
	fadeCheckbox.onChecked = function(b) {
		fadeDurationStepper.selectable = b;
	}
	add(fadeCheckbox);

	fadeDurationStepper = new UINumericStepper(fadeCheckbox.x, fadeCheckbox.y + 60, 1, 0.1, 2, 0, 10, 82);
	fadeDurationStepper.selectable = fadeCheckbox.checked;
	add(fadeDurationStepper);
	addLabelOn(fadeDurationStepper, "Fade\nDuration", 36);

	var imageName = new UIAutoCompleteTextBox(fadeDurationStepper.x + fadeDurationStepper.bWidth + 35, fadeDurationStepper.y, "", 190);
	add(imageName);
	addLabelOn(imageName, "Image Name");
	imageName.suggestItems = getFolderContent("images");

	addTitle(windowSpr.x + 350, retrySFX.y + retrySFX.height + 36, "Video Options");

	var soundCheckbox = new UICheckbox(windowSpr.x + 350, retrySFX.y + retrySFX.height + 96, "Video has sound?", true);
	add(soundCheckbox);

	var loopCheckbox = new UICheckbox(soundCheckbox.x + 185, soundCheckbox.y, "Video Looping?", true);
	add(loopCheckbox);

	var videoName = new UIAutoCompleteTextBox(soundCheckbox.x, soundCheckbox.y + 60, "", 190);
	add(videoName);
	addLabelOn(videoName, "Video Name");
	videoName.suggestItems = getFolderContent("videos");

	function loadData() {
		if (Reflect.fields(GameoverEditor_currentData).length == 0) return;

		gameoverType.setOption(gameoverType.options.indexOf(GameoverEditor_currentData.gameoverType) ?? 0);
		
		scriptName.label.text = GameoverEditor_currentData.scriptName ?? "";
		deathSfx.label.text = GameoverEditor_currentData.deathSfx ?? "";
		sfxDelay.value = GameoverEditor_currentData.sfxDelay ?? 0;
		deathMusic.label.text = GameoverEditor_currentData.deathMusic ?? "";
		musicDelay.value = GameoverEditor_currentData.musicDelay ?? 0;
		retrySFX.label.text = GameoverEditor_currentData.retrySfx ?? "";

		fadeDurationStepper.value = GameoverEditor_currentData.pngOptions.fadeDuration ?? 0;
		fadeCheckbox.checked = (GameoverEditor_currentData.pngOptions.fadeDuration ?? 0) > 0;
		imageName.label.text = GameoverEditor_currentData.pngOptions.imageName ?? "";
		fadeCheckbox.onChecked(fadeCheckbox.checked);

		loopCheckbox.checked = GameoverEditor_currentData.videoOptions.videoLooping ?? false;
		soundCheckbox.checked = GameoverEditor_currentData.videoOptions.videoHasSound ?? true;
		videoName.label.text = GameoverEditor_currentData.videoOptions.videoName ?? "";
	}

	loadData();

	var saveButton = new UIButton(windowSpr.x + windowSpr.bWidth - 20, windowSpr.y + windowSpr.bHeight - 16 - 32, "Save & Close", function() {
		var oldData = GameoverEditor_currentData;
		GameoverEditor_currentData = {
			gameoverType: gameoverType.options[gameoverType.index],
			scriptName: scriptName.label.text,
			deathSfx: deathSfx.label.text,
			sfxDelay: Math.max(0, sfxDelay.value),
			deathMusic: deathMusic.label.text,
			musicDelay: Math.max(0, musicDelay.value),
			retrySfx: retrySFX.label.text,
			pngOptions: {
				imageName: imageName.label.text,
				fadeDuration: fadeCheckbox.checked ? Math.max(0, fadeDurationStepper.value) : 0,
			},
			videoOptions: {
				videoLooping: loopCheckbox.checked,
				videoHasSound: soundCheckbox.checked,
				videoName: videoName.label.text,
			},
		};
		FlxG.state.stateScripts.get("playPreview")();
		undos.addToUndo({type: "changeData", undoData: {oldData: oldData, newData: GameoverEditor_currentData}});
		close();
	});
	add(saveButton);
	saveButton.x -= saveButton.bWidth;

	var closeButton = new UIButton(saveButton.x - 20, saveButton.y, "Close", function() {
		close();
	});
	add(closeButton);
	closeButton.frames = Paths.getFrames("editors/ui/grayscale-button");
	closeButton.color = 0xFFFF0000;
	closeButton.x -= closeButton.bWidth;
}