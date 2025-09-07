/*import sys.FileSystem;
import openfl.system.Capabilities;
import funkin.backend.utils.NdllUtil;
import funkin.backend.utils.NativeAPI;
import funkin.backend.utils.ThreadUtil;

var color:Array<String> = ['purple0000','blue0000','green0000','red0000'];

var windowPosX = 0;
var windowPosY = 0;
var windowWidth = 0;
var windowHeight = 0;

var showTaskbar = NdllUtil.getFunction("WindowUtils", "ndllexample_show_taskbar", 1);
var getWallpaper = NdllUtil.getFunction("WindowUtils", "ndllexample_get_wallpaper", 0);
var setWallpaper = NdllUtil.getFunction("WindowUtils", "ndllexample_set_wallpaper", 1);

var effect = stage.stageSprites["effect"];

var mecanics;
function postCreate() {
    window.maximized = false;
    window.opacity = 0;
    window.borderless = true;

    windowPosX = window.x;
    windowPosY = window.y;
    windowWidth = window.width;
    windowHeight = window.height;

    window.x = window.y = 0;
    window.width = Capabilities.screenResolutionX - 1;
    window.height = Capabilities.screenResolutionY - 1;
    FlxG.fullscreen = false;
    effect.visible = false;
       
    var errorType = "Null Object Reference";
    var fakeCrashThing = "";

    mecanics = FlxG.save.data.disto;
    #if (linux || macos)
    mecanics = false;
    #end

    var lines = [
           "(flixel/FlxSprite.hx) FlxSprite.set_angle() - line 1581",
           "(C:\\hostedtoolcache\\windows\\haxe\\4.2.5\\x64\\std/cpp/_std/Re",
           "flect.hx) Reflect.setProperty() - line 50",
           "(flixel/tweens/misc/VarTween.hx) VarTween.update() - line 61",
           "(flixel/tweens/FlxTween.hx) FlxTweenManager.update() - line",
           "1264",
           "(flixel/FlxGame.hx) FlxGame.update() - line 795",
           "(flixel/FlxGame.hx) FlxGame.step() - line 727",
           "(flixel/FlxGame.hx) FlxGame.onEnterFrame() - line 597",
           "(funkin/backend/system/FunkinGame.hx)",
           "FunkinGame.onEnterFrame() - line 18",
           "(openfl/events/EventDispatcher.hx)",
           "EventDispatcher.__dispatchEvent() - line 402",
           "(openfl/display/DisplayObject.hx) DisplayObject._dispatch() -",
           "line 1399"
    ];

    for (line in lines)
           fakeCrashThing += line + "\n";

    NativeAPI.showMessageBox("Codename Engine Crash Handler", "Uncaught Error: " + errorType + "\n\n" + fakeCrashThing, 0x00000010);

    if (mecanics)
        showTaskbar(false);

    oldWallpaper = getWallpaper();
}

var oldWallpaper = "";

function destroy() {
    if (mecanics) {
        setWallpaper(oldWallpaper);
        showTaskbar(true);
    }
    window.borderless = false;
    window.x = windowPosX;
    window.y = windowPosY;
    window.width = windowWidth;
    window.height = windowHeight;
    window.opacity = 1;
}

function update() {
    if (FlxG.fullscreen) {
        window.borderless = true;
        FlxG.fullscreen = false;
    }
}

function stepHit(curStep:Int){
    switch(curStep) {
        case 10:
            FlxTween.tween(window, {opacity: 1}, 7, {});

        case 128:
            effect.visible = true;

        case 190:
            FlxTween.tween(window, {x: windowPosX, y: windowPosY, width: windowWidth, height: windowHeight}, 1, {ease: FlxEase.expoOut});
        
        case 430:
            FlxTween.tween(window, {x: windowPosX, y: windowPosY, width: windowWidth, height: windowHeight}, 3, {ease: FlxEase.expoOut});

        case 770:
            if (mecanics) {
                ThreadUtil.createSafe(function()
                {
                    var relPath:String = Assets.getPath("assets/images/darkwallpaper.bmp");
                    relPath = FileSystem.absolutePath(relPath);
                    trace(relPath);
                    relPath = StringTools.replace(relPath, "/", "\\");
                    setWallpaper(relPath);
                    window.x = window.y = 75;
                    window.width = Capabilities.screenResolutionX - 150;
                    window.height = Capabilities.screenResolutionY - 150;
                });
            }

        case 1280:
            ThreadUtil.createSafe(function()
            {
                window.x = window.y = 200;
                window.width = Capabilities.screenResolutionX - 400;
                window.height = Capabilities.screenResolutionY - 400;
            });
    }
}

function onDadHit(e){
    if (e.noteType == "Event Note")
    {
        window.x += FlxG.random.float(-50, 50);
        window.y += FlxG.random.float(-50, 50);
        window.width += FlxG.random.float(-50, 50);
        window.height = window.width / (16/9);

        var screenSafeZone = 50;
        window.width = Math.max(windowWidth * 0.75, Math.min(windowWidth * 1.75, window.width));
        window.x = Math.max(screenSafeZone, Math.min((Capabilities.screenResolutionX - window.width) - screenSafeZone, window.x));
        window.y = Math.max(screenSafeZone, Math.min((Capabilities.screenResolutionY - window.height) - screenSafeZone, window.y));
    }
    t = new CustomShader('funi');
    if (e.note.isSustainNote) return;
    
    var fallnotes:FlxSprite = new FlxSprite(FlxG.random.int(-25, 25) * 40,200);

    fallnotes.colorTransform.color = FlxColor.WHITE;

    fallnotes.frames = Paths.getFrames('game/notes/note');
    fallnotes.animation.addByPrefix('fart', color[e.direction]);
    fallnotes.updateHitbox();
    fallnotes.animation.play('fart');
    insert(members.indexOf(dad) - 1, fallnotes);
    fallnotes.shader = t;
    
    FlxTween.tween(fallnotes, {y: (fallnotes.y + FlxG.random.int(50, 200)) + 300, alpha: 0 ,angle:FlxG.random.int(360, 720)}, 2, {ease: FlxEase.circOut,onComplete: function() {
        fallnotes.destroy();
    }});
}
}*/