import funkin.backend.system.Flags;

var skin = "";

switch (FlxG.save.data.curPowerUp) {
    case 0:
        skin = "note"; 
    case 1:
        skin = "fire_notes"; 
    case 2:
        skin = "ice_notes";
    case 3:
        skin = "metal_note";
    case 4:
        skin = "poison_note";  
    default:
        skin = "note";
}
function create() {
    
}

function onNoteCreation(event) {
    if (event.strumLineID == 1){        
        event.noteSprite = (PlayState.instance.curStage == "cataclysmic")?'game/notes/cataclysmic/mx_'+ skin : 'game/notes/'+ skin;
    }
    if (event.strumLineID == 0){        
        event.noteSprite = (PlayState.instance.curStage == "cataclysmic")?'game/notes/cataclysmic/mx_note' : 'game/notes/note';
    }
}

function onStrumCreation(event) {
    //event.sprite = event.player == 0 ? 'game/notes/note' : 'game/notes/'+ skin;
    if (event.player == 0) {
        event.sprite = 'game/notes/note';
    } else {
        event.sprite = (PlayState.instance.curStage == "cataclysmic")?'game/notes/cataclysmic/mx_'+ skin : 'game/notes/'+ skin;
    }
    
}
function onPostStrumCreation(event) {
    var strumScale = event.strum.strumLine.strumScale;    
    event.strum.setGraphicSize(Std.int((150 * Flags.DEFAULT_NOTE_SCALE) * strumScale));
    event.strum.updateHitbox();
}