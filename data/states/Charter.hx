// HOOK FOR THE CHART EDITOR TO ADD CUSTOM SHITS SNP USES
import funkin.editors.ui.UITopMenu;
import flixel.input.keyboard.FlxKey;
import funkin.editors.ui.UISubstateWindow;
import funkin.editors.ui.UITopMenu.UITopMenuButton;

function postCreate() {

	topMenu[0] = {
		label: "File",
		childs: [
			{
				label: "New"
			},
			null,
			{
				label: "Save",
				keybind: [FlxKey.CONTROL, FlxKey.S],
				onSelect: function()
				{
					_file_save_no_events();
					_file_events_save();
				},
			},
			{
				label: "Save As...",
				keybind: [FlxKey.CONTROL, FlxKey.SHIFT, FlxKey.S],
				onSelect: _file_saveas_no_events,
			},
			{
				label: "Save Events As...",
				keybind: [FlxKey.CONTROL, FlxKey.SHIFT, FlxKey.ALT, FlxKey.S],
				onSelect: _file_events_saveas,
			},
			null,
			{
				label: "Save Meta",
				keybind: [FlxKey.CONTROL, FlxKey.ALT, FlxKey.S],
				onSelect: _file_meta_save,
			},
			{
				label: "Save Meta As...",
				keybind: [FlxKey.CONTROL, FlxKey.ALT, FlxKey.SHIFT, FlxKey.S],
				onSelect: _file_meta_saveas,
			},
			null,
			{
				label: "Exit",
				onSelect: _file_exit
			}
		]
	};

	refreshTopMenu();

	playBackSlider.valueStepper.min = 0.1;
	playBackSlider.startText .text = "0.1";
	playBackSlider.segments[0].start = 0.1;
	playBackSlider.segments[1].end = 10;
	playBackSlider.valueStepper.max = 10;
	playBackSlider.endText.text = "10";
}

function refreshTopMenu() {
	var index = members.indexOf(topMenuSpr);
	var daCam = topMenuSpr.cameras;
	remove(topMenuSpr);
	topMenuSpr = new UITopMenu(topMenu);
	topMenuSpr.cameras = daCam;
	insert(index, topMenuSpr);

	var freakyX = 0;
	for(o in topMenuSpr.members) {
		freakyX += o.bWidth;
	}
	var freakyChilds = [
		{
			label: "Edit Pause Menu Metadata",
			color: 0xFF959829, icon: 4,
			onCreate: function (button) {button.label.offset.x = button.icon.offset.x = -2;},
			onSelect: function () {
				openSubState(new UISubstateWindow(true, "popups/PauseMetaScreen"));
			}
		},
		{
			label: "Edit Result Screen Metadata",
			color: 0xFF959829, icon: 4,
			onCreate: function (button) {button.label.offset.x = button.icon.offset.x = -2;},
			onSelect: function () {
				openSubState(new UISubstateWindow(true, "popups/ResultMetaScreen"));
			}
		}
	];
	var cool = new UITopMenuButton(freakyX, 0, topMenuSpr, "SNP Metadata", freakyChilds);
	cool.screenCenter(0x01);
	cool.x -= cool.bWidth;
	topMenuSpr.members.push(cool);  
}