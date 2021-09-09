#include "../../base.shader"

float4 _colorFluctuateLow = 255;
float4 _colorFluctuateHigh = 255;
float _fluctuateInterval;
float _camScale;
float _maxScale;
float4x4 _invShipRotMatrix;
Texture2D _background;
SamplerState _background_SS;

VERT_OUTPUT_ATLAS vert(in VERT_INPUT_ATLAS input)
{
	float4 offsetFromCenter = mul(input.location - input.center, _invShipRotMatrix);
	float4 scaledLoc = input.center + offsetFromCenter * min(_camScale, _maxScale);

	VERT_OUTPUT_ATLAS output;
	output.location = mul(scaledLoc, _transform);
	output.color = input.color * _color;
	output.uv = getAnimatedUVs(input.animInfo);
	output.spriteUV = input.spriteUV;
	return output;
}

PIX_OUTPUT pix(in VERT_OUTPUT_ATLAS input) : SV_TARGET
{
	float4 bg = _background.Sample(_background_SS, input.spriteUV);
	float4 fg = _texture.Sample(_texture_SS, input.uv) * lerp(_colorFluctuateLow, _colorFluctuateHigh, wave(_time, _fluctuateInterval));

	float4 combinedColor = bg * (1 - fg.a) + fg * fg.a;
	combinedColor.r = min(combinedColor.r, 1);
	combinedColor.g = min(combinedColor.g, 1);
	combinedColor.b = min(combinedColor.b, 1);
	combinedColor.a = min(fg.a * (1 - bg.a) + bg.a, 1);

	combinedColor *= input.color;
	if(combinedColor.a <= 0)
		discard;
	return combinedColor;
}