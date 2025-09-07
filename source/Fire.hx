class Fire extends flixel.FlxSprite
{
	
	var yToFade = 0;
	var yToStartFading = 0;

	public function new(x:Float, y:Float, daColor:FlxColor, daScale:Float)
	{
		super(x, y);
		trace("yolo");

		loadGraphic(Paths.image('stages/betrayed/lava_sparkle'));
		antialiasing = true;
		scale.set(daScale,daScale);
		blend = 0;
		alpha = 0.7;

		scrollFactor.set(FlxG.random.float(0.8, 1.1), FlxG.random.float(0.8, 1.1));
		velocity.set(FlxG.random.float(-233, 233), FlxG.random.float(-600, 0));
		acceleration.set(FlxG.random.float(-5,5),FlxG.random.float(0, -10));

		yToFade = FlxG.random.float(1100, 1400);
		yToStartFading = FlxG.random.float(1500, 1600);
	}

	override function update(elapsed) {
		super.update(elapsed);
		if(x < -800 || x > 1700)
			kill();
		if(y < yToStartFading){
			alpha = 0.7*(1-((yToStartFading - y)/(yToStartFading - yToFade)));
			if (y < yToFade){
				kill();
			}
		}
	}
}