function onNoteHit(e) {
    if (e.note.isSustainNote) {
        e.animCancelled = true;
        for(char in e.characters) {
            if (char != null) {
                var forceAnim = e.forceAnim;
                var charMeta = char.extra["meta"];
                if (Reflect.hasField(charMeta, "staticHoldNotes") && Reflect.field(charMeta, "staticHoldNotes") == "false") {
                    if (char.animation.curAnim.curFrame < 2)
                        forceAnim = false;
                }
                char.playSingAnim(e.direction, e.animSuffix, "SING", forceAnim);
            }
        }
    }
}

function getXmlCharacterMeta(char) {
	var meta = {};
	var charXML = Character.getXMLFromCharName(char);
	var metaNode = null;
	for (node in charXML.elementsNamed("meta")) {
		metaNode = node;
		break;
	}
    if (metaNode != null) {
        for (node in metaNode.elements()) {
            Reflect.setField(meta, node.get("field"), node.get("value"));
        }
    }

	return meta;
}

function postCreate() {
    for (strumline in strumLines.members)
    {
        for (character in strumline.characters)
        {
            character.extra["meta"] = getXmlCharacterMeta(character);
        }
    }
}