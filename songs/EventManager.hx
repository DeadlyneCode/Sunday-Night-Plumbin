public function fadeSprite(sprite, alpha, duration) {
    FlxTween.tween(sprite, {alpha: alpha}, duration, {ease: FlxEase.linear});
}

public function tweenSprite(sprite, properties, duration) {
    FlxTween.tween(sprite, properties, duration, {ease: FlxEase.linear});
}

public function moveAndFadeSprite(sprite, newY, moveDuration, newAlpha, fadeDuration) {
    FlxTween.tween(sprite, {y: newY}, moveDuration, {ease: FlxEase.linear});
    FlxTween.tween(sprite, {alpha: newAlpha}, fadeDuration, {ease: FlxEase.linear});
}

public function moveSprites(sprites:Array<String>, properties:Dynamic, duration:Float) {
    for (sprite in sprites) {
        FlxTween.tween(stage.stageSprites[sprite], properties, duration, {ease: FlxEase.linear});
    }
}

public function killSprites(sprites) {
    for (s in sprites) {
        stage.stageSprites[s].kill();
    }
}

public function setAlphaSprites(sprites, alpha) {
    for (s in sprites) {
        stage.stageSprites[s].alpha = alpha;
    }
}

public function setVisibilitySprite(sprites, visible) {
    for (s in sprites) {
        s.visible = visible;
    }
}

public function setVisibilitySprites(sprites, visible) {
    for (s in sprites) {
        stage.stageSprites[s].visible = visible;
    }
}

public function tweenAlphaSprites(sprites, alpha, duration) {
    for (s in sprites) {
        FlxTween.tween(stage.stageSprites[s], {alpha: alpha}, duration, {ease: FlxEase.linear});
    }
}

public function tweenCameraZoom(camera, zoom, duration, ease) {
    FlxTween.tween(camera, {zoom: zoom}, duration, {ease: ease});
}

public function tweenSprites(sprites: Array<Dynamic>, properties: Dynamic, duration: Float, ease, type = FlxTween.ONESHOOT) {
    for (sprite in sprites) {
        FlxTween.tween(sprite, properties, duration, {type: type, ease: ease});
    }
}
