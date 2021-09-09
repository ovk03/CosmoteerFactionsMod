#define USE_DEFAULT_PIX_ATLAS
#include "../../base.shader"

float4 _shipBounds;

VERT_OUTPUT_ATLAS vert(in VERT_INPUT_ATLAS input)
{
	VERT_OUTPUT_ATLAS output;
	input.location.xy = rotate(input.location.xy - input.center.xy, (_gameTime - input.animInfo.animationStartTime) * input.rotSpeed) + input.center.xy;
	output.location = mul(input.location, _transform);
	output.color = input.color * _color;
	float alphaLow = 1 - inverseLerp(_shipBounds.x + _shipBounds.y, _shipBounds.z + _shipBounds.w, input.location.x + input.location.y);
	float alphaHigh = alphaLow + .5;
	output.color.a = inverseLerp(alphaLow, alphaHigh, output.color.a * 1.5);
	output.uv = getAnimatedUVs(input.animInfo);
	output.spriteUV = input.spriteUV;
	return output;
}
