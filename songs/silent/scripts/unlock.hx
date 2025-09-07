function onSongEnd(e)
{
    if (!FlxG.save.data.alreadyUnlockedDisto)
    {
        FlxG.save.data.alreadyUnlockedDisto = true;
        FlxG.save.data.distoLocked = true;
        FlxG.save.flush();
    }
}