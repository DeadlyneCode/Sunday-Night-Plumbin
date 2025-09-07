function onSongEnd(e)
{
    if (FlxG.save.data.distoLocked)
    {
        FlxG.save.data.distoLocked = false;
        FlxG.save.data.shouldShowFinalCutscene = true;
        FlxG.save.flush();
    }
}