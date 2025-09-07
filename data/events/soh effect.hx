import funkin.game.Character;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import openfl.geom.ColorTransform;

var fond:FlxSprite;
function postCreate(){
    for (event in PlayState.SONG.events){

        if(event.name == "soh effect"){
            var bgcol = event.params[3];
            fond = new FlxSprite();
            fond.makeGraphic(FlxG.width+2000, FlxG.height+2000, FlxColor.bgcol);
            fond.screenCenter();
            fond.scrollFactor.set();
            if (gf != null)
                insert(members.indexOf(gf), fond);
            else
                insert(members.indexOf(dad), fond);
            fond.alpha = 0;
            } 
        }
}
function onEvent(eventEvent) {
    if (eventEvent.event.name == "soh effect") {
        var enable = eventEvent.event.params[0];
        var bgcol = eventEvent.event.params[1];
        var bfcol = eventEvent.event.params[2];
        var dadcol = eventEvent.event.params[3];
        var gfcol = eventEvent.event.params[4];

        var colors = switch(bgcol){
            case 'Black': color = FlxColor.BLACK;
            case 'Blue': color = FlxColor.BLUE;
            case 'Cyan': color = FlxColor.CYAN;
            case 'Gray': color = FlxColor.GRAY;
            case 'Lime': color = FlxColor.LIME;
            case 'Magenta': color = FlxColor.MAGENTA;
            case 'Orange': color = FlxColor.ORANGE;
            case 'Pink': color = FlxColor.PINK;
            case 'Purple': color = FlxColor.PURPLE;
            case 'Red': color = FlxColor.RED;
            case 'White': color = FlxColor.WHITE;
            case 'Yellow': color = FlxColor.YELLOW;
        };

        if (enable){
            FlxG.camera.flash(FlxColor.WHITE, 1);
            fond.alpha = 1;
            fond.color = colors;
            boyfriend.colorTransform.color = bfcol;
            dad.colorTransform.color = dadcol;
            if (gf != null)
                gf.colorTransform.color = gfcol;
        }
        else if (!enable){
            FlxG.camera.flash(FlxColor.WHITE, 1);
            fond.alpha = 0;
            fond.color = colors;
            dad.colorTransform = new ColorTransform();
            boyfriend.colorTransform = new ColorTransform();
            if (gf != null)
                gf.colorTransform = new ColorTransform();
        }
    }
}