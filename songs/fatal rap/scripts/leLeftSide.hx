import flixel.text.FlxTextBorderStyle;

function stepHit(curStep:Int){
    if (curSong == "fatal rap")
    {
        if (curStep == 75)
            doLeftSideThing();
        else if (curStep == 115)
            explodeText();
    }
}

var daTextFallBox:FlxSprite = null;
var daText:FlxText;
var arrow:Alphabet;
var arrow2:Alphabet;

function explodeText()
{
    for (spr in [arrow2, arrow, daTextFallBox])
    {
        spr.acceleration.y = FlxG.random.int(200, 300);
        spr.velocity.y -= FlxG.random.int(140, 160);
        spr.angularVelocity -= FlxG.random.int(10, -10);
        spr.velocity.x = FlxG.random.float(-5, 5);

        FlxTween.tween(spr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				spr.destroy();
			},
			startDelay: Conductor.crochet * 0.004
		});
    }
}

function update(elapsed)
{
    if (daTextFallBox != null)
    {
        daText.x = daTextFallBox.x;
        daText.y = daTextFallBox.y;
        daText.angle = daTextFallBox.angle;
        daText.alpha = daTextFallBox.alpha;
    }
}

function doLeftSideThing()
{
    arrow = new Alphabet(0, 0, "", false);
    arrow.x = (player.members[0].x + player.members[0].width * 1) - 15;

    arrow2 = new Alphabet(0, 0, "", false);
    arrow2.x = (player.members[0].x + player.members[0].width * 3) - 15;

    arrow.text = arrow2.text = downscroll ? "↓" : "↑";
    arrow.y = (player.members[0].y + player.members[0].height);
    arrow2.y = arrow.y;

    daText = new FlxText(player.members[0].x, player.members[0].y + player.members[0].height + 57, player.members[0].width * 4, getString("fatal_play_here"), 30);
    daText.setFormat(Paths.font("U.ttf"), 30, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

    arrow.y += 20;
    arrow2.y += 20;
    daText.y += 20;

    daTextFallBox = new FlxSprite(daText.x, daText.y).makeGraphic(daText.width * 4, daText.height, 0x00FFFFFF);
    add(daText);
    add(arrow);
    add(arrow2);
    add(daTextFallBox);
    arrow2.camera = arrow.camera = daText.camera = camHUD;

    arrow.alpha = arrow2.alpha = daTextFallBox.alpha = 0;

    FlxTween.tween(arrow, {y: arrow.y - 20, alpha: 1}, 1, {ease: FlxEase.expoOut});
    FlxTween.tween(arrow2, {y: arrow2.y - 20, alpha: 1}, 1, {ease: FlxEase.expoOut, startDelay: 0.05});
    FlxTween.tween(daTextFallBox, {y: daTextFallBox.y - 20, alpha: 1}, 1, {startDelay: 0.5, ease: FlxEase.expoOut});
}