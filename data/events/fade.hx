function onEvent(e) {
    if (e.event.name == "fade") {
        var color = e.event.params[0];
        var time = e.event.params[1];
        var reversed = e.event.params[2];
        var cam = e.event.params[3];

        var cams = [];
        switch (cam) {
            case "camGame":
                cams = [camGame];
            case "camHUD":
                cams = [camHUD];
            case "camGame/camHUD":
                cams = [camGame, camHUD];
        }

        for (cam in cams)
            camGame.fade(color, time, !reversed, null, false);
    }
}
