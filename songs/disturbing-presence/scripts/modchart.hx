import modchart.Manager;
import modchart.Config;

function postCreate()
{
	Config.HOLDS_BEHIND_STRUM = true;
	Config.CAMERA3D_ENABLED = false;
    var funk = new Manager();
    add(funk);

	//funk.addModifier("CenterRotate", 0);
    //funk.addModifier("Rotate", 0);
    funk.addModifier("Beat", 0);
    funk.addModifier("Bumpy", 0);
    //funk.addModifier("Vibrate", 0);
    //funk.addModifier("Boost", 0);
    //funk.addModifier("scale", 0);
    funk.addModifier("drunk", 0);
    funk.addModifier("tipsy", 0);
    //funk.addModifier("transform", 0);
    funk.addModifier("opponentSwap", 0);
    funk.addModifier("Stealth", 0);
    funk.addModifier("Invert", 0);
    //funk.addModifier("Reverse", 0);
    funk.addModifier("Confusion", 0);
    //funk.addModifier("Tornado", 0);
    //funk.addModifier("ReceptorScroll", 0);

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