function postCreate() {
	for(b in [bg, coloredBG]) {
		remove(b);
	}
	settingCam.bgColor =  FlxColor.fromRGBFloat(0, 0, 0, 0.95);
	addMenuShaders([settingCam]);
}