import flixel.addons.display.FlxPieDial;
import flixel.addons.display.FlxPieDial.FlxPieDialShape;

var pie = null;
var pieAlpha = 0;
function postCreate() {
    if (FlxG.save.data.waitTimer == true)
    {
        pie = new FlxPieDial(player.members[0].x + (player.members[0].width * 1.5), player.members[0].y + player.members[0].height + 20, 50, 0xFFFFFFFF, 1000, FlxPieDialShape.CIRCLE, true, 0);
        add(pie);
        pie.camera = camHUD;
        pie.alpha = pieAlpha;
    
        var chromaKey = new CustomShader("chromaKey");
        var chromaColor:FlxColor = FlxColor.BLACK;
        chromaKey.u_chromaColor = [
            chromaColor.redFloat / 255.0,
            chromaColor.greenFloat / 255.0,
            chromaColor.blueFloat / 255.0,
            1.0
        ];
        chromaKey.u_tolerance = 0.2;
        pie.shader = chromaKey;
    }
}

function postUpdate(elapsed) {
    if (pie != null)
    {
        pie.alpha = lerp(pie.alpha, pieAlpha, 0.15);
        player.notes.limit = 50000;
        var nextNote = null;
        var lastTime = 0;
        player.notes.forEach(function(note) {
            if (!note.isSustainNote || true)
            {
                if (nextNote == null || note.strumTime < lastTime)
                {
                    lastTime = note.strumTime;
                    nextNote = note;
                }
            }
        });
        if (nextNote != null)
        {
            var minimumTime = 2;
            var time = (nextNote.strumTime - player.notes.__getSongPos()) / 1000;
            if (time > minimumTime)
                pieAlpha = 1;
            else
                pieAlpha = 0;
            pie.amount = (player.notes.__getSongPos() / (nextNote.strumTime - ((minimumTime + 0.25) * 1000)));
        }
    }
}