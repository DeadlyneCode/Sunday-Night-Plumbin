import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;


var emitter:FlxTypedEmitter<FlxParticle>;
var emitter2:FlxTypedEmitter<FlxParticle>;

function postCreate()
{

    if (FlxG.save.data.particles == true){
   ///////////////////////////////////////////////////////////////////////
    emitter = new FlxTypedEmitter<FlxParticle>(-900, 2200);
    emitter.width = FlxG.width + 2500; 
    emitter.loadParticles(Paths.image("stages/betrayed/lava_sparkle"), 120, 16, false, false);
    emitter.solid = true; 
    emitter.lifespan.set(3, 5); 
    emitter.alpha.set(1, 1, 0, 0);
    emitter.blend = 0; 
    emitter.angularVelocity.set(-180, 180);
    emitter.scale.set(0.7, 0.7);

    emitter.color.set(FlxColor.RED, FlxColor.ORANGE, FlxColor.YELLOW, FlxColor.TRANSPARENT);

    insert(members.indexOf(stage.stageSprites["pont"]), emitter);
    emitter.start(false, 0.25);


    emitter.acceleration.set(-5, -50, 5, -150, -10, -250, 100, -350);


    //////////////////////////////////////////////////////////////////////////////////////////

    emitterdevant = new FlxTypedEmitter<FlxParticle>(-900, 2500);
    emitterdevant.width = FlxG.width + 2500; 
    emitterdevant.loadParticles(Paths.image("stages/betrayed/lava_sparkle"), 100, 16, false, false);
    emitterdevant.solid = true; 
    emitterdevant.lifespan.set(5, 6); 
    emitterdevant.alpha.set(1, 1, 0, 0);
    emitterdevant.blend = 0; 

    emitterdevant.angularVelocity.set(-180, 180);
    emitterdevant.color.set(FlxColor.RED, FlxColor.ORANGE, FlxColor.YELLOW, FlxColor.TRANSPARENT);

    emitterdevant.scale.set(0.7, 0.7);


    insert(members.indexOf(boyfriend)+1, emitterdevant);
    emitterdevant.start(false, 0.25);

    // Accélération
    emitterdevant.acceleration.set(-5, -50, 5, -150, -10, -250, 100, -350);





    //////////////////////////////////////////////////////////////////////////////////////////

    emitter2 = new FlxTypedEmitter<FlxParticle>(-900, 2500);
    emitter2.width = FlxG.width + 2500;
    emitter2.loadParticles(Paths.image("stages/betrayed/lava_sparkle"), 20, 16, false, false);
    emitter2.solid = true;
    emitter2.lifespan.set(9, 9);
    emitter2.alpha.set(1, 1, 0, 0);
    emitter2.blend = 0;
    emitter2.color.set(FlxColor.RED, FlxColor.ORANGE, FlxColor.YELLOW, FlxColor.TRANSPARENT);
    //emitterdevant.scale.set(0.8, 0.8);

    insert(members.indexOf(stage.stageSprites["black"]), emitter2);

    emitter2.start(false, 0.25);
    emitter2.acceleration.set(-5, -50, 5, -150, -10, -250, 100, -350);
 }
}

function update(elapsed:Float) {
    if (FlxG.save.data.particles == true){
    emitter.forEach(function(part:FlxParticle) {

        part.offset.x = Math.sin(part.age * part.acceleration.y / 30) * part.width / 5;

        part.angle += 70; 
    });
    }
}

