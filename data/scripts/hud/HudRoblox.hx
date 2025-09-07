import funkin.backend.system.framerate.Framerate;

var coolScore:FlxText = null;
var coolMisses:FlxText = null;
var hamburger:FlxSprite = null;
var robloxCam:FlxCamera;

function postCreate() {
    FlxG.cameras.add(robloxCam = new FlxCamera(), false);
    robloxCam.bgColor =  FlxColor.fromRGBFloat(0, 0, 0, 0);
    for (obj in [iconP1, iconP2, scoreTxt, missesTxt, accuracyTxt, healthBarBG])
        remove(obj);

    var topbar = new FlxSprite(0, 0).makeGraphic(FlxG.width, 60, 0xAB171717);
    topbar.camera = robloxCam;
    add(topbar);

    hamburger = new FlxSprite(8, 10).loadGraphic(Paths.image("hud/Menu"));
    hamburger.camera = robloxCam;
    hamburger.setGraphicSize(45);
    add(hamburger);

    var chat = new FlxSprite(78, 5).loadGraphic(Paths.image("hud/Chat"));
    chat.camera = robloxCam;
    chat.setGraphicSize(45);
    add(chat);
    
    var score = new FlxText(FlxG.width / 1.3, 1, 100, getString("robloxhud_text_score"), 24);
    score.font = Paths.font("SourceSans3-Bold.ttf");
    score.alignment = "center";
    score.camera = robloxCam;
    add(score);
    
    coolScore = new FlxText(score.x, 22, 100, "0", 24);
    coolScore.font = Paths.font("SourceSans3-Regular.ttf");
    coolScore.alignment = "center";
    coolScore.camera = robloxCam;
    add(coolScore);

    var misses = new FlxText(FlxG.width / 1.125, 1, 100, getString("robloxhud_text_misses"), 24);
    misses.font = Paths.font("SourceSans3-Bold.ttf");
    misses.alignment = "center";
    misses.camera = robloxCam;
    add(misses);
    
    coolMisses = new FlxText(misses.x, 22, 100, "0", 24);
    coolMisses.font = Paths.font("SourceSans3-Regular.ttf");
    coolMisses.alignment = "center";
    coolMisses.camera = robloxCam;
    add(coolMisses);

    var userName = new FlxText(FlxG.width / 1.9, 1, 250, "xxxbfxxx", 24);
    userName.font = Paths.font("SourceSans3-Bold.ttf");
    userName.camera = robloxCam;
    add(userName);

    healthBar.x = userName.x;
    healthBar.y = 38;
    healthBar.flipX = true;
    healthBar.barWidth = userName.width;
    healthBar.camera = robloxCam;
    health = 2;
    healthBar.createFilledBar(0x6FFFFFFF, 0xFF66FF33 );

    Framerate.offset.y = 63;
}

function update() {
    coolScore.text = songScore;
    coolMisses.text = misses;
}

function destroy() {
    Framerate.offset.y = 0;
}