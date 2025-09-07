function stepHit(curstep:Int){
	switch(curStep) {
		case 112:
			FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.smootherStepInOut});
		case 2465:
			stage.stageSprites["black"].alpha = 1;
		case 2468:
			stage.stageSprites["black"].alpha = 0;
		case 2532:
			FlxTween.tween(stage.stageSprites["black"], {alpha: 1}, 4, {ease: FlxEase.linear});
	}
}