function onEvent(e) {
    var event = e.event;
    if (event.name == "Cam Zoom") {
        var ease = event.params[0];
        var in = event.params[1];
        var time = event.params[2];
        var zoom2 = event.params[3];
        FlxTween.cancelTweensOf(FlxG.camera);
        FlxTween.tween(FlxG.camera, {zoom: zoom2}, time, {ease: CoolUtil.flxeaseFromString(ease, in), onComplete: (_) -> {
            defaultCamZoom = zoom2;
        }});
    }
}