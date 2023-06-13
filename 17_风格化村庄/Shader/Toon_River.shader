// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon_River"
{
	Properties
	{
		_WaveASpeedXYSteepnesswavelength("WaveA(SpeedXY,Steepness,wavelength)", Vector) = (1,1,2,50)
		_WaveB("WaveB", Vector) = (1,1,2,50)
		_WaveC("WaveC", Vector) = (1,1,2,50)
		_NormalScale("NormalScale", Float) = 0
		_NormalSpeed("NormalSpeed", Vector) = (0,0,0,0)
		_NormalMap("NormalMap", 2D) = "bump" {}
		_DeepColor("DeepColor", Color) = (0,0,0,0)
		_ShallowColor("ShallowColor", Color) = (0,0,0,0)
		_DeepRange("DeepRange", Float) = 1
		_SufFresnelPower("SufFresnelPower", Float) = 0
		_SurFresnelColor("SurFresnelColor", Color) = (0,0,0,0)
		_ReflectionDistort("ReflectionDistort", Range( 0 , 1)) = 0
		_ReflectionIntensity("ReflectionIntensity", Float) = 1
		_ReflectionPower("ReflectionPower", Float) = 5
		_UnderWaterDistort("UnderWaterDistort", Float) = 1
		_CausticIntensity("CausticIntensity", Float) = 0
		_CausticScale("CausticScale", Float) = 1
		_CausticSpeed("CausticSpeed", Vector) = (0,0,0,0)
		_CausticTex("CausticTex", 2D) = "white" {}
		_CausticRange("CausticRange", Float) = 0
		_FoamColor("FoamColor", Color) = (1,1,1,1)
		_FoamNormalMap("FoamNormalMap", 2D) = "white" {}
		_FoamFastSpeed("FoamFastSpeed", Float) = 1
		_FoamSlowSpeed("FoamSlowSpeed", Float) = 1
		_FoamRange("FoamRange", Float) = 0
		_FoamContrast("FoamContrast", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
			float4 screenPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv2_texcoord2;
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _WaveASpeedXYSteepnesswavelength;
		uniform float4 _WaveB;
		uniform float4 _WaveC;
		uniform float4 _DeepColor;
		uniform float4 _ShallowColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DeepRange;
		uniform float4 _SurFresnelColor;
		uniform float _SufFresnelPower;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _NormalScale;
		uniform float2 _NormalSpeed;
		uniform float _ReflectionDistort;
		uniform float _ReflectionIntensity;
		uniform float _ReflectionPower;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _UnderWaterDistort;
		uniform sampler2D _CausticTex;
		uniform float _CausticScale;
		uniform float2 _CausticSpeed;
		uniform float _CausticIntensity;
		uniform float _CausticRange;
		uniform float _FoamContrast;
		uniform sampler2D _FoamNormalMap;
		SamplerState sampler_FoamNormalMap;
		uniform float _FoamFastSpeed;
		uniform float4 _FoamNormalMap_ST;
		uniform float _FoamSlowSpeed;
		uniform float _FoamRange;
		uniform float4 _FoamColor;


		float3 GerstnerWave188( float3 position, inout float3 tangent, inout float3 binormal, float4 wave )
		{
			float steepness = wave.z * 0.01;
			float wavelength = wave.w;
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, position.xz) - c * _Time.y);
			float a = steepness / k;
						
			tangent += float3(
			-d.x * d.x * (steepness * sin(f)),
			d.x * (steepness * cos(f)),
			-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
			-d.x * d.y * (steepness * sin(f)),
			d.y * (steepness * cos(f)),
			-d.y * d.y * (steepness * sin(f))
			);
			return float3(
			d.x * (a * cos(f)),
			a * sin(f),
			d.y * (a * cos(f))
			);
		}


		float3 GerstnerWave196( float3 position, inout float3 tangent, inout float3 binormal, float4 wave )
		{
			float steepness = wave.z * 0.01;
			float wavelength = wave.w;
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, position.xz) - c * _Time.y);
			float a = steepness / k;
						
			tangent += float3(
			-d.x * d.x * (steepness * sin(f)),
			d.x * (steepness * cos(f)),
			-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
			-d.x * d.y * (steepness * sin(f)),
			d.y * (steepness * cos(f)),
			-d.y * d.y * (steepness * sin(f))
			);
			return float3(
			d.x * (a * cos(f)),
			a * sin(f),
			d.y * (a * cos(f))
			);
		}


		float3 GerstnerWave203( float3 position, inout float3 tangent, inout float3 binormal, float4 wave )
		{
			float steepness = wave.z * 0.01;
			float wavelength = wave.w;
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8 / k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, position.xz) - c * _Time.y);
			float a = steepness / k;
						
			tangent += float3(
			-d.x * d.x * (steepness * sin(f)),
			d.x * (steepness * cos(f)),
			-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
			-d.x * d.y * (steepness * sin(f)),
			d.y * (steepness * cos(f)),
			-d.y * d.y * (steepness * sin(f))
			);
			return float3(
			d.x * (a * cos(f)),
			a * sin(f),
			d.y * (a * cos(f))
			);
		}


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		float3 InvertDepthDir72_g1( float3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 position188 = ase_worldPos;
			float3 tangent188 = float3( 1,0,0 );
			float3 binormal188 = float3( 0,0,1 );
			float4 wave188 = _WaveASpeedXYSteepnesswavelength;
			float3 localGerstnerWave188 = GerstnerWave188( position188 , tangent188 , binormal188 , wave188 );
			float3 position196 = ase_worldPos;
			float3 tangent196 = tangent188;
			float3 binormal196 = binormal188;
			float4 wave196 = _WaveB;
			float3 localGerstnerWave196 = GerstnerWave196( position196 , tangent196 , binormal196 , wave196 );
			float3 position203 = ase_worldPos;
			float3 tangent203 = tangent196;
			float3 binormal203 = binormal196;
			float4 wave203 = _WaveC;
			float3 localGerstnerWave203 = GerstnerWave203( position203 , tangent203 , binormal203 , wave203 );
			float3 temp_output_191_0 = ( ase_worldPos + localGerstnerWave188 + localGerstnerWave196 + localGerstnerWave203 );
			float3 worldToObj192 = mul( unity_WorldToObject, float4( temp_output_191_0, 1 ) ).xyz;
			float3 WaveVertexPos194 = worldToObj192;
			v.vertex.xyz = WaveVertexPos194;
			v.vertex.w = 1;
			float3 normalizeResult198 = normalize( cross( binormal203 , tangent203 ) );
			float3 worldToObjDir199 = mul( unity_WorldToObject, float4( normalizeResult198, 0 ) ).xyz;
			float3 WaveVertexNormal200 = worldToObjDir199;
			v.normal = WaveVertexNormal200;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldPos = i.worldPos;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 UV22_g3 = ase_screenPosNorm.xy;
			float2 localUnStereo22_g3 = UnStereo( UV22_g3 );
			float2 break64_g1 = localUnStereo22_g3;
			float clampDepth69_g1 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g1 = ( 1.0 - clampDepth69_g1 );
			#else
				float staticSwitch38_g1 = clampDepth69_g1;
			#endif
			float3 appendResult39_g1 = (float3(break64_g1.x , break64_g1.y , staticSwitch38_g1));
			float4 appendResult42_g1 = (float4((appendResult39_g1*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g1 = mul( unity_CameraInvProjection, appendResult42_g1 );
			float3 In72_g1 = ( (temp_output_43_0_g1).xyz / (temp_output_43_0_g1).w );
			float3 localInvertDepthDir72_g1 = InvertDepthDir72_g1( In72_g1 );
			float4 appendResult49_g1 = (float4(localInvertDepthDir72_g1 , 1.0));
			float3 PositionFromDepth219 = (mul( unity_CameraToWorld, appendResult49_g1 )).xyz;
			float WaterDepth222 = ( ase_worldPos.y - (PositionFromDepth219).y );
			float clampResult237 = clamp( ( WaterDepth222 / _DeepRange ) , 0.0 , 1.0 );
			float4 lerpResult232 = lerp( _DeepColor , _ShallowColor , pow( ( 1.0 - clampResult237 ) , 2.132 ));
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV241 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode241 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV241, _SufFresnelPower ) );
			float4 lerpResult243 = lerp( lerpResult232 , _SurFresnelColor , fresnelNode241);
			float4 WaterColor234 = lerpResult243;
			float2 uv2_NormalMap = i.uv2_texcoord2 * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float2 temp_output_253_0 = ( uv2_NormalMap / _NormalScale );
			float2 temp_output_257_0 = ( _NormalSpeed * _Time.y * 0.1 );
			float3 SurfaceNormal261 = BlendNormals( UnpackNormal( tex2D( _NormalMap, ( temp_output_253_0 + temp_output_257_0 ) ) ) , UnpackNormal( tex2D( _NormalMap, ( ( temp_output_253_0 * 1.2 ) + ( temp_output_257_0 * 1.7 ) ) ) ) );
			float3 lerpResult416 = lerp( float3(0,1,0) , SurfaceNormal261 , _ReflectionDistort);
			float3 indirectNormal407 = lerpResult416;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float fresnelNdotV301 = dot( ase_normWorldNormal, ase_worldViewDir );
			float fresnelNode301 = ( 0.0 + _ReflectionIntensity * pow( max( 1.0 - fresnelNdotV301 , 0.0001 ), _ReflectionPower ) );
			float clampResult305 = clamp( fresnelNode301 , 0.0 , 1.0 );
			Unity_GlossyEnvironmentData g407 = UnityGlossyEnvironmentSetup( 0.95, data.worldViewDir, indirectNormal407, float3(0,0,0));
			float3 indirectSpecular407 = UnityGI_IndirectSpecular( data, clampResult305, indirectNormal407, g407 );
			float3 ReflectionColor282 = indirectSpecular407;
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor295 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( ( SurfaceNormal261 * _UnderWaterDistort * 0.01 ) , 0.0 ) ).xy/( ase_grabScreenPosNorm + float4( ( SurfaceNormal261 * _UnderWaterDistort * 0.01 ) , 0.0 ) ).w);
			float2 temp_output_308_0 = ( (PositionFromDepth219).xz / _CausticScale );
			float2 temp_output_311_0 = ( _Time.y * _CausticSpeed * 0.01 );
			float clampResult332 = clamp( exp( ( -WaterDepth222 / _CausticRange ) ) , 0.0 , 1.0 );
			float4 CausticColor322 = ( ( min( tex2D( _CausticTex, ( temp_output_308_0 + temp_output_311_0 ) ) , tex2D( _CausticTex, ( -temp_output_308_0 + temp_output_311_0 ) ) ) * _CausticIntensity ) * clampResult332 );
			float4 UnderWaterColor296 = ( screenColor295 + CausticColor322 );
			float WaterOpacity249 = ( 1.0 - (lerpResult243).a );
			float4 lerpResult299 = lerp( ( WaterColor234 + float4( ReflectionColor282 , 0.0 ) ) , UnderWaterColor296 , WaterOpacity249);
			float temp_output_10_0_g5 = _FoamContrast;
			float2 uv_FoamNormalMap = i.uv_texcoord * _FoamNormalMap_ST.xy + _FoamNormalMap_ST.zw;
			float2 panner424 = ( ( _FoamFastSpeed * _Time.y ) * float2( 1,0 ) + uv_FoamNormalMap);
			float2 panner429 = ( ( _Time.y * _FoamSlowSpeed ) * float2( 1,0 ) + uv_FoamNormalMap);
			float lerpResult432 = lerp( tex2D( _FoamNormalMap, panner424 ).r , tex2D( _FoamNormalMap, panner429 ).r , i.vertexColor.r);
			float clampResult439 = clamp( exp( ( -WaterDepth222 / _FoamRange ) ) , 0.0 , 1.0 );
			float clampResult445 = clamp( ( clampResult439 * i.vertexColor.g ) , 0.0 , 1.0 );
			float clampResult8_g5 = clamp( ( ( lerpResult432 - 1.0 ) + ( clampResult445 * 2.0 ) ) , 0.0 , 1.0 );
			float lerpResult13_g5 = lerp( ( 0.0 - temp_output_10_0_g5 ) , ( temp_output_10_0_g5 + 1.0 ) , clampResult8_g5);
			float clampResult14_g5 = clamp( lerpResult13_g5 , 0.0 , 1.0 );
			float4 FoamColor377 = ( clampResult14_g5 * _FoamColor );
			float4 lerpResult397 = lerp( lerpResult299 , ( lerpResult299 + float4( (FoamColor377).rgb , 0.0 ) ) , (FoamColor377).a);
			c.rgb = max( lerpResult397 , float4( 0,0,0,0 ) ).rgb;
			c.a = i.vertexColor.a;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv2_texcoord2;
				o.customPack1.xy = v.texcoord1;
				o.customPack1.zw = customInputData.uv_texcoord;
				o.customPack1.zw = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv2_texcoord2 = IN.customPack1.xy;
				surfIN.uv_texcoord = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
60.8;437.6;1536;727;-1770.724;-378.1296;2.35238;True;False
Node;AmplifyShaderEditor.CommentaryNode;229;655.5964,845.4196;Inherit;False;1395.008;326.1035;WaterDepth;7;217;220;215;222;221;219;218;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;215;705.5964,1061.123;Inherit;False;Reconstruct World Position From Depth;-1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;217;1062.804,1055.42;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;1246.804,1055.42;Inherit;False;PositionFromDepth;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;270;354.5183,2039.299;Inherit;False;1743.447;617.9792;SurfaceNormal;17;267;266;257;264;268;255;259;256;253;260;258;263;261;262;265;254;421;SurfaceNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;333;406.9668,4206.633;Inherit;False;1882.254;869.2212;CausticColor;24;306;309;307;313;312;308;310;326;311;321;330;328;314;319;329;315;316;325;320;331;332;324;327;322;CausticColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;218;1298.804,897.0545;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;220;1492.804,1055.42;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;258;574.8413,2330.829;Inherit;False;Property;_NormalSpeed;NormalSpeed;5;0;Create;True;0;0;False;0;False;0,0;-5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;306;456.9668,4256.633;Inherit;False;219;PositionFromDepth;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;259;551.8413,2536.829;Inherit;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;254;587.463,2226.299;Inherit;False;Property;_NormalScale;NormalScale;4;0;Create;True;0;0;False;0;False;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;421;536.2885,2075.194;Inherit;False;1;260;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;256;571.8413,2452.829;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;309;690.3599,4382.686;Inherit;False;Property;_CausticScale;CausticScale;17;0;Create;True;0;0;False;0;False;1;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;829.8413,2379.829;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;267;949.6732,2541.879;Inherit;False;Constant;_Float3;Float 3;13;0;Create;True;0;0;False;0;False;1.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;221;1631.804,951.4196;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;307;708.9668,4283.633;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;253;868.463,2123.299;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;265;948.6731,2348.879;Inherit;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;313;658.9002,4771.869;Inherit;False;Constant;_Float6;Float 6;18;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;308;931.3599,4317.686;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;1825.804,947.4196;Inherit;False;WaterDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;312;669.9002,4634.869;Inherit;False;Property;_CausticSpeed;CausticSpeed;18;0;Create;True;0;0;False;0;False;0,0;-8,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;310;661.9002,4543.869;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;240;351.4345,1237.905;Inherit;False;1891.406;685.2443;WaterColor;18;244;234;243;232;241;230;231;242;245;239;246;237;235;236;233;247;248;249;WaterColor;0,0.7505074,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;1125.673,2333.879;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;1109.673,2481.879;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;406;2695.376,1603.447;Inherit;False;2538.853;1101.281;FoamColor;26;394;393;377;422;423;424;425;426;427;428;429;430;431;432;433;434;435;436;437;438;439;441;442;443;444;445;FoamColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;866.9002,4591.869;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;401.4345,1667.105;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;445.8149,1786.668;Inherit;False;Property;_DeepRange;DeepRange;9;0;Create;True;0;0;False;0;False;1;1.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;321;1048.508,4489.832;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;1129.883,4874.221;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;1234.673,2421.879;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;434;2893.509,2240.304;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;255;1115.463,2203.299;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;260;1367.27,2171.369;Inherit;True;Property;_NormalMap;NormalMap;6;0;Create;True;0;0;False;0;False;-1;None;972ba3323c209b54dacffe0942af5729;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;235;634.9507,1675.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;319;1178.679,4566.387;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;262;1368.037,2424.036;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;260;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NegateNode;328;1339.456,4881.662;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;314;1141.9,4358.869;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;330;1298.296,4960.454;Inherit;False;Property;_CausticRange;CausticRange;20;0;Create;True;0;0;False;0;False;0;0.66;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;437;2977.509,2397.304;Inherit;False;Property;_FoamRange;FoamRange;25;0;Create;True;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;435;3112.509,2274.304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;425;2803.963,1984.433;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;316;1336.622,4557.504;Inherit;True;Property;_TextureSample1;Texture Sample 1;19;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;315;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;315;1333.766,4332.376;Inherit;True;Property;_CausticTex;CausticTex;19;0;Create;True;0;0;False;0;False;-1;None;72417ee6f632e4e4aabc8c81143957bf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;237;773.0151,1675.168;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;329;1470.296,4904.454;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;431;2836.03,2094.868;Inherit;False;Property;_FoamSlowSpeed;FoamSlowSpeed;24;0;Create;True;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;263;1676.045,2313.205;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;436;3259.509,2330.304;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;427;2817.964,1851.533;Inherit;False;Property;_FoamFastSpeed;FoamFastSpeed;23;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;430;3079.03,2051.868;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;1688.378,4602.78;Inherit;False;Property;_CausticIntensity;CausticIntensity;16;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;813.5508,1817.905;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;False;2.132;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;261;1871.565,2168.384;Inherit;False;SurfaceNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ExpOpNode;331;1594.296,4905.454;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;320;1688.679,4459.387;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;298;474.8837,3590.317;Inherit;False;1324.8;509.5317;UnderWaterColor;11;296;295;290;288;292;291;293;294;334;335;336;UnderWaterColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;239;922.0206,1676.558;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;426;3034.964,1897.533;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;283;419.4985,2844.335;Inherit;False;1866.815;657.1509;ReflectionColor;11;301;305;302;303;282;281;279;407;415;416;418;ReflectionColor;1,0.8254717,0.8254717,1;0;0
Node;AmplifyShaderEditor.ExpOpNode;438;3416.509,2356.304;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;422;2832.148,1669.554;Inherit;False;0;423;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;1884.378,4534.78;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;429;3240.148,1966.687;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;294;532.8837,3983.449;Inherit;False;Constant;_Float5;Float 5;15;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;291;526.8837,3828.449;Inherit;False;261;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;293;524.8837,3907.449;Inherit;False;Property;_UnderWaterDistort;UnderWaterDistort;15;0;Create;True;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;462.5365,3370.076;Inherit;False;Property;_ReflectionPower;ReflectionPower;14;0;Create;True;0;0;False;0;False;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;332;1718.296,4905.454;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;424;3235.156,1732.966;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;230;728.0345,1287.905;Inherit;False;Property;_DeepColor;DeepColor;7;0;Create;True;0;0;False;0;False;0,0,0,0;0.04004983,0.3396225,0.3120303,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;245;988.7026,1759.323;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;302;489.5366,3280.076;Inherit;False;Property;_ReflectionIntensity;ReflectionIntensity;13;0;Create;True;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;242;1137.997,1790.527;Inherit;False;Property;_SufFresnelPower;SufFresnelPower;10;0;Create;True;0;0;False;0;False;0;4.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;439;3578.509,2376.304;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;443;3665.511,2511.535;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;231;734.0345,1464.905;Inherit;False;Property;_ShallowColor;ShallowColor;8;0;Create;True;0;0;False;0;False;0,0,0,0;0.2784308,0.8588236,0.764706,0.2392157;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;244;1140.811,1532.188;Inherit;False;Property;_SurFresnelColor;SurFresnelColor;11;0;Create;True;0;0;False;0;False;0,0,0,0;0.003921569,0.1607839,0.2274506,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;241;1343.657,1666.663;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;193;-115.4068,6045.981;Inherit;False;2542.907;761.6924;Wave Vertex Animation ;21;203;196;189;200;194;192;199;191;198;197;188;202;190;204;207;206;208;209;210;211;212;Wave Vertex Animation ;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;786.8836,3872.449;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FresnelNode;301;712.093,3242.159;Inherit;True;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;2029.107,4755.341;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;418;640.8801,2852.987;Inherit;False;Constant;_Vector0;Vector 0;34;0;Create;True;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;428;3462.955,1948.64;Inherit;True;Property;_FoamNormalMap1;FoamNormalMap;22;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;423;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;288;545.7649,3640.317;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;415;472.8308,2989.89;Inherit;False;261;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;433;3808.165,2005.442;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;279;562.1703,3072.42;Inherit;False;Property;_ReflectionDistort;ReflectionDistort;12;0;Create;True;0;0;False;0;False;0;0.08235295;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;232;1143.034,1385.905;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;444;3874.901,2422.601;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;423;3455.156,1698.967;Inherit;True;Property;_FoamNormalMap;FoamNormalMap;22;0;Create;True;0;0;False;0;False;-1;None;31e68d75d2651c148b4a9a296306d21c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;290;932.8836,3679.449;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldPosInputsNode;189;5.016447,6127.708;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ClampOpNode;305;1029.774,3257.603;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;416;882.8801,2888.987;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;322;2064.421,4445.462;Inherit;False;CausticColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;190;-36.98307,6425.707;Inherit;False;Property;_WaveASpeedXYSteepnesswavelength;WaveA(SpeedXY,Steepness,wavelength);0;0;Create;True;0;0;False;0;False;1,1,2,50;0,-1,0,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;445;4100.051,2317.906;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;243;1549.627,1508.114;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;441;4288.021,2370.432;Inherit;False;Property;_FoamContrast;FoamContrast;26;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;432;3997.823,1792.521;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;788.4985,3161.158;Inherit;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;False;0;False;0.95;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectSpecularLight;407;1193.608,3103.97;Inherit;True;World;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScreenColorNode;295;1096.884,3676.449;Inherit;False;Global;_GrabScreen0;Grab Screen 0;15;0;Create;True;0;0;False;0;False;Object;-1;False;True;1;0;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;188;364.1906,6324.435;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.Vector4Node;202;376.2455,6498.129;Inherit;False;Property;_WaveB;WaveB;1;0;Create;True;0;0;False;0;False;1,1,2,50;-0.5,-0.5,0,30;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;247;1719.908,1629.874;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;394;4724.032,2110.535;Inherit;False;Property;_FoamColor;FoamColor;21;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;336;1129.228,3916.753;Inherit;False;322;CausticColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;442;4485.947,2252.442;Inherit;True;HeightLerp;-1;;5;ea906bbd821f2a54292204fd6b053587;0;3;2;FLOAT;0;False;5;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;204;795.053,6514.918;Inherit;False;Property;_WaveC;WaveC;2;0;Create;True;0;0;False;0;False;1,1,2,50;1,0.5,0,20;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;1818.214,1356.046;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;335;1373.228,3818.753;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;196;700.173,6324.522;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.OneMinusNode;248;1865.908,1634.874;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;282;1843.792,3051.322;Inherit;False;ReflectionColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;4816.89,1978.49;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;2268.576,912.9197;Inherit;False;282;ReflectionColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;249;2018.908,1632.874;Inherit;False;WaterOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;2294.266,752.506;Inherit;False;234;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;203;1040.505,6299.711;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;377;5009.43,1989.47;Inherit;False;FoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;1612.884,3689.449;Inherit;False;UnderWaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;378;2997.311,1168.723;Inherit;False;377;FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;300;2513.702,1140.109;Inherit;False;249;WaterOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;297;2425.864,1027.255;Inherit;False;296;UnderWaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;2556.659,895.877;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CrossProductOpNode;197;1375.715,6572.312;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;1295.392,6116.941;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;395;3170.066,1114.368;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;398;3193.066,1236.368;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;198;1574.715,6606.312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;299;2760.769,938.3815;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;396;3333.066,1088.368;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;399;3470.066,1104.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;199;1774.715,6584.312;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;192;1528.069,6117.234;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;397;3479.066,951.3679;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;2024.714,6601.312;Inherit;False;WaveVertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;1831.549,6127.313;Inherit;False;WaveVertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;206;1543.185,6328.448;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;3799.594,1090.127;Inherit;False;194;WaveVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;211;1810.247,6411.563;Inherit;False;Property;_WaveColor;WaveColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.3098039,0.5333334,0.7921569,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;201;3777.889,1173.313;Inherit;False;200;WaveVertexNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;207;1358.185,6380.447;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;361;3909.726,952.87;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;446;4085.498,846.8708;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;2212.537,6224.663;Inherit;False;WaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;334;1336.228,3674.753;Inherit;False;UnderWaterSceneColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;2097.476,6346.896;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;208;1715.185,6336.448;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;209;1893.477,6277.896;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4337.768,806.0941;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Toon_River;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;217;0;215;0
WireConnection;219;0;217;0
WireConnection;220;0;219;0
WireConnection;257;0;258;0
WireConnection;257;1;256;0
WireConnection;257;2;259;0
WireConnection;221;0;218;2
WireConnection;221;1;220;0
WireConnection;307;0;306;0
WireConnection;253;0;421;0
WireConnection;253;1;254;0
WireConnection;308;0;307;0
WireConnection;308;1;309;0
WireConnection;222;0;221;0
WireConnection;264;0;253;0
WireConnection;264;1;265;0
WireConnection;266;0;257;0
WireConnection;266;1;267;0
WireConnection;311;0;310;0
WireConnection;311;1;312;0
WireConnection;311;2;313;0
WireConnection;321;0;308;0
WireConnection;268;0;264;0
WireConnection;268;1;266;0
WireConnection;255;0;253;0
WireConnection;255;1;257;0
WireConnection;260;1;255;0
WireConnection;235;0;233;0
WireConnection;235;1;236;0
WireConnection;319;0;321;0
WireConnection;319;1;311;0
WireConnection;262;1;268;0
WireConnection;328;0;326;0
WireConnection;314;0;308;0
WireConnection;314;1;311;0
WireConnection;435;0;434;0
WireConnection;316;1;319;0
WireConnection;315;1;314;0
WireConnection;237;0;235;0
WireConnection;329;0;328;0
WireConnection;329;1;330;0
WireConnection;263;0;260;0
WireConnection;263;1;262;0
WireConnection;436;0;435;0
WireConnection;436;1;437;0
WireConnection;430;0;425;0
WireConnection;430;1;431;0
WireConnection;261;0;263;0
WireConnection;331;0;329;0
WireConnection;320;0;315;0
WireConnection;320;1;316;0
WireConnection;239;0;237;0
WireConnection;426;0;427;0
WireConnection;426;1;425;0
WireConnection;438;0;436;0
WireConnection;324;0;320;0
WireConnection;324;1;325;0
WireConnection;429;0;422;0
WireConnection;429;1;430;0
WireConnection;332;0;331;0
WireConnection;424;0;422;0
WireConnection;424;1;426;0
WireConnection;245;0;239;0
WireConnection;245;1;246;0
WireConnection;439;0;438;0
WireConnection;241;3;242;0
WireConnection;292;0;291;0
WireConnection;292;1;293;0
WireConnection;292;2;294;0
WireConnection;301;2;302;0
WireConnection;301;3;303;0
WireConnection;327;0;324;0
WireConnection;327;1;332;0
WireConnection;428;1;429;0
WireConnection;232;0;230;0
WireConnection;232;1;231;0
WireConnection;232;2;245;0
WireConnection;444;0;439;0
WireConnection;444;1;443;2
WireConnection;423;1;424;0
WireConnection;290;0;288;0
WireConnection;290;1;292;0
WireConnection;305;0;301;0
WireConnection;416;0;418;0
WireConnection;416;1;415;0
WireConnection;416;2;279;0
WireConnection;322;0;327;0
WireConnection;445;0;444;0
WireConnection;243;0;232;0
WireConnection;243;1;244;0
WireConnection;243;2;241;0
WireConnection;432;0;423;1
WireConnection;432;1;428;1
WireConnection;432;2;433;1
WireConnection;407;0;416;0
WireConnection;407;1;281;0
WireConnection;407;2;305;0
WireConnection;295;0;290;0
WireConnection;188;0;189;0
WireConnection;188;3;190;0
WireConnection;247;0;243;0
WireConnection;442;2;432;0
WireConnection;442;5;445;0
WireConnection;442;10;441;0
WireConnection;234;0;243;0
WireConnection;335;0;295;0
WireConnection;335;1;336;0
WireConnection;196;0;189;0
WireConnection;196;1;188;2
WireConnection;196;2;188;3
WireConnection;196;3;202;0
WireConnection;248;0;247;0
WireConnection;282;0;407;0
WireConnection;393;0;442;0
WireConnection;393;1;394;0
WireConnection;249;0;248;0
WireConnection;203;0;189;0
WireConnection;203;1;196;2
WireConnection;203;2;196;3
WireConnection;203;3;204;0
WireConnection;377;0;393;0
WireConnection;296;0;335;0
WireConnection;284;0;238;0
WireConnection;284;1;285;0
WireConnection;197;0;203;3
WireConnection;197;1;203;2
WireConnection;191;0;189;0
WireConnection;191;1;188;0
WireConnection;191;2;196;0
WireConnection;191;3;203;0
WireConnection;395;0;378;0
WireConnection;398;0;378;0
WireConnection;198;0;197;0
WireConnection;299;0;284;0
WireConnection;299;1;297;0
WireConnection;299;2;300;0
WireConnection;396;0;299;0
WireConnection;396;1;395;0
WireConnection;399;0;398;0
WireConnection;199;0;198;0
WireConnection;192;0;191;0
WireConnection;397;0;299;0
WireConnection;397;1;396;0
WireConnection;397;2;399;0
WireConnection;200;0;199;0
WireConnection;194;0;192;0
WireConnection;206;0;191;0
WireConnection;206;1;207;0
WireConnection;361;0;397;0
WireConnection;212;0;210;0
WireConnection;334;0;295;0
WireConnection;210;0;209;0
WireConnection;210;1;211;0
WireConnection;208;0;206;0
WireConnection;209;0;208;0
WireConnection;0;9;446;4
WireConnection;0;13;361;0
WireConnection;0;11;195;0
WireConnection;0;12;201;0
ASEEND*/
//CHKSM=A560279F4E3D6245587FCABCA56CEC1D56C8688A