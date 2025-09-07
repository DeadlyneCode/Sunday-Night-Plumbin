import flixel.text.FlxTextBorderStyle;

function postCreate() {	
	missesTxt.visible = accuracyTxt.visible = false;
	scoreTxt.alignment = "center";
	scoreTxt.y = healthBarBG.y + 50;
	for (str=>strum in strumLines.members)
	{
		for (i in 0...4)
			strum.members[i].x -= 35;

		strum.onNoteUpdate.add(function (e) {
			if (e.note.isSustainNote)
			{
				e.note.clipRect = null;
				if (!StringTools.endsWith(e.note.animation.curAnim.name, "end") && e.note.__strum != null)
					e.note.scale.set(e.note.scale.x, Conductor.stepCrochet / 100 * 1.5 * e.note.__strum.getScrollSpeed(e.note));
			}
		});
	}

	var kadeshit:FlxText = new FlxText(20, 5, 0, PlayState.SONG.meta.displayName +  " - Hard " +  "| KE 1.2",12);
	kadeshit.setFormat(Paths.font("vcr.ttf"), 16,  FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
	kadeshit.x = 5;
	kadeshit.cameras = [camHUD];
	
	add(kadeshit);
}

function postUpdate(elapsed:Float) {
	if (camZooming)
	{
		FlxG.camera.zoom = lerp(FlxG.camera.zoom, defaultCamZoom, camGameZoomLerp, true);
		camHUD.zoom = lerp(camHUD.zoom, defaultHudZoom, camHUDZoomLerp, true);
	}
	doIconBop = false;
	iconP1.y = healthBar.y - (iconP1.height / 2);
	iconP2.y = healthBar.y - (iconP2.height / 2);
	iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
	iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

	iconP1.updateHitbox();
	iconP2.updateHitbox();
	var iconOffset:Int = 26;
	iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
	iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

	scoreTxt.text = "Score:" + songScore + " | Combo Breaks:" + misses + " | Accuracy:" + (accuracy == -1 ? "?" : CoolUtil.quantize(accuracy * 100, 100) + "%") + " | " + curRating.rating;
}

function beatHit(curBeat:Int) {
	iconP1.setGraphicSize(Std.int(iconP1.width + 30));
	iconP2.setGraphicSize(Std.int(iconP2.width + 30));
		
	iconP1.updateHitbox();
	iconP2.updateHitbox();
}

function onDadHit(e)
{
	if (e.note.isSustainNote)
		e.deleteNote = true;
	e.preventStrumGlow();
}

function onPlayerHit(e)
{
	e.showSplash = false;
}