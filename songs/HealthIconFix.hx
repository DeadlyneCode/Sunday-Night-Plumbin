function postCreate() {
    var char = iconP1.curCharacter;
    var path = Paths.image('icons/' + char);
	if (!Assets.exists(path)) path = Paths.image('icons/face');

	iconP1.loadGraphic(path, true, 150, 150);

    iconP1.animation.add(char, [for(i in 0...iconP1.frames.frames.length) i], 0, false, iconP1.isPlayer);
	iconP1.animation.play(char);
    iconP1.updateHitbox();
}