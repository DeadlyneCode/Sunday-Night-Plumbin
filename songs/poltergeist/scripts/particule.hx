import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.util.FlxColor;

var emitter:FlxTypedEmitter<FlxParticle>;

function postCreate()
{
    if (FlxG.save.data.particles == true){
    emitter = new FlxTypedEmitter<FlxParticle>(0, 500);
    emitter.width = FlxG.width + 100;
    emitter.height = FlxG.height + 200;
    emitter.loadParticles(Paths.image("stages/manor/particules"), 200, 16, false, false);
    emitter.solid = false;
    
    emitter.lifespan.set(40, 70);

    emitter.alpha.set(0.0, 0.5, 0.3, 0);
    emitter.blend = 0; 
    emitter.angularVelocity.set(-5, 5);
    emitter.scale.set(0.15, 0.15, 0.30, 0.30, 0.20, 0.20, 0.18, 0.18);
    //emitter.scale.set(0.15, 0.25);


    emitter.color.set(
        FlxColor.GRAY,
        FlxColor.fromRGB(220, 220, 220),
        FlxColor.fromRGB(160, 160, 160),
        FlxColor.TRANSPARENT
    );

    insert(members.indexOf(dad), emitter);
    emitter.start(false, 0.2);

    // Descente très lente
    emitter.acceleration.set(-0.3, 0.15, 0.3, 0.35, -0.2, 0.2, 0.2, 0.4); 

    }
}

function update(elapsed:Float) {
    if (FlxG.save.data.particles == true){
    emitter.forEach(function(part:FlxParticle) {
        var turbulence = Math.sin(part.age * 0.6) * 2 
                       + Math.cos(part.age * 0.25) * 1.5; 
        part.offset.x = turbulence * (part.width / 10); 
    });
    }
}
