function create(){
    dad.alpha = 0;
}

function stepHit(curStep:Int){
    switch (curStep){
        case 60:
            FlxTween.tween(dad, {alpha:1}, 1);
        case 992:
            FlxTween.tween(dad, {alpha:0}, 1);
    }
}