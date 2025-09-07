var lifeBG:FunkinSprite;
var lifeBar:FunkinSprite;

function create() {
    lifeBG = new FunkinSprite();
    lifeBar = new FunkinSprite();

    for(l=>life in [lifeBG, lifeBar]) {
        var hudAnim:Array<String> = ["bg", 'life'][l];

        life.loadSprite(Paths.image("hud/b3313"));
        life.addAnim(hudAnim, hudAnim, 0, false);
        life.playAnim(hudAnim);
        life.updateHitbox();
        life.antialiasing = true;
        life.scrollFactor.set();
        life.camera = camHUD;
        add(life);
    }

    lifeBG.x = (camHUD.width - lifeBG.width) / 2;
    lifeBG.y = -lifeBG.height;
}

var timer:Float = 3;
var timeLeft:Float = 0;
var canFade:Bool;

function postUpdate(elapsed:Float) {
    updateHUD();

    if (canFade) {
        if (timeLeft > 0) {
            timeLeft -= elapsed;
            fadeHUD(false);
        }
        else
            fadeHUD(true);
    }
}

var healthStates:Array<Array<Dynamic>> = [
    [0.0, 0xFF000000],
    [0.2, 0xFFFF0000],
    [0.8, 0xFFE01F8A],
    [1.4, 0xFFC525CF],
    [2, 0xFF1423A0],
];

function updateHUD() {
    //trace(lifeBar);
    iconP2.x = lifeBG.x + (lifeBG.width - iconP2.width) / 2;
    lifeBar.x = lifeBG.x + (lifeBG.width - lifeBar.width) / 2;

    if (downscroll) {
        lifeBar.y = lifeBG.y + 30;
        iconP2.y = lifeBG.y + lifeBG.height - (iconP2.height + 20);
    }
    else {
        lifeBar.y = lifeBG.y + lifeBG.height - (lifeBar.height + 30);
        iconP2.y = lifeBG.y + 20;
    }

    for(e=>healthState in healthStates) {
        if (health >= healthState[0]) {
            lifeBar.animation.curAnim.curFrame = e;
            lifeBar.color = healthState[1];
        }
    }

    canFade = (health > healthStates[1][0]);
}

function fadeHUD(isOut:Bool) {
    lifeBG.y = CoolUtil.fpsLerp(lifeBG.y, isOut ? -lifeBG.height : 0, 5 / 60);
}

function onPlayerMiss(event)
    timeLeft = timer;

function postCreate() {
    health = 2;
    doIconBop = false;

    for (hud in [healthBar, healthBarBG, scoreTxt, missesTxt, accuracyTxt, iconP1])
        remove(hud);
}

function centerStrumline() {
    for (i=>item in player.members) {
        item.x = lifeBG.x + (lifeBG.width - item.width) / 2;

        if (i <= 1)
            item.x -= (item.width * (1-(i % 2)) + lifeBG.width-95);
        else
            item.x += (item.width * (i % 2) + lifeBG.width-95);
    }
}