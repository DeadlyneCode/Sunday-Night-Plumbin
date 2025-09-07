import funkin.backend.system.GraphicCacheSprite;

var data:Map<Int, {lastNote:{time:Float, id:Int}}> = [];
var maxClones:Int = 5;
var clonePool:Array<Character> = [];
var activeClones:Array<Character> = [];
var preCache:GraphicCacheSprite;
var minDistance:Float = 100;

function postCreate() {
    preCache = new GraphicCacheSprite();
    preCache.cache(Paths.image('characters/maltigi/spritemap1'));

    for (sl in strumLines.members) {
        data[strumLines.members.indexOf(sl)] = {
            lastNote: { time: -9999, id: -1 }
        };
    }

    for (i in 0...maxClones) {
        var clone = new Character(0, 0, "maltigi", false);
        clone.alpha = 0.75;
        clone.scale.set(0.75, 0.75);
        clone.exists = false;
        clone.visible = false;
        clonePool.push(clone);
        insert(members.indexOf(dad), clone);
    }
}

function onDadHit(event) {
    if (event.noteType == "No Anim Note" || event.note.isSustainNote) return;

    var target = data[strumLines.members.indexOf(event.note.strumLine)];
    target.lastNote.time = event.note.noteData;
    target.lastNote.id = event.note.noteData;

    for (character in event.characters) {
        if (character.visible) {
            var clone = getCloneFromPool();
            if (clone != null) {
                initializeClone(clone, character);
            }
        }
    }
}

function getCloneFromPool():Character {
    if (clonePool.length > 0) {
        return clonePool.pop();
    }
    return null;
}

function initializeClone(clone:Character, source:Character) {
    var startX:Int;
    var startY:Int;

    do {
        var randomX = FlxG.random.int(0, 1);
        startY = FlxG.random.int(0, FlxG.height);
        startX = (randomX == 1) ? -1228 : 1228;
    } while (isTooCloseToOtherClones(startX, startY));

    clone.setPosition(startX, startY);
    clone.playAnim(source.getAnimName(), true);
    clone.exists = true;
    clone.visible = true;
    activeClones.push(clone);

    moveClone(clone);

    FlxTween.tween(clone, {alpha: 0}, 1.0).onComplete = function() {
        deactivateClone(clone);
    };
}

function deactivateClone(clone:Character) {
    clone.exists = false;
    clone.visible = false;
    clone.alpha = 0.75;
    activeClones.remove(clone);
    clonePool.push(clone);
}

function onSongEnd() {
    FlxG.save.data.unlockedMaltigi = true;
    FlxG.save.flush();
}

function moveClone(clone:Character) {
    var direction = (clone.x == -1228) ? 1 : -1;
    var moveX = FlxG.random.int(500, 800) * direction;
    var moveY = FlxG.random.int(-100, 100);

    var targetX = clone.x + moveX;
    var targetY = clone.y + moveY;

    FlxTween.tween(clone, {x: targetX, y: targetY}, 0.5, {ease: FlxEase.quadOut});
}

function isTooCloseToOtherClones(x:Float, y:Float):Bool {
    for (existingClone in activeClones) {
        var distanceX = Math.abs(x - existingClone.x);
        var distanceY = Math.abs(y - existingClone.y);
        var distance = Math.sqrt(Math.pow(distanceX, 2) + Math.pow(distanceY, 2));
        if (distance < minDistance) {
            return true; 
        }
    }
    return false;
}
