import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxGradient;

var pages:Array<FlxGroup> = [];
var pressCount:Int = 0;
var music:FlxSound;

var text;

function create() {
    loadMusic(pressCount);
    createPage1();
    createPage2();
    createPage3();
    createPage4();
    createPage5();
    createPage6();

    add(FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height / 1.5, [0xFF000000, 0x00000000])).scrollFactor.set(0, 0);

    text = new FlxText(150, 50, 1200, getString("cutscene_text1"), 25);
    text.setFormat(Paths.font("U.ttf"), 28, 0xFFFBEB6F, null, FlxTextBorderStyle.SHADOW, FlxColor.BLACK, true);
    text.antialiasing = true;
    add(text);
}

function update(elapsed:Float) {
    if (controls.ACCEPT && canPress) {
        pressCount++;
        change();
    }
}

var speed = 0.5;
var canPress = true;

function loadMusic(index:Int) {
    music = FlxG.sound.load(Paths.music("cutscene/" + index), 1, true);
    music.looped = true;
    music.play();
}

function createPage(group:FlxGroup, elements:Array<FlxSprite>) {
    for (element in elements) {
        group.add(element);
    }
    group.visible = false;
    add(group);
    pages.push(group);
}

function createPage1() {
    var page = new FlxGroup();
    var elements = [
        new FlxSprite(-300, -180).loadGraphic(Paths.image("states/cutscene/pg1/page1-ciel")),
        new FlxBackdrop(Paths.image("states/cutscene/pg1/page1-cloud"), 0, 0, true, false, 0, 0),
        new FlxSprite(90, -180).loadGraphic(Paths.image("states/cutscene/pg1/page1-castle")),
        new FlxSprite(-120, 300).loadGraphic(Paths.image("states/cutscene/pg1/page1-toad"))
    ];
    elements[1].velocity.set(-25, 0);
    for (el in elements) {
        el.scrollFactor.set(0, 0);
        el.scale.set(0.7, 0.7);
        el.antialiasing = true;
    }
    createPage(page, elements);
    page.visible = true;
    FlxTween.tween(elements[2], {x: 140}, 25, {ease: FlxEase.sineInOut});
    FlxTween.tween(elements[3], {x: -160}, 25, {ease: FlxEase.sineInOut});
}

function createPage2() {
    var page = new FlxGroup();
    var ciel = new FlxSprite(-300, -180).loadGraphic(Paths.image("states/cutscene/pg2/page2-ciel"));
    var castle = new FlxSprite(480, 0).loadGraphic(Paths.image("states/cutscene/pg2/page2-castle"));
    for (el in [ciel, castle]) {
        el.scrollFactor.set(0, 0);
        el.scale.set(0.7, 0.7);
        el.antialiasing = true;
    }
    createPage(page, [ciel, castle]);
}

function createPage3() {
    var page = new FlxGroup();
    var ciel = new FlxSprite(-300, -180).loadGraphic(Paths.image("states/cutscene/pg3/page3-ciel"));
    var particule = new FlxSprite(-300, -200).loadGraphic(Paths.image("states/cutscene/pg3/page3-particule"));
    var toad = new FlxSprite(-50, 100).loadGraphic(Paths.image("states/cutscene/pg3/page3-toad"));
    var luigi = new FlxSprite(660, 250).loadGraphic(Paths.image("states/cutscene/pg3/page3-luigi"));
    var mario = new FlxSprite(300, 150).loadGraphic(Paths.image("states/cutscene/pg3/page3-mario"));
    for (el in [ciel, particule, toad, luigi, mario]) {
        el.scrollFactor.set(0, 0);
        el.scale.set(0.7, 0.7);
        el.antialiasing = true;
    }
    createPage(page, [ciel, particule, toad, luigi, mario]);
}

function createPage4() {
    var page = new FlxGroup();
    var ciel = new FlxSprite(-300, -180).loadGraphic(Paths.image("states/cutscene/pg4/page4-ciel"));
    var castle = new FlxSprite(130, -180).loadGraphic(Paths.image("states/cutscene/pg4/page4-perso"));
    for (el in [ciel, castle]) {
        el.scrollFactor.set(0, 0);
        el.scale.set(0.7, 0.7);
        el.antialiasing = true;
    }
    createPage(page, [ciel, castle]);
}

function createPage5() {
    var page = new FlxGroup();
    var ciel = new FlxSprite(0, -10).loadGraphic(Paths.image("states/cutscene/pg5/page5-ciel"));
    var perso = new FlxSprite(0, 70).loadGraphic(Paths.image("states/cutscene/pg5/page5-perso"));
    for (el in [perso]) {
        el.scrollFactor.set(0, 0);
        el.scale.set(0.68, 0.68);
        el.updateHitbox();
        el.antialiasing = true;
    }
    ciel.x = FlxG.width - ciel.width;
    createPage(page, [ciel, perso]);
}

function createPage6() {
    var page = new FlxGroup();
    var ciel = new FlxSprite(-300, -180).loadGraphic(Paths.image("states/cutscene/pg6/page6-ciel"));
    var bf = new FlxSprite(300, 110).loadGraphic(Paths.image("states/cutscene/pg6/page6-bf"));
    var gf = new FlxSprite(-180, -110).loadGraphic(Paths.image("states/cutscene/pg6/page6-gf"));
    for (el in [ciel, bf, gf]) {
        el.scrollFactor.set(0, 0);
        el.scale.set(0.7, 0.7);
        el.antialiasing = true;
    }
    createPage(page, [ciel, bf, gf]);
}

var canPress = true;
function change() {
    var speed = pressCount == 3 ? 3.5 : 0.5;
    var prevMusic = music;
    music.fadeOut(speed, 0);
    canPress = false;

    var doFadeIn = function () {
        if (pressCount < pages.length) {
            music = FlxG.sound.load(Paths.music("cutscene/" + pressCount), true);
            music.volume = 0;
            music.looped = true;
            music.play(false, prevMusic.time);
            FlxTween.tween(music, { volume: 1 }, speed);
        }
    }
    if (pressCount != 3)
        doFadeIn();

    new FlxTimer().start(speed, (_) -> prevMusic.stop());

    FlxG.camera.fade(FlxColor.BLACK, speed, false, () -> {
        if (pressCount == 3)
            doFadeIn();
        for (page in pages) page.visible = false;

        text.text = getString("cutscene_text" + (pressCount + 1));

        switch (pressCount) {
            case 1:
                pages[1].visible = true;
                var castle2 = pages[1].members[1]; // Assumes castle is second in array
                FlxTween.tween(castle2, { x: 520 }, 25, { ease: FlxEase.sineInOut });

            case 2:
                pages[2].visible = true;
                var mario = pages[2].members[4];
                var luigi = pages[2].members[3];
                var toad = pages[2].members[2];
                FlxTween.tween(mario, { y: 0 }, 40, { ease: FlxEase.sineInOut });
                FlxTween.tween(mario, { angle: 30 }, 50, { ease: FlxEase.backInOut });
                FlxTween.tween(luigi, { y: 190 }, 30, { ease: FlxEase.sineInOut });
                FlxTween.tween(luigi, { angle: 20 }, 50, { ease: FlxEase.backInOut });
                FlxTween.tween(toad, { y: 0 }, 40, { ease: FlxEase.sineInOut });
                FlxTween.tween(toad, { angle: 30 }, 40, { ease: FlxEase.backInOut });

            case 3:
                pages[3].visible = true;

            case 4:
                pages[4].visible = true;
                var castle4 = pages[4].members[0];
                var perso5 = pages[4].members[1];
                FlxTween.tween(castle4, { x: 0 }, 30, { ease: FlxEase.sineInOut });
                FlxTween.tween(perso5, { y: 10 }, 20, { ease: FlxEase.sineInOut });

            case 5:
                speed = 0.5;
                pages[5].visible = true;
                var gf = pages[5].members[2];
                var bf = pages[5].members[1];
                FlxTween.tween(gf, { x: -100 }, 20, { ease: FlxEase.sineInOut });
                FlxTween.tween(bf, { x: 340 }, 20, { ease: FlxEase.sineInOut });

            case 6:
                FlxG.switchState(new TitleState());
                FlxG.save.data.showCutscene = false;
        }

        FlxG.camera.fade(FlxColor.BLACK, speed, true);
        new FlxTimer().start(speed + 0.1, (_) -> canPress = true);
    });
}
