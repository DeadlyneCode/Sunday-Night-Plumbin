import flixel.input.keyboard.FlxKey;
import funkin.backend.assets.Paths;
import funkin.backend.system.Flags;
import funkin.backend.utils.WindowUtils;
import funkin.editors.EditorTreeMenu;
import funkin.editors.SaveWarning;
import funkin.editors.UndoList;
import funkin.editors.ui.UIState;
import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UITopMenu;
import funkin.editors.ui.UIUtil;
import haxe.Json;
import hxvlc.flixel.FlxVideoSprite;
import sys.FileSystem;
import sys.io.File;

var topMenuSpr:UITopMenu;

static var GameoverEditor_currentData = {};

var playingMusic:Bool = false;

var gameoverCamera:FlxCamera;
var uiCamera:FlxCamera;
var undos:UndoList;
function create() {
	gameoverCamera = FlxG.camera;
	gameoverCamera.zoom = 1;
	uiCamera = new FlxCamera();
	uiCamera.bgColor = 0;
	FlxG.cameras.add(uiCamera, false);

	topMenu = [
		{
			label: "File",
			childs: [
				{
					label: "New"
				},
				null,
				{
					label: "Save",
					keybind: [FlxKey.CONTROL, FlxKey.S],
					onSelect: _file_save
				},
				null,
				{
					label: "Exit",
					onSelect: _file_exit
				}
			]
		},
		{
			label: "Edit",
			childs: [
				{
					label: "Undo",
					keybind: [FlxKey.CONTROL, FlxKey.Z],
					onSelect: _edit_undo
				},
				{
					label: "Redo",
					keybinds: [[FlxKey.CONTROL, FlxKey.Y], [FlxKey.CONTROL, FlxKey.SHIFT, FlxKey.Z]],
					onSelect: _edit_redo
				},
				null,
				{
					label: "Edit Gameover data",
					color: 0xFF959829, icon: 4,
					onCreate: (button) -> {button.label.offset.x = button.icon.offset.x = -2;},
					onSelect: (_) -> {
						openSubState(new UISubstateWindow(true, "gameovereditor/popups/StageData"));
					}
				},
			]
		},
		{
			label: "Preview",
			childs: [
				{
					label: "Restart",
					keybind: [FlxKey.SPACE],
					onSelect: () -> playPreview(),
				},
				null,
				{
					label: "Play Death SFX",
					onSelect: () -> {
						FlxG.sound.play(Paths.sound(GameoverEditor_currentData.deathSfx));
					},
				},
				{
					label: "Play Retry SFX",
					onSelect: () -> {
						FlxG.sound.play(Paths.sound(GameoverEditor_currentData.retrySfx));
					},
				},
				{
					label: "Play Death Music",
					onCreate: (b) -> b.label.text = playingMusic ? "Stop Death Music" : "Play Death Music",
					onSelect: (b) -> {
						if (playingMusic) {
							FlxG.sound.music.stop();
							playingMusic = false;
						} else {
							FlxG.sound.playMusic(Paths.music(GameoverEditor_currentData.deathMusic));
							playingMusic = true;
						}
					},
				}
			]
		},
		{
			label: "Menu",
			childs: [
				{
					label: "Reload",
					onSelect: () -> FlxG.switchState(new UIState(true, "gameovereditor/GameoverEditor")),
				}
			]
		}
	];

	topMenuSpr = new UITopMenu(topMenu);
	topMenuSpr.cameras = [uiCamera];
	add(topMenuSpr);
	undos = new UndoList();

	WindowUtils.suffix = " (Gameover Editor)";
	SaveWarning.selectionClass = MainMenuState;
	SaveWarning.saveFunc = () -> {_file_save(null);};

	if (FileSystem.exists(Paths.getAssetsRoot() + '/songs/' + GameoverEditor_song + '/gameover.json'))
		GameoverEditor_currentData = Json.parse(File.getContent(Paths.getAssetsRoot() + '/songs/' + GameoverEditor_song + '/gameover.json'));
	else
		GameoverEditor_currentData = {};

	playPreview();
}

var gameoverMembers = [];
var onDestroys = [];
function playPreview() {
	GameoverEditor_currentData = GameoverEditor_currentData ?? {};

	for (member in gameoverMembers) {
		member.destroy();
		remove(member, true);
	}
	for (des in onDestroys) {
		des();
	}

	var gameoverType = GameoverEditor_currentData.gameoverType ?? "PNG";
	switch (gameoverType)
	{
		case "PNG":
			var gameoverSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(GameoverEditor_currentData.pngOptions.imageName));
			add(gameoverSprite);
			gameoverSprite.setGraphicSize(FlxG.width, FlxG.height);
			gameoverSprite.updateHitbox();
			if (GameoverEditor_currentData.pngOptions.fadeDuration > 0)
			{
				gameoverSprite.alpha = 0.001;
				FlxTween.tween(gameoverSprite, {alpha: 1}, GameoverEditor_currentData.pngOptions.fadeDuration);
			}
			gameoverSprite.cameras = [gameoverCamera];
			gameoverMembers.push(gameoverSprite);
		case "Video":
			var gameoverVideo = new FlxVideoSprite(0, 0);
			gameoverVideo.load(Assets.getPath(Paths.video(GameoverEditor_currentData.videoOptions.videoName)), [(!GameoverEditor_currentData.videoOptions.videoHasSound ? ':no-audio' : ':audio')]);
			
			gameoverVideo.bitmap.onFormatSetup.add(function():Void
			{
				if (gameoverVideo.bitmap != null && gameoverVideo.bitmap.bitmapData != null)
				{
					var scale:Float = Math.min(FlxG.width / gameoverVideo.bitmap.bitmapData.width, FlxG.height / gameoverVideo.bitmap.bitmapData.height);
					gameoverVideo.setGraphicSize(gameoverVideo.bitmap.bitmapData.width * scale, gameoverVideo.bitmap.bitmapData.height * scale);
					gameoverVideo.updateHitbox();
					gameoverVideo.screenCenter();
				}
			});

			onDestroys.push(() -> gameoverVideo.stop());

			add(gameoverVideo);
			gameoverVideo.cameras = [gameoverCamera];
			gameoverMembers.push(gameoverVideo);

			gameoverVideo.play();
	}
}

function update(elapsed:Float) {
	WindowUtils.prefix = undos.unsaved ? "* " : "";
	SaveWarning.showWarning = undos.unsaved;

	if(FlxG.keys.justPressed.ANY)
		UIUtil.processShortcuts(topMenu);
}

function _file_exit(_) {
	if (undos.unsaved) SaveWarning.triggerWarning();
	else {
		GameoverEditor_currentData = {};
		undos = null; 
		var state = new EditorTreeMenu();
		state.scriptName = "gameovereditor/Selector";
		FlxG.switchState(state);
	}
}

function _file_save(_) {
	var data = Json.stringify(GameoverEditor_currentData, null, "\t");
	CoolUtil.safeSaveFile(
		Paths.getAssetsRoot() + '/songs/' + GameoverEditor_song + '/gameover.json', data
	);
	FlxG.sound.play(Paths.sound(Flags.DEFAULT_EDITOR_SAVE_SOUND));
	undos.save();
	return;
}

function _edit_undo(_) {
	var undo = undos.undo();
	var action = undo.type;
	var undoData = undo.undoData;
	switch (action) {
		case "changeData":
			GameoverEditor_currentData = undoData.oldData;
	}
	playPreview();
}

function _edit_redo(_) {
	var redo = undos.redo();
	var action = redo.type;
	var undoData = redo.undoData;
	switch (action) {
		case "changeData":
			GameoverEditor_currentData = undoData.newData;
	}
	playPreview();
}