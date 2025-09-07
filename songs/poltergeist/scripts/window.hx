var allSpr = [];
var lights = [];
var OgPos = 1300;
var windowstuff = true;
var separatorStuff = [1000, -1800];
var lightOffsetX = 0;
var lightOffsetY = 0;

function create() {
    for (i in 0...3) {
        var w = new FlxSprite(separatorStuff[0] * i, 0);
        w.frames = Paths.getSparrowAtlas("stages/manor/window");
        w.scrollFactor.set(0.4, 0.4);
        w.alpha = 0.000001;
        insert(members.indexOf(dad) - 1, w);
        w.animation.addByPrefix("Window1", "1", 24);
        w.animation.addByPrefix("Window2", "2", 24);
        w.animation.addByPrefix("Window3", "3", 24);
        w.velocity.x = -1600;
        allSpr.push(w);
    }
}

function postCreate() {
    var proto = stage.stageSprites["lightwindow"];
    if (proto != null) {
        if (allSpr.length > 0) {
            lightOffsetX = proto.x - allSpr[0].x + 700;
            lightOffsetY = proto.y - allSpr[0].y;
        }
        proto.visible = false;
        for (i in 0...3) {
            var l = new FlxSprite(proto.x, proto.y);
            l.frames = proto.frames;
            l.blend = 0;
            l.antialiasing = proto.antialiasing;
            l.scrollFactor.set(proto.scrollFactor.x, proto.scrollFactor.y);
            l.alpha = 0.0000001;
            insert(members.indexOf(dad) + 1, l);
            lights.push(l);
        }
    }
}

function update() {
    if (windowstuff) {
        if (allSpr[0].x < separatorStuff[1]) {
            allSpr[0].x = OgPos;
            restoreTween(allSpr[0]);
        }
        if (allSpr[1].x < separatorStuff[1]) {
            allSpr[1].x = OgPos;
            restoreTween(allSpr[1]);
        }
        if (allSpr[2].x < separatorStuff[1]) {
            allSpr[2].x = OgPos;
            restoreTween(allSpr[2]);
        }
    }
    for (i in 0...Math.min(allSpr.length, lights.length)) {
        var w = allSpr[i];
        var l = lights[i];
        l.x = w.x + lightOffsetX;
        l.y = w.y + lightOffsetY;
        if (members.indexOf(l) <= members.indexOf(dad)) {
            remove(l, false);
            insert(members.indexOf(dad) + 1, l);
        }
    }
}

function restoreTween(spr) {
    spr.y = 500;
    FlxTween.cancelTweensOf(spr);
    FlxTween.tween(spr, {y: 0}, 0.6, {ease: FlxEase.backOut});
    spr.animation.play("Window" + FlxG.random.int(1, 3));
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1057:
            for (i in allSpr) i.alpha = 1;
            for (l in lights) l.alpha = 0.15;
        case 1328:
            for (i in allSpr) i.alpha = 0.0000001;
            for (l in lights) l.alpha = 0.0000001;
    }
}
