#include "../../base.shader"

struct VERT_OUTPUT2
{
	float4 location : SV_POSITION;
	float4 color : COLOR0;
	float2 uv : TEXCOORD0;
	float2 uv2 : TEXCOORD1;
};

VERT_OUTPUT2 vert(in VERT_INPUT_ATLAS input)
{
	float4 loc = input.center + (input.location - input.center) * 1.25;

	VERT_OUTPUT2 output;
	output.location = mul(loc, _transform);
	output.color = input.color * _color;
	output.uv = input.animInfo.uv;
	output.uv2.x = (output.location.x + 1) / 2;
	output.uv2.y = (-output.location.y + 1) / 2;
	return output;
}

Texture2D _ftlBackground;
SamplerState _ftlBackground_SS;

Texture2D _warpTexture;
SamplerState _warpTexture_SS;

PIX_OUTPUT pix(in VERT_OUTPUT2 input) : SV_TARGET
{
	float a = _texture.Sample(_texture_SS, input.uv).a;
	if(a <= 0)
		discard;

	float2 offset = (_warpTexture.Sample(_warpTexture_SS, input.uv2).rg * 2 - 1) * .02;
	offset *= a * input.color.a;

	return _ftlBackground.Sample(_ftlBackground_SS, input.uv2 + offset);
}