import flixel.addons.display.FlxBackdrop;
import funkin.savedata.FunkinSave;
var sc = 0;
var opp=["EXIT", "RETRY"];
var txt=[];
var curSelected = 0;
var mfTimer = 0;

var rating:String = "F";
var score:Int = PlayState.instance.songScore;
var misses:Int = PlayState.instance.misses;

//the fact that there isnt any translation system here is because old games didnt have languages back then
function create() {
	rating = PlayState.instance.curRating.rating;
	if (score < 0 || rating == "[N/A]")
		rating = "F";

    rankMusic = new FlxSound();
    rankJingle = new FlxSound();
    soundEffect = new FlxSound();
    FlxG.sound.list.add(soundEffect);
    FlxG.sound.list.add(rankMusic);
    FlxG.sound.list.add(rankJingle);

    var pos = [300, 250];
    camShit = new FlxCamera();
	camShit.bgColor = 0xFF13182e;
    FlxG.cameras.add(camShit, false);
    //S == 300, 250
    //M & G == 300, 220
    //F == 300, 256
    var anim;
    switch(rating){
        case "S++"|"S"|"A":
            anim=  "rankS";
        case "B"|"C":
            anim= "rankG";
        case "D"|"E":
            anim= "rankM";
        case "F":
            anim= "rankF";
    }
    switch(rating){
        case "B"|"C"|"D"|"E":
            pos = [300, 220];
        case "F":
            pos = [300, 256];
        default:
            pos = [300, 250];
    }
    bf = new FlxSprite(pos[0], pos[1]);
    bf.frames = Paths.getSparrowAtlas("states/score/pixel/"+anim);
    bf.animation.addByPrefix("rank", anim, 24, false);
    add(bf);
    bf.alpha = 0;
    bf.scale.set(8, 8);

    d = new CustomShader('ntscc');
    camShit.addShader(d);
    for (i in 0...2){
        var panorama = new FlxBackdrop(Paths.image("states/score/pixel/back"), FlxAxes.X);
        panorama.velocity.x = 25;
        panorama.y = 25;
        panorama.cameras = [camShit];
        panorama.scale.set(4, 4);
        insert(0,panorama);
        panorama.ID = i;
        switch(panorama.ID){
            case 1:
                panorama.velocity.x = -25;
                panorama.y = 685;
        }

    }


    FlxTween.num(sc, score, 1, {ease:FlxEase.sineInOut, onComplete: ()->{
        FlxG.sound.play(Paths.sound("score2"));

        FlxTween.num(miss, misses, 1, {ease:FlxEase.sineInOut, onComplete: ()->{

            soundEffect.loadEmbedded(Paths.sound('score2'));
            soundEffect.play();
            
            new FlxTimer().start(0.5, ()->{

                bf.alpha = 1;
                rankResult.text = rating;
                bf.animation.play("rank");
                switch(rating){
                    case "S++"|"S"|"A":
                        rankMusic.loadEmbedded(Paths.sound('jp score perfect'), true);
                        rankMusic.play(true);
                    case "B"|"C":
                        rankMusic.loadEmbedded(Paths.sound('jp score good'), true);
                        rankMusic.play(true);
                    case "D"|"E":
                        rankMusic.loadEmbedded(Paths.sound('jp score neutral'), true);
                        rankMusic.play(true);
                    case "F":
                        rankJingle.loadEmbedded(Paths.sound('jp score bad intro'), false);
                        rankJingle.play(true);
                        rankJingle.onComplete = function() {
                            rankMusic.loadEmbedded(Paths.sound('jp score bad'), true);
                            rankMusic.play(true);
                        }
                }
    
            });
        }}, (value)->{
            msNum.text = Math.fround(value);
        });

    }}, (value)->{
        scNum.text = Math.fround(value);
        new FlxTimer(2.8).start(0.1, ()->{
            FlxG.sound.play(Paths.sound("scoret"));
        });
        }
    );

    highScore = new FlxText(500,75, -1, "HIGH SCORE", 40);
    add(highScore);
    highScore.color = FlxColor.RED;


    rank = new FlxText(500,290, -1, "RANK", 40);
    add(rank);

    sc = new FlxText(rank.x+220,rank.y, -1, "SCORE", 40);
    add(sc);

    miss = new FlxText(sc.x+ 220,rank.y, -1, "MISSES", 40);
    add(miss);

    ///////////////num move//////////////
    var highScoreStats = FunkinSave.getSongHighscore(state.curSong, "normal").score;

    highScoreNum = new FlxText(highScore.x+60,highScore.y+50, -1, (score>highScoreStats) ? score : highScoreStats, 40);
    add(highScoreNum);
    
    scNum = new FlxText(sc.x,sc.y+100, -1, "0", 40);
    add(scNum);

    rankResult = new FlxText(rank.x+50,scNum.y, -1, "?", 40);
    add(rankResult);


    msNum = new FlxText(miss.x,scNum.y, -1, "0", 40);
    add(msNum);
    for (i in[scNum, rankResult, msNum])
        i.setFormat(null, 40, 0xFFE61F1A);
    //msNum.color = scNum.color= rankResult.color = 0xFFE61F1A;


    for (i in 0...2){
        bar = new FlxSprite(1000 *i).makeSolid(160, FlxG.width, FlxColor.BLACK);
        add(bar);
        bar.ID = i;
        bar.cameras = [camShit];
        switch(bar.ID){
            case 1:
                bar.setPosition(1120,0);
        }
       }

    miss.setFormat(null, 40, 0xFF62E1DA,"center");
    sc.setFormat(null, 40, 0xFF62E1DA,"center");

	txtGroup = new FlxGroup();
    add(txtGroup);
    for (i in 0...opp.length){
        option = new FlxText(250*i+650,600, -1, opp[i], 40);
        txtGroup.add(option);
        option.color = 0xFFF2E356;
        option.ID = i;
    }

    for (i in[bf, sc, miss, msNum, scNum, rank, rankResult, highScore, highScoreNum, txtGroup])
        i.camera  = camShit;

    changeSelec(0);
}

function postUpdate(elapsed:Float) {
    mfTimer = elapsed;
    if(controls.BACK)
        FlxG.switchState(new MainMenuState());
	if (FlxG.keys.justPressed.B) {
        bf.animation.play("rank");
    }

    if (controls.ACCEPT){
        CoolUtil.playMenuSFX(1);
        new FlxTimer().start(1.1, ()-> { 
            switch (opp[curSelected]) {
                case 'EXIT':
                    PlayState.instance.endSong();
                
                case 'RETRY':
                    FlxG.resetState();
            }
        });
    }


    if(controls.LEFT_P)
        changeSelec(-1);
    if(controls.RIGHT_P)
        changeSelec(1);

}


function changeSelec(change){

    curSelected = FlxMath.wrap(curSelected +change, 0, opp.length-1);

    txtGroup.forEach((txt:FlxText)->{
        txt.alpha = (txt.ID == curSelected)? 1:0.3;
    });

}