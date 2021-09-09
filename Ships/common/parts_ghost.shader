#define USE_UNANIMATED_VERT_ATLAS
#include "../../base.shader"

PIX_OUTPUT pix(in VERT_OUTPUT_ATLAS input) : SV_TARGET
{
	float4 c = _color;
	c.a *= _texture.Sample(_texture_SS, input.uv).a;
	if(c.a <= 0)
		discard;
	return c;
}