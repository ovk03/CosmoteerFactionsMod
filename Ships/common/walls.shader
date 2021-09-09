#include "../../base.shader"

struct VERT_OUTPUT_WALLS
{
	float4 location : SV_POSITION;
	float4 color : COLOR0;
	float2 uv : TEXCOORD0;
	float2 uv2 : TEXCOORD1;
};

VERT_OUTPUT_WALLS vert(in VERT_INPUT_ATLAS input)
{
	VERT_OUTPUT_WALLS output;
	output.location = mul(input.location, _transform);
	output.color = input.color * _color;
	output.uv = getAnimatedUVs(input.animInfo);
	output.uv2.x = (output.location.x + 1) / 2;
	output.uv2.y = (output.location.y - 1) / -2;
	return output;
}

Texture2D _stencilTarget;
SamplerState _stencilTarget_SS;
float4 _roofBaseColor = 255;
PIX_OUTPUT pix(in VERT_OUTPUT_WALLS input) : SV_TARGET
{
	float4 pixel = _texture.Sample(_texture_SS, input.uv);
	pixel = swapAllegianceColor(pixel, _roofBaseColor);
	pixel.a *= 1 - _stencilTarget.Sample(_stencilTarget_SS, input.uv2).a;
	pixel *= input.color;
	if(pixel.a <= 0)
		discard;
	return pixel;
}