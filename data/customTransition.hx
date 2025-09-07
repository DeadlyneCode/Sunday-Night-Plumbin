import openfl.display.BitmapData;

var time = 0.6;
var maxScale = 35;

var trans;
var top;
var bot;
var left;
var right;
function create(event) {
    var width = FlxG.width / 2;
    var height = FlxG.height / 2;

    var black = new BitmapData(width, height, true, 0xFF000000);
    var border = new BitmapData(width * 5, height * 5, true, 0xFF000000);

    var chromaKeyTrans = new CustomShader("chromaKeyTrans");
    chromaKeyTrans.data.mask.input = FlxG.bitmap.add(Paths.image("trans")).bitmap;

    trans = new FlxSprite().loadGraphic(black);
    trans.setGraphicSize(width, height);
    trans.shader = chromaKeyTrans;
    trans.screenCenter();
    trans.scrollFactor.set();
    add(trans);

    top = new FlxSprite().loadGraphic(border);
    top.screenCenter();
    top.scrollFactor.set();
    add(top);

    bot = new FlxSprite().loadGraphic(border);
    bot.screenCenter();
    bot.scrollFactor.set();
    add(bot);

    left = new FlxSprite().loadGraphic(border);
    left.screenCenter();
    left.scrollFactor.set();
    add(left);

    right = new FlxSprite().loadGraphic(border);
    right.screenCenter();
    right.scrollFactor.set();
    add(right);

    switch (event.transOut)
    {
        case true:
            trans.scale.x = trans.scale.y = maxScale;
            FlxTween.tween(trans, {"scale.x": 0, "scale.y": 0}, time, {
                onComplete: finish
            });
        case false:
            trans.scale.x = trans.scale.y = 0;
            FlxTween.tween(trans, {"scale.x": maxScale, "scale.y": maxScale}, time, {
                onComplete: finish
            });
    }

    allowSkip = false;
    event.cancel();
}

function update()
{
    if (trans != null)
    {
        trans.updateHitbox();
        trans.screenCenter();
        if (left != null) {
            left.x = trans.x - left.width;
            left.y = trans.y - ((left.height - trans.height) / 2);
        }
        if (right != null) {
            right.x = trans.x + trans.width;
            right.y = trans.y - ((right.height - trans.height) / 2);
        }
        if (bot != null) {
            bot.y = trans.y + trans.height;
            bot.x = trans.x - ((bot.width - trans.height) / 2);
        }
        if (top != null) {
            top.y = trans.y - top.height;
            top.x = trans.x - ((top.width - trans.height) / 2);
        }
    }
}