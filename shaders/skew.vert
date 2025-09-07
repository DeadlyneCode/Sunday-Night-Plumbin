#pragma header
attribute float vertexXOffset;
attribute float vertexYOffset;

void main(void)
{
    openfl_Alphav = openfl_Alpha;
	openfl_TextureCoordv = openfl_TextureCoord;
    
    openfl_Alphav = openfl_Alpha * alpha;
    
    if (hasColorTransform)
    {
        openfl_ColorOffsetv = colorOffset / 255.0;
        openfl_ColorMultiplierv = colorMultiplier;
    }
	vec4 pos = openfl_Position;
 	pos.x += vertexXOffset;
 	pos.y += vertexYOffset;
	gl_Position = openfl_Matrix * pos;
}