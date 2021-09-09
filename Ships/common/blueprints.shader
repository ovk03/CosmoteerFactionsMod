#include "../../base.shader"

float4 _colorFluctuateLow = 255;
float4 _colorFluctuateHigh = 255;
float _fluctuateInterval;
float4 _redTransform;
float4 _greenTransform;
float4 _blueTransform;
float4 _alphaTransform;

VERT_OUTPUT vert(in VERT_INPUT_ATLAS input)
{
	VERT_OUTPUT output;
	output.location = mul(input.location, _transform);
	output.color = input.color * _color * lerp(_colorFluctuateLow, _colorFluctuateHigh, wave(_time, _fluctuateInterval));
	output.uv = getAnimatedUVs(input.animInfo);
	return output;
}

PIX_OUTPUT pix(in VERT_OUTPUT input) : SV_TARGET
{
	float4 texColor = _texture.Sample(_texture_SS, input.uv);
	float4 transformedColor = texColor.r * _redTransform + texColor.g * _greenTransform + texColor.b * _blueTransform + texColor.a * _alphaTransform;
	transformedColor *= input.color;
	if(transformedColor.a <= 0)
		discard;
	return transformedColor;
}