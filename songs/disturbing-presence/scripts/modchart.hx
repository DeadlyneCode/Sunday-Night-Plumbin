import modchart.Manager;
import modchart.Config;

function postCreate()
{
	Config.HOLDS_BEHIND_STRUM = true;
	Config.CAMERA3D_ENABLED = false;
    var funk = new Manager();
    add(funk);

	funk.addModifier("CenterRotate", -1);
    funk.addModifier("Rotate", -1);
    funk.addModifier("Beat", -1);
    funk.addModifier("Bumpy", -1);
    funk.addModifier("Vibrate", -1);
    funk.addModifier("Boost", -1);
    funk.addModifier("scale", -1);
    funk.addModifier("drunk", -1);
    funk.addModifier("tipsy", -1);
    funk.addModifier("transform", -1);
    funk.addModifier("opponentSwap", -1);
    funk.addModifier("Stealth", -1);
    funk.addModifier("Invert", -1);
    funk.addModifier("Reverse", -1);
    funk.addModifier("Confusion", -1);
    funk.addModifier("Tornado", -1);
    funk.addModifier("ReceptorScroll", -1);

    funk.setPercent("opponentSwap", -1, 1);
	funk.ease("opponentSwap", 42, 4, 0, FlxEase.quadOut, 1);
	
	funk.ease("opponentSwap", 154, 4, 0.5, FlxEase.quadOut, 1);

	funk.set("scrollAngleX", 192, -60 * (Options.downscroll ? -1 : 1), 1);
    funk.set("suddenStart", 192, 10, 1);
    funk.set("suddenEnd", 192, 7, 1);
    funk.set("sudden", 192, 1, 1);
	funk.set("drunk", 192, 0.1, 1);
	funk.set("tipsy", 192, 0.3, 1);

	funk.set("scrollAngleX", 256, 0, 1);
    funk.set("sudden", 256, 0, 1);
	funk.set("drunk", 256, 0, 1);
	funk.set("tipsy", 256, 0, 1);

	funk.ease("drunk", 320, 32, 0.7, FlxEase.quadOut, 1);
	funk.ease("tipsy", 320, 32, 0.7, FlxEase.quadOut, 1);

	funk.set("drunk", 472, 0, 1);
	funk.set("tipsy", 472, 0, 1);
	funk.set("beat", 472, 1, 1);

	var screams = [[494, 2, 1], [500, 4, 0.3], [512, 2, 0.5], [518, 2, 1]];
	for (i in 0...screams.length)
	{
		var scream = screams[i];
		funk.set("bumpy", scream[0], -25 * scream[2], 1);
		funk.ease("bumpy", scream[0], scream[1], 0, FlxEase.quadOut, 1);
	}

	
	funk.ease("bumpy", 535, 4, -35, FlxEase.quadOut, 1);
	funk.ease("drunk", 535, 4, 1.3, FlxEase.quadOut, 1);
    funk.ease("sudden", 535, 2, 1, 1);
    funk.set("sudden", 192, 1, 1);

	funk.set("bumpy", 570, 15, 1);
	funk.ease("bumpy", 576, 4, 0, FlxEase.quadOut, 1);
	funk.ease("drunk", 576, 4, 0.7, FlxEase.quadOut, 1);

	funk.set("bump", 592, 0, 1);	
	funk.set("beat", 600, 0, 1);
}