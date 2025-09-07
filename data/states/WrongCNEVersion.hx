import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.system.macros.GitCommitMacro;
import lime.app.Application;

var label = new FlxText(0, 0, FlxG.width, "", 28);
function postCreate() {
    var gameCommit = GitCommitMacro.commitHash;
    var gameVer = Application.current.meta['version'];

    if (gameVer == goodVersion && gameCommit == goodCommitNumba) { //incase
        allowEnter = false;
        allowBack = false;
        new FlxTimer().start(1, exit);
    }

    var text = 
        [
            "You are not running the right version of Codename Engine that SNP recommend.",
            "You are running version *v" + gameVer + "* (Commit #" + gameCommit + "#)",
            "SNP Recommends version *v" + goodVersion + "* (Commit #" + goodCommitNumba + "#)",
            "",
            "Press %Enter% to download that version",
            "Press %Escape% to skip that warning and $accept the consequences$ of the $mod breaking$"
        ].join("\n");

    label.setFormat(Paths.font("U.ttf"), 24, FlxColor.WHITE, "center");
    label.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 4, 3);
    label.antialiasing = true;
    add(label);

    setText(text);
}

function setText(text) {
        label.applyMarkup(text,
        [
            new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFE044FF), "*"),
            new FlxTextFormatMarkerPair(new FlxTextFormat(0xFF8644FF), "#"),
            new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFFFF00), "%"),
            new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "$"),
        ]
    );
    label.screenCenter();
}

function exit() {
    if (FlxG.save.data.viewWarningState || FlxG.save.data.showCutscene)
        FlxG.switchState(FlxG.save.data.viewWarningState ? new ModState('Warning') : new ModState('CutsceneState'));
    else
        FlxG.switchState(new TitleState());
}

var allowEnter = true;
var allowBack = true;
function update(elapsed:Float) {
    if (controls.ACCEPT && allowEnter)
    {
        allowEnter = false;
        setText(
            [
                "The download link has been opened in your #browser#",
                "",
                "You can still press %Escape% to skip that warning and $accept the consequences$ of the $mod breaking$"
            ].join("\n")
        );
        CoolUtil.openURL(cneDownloadLink);
    } else if (controls.BACK && allowBack)
        exit();
}