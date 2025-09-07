import funkin.game.Character;

var charList:Array<Array<String>> = [];

function postCreate() {
    var allEvents:Array<Dynamic> = PlayState.SONG.events;
    for (event in allEvents){
        if(event.name == "Change Character") {
            var charName = event.params[2];
            if (!charList.contains(charName))
            {
                var tempChar = new Character(0, 0, charName, false, true);
                add(tempChar);

                var sprGraph = Paths.image('characters/' + (tempChar.xml.get("sprite") ?? charName));
                if (tempChar.animateAtlas != null && tempChar.atlasPath != null)
                    sprGraph = tempChar.atlasPath;

                var graphic = FlxG.bitmap.add(sprGraph);
                remove(tempChar);
                graphic.useCount++;
                graphic.destroyOnNoUse = false;
                graphicCache.cachedGraphics.push(graphic);
                graphicCache.nonRenderedCachedGraphics.push(graphic);
                //tempChar.drawComplex(FlxG.camera);
                charList.push(charName);
            }
        }
    }
}

function onEvent(daEvent) {
    if (daEvent.event.name == "Change Character") {
        var strumlineInt:Int = daEvent.event.params[0];
        var charIndex:Int = daEvent.event.params[1];
        var charName = daEvent.event.params[2];

        var strumline = strumLines.members[strumlineInt];
        var charFromStrumline = strumline.characters[charIndex];

        remove(charFromStrumline, true);

        var strumLineData = PlayState.SONG.strumLines[strumlineInt];
        var charPosName:String = strumLineData.position == null ? (switch(strumLineData.type) {
            case 0: "dad";
            case 1: "boyfriend";
            case 2: "girlfriend";
        }) : strumLineData.position;

        var oldIndex = members.indexOf(charFromStrumline);

        strumline.characters[charIndex] = new Character(charFromStrumline.x, charFromStrumline.y, charName, stage.isCharFlipped(charPosName, strumLineData.type == 1));
        stage.applyCharStuff(strumline.characters[charIndex], charPosName, charIndex);

        insert(oldIndex, strumline.characters[charIndex]);
        updateHealthBarColors();
    }
}
    
function updateHealthBarColors() {
    iconP1.setIcon(boyfriend != null ? boyfriend.getIcon() : "face");
    iconP2.setIcon(dad != null ? dad.getIcon() : "face");

    var leftColor:Int = dad != null && dad.iconColor != null && Options.colorHealthBar ? dad.iconColor : (PlayState.opponentMode ? 0xFF66FF33 : 0xFFFF0000);
    var rightColor:Int = boyfriend != null && boyfriend.iconColor != null && Options.colorHealthBar ? boyfriend.iconColor : (PlayState.opponentMode ? 0xFFFF0000 : 0xFF66FF33); // switch the colors
    healthBar.createFilledBar(leftColor, rightColor);
    set_maxHealth(maxHealth); //updates the fucking bar
}