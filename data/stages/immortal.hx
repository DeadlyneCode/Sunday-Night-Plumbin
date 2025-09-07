import flixel.addons.display.FlxBackdrop;

var cloud:FlxBackdrop;
var heat = new CustomShader('heatShader');
var circlee:FunkinSprite;
var time:Float = 0;

function postCreate() {
	camHUD.alpha = 0;

	circlee = new FunkinSprite(800, 1200, Paths.image("stages/immortal/circlee"));
	XMLUtil.addAnimToSprite(circlee, {
		name: "loop",
		anim: "circle",
		fps: 24,
		loop: true,
		animType: "loop", // if you use "loop" then it automatically plays the last added animation
		x: 40, // offsetX
		y: -320, // offsetY
		indices: [],
		forced: true, // If everytime the animation plays, it should be forced to play
	});
	circlee.scale.set(3, 3);
	circlee.playAnim("loop", false);

	cloud = new FlxBackdrop(Paths.image('stages/immortal/cloud'), 0, 0, true, false, 0, 0);
	cloud.velocity.set(-25, 0);
	cloud.scrollFactor.set(0.75, 0.75);
	cloud.visible = true;
	cloud.scale.set(2, 2);
	cloud.y = -100;
	insert(members.indexOf(stage.stageSprites["montagne"]) + 1, cloud);

	var hud = importScript("data/scripts/hud/HudV2");
	hud.set("HudStyle", "hudc");
	strumLines.members[3].characters[0].x = strumLines.members[3].characters[0].x - 100;
	strumLines.members[3].characters[0].y = strumLines.members[3].characters[0].y - 100;
	t = new CustomShader('red');

	if (FlxG.save.data.tv == true) {
		d = new CustomShader('ntscc');

		camGame.addShader(d);
		camHUD.addShader(d);
	}
}

function stepHit(curStep:Int) {
	switch (curStep) {
		case 1023:
			cloud.kill();
			camGame.addShader(heat);
		case 2144:
			insert(members.indexOf(gf), circlee);
			camGame.addShader(null);
		case 2145:
			camGame.addShader(d);
		case 2432:
			boyfriend.shader = t;
		case 2686:
			circlee.kill();
			boyfriend.shader = null;
	}
}

function postUpdate(elapsed) {
	if (FlxG.save.data.heatwave == true)
		time += elapsed;
	heat.iTime = time;
}
