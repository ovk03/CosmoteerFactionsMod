#include "../../base.shader"

struct VERT_OUTPUT_ROOF
{
	float4 location : SV_POSITION;
	float4 localLoc : POSITION1;
	float4 color : COLOR0;
	float2 uv : TEXCOORD0;
	float2 uv2 : TEXCOORD1;
};

float4 _shipBounds;

VERT_OUTPUT_ROOF vert(in VERT_INPUT_ATLAS input)
{
	VERT_OUTPUT_ROOF output;
	output.localLoc = input.location;
	input.location.xy = rotate(input.location.xy - input.center.xy, (_gameTime - input.animInfo.animationStartTime) * input.rotSpeed) + input.center.xy;
	output.location = mul(input.location, _transform);
	output.color = input.color * _color;
	float alphaLow = 1 - inverseLerp(_shipBounds.x + _shipBounds.y, _shipBounds.z + _shipBounds.w, input.location.x + input.location.y);
	float alphaHigh = alphaLow + .5;
	output.color.a = inverseLerp(alphaLow, alphaHigh, output.color.a * 1.5);
	output.uv = getAnimatedUVs(input.animInfo);
	output.uv2.x = (output.location.x + 1) / 2;
	output.uv2.y = (output.location.y - 1) / -2;
	return output;
}

float4 _roofBaseColor = 255;
Texture2D _roofBaseTexture;
SamplerState _roofBaseTexture_SS;
float2 _roofBaseTextureScale;

Texture2D _roofDecalsTarget;
SamplerState _roofDecalsTarget_SS;

float4 _roofDecalColor1 = 255;
float4 _roofDecalColor2 = 255;

PIX_OUTPUT pix(in VERT_OUTPUT_ROOF input) : SV_TARGET
{
	float4 c = _texture.Sample(_texture_SS, input.uv) * input.color;

	float3 decal = _roofDecalsTarget.Sample(_roofDecalsTarget_SS, input.uv2).rgb;
	c.rgb *= decal.r * _roofBaseColor.rgb + decal.g * _roofDecalColor1.rgb + decal.b * _roofDecalColor2.rgb;

	float3 baseTex = (1 - (1 - _roofBaseTexture.Sample(_roofBaseTexture_SS, input.localLoc.xy / _roofBaseTextureScale)) * _roofBaseColor.a).rgb;
	c.rgb *= baseTex;

	if(c.a <= 0)
		discard;

	return c;
}
