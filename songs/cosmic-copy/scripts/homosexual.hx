var fakeIconP2;
var iconBumpFreaky = false;

function postCreate()
{
    fakeIconP2 = new HealthIcon(dad.getIcon(), false);
    fakeIconP2.cameras = [camHUD];
    insert(members.indexOf(iconP2), fakeIconP2);
    fakeIconP2.visible = false;
    var hud = importScript("data/scripts/hud/HudV2");
}

function stepHit(curStep)
{
    savedPos = true;
    if (curStep == 1119)
    {
        fakeIconP2.visible = true;
        iconP2.visible = false;
        fakeIconP2.scale.set(iconP2.scale.x, iconP2.scale.y);
        fakeIconP2.setPosition(iconP2.x, iconP2.y);
        fakeIconP2.animation.curAnim.curFrame = iconP2.animation.curAnim.curFrame;
        fakeIconP2.acceleration.y = FlxG.random.int(200, 300);
        fakeIconP2.velocity.y -= FlxG.random.int(140, 160);
        fakeIconP2.angularVelocity -= FlxG.random.int(10, -10);
        fakeIconP2.velocity.x = FlxG.random.float(-5, 5);
    }

    if (curStep == 1139)
    {
        iconBumpFreaky = true;
        fakeIconP2.acceleration.y = 0;
        fakeIconP2.velocity.set(0, 0);
        fakeIconP2.angularVelocity = 0;
        fakeIconP2.alpha = 0.001;

        fakeIconP2.setIcon(strumLines.members[0].characters[1].getIcon());
        iconP2.setIcon(strumLines.members[0].characters[1].getIcon());
        //iconP2.y = FlxG.height - (150 * 0.4) - (iconP2.height / 2) + 50;

        FlxTween.tween(fakeIconP2, { alpha: 1 }, 1.5, { ease: FlxEase.circOut });
        iconP2.visible = true;
        fakeIconP2.visible = false;
        /*FlxTween.tween(iconP2, { y: 0 }, 1.5, { ease: FlxEase.circOut, onComplete:function (_) {
            iconP2.visible = true;
            fakeIconP2.visible = false;
        } });*/

    }
}

var HudIconsBaseY = FlxG.height - 150;
function postDraw() {
    if (iconBumpFreaky) {
        fakeIconP2.scale.set(iconP2.scale.x, iconP2.scale.y);
        fakeIconP2.setPosition(iconP2.x, iconP2.y);
    }
    fakeIconP2.animation.curAnim.curFrame = iconP2.animation.curAnim.curFrame;
}