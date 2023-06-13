// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Landscape_test"
{
	Properties
	{
		_BlendMask1("BlendMask1", 2D) = "white" {}
		_BlendMask2("BlendMask2", 2D) = "black" {}
		_BlendContrast("BlendContrast", Range( 0 , 1)) = 0
		_Layer1Tilling("Layer1Tilling", Float) = 0
		_Layer1_HeightContrast("Layer1_HeightContrast", Range( -1 , 1)) = 0
		_Layer1_BaseColor("Layer1_BaseColor", 2D) = "white" {}
		_Layer1_HRA("Layer1_HRA", 2D) = "white" {}
		_Layer1_Normal("Layer1_Normal", 2D) = "bump" {}
		_Layer2Tilling("Layer2Tilling", Float) = 0
		_Layer2_HeightContrast("Layer2_HeightContrast", Range( -1 , 1)) = 0
		_Layer2_BaseColor("Layer2_BaseColor", 2D) = "white" {}
		_Layer2_HRA("Layer2_HRA", 2D) = "white" {}
		_Layer2_Normal("Layer2_Normal", 2D) = "bump" {}
		_Layer3Tilling("Layer3Tilling", Float) = 0
		_Layer3_HeightContrast("Layer3_HeightContrast", Range( -1 , 1)) = 0
		_Layer3_BaseColor("Layer3_BaseColor", 2D) = "white" {}
		_Layer3_HRA("Layer3_HRA", 2D) = "white" {}
		_Layer3_Normal("Layer3_Normal", 2D) = "bump" {}
		_Layer4Tilling("Layer4Tilling", Float) = 0
		_Layer6Tilling("Layer6Tilling", Float) = 0
		_Layer8Tilling("Layer8Tilling", Float) = 0
		_Layer5Tilling("Layer5Tilling", Float) = 0
		_Layer7Tilling("Layer7Tilling", Float) = 0
		_Layer6_HeightContrast("Layer6_HeightContrast", Range( -1 , 1)) = 0
		_Layer5_HeightContrast("Layer5_HeightContrast", Range( -1 , 1)) = 0
		_Layer8_HeightContrast("Layer8_HeightContrast", Range( -1 , 1)) = 0
		_Layer4_HeightContrast("Layer4_HeightContrast", Range( -1 , 1)) = 0
		_Layer8_BaseColor("Layer8_BaseColor", 2D) = "black" {}
		_Layer6_BaseColor("Layer6_BaseColor", 2D) = "black" {}
		_Layer5_BaseColor("Layer5_BaseColor", 2D) = "black" {}
		_Layer4_BaseColor("Layer4_BaseColor", 2D) = "white" {}
		_Layer7_BaseColor("Layer7_BaseColor", 2D) = "black" {}
		_Layer7_HRA("Layer7_HRA", 2D) = "black" {}
		_Layer5_HRA("Layer5_HRA", 2D) = "black" {}
		_Layer6_HRA("Layer6_HRA", 2D) = "black" {}
		_Layer4_HRA("Layer4_HRA", 2D) = "white" {}
		_Layer8_HRA("Layer8_HRA", 2D) = "black" {}
		_Layer4_Normal("Layer4_Normal", 2D) = "bump" {}
		_Layer5_Normal("Layer5_Normal", 2D) = "bump" {}
		_Layer8_Normal("Layer8_Normal", 2D) = "bump" {}
		_Layer7_Normal("Layer7_Normal", 2D) = "bump" {}
		_Layer6_Normal("Layer6_Normal", 2D) = "bump" {}
		_Layer7_Normal_Scale("Layer7_Normal_Scale", Range( 0 , 3)) = 0
		_Layer6_Normal_Scale("Layer6_Normal_Scale", Range( 0 , 3)) = 0
		_Layer2_Normal_Scale("Layer2_Normal_Scale", Range( 0 , 3)) = 0
		_Layer5_Normal_Scale("Layer5_Normal_Scale", Range( 0 , 3)) = 0
		_Layer1_Normal_Scale("Layer1_Normal_Scale", Range( 0 , 3)) = 0
		_Layer3_Normal_Scale("Layer3_Normal_Scale", Range( 0 , 3)) = 0
		_Layer8_NormalScale("Layer8_NormalScale", Range( 0 , 3)) = 0
		_Layer4_Normal_Scale("Layer4_Normal_Scale", Range( 0 , 3)) = 0
		_Layer8_AOAdjust("Layer8_AOAdjust", Range( -1 , 1)) = 0
		_Layer8_RughnessAdjust("Layer8_RughnessAdjust", Range( -1 , 1)) = 0
		_Layer2_AO_Adjust("Layer2_AO_Adjust", Range( -1 , 1)) = 0
		_Layer2_Roughness_Adjust("Layer2_Roughness_Adjust", Range( -1 , 1)) = 0
		_Layer3_AO_Adjust("Layer3_AO_Adjust", Range( -1 , 1)) = 0
		_Layer3_Roughness_Adjust("Layer3_Roughness_Adjust", Range( -1 , 1)) = 0
		_Layer7_AO_Adjust("Layer7_AO_Adjust", Range( -1 , 1)) = 0
		_Layer7_Roughness_Adjust("Layer7_Roughness_Adjust", Range( -1 , 1)) = 0
		_Layer4_Roughness_Adjust("Layer4_Roughness_Adjust", Range( -1 , 1)) = 0
		_Layer1_AO_Adjust("Layer1_AO_Adjust", Range( -1 , 1)) = 0
		_Layer5_Roughness_Adjust("Layer5_Roughness_Adjust", Range( -1 , 1)) = 0
		_Layer5_AO_Adjust("Layer5_AO_Adjust", Range( -1 , 1)) = 0
		_Layer6_AO_Adjust("Layer6_AO_Adjust", Range( -1 , 1)) = 0
		_Layer6_Roughness_Adjust("Layer6_Roughness_Adjust", Range( -1 , 1)) = 0
		_Layer1_Roughness_Adjust("Layer1_Roughness_Adjust", Range( -1 , 1)) = 0
		_Layer4_AO_Adjust("Layer4_AO_Adjust", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

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
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float2 uv2_texcoord2;
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

		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer1_BaseColor);
		uniform float _Layer1Tilling;
		SamplerState sampler_linear_repeat;
		uniform float _Layer1_HeightContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer1_HRA);
		SamplerState sampler_Layer1_HRA;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendMask1);
		uniform float4 _BlendMask1_ST;
		uniform float _Layer2_HeightContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer2_HRA);
		SamplerState sampler_Layer2_HRA;
		uniform float _Layer2Tilling;
		uniform float _Layer3_HeightContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer3_HRA);
		SamplerState sampler_Layer3_HRA;
		uniform float _Layer3Tilling;
		uniform float _Layer4_HeightContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer4_HRA);
		SamplerState sampler_Layer4_HRA;
		uniform float _Layer4Tilling;
		uniform float _Layer5_HeightContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer5_HRA);
		SamplerState sampler_Layer5_HRA;
		uniform float _Layer5Tilling;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_BlendMask2);
		uniform float _Layer6_HeightContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer6_HRA);
		SamplerState sampler_Layer6_HRA;
		uniform float _Layer6Tilling;
		uniform float _Layer8_HeightContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer8_HRA);
		SamplerState sampler_Layer8_HRA;
		uniform float _Layer8Tilling;
		uniform float _BlendContrast;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer2_BaseColor);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer3_BaseColor);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer4_BaseColor);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer5_BaseColor);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer6_BaseColor);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer7_BaseColor);
		uniform float _Layer7Tilling;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer8_BaseColor);
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer1_Normal);
		uniform float _Layer1_Normal_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer2_Normal);
		uniform float _Layer2_Normal_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer3_Normal);
		uniform float _Layer3_Normal_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer4_Normal);
		uniform float _Layer4_Normal_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer5_Normal);
		uniform float _Layer5_Normal_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer6_Normal);
		uniform float4 _Layer6_Normal_ST;
		SamplerState sampler_Layer6_Normal;
		uniform float _Layer6_Normal_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer7_Normal);
		uniform float4 _Layer7_Normal_ST;
		SamplerState sampler_Layer7_Normal;
		uniform float _Layer7_Normal_Scale;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer8_Normal);
		uniform float _Layer8_NormalScale;
		uniform float _Layer1_Roughness_Adjust;
		uniform float _Layer2_Roughness_Adjust;
		uniform float _Layer3_Roughness_Adjust;
		uniform float _Layer4_Roughness_Adjust;
		uniform float _Layer5_Roughness_Adjust;
		uniform float _Layer6_Roughness_Adjust;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Layer7_HRA);
		SamplerState sampler_Layer7_HRA;
		uniform float _Layer7_Roughness_Adjust;
		uniform float _Layer8_RughnessAdjust;
		uniform float _Layer1_AO_Adjust;
		uniform float _Layer2_AO_Adjust;
		uniform float _Layer3_AO_Adjust;
		uniform float _Layer4_AO_Adjust;
		uniform float _Layer5_AO_Adjust;
		uniform float _Layer6_AO_Adjust;
		uniform float _Layer7_AO_Adjust;
		uniform float _Layer8_AOAdjust;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float2 LayerUV4 = ( i.uv_texcoord * 0.01 );
			float2 temp_output_8_0 = ( LayerUV4 * _Layer1Tilling );
			float4 Layer1_BaseColor11 = SAMPLE_TEXTURE2D( _Layer1_BaseColor, sampler_linear_repeat, temp_output_8_0 );
			float temp_output_3_0_g7 = _Layer1_HeightContrast;
			float4 tex2DNode5 = SAMPLE_TEXTURE2D( _Layer1_HRA, sampler_linear_repeat, temp_output_8_0 );
			float lerpResult1_g7 = lerp( ( 0.0 - temp_output_3_0_g7 ) , ( temp_output_3_0_g7 + 1.0 ) , tex2DNode5.r);
			float clampResult2_g7 = clamp( lerpResult1_g7 , 0.0 , 1.0 );
			float Layer1_Height13 = clampResult2_g7;
			float2 uv2_BlendMask1 = i.uv2_texcoord2 * _BlendMask1_ST.xy + _BlendMask1_ST.zw;
			float4 break164 = SAMPLE_TEXTURE2D( _BlendMask1, sampler_linear_repeat, uv2_BlendMask1 );
			float temp_output_156_0 = ( Layer1_Height13 + break164.r );
			float temp_output_3_0_g6 = _Layer2_HeightContrast;
			float2 temp_output_27_0 = ( LayerUV4 * _Layer2Tilling );
			float4 tex2DNode28 = SAMPLE_TEXTURE2D( _Layer2_HRA, sampler_linear_repeat, temp_output_27_0 );
			float lerpResult1_g6 = lerp( ( 0.0 - temp_output_3_0_g6 ) , ( temp_output_3_0_g6 + 1.0 ) , tex2DNode28.r);
			float clampResult2_g6 = clamp( lerpResult1_g6 , 0.0 , 1.0 );
			float Layer2_Height35 = clampResult2_g6;
			float temp_output_157_0 = ( Layer2_Height35 + break164.g );
			float temp_output_3_0_g12 = _Layer3_HeightContrast;
			float2 temp_output_38_0 = ( LayerUV4 * _Layer3Tilling );
			float4 tex2DNode41 = SAMPLE_TEXTURE2D( _Layer3_HRA, sampler_linear_repeat, temp_output_38_0 );
			float lerpResult1_g12 = lerp( ( 0.0 - temp_output_3_0_g12 ) , ( temp_output_3_0_g12 + 1.0 ) , tex2DNode41.r);
			float clampResult2_g12 = clamp( lerpResult1_g12 , 0.0 , 1.0 );
			float Layer3_Height44 = clampResult2_g12;
			float temp_output_158_0 = ( Layer3_Height44 + break164.b );
			float temp_output_3_0_g11 = _Layer4_HeightContrast;
			float2 temp_output_169_0 = ( LayerUV4 * _Layer4Tilling );
			float4 tex2DNode170 = SAMPLE_TEXTURE2D( _Layer4_HRA, sampler_linear_repeat, temp_output_169_0 );
			float lerpResult1_g11 = lerp( ( 0.0 - temp_output_3_0_g11 ) , ( temp_output_3_0_g11 + 1.0 ) , tex2DNode170.r);
			float clampResult2_g11 = clamp( lerpResult1_g11 , 0.0 , 1.0 );
			float Layer4_Height171 = clampResult2_g11;
			float temp_output_181_0 = ( Layer4_Height171 + break164.a );
			float temp_output_3_0_g14 = _Layer5_HeightContrast;
			float2 temp_output_291_0 = ( LayerUV4 * _Layer5Tilling );
			float4 tex2DNode292 = SAMPLE_TEXTURE2D( _Layer5_HRA, sampler_linear_repeat, temp_output_291_0 );
			float lerpResult1_g14 = lerp( ( 0.0 - temp_output_3_0_g14 ) , ( temp_output_3_0_g14 + 1.0 ) , tex2DNode292.r);
			float clampResult2_g14 = clamp( lerpResult1_g14 , 0.0 , 1.0 );
			float Layer5_Height294 = clampResult2_g14;
			float4 break287 = SAMPLE_TEXTURE2D( _BlendMask2, sampler_linear_repeat, uv2_BlendMask1 );
			float temp_output_372_0 = ( Layer5_Height294 + break287.r );
			float temp_output_3_0_g15 = _Layer6_HeightContrast;
			float2 temp_output_311_0 = ( LayerUV4 * _Layer6Tilling );
			float4 tex2DNode312 = SAMPLE_TEXTURE2D( _Layer6_HRA, sampler_linear_repeat, temp_output_311_0 );
			float lerpResult1_g15 = lerp( ( 0.0 - temp_output_3_0_g15 ) , ( temp_output_3_0_g15 + 1.0 ) , tex2DNode312.r);
			float clampResult2_g15 = clamp( lerpResult1_g15 , 0.0 , 1.0 );
			float Layer6_Height314 = clampResult2_g15;
			float temp_output_371_0 = ( Layer6_Height314 + break287.g );
			float temp_output_375_0 = ( Layer6_Height314 + break287.b );
			float temp_output_3_0_g17 = _Layer8_HeightContrast;
			float2 temp_output_351_0 = ( LayerUV4 * _Layer8Tilling );
			float4 tex2DNode352 = SAMPLE_TEXTURE2D( _Layer8_HRA, sampler_linear_repeat, temp_output_351_0 );
			float lerpResult1_g17 = lerp( ( 0.0 - temp_output_3_0_g17 ) , ( temp_output_3_0_g17 + 1.0 ) , tex2DNode352.r);
			float clampResult2_g17 = clamp( lerpResult1_g17 , 0.0 , 1.0 );
			float Layer8_Height354 = clampResult2_g17;
			float temp_output_374_0 = ( Layer8_Height354 + break287.a );
			float temp_output_97_0 = ( max( max( max( max( temp_output_156_0 , temp_output_157_0 ) , temp_output_158_0 ) , temp_output_181_0 ) , max( temp_output_372_0 , max( temp_output_371_0 , max( temp_output_375_0 , temp_output_374_0 ) ) ) ) - _BlendContrast );
			float temp_output_105_0 = max( ( temp_output_156_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_106_0 = max( ( temp_output_157_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_107_0 = max( ( temp_output_158_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_185_0 = max( ( temp_output_181_0 - temp_output_97_0 ) , 0.0 );
			float4 appendResult109 = (float4(temp_output_105_0 , temp_output_106_0 , temp_output_107_0 , temp_output_185_0));
			float temp_output_387_0 = max( ( temp_output_372_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_385_0 = max( ( temp_output_371_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_388_0 = max( ( temp_output_375_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_386_0 = max( ( temp_output_374_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_455_0 = ( ( temp_output_105_0 + temp_output_106_0 + temp_output_107_0 + temp_output_185_0 ) + ( temp_output_387_0 + temp_output_385_0 + temp_output_388_0 + temp_output_386_0 ) );
			float4 BlendWeight1112 = ( appendResult109 / temp_output_455_0 );
			float4 break117 = BlendWeight1112;
			float4 Layer2_BaseColor34 = SAMPLE_TEXTURE2D( _Layer2_BaseColor, sampler_linear_repeat, temp_output_27_0 );
			float4 Layer3_BaseColor43 = SAMPLE_TEXTURE2D( _Layer3_BaseColor, sampler_linear_repeat, temp_output_38_0 );
			float4 Layer4_BaseColor176 = SAMPLE_TEXTURE2D( _Layer4_BaseColor, sampler_linear_repeat, temp_output_169_0 );
			float4 Layer5_BaseColor297 = SAMPLE_TEXTURE2D( _Layer5_BaseColor, sampler_linear_repeat, temp_output_291_0 );
			float4 appendResult389 = (float4(temp_output_387_0 , temp_output_385_0 , temp_output_388_0 , temp_output_386_0));
			float4 BlendWeight2396 = ( appendResult389 / temp_output_455_0 );
			float4 break405 = BlendWeight2396;
			float4 Layer6_BaseColor317 = SAMPLE_TEXTURE2D( _Layer6_BaseColor, sampler_linear_repeat, temp_output_311_0 );
			float2 temp_output_331_0 = ( LayerUV4 * _Layer7Tilling );
			float4 Layer7_BaseColor337 = SAMPLE_TEXTURE2D( _Layer7_BaseColor, sampler_linear_repeat, temp_output_331_0 );
			float4 Layer8_BaseColor357 = SAMPLE_TEXTURE2D( _Layer8_BaseColor, sampler_linear_repeat, temp_output_351_0 );
			float4 BaseColor54 = ( ( Layer1_BaseColor11 * break117.x ) + ( Layer2_BaseColor34 * break117.y ) + ( Layer3_BaseColor43 * break117.z ) + ( break117.w * Layer4_BaseColor176 ) + ( Layer5_BaseColor297 * break405.x ) + ( Layer6_BaseColor317 * break405.y ) + ( Layer7_BaseColor337 * break405.z ) + ( break405.w * Layer8_BaseColor357 ) );
			s1.Albedo = BaseColor54.rgb;
			float3 Layer1_Normal16 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer1_Normal, sampler_linear_repeat, temp_output_8_0 ) ) * _Layer1_Normal_Scale );
			float4 break144 = BlendWeight1112;
			float3 Layer2_Normal32 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer2_Normal, sampler_linear_repeat, temp_output_27_0 ) ) * _Layer2_Normal_Scale );
			float3 Layer3_Normal47 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer3_Normal, sampler_linear_repeat, temp_output_38_0 ) ) * _Layer3_Normal_Scale );
			float3 Layer4_Normal175 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer4_Normal, sampler_linear_repeat, temp_output_169_0 ) ) * _Layer4_Normal_Scale );
			float3 Layer5_Normal300 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer5_Normal, sampler_linear_repeat, temp_output_291_0 ) ) * _Layer5_Normal_Scale );
			float4 break433 = BlendWeight2396;
			float2 uv_Layer6_Normal = i.uv_texcoord * _Layer6_Normal_ST.xy + _Layer6_Normal_ST.zw;
			float3 Layer6_Normal320 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer6_Normal, sampler_Layer6_Normal, uv_Layer6_Normal ) ) * _Layer6_Normal_Scale );
			float2 uv_Layer7_Normal = i.uv_texcoord * _Layer7_Normal_ST.xy + _Layer7_Normal_ST.zw;
			float3 Layer7_Normal340 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer7_Normal, sampler_Layer7_Normal, uv_Layer7_Normal ) ) * _Layer7_Normal_Scale );
			float3 Layer8_Normal360 = ( UnpackNormal( SAMPLE_TEXTURE2D( _Layer8_Normal, sampler_linear_repeat, temp_output_351_0 ) ) * _Layer8_NormalScale );
			float3 Normal152 = ( ( Layer1_Normal16 * break144.x ) + ( Layer2_Normal32 * break144.y ) + ( Layer3_Normal47 * break144.z ) + ( Layer4_Normal175 * break144.w ) + ( Layer5_Normal300 * break433.x ) + ( Layer6_Normal320 * break433.y ) + ( Layer7_Normal340 * break433.z ) + ( Layer8_Normal360 * break433.w ) );
			s1.Normal = WorldNormalVector( i , Normal152 );
			s1.Emission = float3( 0,0,0 );
			s1.Metallic = 0.0;
			float Layer1_Roughness14 = ( tex2DNode5.g + _Layer1_Roughness_Adjust );
			float4 break122 = BlendWeight1112;
			float Layer2_Roughness31 = ( tex2DNode28.g + _Layer2_Roughness_Adjust );
			float Layer3_Roughness45 = ( tex2DNode41.g + _Layer3_Roughness_Adjust );
			float Layer4_Roughness174 = ( tex2DNode170.g + _Layer4_Roughness_Adjust );
			float Layer5_Roughness298 = ( tex2DNode292.g + _Layer5_Roughness_Adjust );
			float4 break418 = BlendWeight2396;
			float Layer6_Roughness318 = ( tex2DNode312.g + _Layer6_Roughness_Adjust );
			float4 tex2DNode332 = SAMPLE_TEXTURE2D( _Layer7_HRA, sampler_linear_repeat, temp_output_331_0 );
			float Layer7_Roughness338 = ( tex2DNode332.g + _Layer7_Roughness_Adjust );
			float Layer8_Roughness358 = ( tex2DNode352.g + _Layer8_RughnessAdjust );
			float Roughness130 = ( ( Layer1_Roughness14 * break122.x ) + ( Layer2_Roughness31 * break122.y ) + ( Layer3_Roughness45 * break122.z ) + ( break122.w * Layer4_Roughness174 ) + ( Layer5_Roughness298 * break418.x ) + ( Layer6_Roughness318 * break418.y ) + ( Layer7_Roughness338 * break418.z ) + ( break418.w * Layer8_Roughness358 ) );
			s1.Smoothness = ( 1.0 - Roughness130 );
			float Layer1_AO15 = ( tex2DNode5.b + _Layer1_AO_Adjust );
			float4 break133 = BlendWeight1112;
			float Layer2_AO33 = ( tex2DNode28.b + _Layer2_AO_Adjust );
			float Layer3_AO46 = ( tex2DNode41.b + _Layer3_AO_Adjust );
			float Layer4_AO177 = ( tex2DNode170.b + _Layer4_AO_Adjust );
			float Layer5_AO299 = ( tex2DNode292.b + _Layer5_AO_Adjust );
			float4 break430 = BlendWeight2396;
			float Layer6_AO319 = ( tex2DNode312.b + _Layer6_AO_Adjust );
			float Layer7_AO339 = ( tex2DNode332.b + _Layer7_AO_Adjust );
			float Layer8_AO359 = ( tex2DNode352.b + _Layer8_AOAdjust );
			float AO141 = ( ( Layer1_AO15 * break133.x ) + ( Layer2_AO33 * break133.y ) + ( Layer3_AO46 * break133.z ) + ( break133.w * Layer4_AO177 ) + ( Layer5_AO299 * break430.x ) + ( Layer6_AO319 * break430.y ) + ( Layer7_AO339 * break430.z ) + ( break430.w * Layer8_AO359 ) );
			s1.Occlusion = AO141;

			data.light = gi.light;

			UnityGI gi1 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g1 = UnityGlossyEnvironmentSetup( s1.Smoothness, data.worldViewDir, s1.Normal, float3(0,0,0));
			gi1 = UnityGlobalIllumination( data, s1.Occlusion, s1.Normal, g1 );
			#endif

			float3 surfResult1 = LightingStandard ( s1, viewDir, gi1 ).rgb;
			surfResult1 += s1.Emission;

			#ifdef UNITY_PASS_FORWARDADD//1
			surfResult1 -= s1.Emission;
			#endif//1
			c.rgb = surfResult1;
			c.a = 1;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
465.3333;837.3334;1536;561;370.9874;604.78;2.728401;True;False
Node;AmplifyShaderEditor.CommentaryNode;206;-1085.23,-1239.264;Inherit;False;899.435;411.4983;LayerUI;6;207;4;208;3;442;443;LayerUI;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-992.3868,-987.7082;Inherit;False;Constant;_Float1;Float 1;22;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1035.23,-1184.366;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-783.4672,-1110.859;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-455.8441,-1149.344;Inherit;False;LayerUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2965.432,-671.943;Inherit;False;1802.734;1023.007;Layer1;20;266;267;264;265;15;14;262;263;16;13;198;199;11;6;2;5;8;9;7;444;Layer1;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.SamplerStateNode;442;-812.2788,-927.3477;Inherit;False;0;0;0;1;-1;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2985.048,437.7691;Inherit;False;1824.541;1018.258;Layer2;20;268;271;270;272;273;269;33;32;31;30;34;29;35;200;28;201;27;25;26;445;Layer2;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;348;-3019.094,6478.674;Inherit;False;1818.722;832.6957;Layer8;20;367;366;365;364;363;362;361;360;359;358;357;356;355;354;353;352;351;350;349;451;Layer8;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;308;-3010.934,4657.136;Inherit;False;1818.722;832.6957;Layer6;19;327;326;325;324;323;322;321;320;319;318;317;316;315;314;313;312;311;310;309;Layer6;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2931.149,598.1025;Inherit;False;Property;_Layer2Tilling;Layer2Tilling;8;0;Create;True;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;443;-538.2776,-922.0361;Inherit;False;SamplerState;-1;True;1;0;SAMPLERSTATE;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;7;-2940.494,-354.1043;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;350;-2965.193,6638.007;Inherit;False;Property;_Layer8Tilling;Layer8Tilling;20;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2935.047,513.6021;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;309;-2960.932,4732.969;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;36;-2988.237,1593.316;Inherit;False;1832.571;1050.137;Layer3;17;43;46;47;45;40;42;44;202;41;203;38;39;37;277;275;278;446;Layer3;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-2969.092,6554.507;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-2957.033,4816.469;Inherit;False;Property;_Layer6Tilling;Layer6Tilling;19;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2936.938,-185.5565;Inherit;False;Property;_Layer1Tilling;Layer1Tilling;3;0;Create;True;0;0;False;0;False;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-2752.933,4760.27;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;445;-2916.803,777.655;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.CommentaryNode;166;-2975.854,2760.06;Inherit;False;1818.722;832.6957;Layer4;20;175;177;174;176;173;172;171;204;205;170;169;167;168;284;283;281;280;285;282;447;Layer4;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;351;-2761.093,6581.808;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;288;-3010.933,3719.756;Inherit;False;1818.722;832.6957;Layer5;19;307;306;305;304;303;302;301;300;299;298;297;296;295;294;293;292;291;290;289;Layer5;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;449;-2952.951,4958.064;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2691.433,-322.5992;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2934.336,1753.649;Inherit;False;Property;_Layer3Tilling;Layer3Tilling;13;0;Create;True;0;0;False;0;False;0;12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2727.048,540.9024;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;451;-2952.026,6814.01;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-2938.235,1669.149;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;444;-2754.792,-561.6462;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;-2960.931,3795.589;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;199;-2093.789,-512.2357;Inherit;False;Property;_Layer1_HeightContrast;Layer1_HeightContrast;4;0;Create;True;0;0;False;0;False;0;0.1502941;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-2921.953,2919.393;Inherit;False;Property;_Layer4Tilling;Layer4Tilling;18;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;312;-2515.025,4933.924;Inherit;True;Property;_Layer6_HRA;Layer6_HRA;35;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;352;-2523.185,6755.462;Inherit;True;Property;_Layer8_HRA;Layer8_HRA;37;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;446;-2929.379,1929.391;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-2925.852,2835.893;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;28;-2490.577,701.6232;Inherit;True;Property;_Layer2_HRA;Layer2_HRA;11;0;Create;True;0;0;False;0;False;-1;None;f9a894a8bd307384ebe3c0025a3d6a36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;201;-2170.601,635.3416;Inherit;False;Property;_Layer2_HeightContrast;Layer2_HeightContrast;9;0;Create;True;0;0;False;0;False;0;-0.457;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-2469.523,-395.155;Inherit;True;Property;_Layer1_HRA;Layer1_HRA;6;0;Create;True;0;0;False;0;False;-1;None;b6eec86bb987c3349aea2a1f1f15f690;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;290;-2957.032,3879.089;Inherit;False;Property;_Layer5Tilling;Layer5Tilling;21;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;367;-2334.086,6627.153;Inherit;False;Property;_Layer8_HeightContrast;Layer8_HeightContrast;26;0;Create;True;0;0;False;0;False;0;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2730.236,1696.449;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;327;-2380.926,4816.315;Inherit;False;Property;_Layer6_HeightContrast;Layer6_HeightContrast;23;0;Create;True;0;0;False;0;False;0;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-2717.853,2863.193;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;198;-1795.089,-507.4464;Inherit;False;CheapContrast;-1;;7;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerStateNode;452;-954.65,6550.003;Inherit;False;0;0;0;1;-1;1;0;SAMPLER2D;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-871.486,6224.729;Inherit;False;1;162;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;447;-2934.867,3078.161;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.FunctionNode;353;-2077.007,6657.96;Inherit;False;CheapContrast;-1;;17;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;200;-1850.388,562.1492;Inherit;False;CheapContrast;-1;;6;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;313;-2068.847,4836.422;Inherit;False;CheapContrast;-1;;15;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-2150.741,1762.983;Inherit;False;Property;_Layer3_HeightContrast;Layer3_HeightContrast;14;0;Create;True;0;0;False;0;False;0;-0.285;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;448;-2927.4,4111.09;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-2752.932,3822.889;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;41;-2509.755,1871.689;Inherit;True;Property;_Layer3_HRA;Layer3_HRA;16;0;Create;True;0;0;False;0;False;-1;None;0402a229615d8554aaf01a7776b46994;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;314;-1781.318,4842.073;Inherit;False;Layer6_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;170;-2479.945,3036.848;Inherit;True;Property;_Layer4_HRA;Layer4_HRA;36;0;Create;True;0;0;False;0;False;-1;None;865a4d2d913f9e64f8bf5ddcffc39307;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;354;-1789.478,6663.611;Inherit;False;Layer8_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;286;-624.9221,6893.296;Inherit;True;Property;_BlendMask2;BlendMask2;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;292;-2515.024,3996.544;Inherit;True;Property;_Layer5_HRA;Layer5_HRA;34;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;307;-2325.925,3866.935;Inherit;False;Property;_Layer5_HeightContrast;Layer5_HeightContrast;25;0;Create;True;0;0;False;0;False;0;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;202;-1871.005,1741.47;Inherit;False;CheapContrast;-1;;12;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-2290.846,2907.239;Inherit;False;Property;_Layer4_HeightContrast;Layer4_HeightContrast;27;0;Create;True;0;0;False;0;False;0;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;113;-45.86373,6334.391;Inherit;False;2217.623;1437.538;BlendWeight;50;396;112;395;390;389;377;376;111;110;109;388;387;386;385;384;383;382;381;107;105;185;106;100;184;101;99;98;97;182;96;380;378;375;95;368;180;369;374;373;372;371;370;158;181;156;157;161;160;159;455;BlendWeight;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1534.101,580.7497;Inherit;False;Layer2_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1490.081,-493.8984;Inherit;False;Layer1_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;162;-620.7383,6282.895;Inherit;True;Property;_BlendMask1;BlendMask1;0;0;Create;True;0;0;False;0;False;-1;None;3bd9874aba2131541bcb232ced7efc25;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1576.376,1752.681;Inherit;False;Layer3_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;164;-318.7812,6352.975;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;293;-2042.846,3880.841;Inherit;False;CheapContrast;-1;;14;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;373;124.1317,7297.108;Inherit;False;354;Layer8_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;148.2288,6386.07;Inherit;False;13;Layer1_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;149.2288,6488.07;Inherit;False;35;Layer2_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;204;-2033.767,2939.346;Inherit;False;CheapContrast;-1;;11;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;370;118.9564,7181.944;Inherit;False;314;Layer6_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;287;-319.9435,6905.104;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;-1781.318,3903.692;Inherit;False;Layer5_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;360.5571,6380.999;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;171;-1746.239,2943.996;Inherit;False;Layer4_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;375;333.8884,7213.588;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;369;115.9564,7059.624;Inherit;False;314;Layer6_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;359.5214,6508.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;374;331.132,7343.108;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;152.2288,6600.571;Inherit;False;44;Layer3_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;95;483.6217,6440.697;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;157.4042,6715.735;Inherit;False;171;Layer4_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;378;462.5933,7259.639;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;358.5925,6642.035;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;368;109.6558,6921.581;Inherit;False;294;Layer5_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;371;326.249,7090.051;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;181;364.4044,6761.735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;372;327.2847,6962.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;377;554.215,7049.613;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;96;573.7365,6572.104;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;182;637.9307,6739.6;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;376;614.2398,6885.147;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;380;763.3151,6838.211;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;487.0453,7564.258;Inherit;False;Property;_BlendContrast;BlendContrast;2;0;Create;True;0;0;False;0;False;0;0.051;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;97;764.38,7435.935;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;100;983.0877,6502.99;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;382;1019.273,7213.561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;101;986.0877,6627.99;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;384;1016.273,7088.561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;381;1016.273,6961.561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;184;1011.404,6763.735;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;383;1044.589,7349.306;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;983.0877,6375.99;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;107;1157.087,6630.99;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;388;1190.272,7216.561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;385;1185.272,7089.561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;185;1175.403,6764.735;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;105;1152.087,6376.99;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;387;1185.272,6962.561;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;328;-3009.682,5579.859;Inherit;False;1818.722;832.6957;Layer7;20;347;346;345;344;343;342;341;340;339;338;337;336;335;334;333;332;331;330;329;450;Layer7;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;386;1208.588,7350.306;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;106;1152.087,6503.99;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;1377.949,6642.697;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;330;-2955.781,5739.192;Inherit;False;Property;_Layer7Tilling;Layer7Tilling;22;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;329;-2959.68,5655.692;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;1370.128,6811.146;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;450;-2989.999,5940.84;Inherit;False;443;SamplerState;1;0;OBJECT;;False;1;SAMPLERSTATE;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;1354.905,6377.073;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;455;1515.066,6751.282;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;389;1492.97,7006.833;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;331;-2751.681,5682.992;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;284;-2160.632,3053.869;Inherit;False;Property;_Layer4_Roughness_Adjust;Layer4_Roughness_Adjust;59;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-2047.666,2058.922;Inherit;False;Property;_Layer3_AO_Adjust;Layer3_AO_Adjust;55;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;363;-2203.872,6772.483;Inherit;False;Property;_Layer8_RughnessAdjust;Layer8_RughnessAdjust;52;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-2179.446,3199.681;Inherit;False;Property;_Layer4_AO_Adjust;Layer4_AO_Adjust;66;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;343;-2194.46,5873.668;Inherit;False;Property;_Layer7_Roughness_Adjust;Layer7_Roughness_Adjust;58;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;332;-2513.773,5856.647;Inherit;True;Property;_Layer7_HRA;Layer7_HRA;33;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;267;-2137.79,-331.0912;Inherit;False;Property;_Layer1_Roughness_Adjust;Layer1_Roughness_Adjust;65;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-2195.711,4013.565;Inherit;False;Property;_Layer5_Roughness_Adjust;Layer5_Roughness_Adjust;61;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;323;-2195.712,4950.945;Inherit;False;Property;_Layer6_Roughness_Adjust;Layer6_Roughness_Adjust;64;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;278;-2059.597,1942.112;Inherit;False;Property;_Layer3_Roughness_Adjust;Layer3_Roughness_Adjust;56;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;395;1725.373,6972.351;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;111;1710.208,6446.476;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;272;-2117.71,766.5662;Inherit;False;Property;_Layer2_Roughness_Adjust;Layer2_Roughness_Adjust;54;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;295;-2514.324,4215.946;Inherit;True;Property;_Layer5_Normal;Layer5_Normal;39;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;172;-2479.245,3256.248;Inherit;True;Property;_Layer4_Normal;Layer4_Normal;38;0;Create;True;0;0;False;0;False;-1;None;08b81ef30d418744a883e6f50a673a0a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;326;-2220.672,5302.466;Inherit;False;Property;_Layer6_Normal_Scale;Layer6_Normal_Scale;44;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;355;-2522.485,6974.863;Inherit;True;Property;_Layer8_Normal;Layer8_Normal;40;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-2468.823,-175.7553;Inherit;True;Property;_Layer1_Normal;Layer1_Normal;7;0;Create;True;0;0;False;0;False;-1;None;dcaefaeab85f0be409c91786faebb73b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;273;-1830.789,761.744;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;285;-1841.632,3030.869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-2220.671,4365.087;Inherit;False;Property;_Layer5_Normal_Scale;Layer5_Normal_Scale;46;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;315;-2514.325,5153.325;Inherit;True;Property;_Layer6_Normal;Layer6_Normal;42;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-2488.44,919.5859;Inherit;True;Property;_Layer2_Normal;Layer2_Normal;12;0;Create;True;0;0;False;0;False;-1;None;047fcc97941555f4a9ec6313d17db43e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;262;-2197.96,18.57676;Inherit;False;Property;_Layer1_Normal_Scale;Layer1_Normal_Scale;47;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;-532.0887,1352.593;Inherit;False;1777.989;1090.331;Roughness;22;130;129;123;125;124;126;128;127;188;122;187;131;408;409;410;412;413;414;415;416;418;454;Roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-2185.592,3405.39;Inherit;False;Property;_Layer4_Normal_Scale;Layer4_Normal_Scale;50;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;322;-1876.711,4927.945;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;269;-2206.751,1152.59;Inherit;False;Property;_Layer2_Normal_Scale;Layer2_Normal_Scale;45;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;396;1889.581,7022.844;Inherit;False;BlendWeight2;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-2109.309,2248.206;Inherit;False;Property;_Layer3_Normal_Scale;Layer3_Normal_Scale;48;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;342;-1875.46,5850.668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;143;-534.1263,2487.102;Inherit;False;1777.901;1234.258;AO;24;141;140;134;135;192;193;191;138;136;139;190;137;133;142;419;420;421;422;423;424;427;428;430;431;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;346;-2219.42,6225.189;Inherit;False;Property;_Layer7_Normal_Scale;Layer7_Normal_Scale;43;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;304;-2214.525,4159.378;Inherit;False;Property;_Layer5_AO_Adjust;Layer5_AO_Adjust;62;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;264;-2156.604,-185.2795;Inherit;False;Property;_Layer1_AO_Adjust;Layer1_AO_Adjust;60;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;335;-2513.073,6076.047;Inherit;True;Property;_Layer7_Normal;Layer7_Normal;41;0;Create;True;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;276;-1724.78,2045.494;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;-1740.597,1919.112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;266;-1818.79,-354.0912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;42;-2512.224,2099.01;Inherit;True;Property;_Layer3_Normal;Layer3_Normal;17;0;Create;True;0;0;False;0;False;-1;None;a624cf88c42842d41a00ee64a6ec5a6d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;362;-1884.871,6749.483;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;282;-1855.446,3174.681;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;271;-2150.424,914.5169;Inherit;False;Property;_Layer2_AO_Adjust;Layer2_AO_Adjust;53;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-2222.686,6918.295;Inherit;False;Property;_Layer8_AOAdjust;Layer8_AOAdjust;51;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;1899.125,6449.7;Inherit;False;BlendWeight1;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;324;-2214.526,5096.757;Inherit;False;Property;_Layer6_AO_Adjust;Layer6_AO_Adjust;63;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;366;-2228.832,7124.004;Inherit;False;Property;_Layer8_NormalScale;Layer8_NormalScale;49;0;Create;True;0;0;False;0;False;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;344;-2213.274,6019.48;Inherit;False;Property;_Layer7_AO_Adjust;Layer7_AO_Adjust;57;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;302;-1876.711,3990.565;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-2507.166,1662.328;Inherit;True;Property;_Layer3_BaseColor;Layer3_BaseColor;15;0;Create;True;0;0;False;0;False;-1;None;79cdfdd3029b5f24daa5bd72fd5ae2c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;318;-1722.796,4989.41;Inherit;False;Layer6_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2471.684,-621.9431;Inherit;True;Property;_Layer1_BaseColor;Layer1_BaseColor;5;0;Create;True;0;0;False;0;False;-1;None;a51e35cd577187f4ebc43215c0a8fd71;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;365;-1938.129,7050.723;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-1687.717,3092.333;Inherit;False;Layer4_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;358;-1730.956,6810.948;Inherit;False;Layer8_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;316;-2581.188,4707.136;Inherit;True;Property;_Layer6_BaseColor;Layer6_BaseColor;29;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;131;-482.0887,1553.615;Inherit;False;112;BlendWeight1;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;-1835.176,2205.968;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1660.232,-361.9658;Inherit;False;Layer1_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-1928.718,6151.908;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-1922.084,-60.26402;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;356;-2591.348,6530.674;Inherit;True;Property;_Layer8_BaseColor;Layer8_BaseColor;28;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;173;-2546.108,2810.06;Inherit;True;Property;_Layer4_BaseColor;Layer4_BaseColor;31;0;Create;True;0;0;False;0;False;-1;None;87c216936b76489438803719b1cd7df1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;268;-1885.965,1085.511;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;338;-1721.545,5912.132;Inherit;False;Layer7_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1683.061,811.4155;Inherit;False;Layer2_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-1929.969,4291.806;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;341;-1889.274,5994.48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-505.05,69.18512;Inherit;False;1727.324;1180.403;BaseColor;14;54;121;120;118;119;48;49;179;114;117;178;115;406;399;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;321;-1890.525,5071.757;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;298;-1722.796,4052.03;Inherit;False;Layer5_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-514.0571,2675.16;Inherit;False;112;BlendWeight1;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;301;-1890.525,4134.378;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;336;-2579.936,5629.859;Inherit;True;Property;_Layer7_BaseColor;Layer7_BaseColor;32;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;408;-490.8502,2053.781;Inherit;False;396;BlendWeight2;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1434.656,1984.015;Inherit;False;Layer3_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-1678.717,3193.333;Inherit;False;Layer4_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;265;-1832.604,-210.2795;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;270;-1833.91,886.3088;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;296;-2581.187,3769.756;Inherit;True;Property;_Layer5_BaseColor;Layer5_BaseColor;30;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;325;-1929.969,5229.185;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;361;-1898.685,6893.295;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-2491.302,487.7694;Inherit;True;Property;_Layer2_BaseColor;Layer2_BaseColor;10;0;Create;True;0;0;False;0;False;-1;None;d40d103b99fa9584ab5439aca118ffaf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;154;-535.6699,3803.421;Inherit;False;1798.625;1273.936;Normal;15;151;153;152;145;146;195;147;150;149;194;144;148;436;433;441;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-1894.89,3332.109;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-1425.656,2085.015;Inherit;False;Layer3_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-59.77472,2795.131;Inherit;False;46;Layer3_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;357;-2160.483,6540.895;Inherit;False;Layer8_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;412;-88.61481,2037.351;Inherit;False;318;Layer6_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-93.32644,1794.055;Inherit;False;174;Layer4_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;406;-484.8495,795.5213;Inherit;False;396;BlendWeight2;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;418;-291.6663,2053.972;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;128;-55.15331,1526.785;Inherit;False;31;Layer2_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-1666.717,3293.333;Inherit;False;Layer4_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;300;-1703.096,4253.031;Inherit;False;Layer5_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;297;-2152.322,3781.976;Inherit;False;Layer5_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-515.6697,3994.443;Inherit;False;112;BlendWeight1;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-2117.243,2822.28;Inherit;False;Layer4_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1630.556,-35.25716;Inherit;False;Layer1_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-61.73718,1640.622;Inherit;False;45;Layer3_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-498.1725,424.1406;Inherit;False;112;BlendWeight1;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;409;-102.0879,2294.221;Inherit;False;358;Layer8_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;122;-282.9048,1553.806;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;360;-1709.956,7011.948;Inherit;False;Layer8_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;340;-1700.545,6113.132;Inherit;False;Layer7_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;127;-56.0335,1402.593;Inherit;False;14;Layer1_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-2126.438,499.989;Inherit;False;Layer2_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;320;-1694.796,5215.41;Inherit;False;Layer6_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;299;-1713.796,4153.031;Inherit;False;Layer5_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1641.451,-192.563;Inherit;False;Layer1_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1667.061,899.4156;Inherit;False;Layer2_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;319;-1713.796,5090.41;Inherit;False;Layer6_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;133;-312.0502,2672.753;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1661.061,1032.416;Inherit;False;Layer2_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-2102.6,-622.9998;Inherit;False;Layer1_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;413;-70.49866,2140.788;Inherit;False;338;Layer7_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-56.75821,2934.175;Inherit;False;177;Layer4_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1413.656,2185.015;Inherit;False;Layer3_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;339;-1712.545,6013.132;Inherit;False;Layer7_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;359;-1721.956,6911.948;Inherit;False;Layer8_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;441;-493.5636,4556.288;Inherit;False;396;BlendWeight2;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;317;-2203.523,4688.955;Inherit;False;Layer6_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;337;-2151.071,5642.079;Inherit;False;Layer7_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;431;-455.7135,3188.584;Inherit;False;396;BlendWeight2;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;454;-116.5413,1946.844;Inherit;False;298;Layer5_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-2129.626,1655.536;Inherit;False;Layer3_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;401;-58.7944,650.4991;Inherit;False;297;Layer5_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;-58.28699,4224.937;Inherit;False;175;Layer4_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;407;-77.29909,1072.489;Inherit;False;357;Layer8_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;171.6736,1791.055;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;168.2629,1563.621;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-52.32544,228.3773;Inherit;False;34;Layer2_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;144;-305.318,4000.448;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;434;-30.18087,4794.782;Inherit;False;360;Layer8_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;432;-33.21205,4681.294;Inherit;False;340;Layer7_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;436;-30.62819,4547.458;Inherit;False;320;Layer6_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;419;-1.431125,3308.556;Inherit;False;339;Layer7_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;405;-284.498,788.5276;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;400;-57.91422,774.6913;Inherit;False;317;Layer6_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-53.20564,104.1851;Inherit;False;11;Layer1_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;168.2629,1673.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-61.31816,4111.449;Inherit;False;47;Layer3_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-58.07109,2537.102;Inherit;False;15;Layer1_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;435;-31.50838,4423.266;Inherit;False;300;Layer5_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;410;162.9121,2291.221;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;-58.73429,3977.613;Inherit;False;32;Layer2_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-53.84271,369.6797;Inherit;False;43;Layer3_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-71.71036,526.1752;Inherit;False;176;Layer4_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;117;-278.9092,242.2137;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;416;183.9014,1944.188;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;415;159.5014,2173.788;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;-59.61449,3853.421;Inherit;False;16;Layer1_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;-60.49808,908.5275;Inherit;False;337;Layer7_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;423;0.2725039,3050.527;Inherit;False;299;Layer5_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;430;-253.7066,3186.177;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;139;-57.19088,2661.294;Inherit;False;33;Layer2_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;421;1.152715,3174.719;Inherit;False;319;Layer6_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;171.2253,2830.131;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;182.2629,1459.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;167.2419,2939.175;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;433;-303.2119,4559.293;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;420;1.585385,3447.6;Inherit;False;359;Layer8_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;414;159.5014,2063.787;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;404;170.502,943.5275;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;176.0908,397.2135;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;171.0908,231.2137;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;437;197.7881,4716.294;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;186.3459,510.8375;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;428;213.8688,3088.055;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;403;179.502,707.5278;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;439;192.7881,4584.293;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;427;224.569,3211.556;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;178.682,3910.448;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;479.9335,1660.361;Inherit;False;8;8;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;169.6819,4146.449;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;402;165.502,811.5276;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;206.0908,102.2138;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;192;264.2419,2802.175;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;422;229.5688,3343.556;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;424;225.5854,3452.6;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;399;178.5734,1057.151;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;164.6819,4014.448;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;166.2254,2698.131;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;193;310.2419,2881.175;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;438;205.8192,4846.782;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;177.713,4276.937;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;440;206.7882,4480.293;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;180.2253,2594.131;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;829.8149,1508.964;Inherit;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;479.9955,2795.505;Inherit;False;8;8;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;151;590.8009,4253.247;Inherit;False;8;8;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;589.9145,426.7977;Inherit;False;8;8;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;141;768.6284,2632.698;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;928.8894,439.2877;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;982.6367,3992.441;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;1365.109,185.0595;Inherit;False;130;Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;1543.109,185.0595;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;1445.682,-62.70734;Inherit;False;54;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;1480.002,39.48051;Inherit;False;152;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;1537.109,261.0596;Inherit;False;141;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;1542.109,112.0595;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;1;1792.376,6.291611;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;334;-1719.067,5764.795;Inherit;False;Layer7_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;347;-2324.674,5727.038;Inherit;False;Property;_Layer7_HeightContrast;Layer7_HeightContrast;24;0;Create;True;0;0;False;0;False;0;-0.25;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;333;-2011.595,5727.145;Inherit;False;CheapContrast;-1;;16;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2199.275,80.13073;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Landscape_test;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;208;0;3;0
WireConnection;208;1;207;0
WireConnection;4;0;208;0
WireConnection;443;0;442;0
WireConnection;311;0;309;0
WireConnection;311;1;310;0
WireConnection;351;0;349;0
WireConnection;351;1;350;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;312;1;311;0
WireConnection;312;7;449;0
WireConnection;352;1;351;0
WireConnection;352;7;451;0
WireConnection;28;1;27;0
WireConnection;28;7;445;0
WireConnection;5;1;8;0
WireConnection;5;7;444;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;169;0;168;0
WireConnection;169;1;167;0
WireConnection;198;7;5;1
WireConnection;198;3;199;0
WireConnection;353;7;352;1
WireConnection;353;3;367;0
WireConnection;200;7;28;1
WireConnection;200;3;201;0
WireConnection;313;7;312;1
WireConnection;313;3;327;0
WireConnection;291;0;289;0
WireConnection;291;1;290;0
WireConnection;41;1;38;0
WireConnection;41;7;446;0
WireConnection;314;0;313;0
WireConnection;170;1;169;0
WireConnection;170;7;447;0
WireConnection;354;0;353;0
WireConnection;286;1;163;0
WireConnection;286;7;452;0
WireConnection;292;1;291;0
WireConnection;292;7;448;0
WireConnection;202;7;41;1
WireConnection;202;3;203;0
WireConnection;35;0;200;0
WireConnection;13;0;198;0
WireConnection;162;1;163;0
WireConnection;162;7;452;0
WireConnection;44;0;202;0
WireConnection;164;0;162;0
WireConnection;293;7;292;1
WireConnection;293;3;307;0
WireConnection;204;7;170;1
WireConnection;204;3;205;0
WireConnection;287;0;286;0
WireConnection;294;0;293;0
WireConnection;156;0;159;0
WireConnection;156;1;164;0
WireConnection;171;0;204;0
WireConnection;375;0;370;0
WireConnection;375;1;287;2
WireConnection;157;0;160;0
WireConnection;157;1;164;1
WireConnection;374;0;373;0
WireConnection;374;1;287;3
WireConnection;95;0;156;0
WireConnection;95;1;157;0
WireConnection;378;0;375;0
WireConnection;378;1;374;0
WireConnection;158;0;161;0
WireConnection;158;1;164;2
WireConnection;371;0;369;0
WireConnection;371;1;287;1
WireConnection;181;0;180;0
WireConnection;181;1;164;3
WireConnection;372;0;368;0
WireConnection;372;1;287;0
WireConnection;377;0;371;0
WireConnection;377;1;378;0
WireConnection;96;0;95;0
WireConnection;96;1;158;0
WireConnection;182;0;96;0
WireConnection;182;1;181;0
WireConnection;376;0;372;0
WireConnection;376;1;377;0
WireConnection;380;0;182;0
WireConnection;380;1;376;0
WireConnection;97;0;380;0
WireConnection;97;1;98;0
WireConnection;100;0;157;0
WireConnection;100;1;97;0
WireConnection;382;0;375;0
WireConnection;382;1;97;0
WireConnection;101;0;158;0
WireConnection;101;1;97;0
WireConnection;384;0;371;0
WireConnection;384;1;97;0
WireConnection;381;0;372;0
WireConnection;381;1;97;0
WireConnection;184;0;181;0
WireConnection;184;1;97;0
WireConnection;383;0;374;0
WireConnection;383;1;97;0
WireConnection;99;0;156;0
WireConnection;99;1;97;0
WireConnection;107;0;101;0
WireConnection;388;0;382;0
WireConnection;385;0;384;0
WireConnection;185;0;184;0
WireConnection;105;0;99;0
WireConnection;387;0;381;0
WireConnection;386;0;383;0
WireConnection;106;0;100;0
WireConnection;110;0;105;0
WireConnection;110;1;106;0
WireConnection;110;2;107;0
WireConnection;110;3;185;0
WireConnection;390;0;387;0
WireConnection;390;1;385;0
WireConnection;390;2;388;0
WireConnection;390;3;386;0
WireConnection;109;0;105;0
WireConnection;109;1;106;0
WireConnection;109;2;107;0
WireConnection;109;3;185;0
WireConnection;455;0;110;0
WireConnection;455;1;390;0
WireConnection;389;0;387;0
WireConnection;389;1;385;0
WireConnection;389;2;388;0
WireConnection;389;3;386;0
WireConnection;331;0;329;0
WireConnection;331;1;330;0
WireConnection;332;1;331;0
WireConnection;332;7;450;0
WireConnection;395;0;389;0
WireConnection;395;1;455;0
WireConnection;111;0;109;0
WireConnection;111;1;455;0
WireConnection;295;1;291;0
WireConnection;295;7;448;0
WireConnection;172;1;169;0
WireConnection;172;7;447;0
WireConnection;355;1;351;0
WireConnection;355;7;451;0
WireConnection;6;1;8;0
WireConnection;6;7;444;0
WireConnection;273;0;28;2
WireConnection;273;1;272;0
WireConnection;285;0;170;2
WireConnection;285;1;284;0
WireConnection;315;1;311;0
WireConnection;315;7;449;0
WireConnection;30;1;27;0
WireConnection;30;7;445;0
WireConnection;322;0;312;2
WireConnection;322;1;323;0
WireConnection;396;0;395;0
WireConnection;342;0;332;2
WireConnection;342;1;343;0
WireConnection;335;1;331;0
WireConnection;335;7;450;0
WireConnection;276;0;41;3
WireConnection;276;1;277;0
WireConnection;279;0;41;2
WireConnection;279;1;278;0
WireConnection;266;0;5;2
WireConnection;266;1;267;0
WireConnection;42;1;38;0
WireConnection;42;7;446;0
WireConnection;362;0;352;2
WireConnection;362;1;363;0
WireConnection;282;0;170;3
WireConnection;282;1;283;0
WireConnection;112;0;111;0
WireConnection;302;0;292;2
WireConnection;302;1;303;0
WireConnection;40;1;38;0
WireConnection;40;7;446;0
WireConnection;318;0;322;0
WireConnection;2;1;8;0
WireConnection;2;7;444;0
WireConnection;365;0;355;0
WireConnection;365;1;366;0
WireConnection;174;0;285;0
WireConnection;358;0;362;0
WireConnection;316;1;311;0
WireConnection;316;7;449;0
WireConnection;274;0;42;0
WireConnection;274;1;275;0
WireConnection;14;0;266;0
WireConnection;345;0;335;0
WireConnection;345;1;346;0
WireConnection;263;0;6;0
WireConnection;263;1;262;0
WireConnection;356;1;351;0
WireConnection;356;7;451;0
WireConnection;173;1;169;0
WireConnection;173;7;447;0
WireConnection;268;0;30;0
WireConnection;268;1;269;0
WireConnection;338;0;342;0
WireConnection;31;0;273;0
WireConnection;305;0;295;0
WireConnection;305;1;306;0
WireConnection;341;0;332;3
WireConnection;341;1;344;0
WireConnection;321;0;312;3
WireConnection;321;1;324;0
WireConnection;298;0;302;0
WireConnection;301;0;292;3
WireConnection;301;1;304;0
WireConnection;336;1;331;0
WireConnection;336;7;450;0
WireConnection;45;0;279;0
WireConnection;177;0;282;0
WireConnection;265;0;5;3
WireConnection;265;1;264;0
WireConnection;270;0;28;3
WireConnection;270;1;271;0
WireConnection;296;1;291;0
WireConnection;296;7;448;0
WireConnection;325;0;315;0
WireConnection;325;1;326;0
WireConnection;361;0;352;3
WireConnection;361;1;364;0
WireConnection;29;1;27;0
WireConnection;29;7;445;0
WireConnection;280;0;172;0
WireConnection;280;1;281;0
WireConnection;46;0;276;0
WireConnection;357;0;356;0
WireConnection;418;0;408;0
WireConnection;175;0;280;0
WireConnection;300;0;305;0
WireConnection;297;0;296;0
WireConnection;176;0;173;0
WireConnection;16;0;263;0
WireConnection;122;0;131;0
WireConnection;360;0;365;0
WireConnection;340;0;345;0
WireConnection;34;0;29;0
WireConnection;320;0;325;0
WireConnection;299;0;301;0
WireConnection;15;0;265;0
WireConnection;33;0;270;0
WireConnection;319;0;321;0
WireConnection;133;0;142;0
WireConnection;32;0;268;0
WireConnection;11;0;2;0
WireConnection;47;0;274;0
WireConnection;339;0;341;0
WireConnection;359;0;361;0
WireConnection;317;0;316;0
WireConnection;337;0;336;0
WireConnection;43;0;40;0
WireConnection;188;0;122;3
WireConnection;188;1;187;0
WireConnection;124;0;128;0
WireConnection;124;1;122;1
WireConnection;144;0;153;0
WireConnection;405;0;406;0
WireConnection;125;0;126;0
WireConnection;125;1;122;2
WireConnection;410;0;418;3
WireConnection;410;1;409;0
WireConnection;117;0;115;0
WireConnection;416;0;454;0
WireConnection;416;1;418;0
WireConnection;415;0;413;0
WireConnection;415;1;418;2
WireConnection;430;0;431;0
WireConnection;136;0;137;0
WireConnection;136;1;133;2
WireConnection;123;0;127;0
WireConnection;123;1;122;0
WireConnection;191;0;133;3
WireConnection;191;1;190;0
WireConnection;433;0;441;0
WireConnection;414;0;412;0
WireConnection;414;1;418;1
WireConnection;404;0;398;0
WireConnection;404;1;405;2
WireConnection;120;0;114;0
WireConnection;120;1;117;2
WireConnection;119;0;49;0
WireConnection;119;1;117;1
WireConnection;437;0;432;0
WireConnection;437;1;433;2
WireConnection;179;0;117;3
WireConnection;179;1;178;0
WireConnection;428;0;423;0
WireConnection;428;1;430;0
WireConnection;403;0;401;0
WireConnection;403;1;405;0
WireConnection;439;0;436;0
WireConnection;439;1;433;1
WireConnection;427;0;421;0
WireConnection;427;1;430;1
WireConnection;145;0;149;0
WireConnection;145;1;144;0
WireConnection;129;0;123;0
WireConnection;129;1;124;0
WireConnection;129;2;125;0
WireConnection;129;3;188;0
WireConnection;129;4;416;0
WireConnection;129;5;414;0
WireConnection;129;6;415;0
WireConnection;129;7;410;0
WireConnection;147;0;148;0
WireConnection;147;1;144;2
WireConnection;402;0;400;0
WireConnection;402;1;405;1
WireConnection;118;0;48;0
WireConnection;118;1;117;0
WireConnection;192;0;136;0
WireConnection;422;0;419;0
WireConnection;422;1;430;2
WireConnection;424;0;430;3
WireConnection;424;1;420;0
WireConnection;399;0;405;3
WireConnection;399;1;407;0
WireConnection;146;0;150;0
WireConnection;146;1;144;1
WireConnection;135;0;139;0
WireConnection;135;1;133;1
WireConnection;193;0;191;0
WireConnection;438;0;434;0
WireConnection;438;1;433;3
WireConnection;195;0;194;0
WireConnection;195;1;144;3
WireConnection;440;0;435;0
WireConnection;440;1;433;0
WireConnection;134;0;138;0
WireConnection;134;1;133;0
WireConnection;130;0;129;0
WireConnection;140;0;134;0
WireConnection;140;1;135;0
WireConnection;140;2;192;0
WireConnection;140;3;193;0
WireConnection;140;4;428;0
WireConnection;140;5;427;0
WireConnection;140;6;422;0
WireConnection;140;7;424;0
WireConnection;151;0;145;0
WireConnection;151;1;146;0
WireConnection;151;2;147;0
WireConnection;151;3;195;0
WireConnection;151;4;440;0
WireConnection;151;5;439;0
WireConnection;151;6;437;0
WireConnection;151;7;438;0
WireConnection;121;0;118;0
WireConnection;121;1;119;0
WireConnection;121;2;120;0
WireConnection;121;3;179;0
WireConnection;121;4;403;0
WireConnection;121;5;402;0
WireConnection;121;6;404;0
WireConnection;121;7;399;0
WireConnection;141;0;140;0
WireConnection;54;0;121;0
WireConnection;152;0;151;0
WireConnection;21;0;20;0
WireConnection;1;0;55;0
WireConnection;1;1;23;0
WireConnection;1;3;22;0
WireConnection;1;4;21;0
WireConnection;1;5;19;0
WireConnection;334;0;333;0
WireConnection;333;7;332;1
WireConnection;333;3;347;0
WireConnection;0;13;1;0
ASEEND*/
//CHKSM=6603868DD486222941BDD7A5136B274DB02F4597