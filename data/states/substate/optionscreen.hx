import Type;
import funkin.backend.system.Main;

function create() {
	camera = new FlxCamera();
    camera.bgColor = FlxColor.fromRGBFloat(0, 0, 0, 0.95);
	addMenuShaders([camera]);
	FlxG.cameras.add(camera, false);
}

var spawnedOptions = [];
var selectedThing:FlxSprite;
var selectThingShader;
function postCreate() {
    var items = [];
    var optScreen = data.screen;
    for (i=>member in optScreen.members)
    {
        var optionType = Std.string(Type.getClass(member));
        switch (optionType)
        {
            case "funkin.options.type.Separator":
                items.push(null);
            case "funkin.options.type.Checkbox":
                items.push({type: "Bool", optionName: member.optionName, parent: member.parent, name: member.text, desc: member.desc});
            case "funkin.options.type.NumOption":
                items.push({type: "Number", optionName: member.optionName, parent: member.parent, name: member.text, desc: member.desc, min: member.min, max: member.max, callback: member.selectCallback, step: member.step});
            case "funkin.options.type.TextOption":
                items.push({type: "Button", name: member.text, desc: member.desc, callback: member.selectCallback});
            case "funkin.options.type.ArrayOption":
                items.push({type: "Choice", optionName: member.optionName, parent: member.parent, name: member.text, desc: member.desc, options: member.options, displayOptions: member.displayOptions, callback: member.selectCallback, currentSelection: member.currentSelection});
        }
    }

    selectedThing = new FlxSprite().loadGraphic(Paths.image("states/options/layout"));
    for (i=>item in items)
    {
        if (item == null) continue;
        var group = new FlxSpriteGroup();
        add(group);
        var title = new FlxText(20, 0, selectedThing.width - 20, item.name);
		title.setFormat(Paths.font("U.ttf"), 36, FlxColor.WHITE, "left");
        group.add(title);

        var desc = new FlxText(title.x, title.y + title.height + 10, title.fieldWidth, item.desc);
		desc.setFormat(Paths.font("U.ttf"), 24, FlxColor.WHITE, "left");
        group.add(desc);

        item.onSelect = function () {};
        item.onChangeSelection = function (s) {};

        switch (item.type)
        {
            case "Bool":
                var isEnabled = Reflect.field(item.parent, item.optionName) == true;
                var text = new FlxText(title.x - 20, (title.y + desc.y) / 2 - 10, title.fieldWidth, getString("snpOptions_toggleStatus_" + (isEnabled ? "on" : "off")));
                text.setFormat(Paths.font("U.ttf"), 48, isEnabled ? FlxColor.GREEN : FlxColor.RED, "right");    
                group.add(text);
                item.onSelect = function () {
                    isEnabled = !isEnabled;
                    text.text = getString("snpOptions_toggleStatus_" + (isEnabled ? "on" : "off"));
                    text.setFormat(Paths.font("U.ttf"), 48, isEnabled ? FlxColor.GREEN : FlxColor.RED, "right");
                    Reflect.setField(item.parent, item.optionName, isEnabled);
                    if (item.callback != null)
                        item.callback(isEnabled);
                };
                for (t in [title, desc])
                {
                    t.fieldWidth -= 120;
                    t.updateHitbox();
                }
                text.x -= 20;
            
            case "Choice":
                function formatTextOption() {
                    var currentOptionString = "";
                    if((item.currentSelection > 0))
                        currentOptionString += "< ";
                    else
                        currentOptionString += "  ";

                    currentOptionString += item.displayOptions[item.currentSelection];

                    if(!(item.currentSelection >= item.options.length - 1))
                        currentOptionString += " >";

                    return currentOptionString;
                }
                var text = new FlxText(title.x - 20, (title.y + desc.y) / 2 - 10, title.fieldWidth, formatTextOption());
                text.setFormat(Paths.font("U.ttf"), 48, FlxColor.WHITE, "right");    
                group.add(text);
                item.onChangeSelection = function (change) {
                    if(item.currentSelection <= 0 && change == -1 || item.currentSelection >= item.options.length - 1 && change == 1) return;
                    item.currentSelection += Math.round(change);
                    text.text = formatTextOption();
                    Reflect.setField(item.parent, item.optionName, item.options[item.currentSelection]);
                    if (item.callback != null)
                        item.callback(item.options[item.currentSelection]);
                }
            case "Number":
                var text = new FlxText(title.x - 20, (title.y + desc.y) / 2 - 10, title.fieldWidth, item.currentSelection);
                text.setFormat(Paths.font("U.ttf"), 48, FlxColor.WHITE, "right");    
                group.add(text);
                item.currentSelection = Reflect.field(item.parent, item.optionName);
                item.onChangeSelection = function (change) {
		            if(item.currentSelection <= item.min && change == -1 || item.currentSelection >= item.max && change == 1) return;
		            item.currentSelection = FlxMath.roundDecimal(item.currentSelection + (change * item.step), FlxMath.getDecimals(item.step));
                    text.text = item.currentSelection;
                    Reflect.setField(item.parent, item.optionName, item.currentSelection);
                    if (item.callback != null)
                        item.callback(item.currentSelection);
                }
                item.onChangeSelection(0);
            case "Button":
                title.alignment = "center";
                desc.alignment = "center";
        }

        
        group.y = (Math.max(group.height, selectedThing.height) + 50) * i;
        group.screenCenter(FlxAxes.X);

        spawnedOptions[i] = {group: group, item: item};
    }

    add(selectedThing);
    selectedThing.screenCenter(FlxAxes.X);
    selectedThing.antialiasing = true;

    selectThingShader = new CustomShader("optionSelection");
    selectedThing.shader = selectThingShader;
    changeSelection(0, true);
}

var specialTime:Float = 0;
function update(elapsed:Float) {
    if (spawnedOptions == null || spawnedOptions.length <= 0) return;
    if (spawnedOptions[curSelected] == null) return;
    if (spawnedOptions[curSelected].group == null) return;
        
    var wantPos = spawnedOptions[curSelected].group.y + ((spawnedOptions[curSelected].group.height - selectedThing.height) / 2);
    camera.scroll.y = lerp(camera.scroll.y, (-FlxG.height / 2) + (selectedThing.height / 2) + wantPos, 0.1);
    selectedThing.y = lerp(selectedThing.y, wantPos, 0.25);
    selectedThing.scale.y = Math.max(1, (spawnedOptions[curSelected].group.height + 30)/130);
    selectedThing.updateHitbox();
    specialTime += elapsed;
    selectThingShader.time = specialTime;

    if ((controls.ACCEPT || (FlxG.mouse.justReleased && Main.timeSinceFocus > 0.25)) && timeSinceOpen > 0.1)
		spawnedOptions[curSelected].item.onSelect();
	if (controls.LEFT_P)
		spawnedOptions[curSelected].item.onChangeSelection(-1);
	if (controls.RIGHT_P)
		spawnedOptions[curSelected].item.onChangeSelection(1);

    changeSelection((controls.UP_P ? -1 : 0) + (controls.DOWN_P ? 1 : 0) - FlxG.mouse.wheel);

    timeSinceOpen += elapsed;
}

var timeSinceOpen = 0;

var curSelected = 0;

function wrapToMembers(s)
{
    return FlxMath.wrap(s, 0, spawnedOptions.length-1);
}
function changeSelection(s:Int, force:Bool = false) {
	if (spawnedOptions.length <= 0 || (s == 0 && !force)) return;
	//CoolUtil.playMenuSFX(SCROLL);
    var toAdd = 1;
    var sel = s == 0 ? (spawnedOptions[wrapToMembers(curSelected + s)].group.members.length == 2 ? 1 : 0) : s;
    
    while (spawnedOptions[wrapToMembers(curSelected + (sel * toAdd))] == null || spawnedOptions[wrapToMembers(curSelected + (sel * toAdd))].group.members.length == 2)
    {
        toAdd++;
    }
	curSelected = wrapToMembers(curSelected + (sel * toAdd));
}

function onClose() {
    FlxG.cameras.remove(camera, true);
}