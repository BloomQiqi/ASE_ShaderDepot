// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MaterialBlend"
{
	Properties
	{
		_BlendMask("BlendMask", 2D) = "white" {}
		_BlendContrast("BlendContrast", Range( 0 , 1)) = 0
		_Layer1Tilling("Layer1Tilling", Float) = 0
		_Layer1_HeightContrast("Layer1_HeightContrast", Range( 0 , 1)) = 0
		_Layer1_BaseColor("Layer1_BaseColor", 2D) = "white" {}
		_Layer1_HRA("Layer1_HRA", 2D) = "white" {}
		_Layer1_Normal("Layer1_Normal", 2D) = "bump" {}
		_Layer2Tilling("Layer2Tilling", Float) = 0
		_Layer2_HeightContrast("Layer2_HeightContrast", Range( 0 , 1)) = 0
		_Layer2_BaseColor("Layer2_BaseColor", 2D) = "white" {}
		_Layer2_HRA("Layer2_HRA", 2D) = "white" {}
		_Layer2_Normal("Layer2_Normal", 2D) = "bump" {}
		_Layer3Tilling("Layer3Tilling", Float) = 0
		_Layer3_HeightContrast("Layer3_HeightContrast", Range( 0 , 1)) = 0
		_Layer3_BaseColor("Layer3_BaseColor", 2D) = "white" {}
		_Layer3_HRA("Layer3_HRA", 2D) = "white" {}
		_Layer3_Normal("Layer3_Normal", 2D) = "bump" {}
		_Layer4Tilling("Layer4Tilling", Float) = 0
		_Layer4_HeightContrast("Layer4_HeightContrast", Range( 0 , 1)) = 0
		_Layer4_BaseColor("Layer4_BaseColor", 2D) = "white" {}
		_Layer4_HRA("Layer4_HRA", 2D) = "white" {}
		_Layer4_Normal("Layer4_Normal", 2D) = "bump" {}
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

		uniform sampler2D _Layer1_BaseColor;
		uniform float _Layer1Tilling;
		uniform float _Layer1_HeightContrast;
		uniform sampler2D _Layer1_HRA;
		SamplerState sampler_Layer1_HRA;
		uniform sampler2D _BlendMask;
		uniform float4 _BlendMask_ST;
		uniform float _Layer2_HeightContrast;
		uniform sampler2D _Layer2_HRA;
		SamplerState sampler_Layer2_HRA;
		uniform float _Layer2Tilling;
		uniform float _Layer3_HeightContrast;
		uniform sampler2D _Layer3_HRA;
		SamplerState sampler_Layer3_HRA;
		uniform float _Layer3Tilling;
		uniform float _Layer4_HeightContrast;
		uniform sampler2D _Layer4_HRA;
		SamplerState sampler_Layer4_HRA;
		uniform float _Layer4Tilling;
		uniform float _BlendContrast;
		uniform sampler2D _Layer2_BaseColor;
		uniform sampler2D _Layer3_BaseColor;
		uniform sampler2D _Layer4_BaseColor;
		uniform sampler2D _Layer1_Normal;
		uniform sampler2D _Layer2_Normal;
		uniform sampler2D _Layer3_Normal;
		uniform sampler2D _Layer4_Normal;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			SurfaceOutputStandard s1 = (SurfaceOutputStandard ) 0;
			float2 LayerUV4 = i.uv_texcoord;
			float2 temp_output_8_0 = ( LayerUV4 * _Layer1Tilling );
			float4 Layer1_BaseColor11 = tex2D( _Layer1_BaseColor, temp_output_8_0 );
			float temp_output_3_0_g3 = _Layer1_HeightContrast;
			float4 tex2DNode5 = tex2D( _Layer1_HRA, temp_output_8_0 );
			float lerpResult1_g3 = lerp( ( 0.0 - temp_output_3_0_g3 ) , ( temp_output_3_0_g3 + 1.0 ) , tex2DNode5.r);
			float clampResult2_g3 = clamp( lerpResult1_g3 , 0.0 , 1.0 );
			float Layer1_Height13 = clampResult2_g3;
			float2 uv_BlendMask = i.uv_texcoord * _BlendMask_ST.xy + _BlendMask_ST.zw;
			float4 break164 = tex2D( _BlendMask, uv_BlendMask );
			float temp_output_156_0 = ( Layer1_Height13 + break164.r );
			float temp_output_3_0_g2 = _Layer2_HeightContrast;
			float2 temp_output_27_0 = ( LayerUV4 * _Layer2Tilling );
			float4 tex2DNode28 = tex2D( _Layer2_HRA, temp_output_27_0 );
			float lerpResult1_g2 = lerp( ( 0.0 - temp_output_3_0_g2 ) , ( temp_output_3_0_g2 + 1.0 ) , tex2DNode28.r);
			float clampResult2_g2 = clamp( lerpResult1_g2 , 0.0 , 1.0 );
			float Layer2_Height35 = clampResult2_g2;
			float temp_output_157_0 = ( Layer2_Height35 + break164.g );
			float temp_output_3_0_g4 = _Layer3_HeightContrast;
			float2 temp_output_38_0 = ( LayerUV4 * _Layer3Tilling );
			float4 tex2DNode41 = tex2D( _Layer3_HRA, temp_output_38_0 );
			float lerpResult1_g4 = lerp( ( 0.0 - temp_output_3_0_g4 ) , ( temp_output_3_0_g4 + 1.0 ) , tex2DNode41.r);
			float clampResult2_g4 = clamp( lerpResult1_g4 , 0.0 , 1.0 );
			float Layer3_Height44 = clampResult2_g4;
			float temp_output_158_0 = ( Layer3_Height44 + break164.b );
			float temp_output_3_0_g5 = _Layer4_HeightContrast;
			float2 temp_output_169_0 = ( LayerUV4 * _Layer4Tilling );
			float4 tex2DNode170 = tex2D( _Layer4_HRA, temp_output_169_0 );
			float lerpResult1_g5 = lerp( ( 0.0 - temp_output_3_0_g5 ) , ( temp_output_3_0_g5 + 1.0 ) , tex2DNode170.r);
			float clampResult2_g5 = clamp( lerpResult1_g5 , 0.0 , 1.0 );
			float Layer4_Height171 = clampResult2_g5;
			float temp_output_181_0 = ( Layer4_Height171 + break164.a );
			float temp_output_97_0 = ( max( max( max( temp_output_156_0 , temp_output_157_0 ) , temp_output_158_0 ) , temp_output_181_0 ) - _BlendContrast );
			float temp_output_105_0 = max( ( temp_output_156_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_106_0 = max( ( temp_output_157_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_107_0 = max( ( temp_output_158_0 - temp_output_97_0 ) , 0.0 );
			float temp_output_185_0 = max( ( temp_output_181_0 - temp_output_97_0 ) , 0.0 );
			float4 appendResult109 = (float4(temp_output_105_0 , temp_output_106_0 , temp_output_107_0 , temp_output_185_0));
			float4 BlendWeight112 = ( appendResult109 / ( temp_output_105_0 + temp_output_106_0 + temp_output_107_0 + temp_output_185_0 ) );
			float4 break117 = BlendWeight112;
			float4 Layer2_BaseColor34 = tex2D( _Layer2_BaseColor, temp_output_27_0 );
			float4 Layer3_BaseColor43 = tex2D( _Layer3_BaseColor, temp_output_38_0 );
			float4 Layer4_BaseColor176 = tex2D( _Layer4_BaseColor, temp_output_169_0 );
			float4 BaseColor54 = ( ( Layer1_BaseColor11 * break117.x ) + ( Layer2_BaseColor34 * break117.y ) + ( Layer3_BaseColor43 * break117.z ) + ( break117.w * Layer4_BaseColor176 ) );
			s1.Albedo = BaseColor54.rgb;
			float3 Layer1_Normal16 = UnpackNormal( tex2D( _Layer1_Normal, temp_output_8_0 ) );
			float4 break144 = BlendWeight112;
			float3 Layer2_Normal32 = UnpackNormal( tex2D( _Layer2_Normal, temp_output_27_0 ) );
			float3 Layer3_Normal47 = UnpackNormal( tex2D( _Layer3_Normal, temp_output_38_0 ) );
			float3 Layer4_Normal175 = UnpackNormal( tex2D( _Layer4_Normal, temp_output_169_0 ) );
			float3 Normal152 = ( ( Layer1_Normal16 * break144.x ) + ( Layer2_Normal32 * break144.y ) + ( Layer3_Normal47 * break144.z ) + ( Layer4_Normal175 * break144.w ) );
			s1.Normal = WorldNormalVector( i , Normal152 );
			s1.Emission = float3( 0,0,0 );
			s1.Metallic = 0.0;
			float Layer1_Roughness14 = tex2DNode5.g;
			float4 break122 = BlendWeight112;
			float Layer2_Roughness31 = tex2DNode28.g;
			float Layer3_Roughness45 = tex2DNode41.g;
			float Layer4_Roughness174 = tex2DNode170.g;
			float Roughness130 = ( ( Layer1_Roughness14 * break122.x ) + ( Layer2_Roughness31 * break122.y ) + ( Layer3_Roughness45 * break122.z ) + ( break122.w * Layer4_Roughness174 ) );
			s1.Smoothness = ( 1.0 - Roughness130 );
			float Layer1_AO15 = tex2DNode5.b;
			float4 break133 = BlendWeight112;
			float Layer2_AO33 = tex2DNode28.b;
			float Layer3_AO46 = tex2DNode41.b;
			float Layer4_AO177 = tex2DNode170.b;
			float AO141 = ( ( Layer1_AO15 * break133.x ) + ( Layer2_AO33 * break133.y ) + ( Layer3_AO46 * break133.z ) + ( break133.w * Layer4_AO177 ) );
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
				float2 customPack1 : TEXCOORD1;
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
0;89.6;1536;712;1359.754;-2204.714;1.376396;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1339.54,-283.9094;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-1107.905,-288.8077;Inherit;False;LayerUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2410.528,82.86164;Inherit;False;1419.246;748.0255;Layer1;13;198;13;11;15;16;14;2;6;5;8;7;9;199;Layer1;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2399.975,897.1718;Inherit;False;1420.741;722.2576;Layer2;13;33;32;34;31;30;29;35;28;27;25;26;201;200;Layer2;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2349.974,973.0046;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2346.076,1057.505;Inherit;False;Property;_Layer2Tilling;Layer2Tilling;7;0;Create;True;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-2405.287,1663.448;Inherit;False;1499.953;794.9785;Layer3;13;203;44;202;43;46;40;47;45;42;41;38;37;39;Layer3;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;7;-2360.528,158.6945;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-2356.627,243.1945;Inherit;False;Property;_Layer1Tilling;Layer1Tilling;2;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;166;-2402.52,2493.088;Inherit;False;1481.134;721.2592;Layer4;13;205;204;171;176;175;177;172;173;174;170;169;167;168;Layer4;1,0.7311321,0.7311321,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-2351.386,1823.781;Inherit;False;Property;_Layer3Tilling;Layer3Tilling;12;0;Create;True;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2152.528,185.9945;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-2352.518,2568.921;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2141.975,1000.305;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-2355.285,1739.281;Inherit;False;4;LayerUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;167;-2348.619,2652.421;Inherit;False;Property;_Layer4Tilling;Layer4Tilling;17;0;Create;True;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;-1819.729,322.466;Inherit;False;Property;_Layer1_HeightContrast;Layer1_HeightContrast;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;-2144.519,2596.221;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;201;-1710.951,1097.367;Inherit;False;Property;_Layer2_HeightContrast;Layer2_HeightContrast;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;28;-1904.067,1173.96;Inherit;True;Property;_Layer2_HRA;Layer2_HRA;10;0;Create;True;0;0;False;0;False;-1;None;f9a894a8bd307384ebe3c0025a3d6a36;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1914.62,359.6496;Inherit;True;Property;_Layer1_HRA;Layer1_HRA;5;0;Create;True;0;0;False;0;False;-1;None;b6eec86bb987c3349aea2a1f1f15f690;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-2147.286,1766.581;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;41;-1909.378,1940.236;Inherit;True;Property;_Layer3_HRA;Layer3_HRA;15;0;Create;True;0;0;False;0;False;-1;None;0402a229615d8554aaf01a7776b46994;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;170;-1906.611,2769.876;Inherit;True;Property;_Layer4_HRA;Layer4_HRA;20;0;Create;True;0;0;False;0;False;-1;None;865a4d2d913f9e64f8bf5ddcffc39307;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;205;-1746.475,2665.26;Inherit;False;Property;_Layer4_HeightContrast;Layer4_HeightContrast;18;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;200;-1439.412,1069.983;Inherit;False;CheapContrast;-1;;2;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-1704.04,1867.97;Inherit;False;Property;_Layer3_HeightContrast;Layer3_HeightContrast;13;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;198;-1536,304;Inherit;False;CheapContrast;-1;;3;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;163;-741.3958,2607.009;Inherit;False;0;162;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;204;-1460.434,2672.374;Inherit;False;CheapContrast;-1;;5;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1268.716,305.2585;Inherit;False;Layer1_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;202;-1424.305,1846.457;Inherit;False;CheapContrast;-1;;4;7235b5869aad1de43b58d5dfac7f22ee;0;2;7;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;113;-142.5856,2686.099;Inherit;False;1938.035;867.2469;BlendWeight;24;95;112;111;109;110;106;105;107;100;99;101;97;98;96;159;157;160;158;161;180;181;182;184;185;BlendWeight;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;162;-467.8723,2582.815;Inherit;True;Property;_BlendMask;BlendMask;0;0;Create;True;0;0;False;0;False;-1;None;6c7c4d9438f73c143b8ff906db1db1e0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-1154.365,1092.392;Inherit;False;Layer2_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;164;-272.4927,2811.928;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1129.676,1857.668;Inherit;False;Layer3_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;159;51.50702,2737.778;Inherit;False;13;Layer1_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;52.50702,2839.778;Inherit;False;35;Layer2_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;171;-1173.906,2678.024;Inherit;False;Layer4_Height;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;262.7994,2860.386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;263.8351,2732.707;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;55.50702,2952.279;Inherit;False;44;Layer3_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;180;60.68237,3067.443;Inherit;False;171;Layer4_Height;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;95;442.1345,3220.169;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;181;267.6824,3113.443;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;261.8705,2993.743;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;183;393.6824,3355.443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;96;572.0136,3296.636;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;389.4987,3426.636;Inherit;False;Property;_BlendContrast;BlendContrast;1;0;Create;True;0;0;False;0;False;0;0.28;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;182;710.6824,3335.443;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;97;827.4988,3383.636;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;101;889.3663,2979.698;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;184;891.6824,3110.443;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;100;886.3663,2854.698;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;886.3663,2727.698;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;106;1055.366,2855.698;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;105;1055.366,2728.698;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;107;1060.366,2982.698;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;185;1053.682,3111.443;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;1282.184,2957.781;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;1288.184,2719.781;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;111;1445.184,2849.781;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;1600.184,2844.781;Inherit;False;BlendWeight;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;132;-450.1227,746.5472;Inherit;False;1202.335;549.8287;Roughness;12;130;129;123;125;124;122;127;126;128;131;187;188;Roughness;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;172;-1905.911,2989.276;Inherit;True;Property;_Layer4_Normal;Layer4_Normal;21;0;Create;True;0;0;False;0;False;-1;None;08b81ef30d418744a883e6f50a673a0a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;173;-1908.774,2543.088;Inherit;True;Property;_Layer4_BaseColor;Layer4_BaseColor;19;0;Create;True;0;0;False;0;False;-1;None;87c216936b76489438803719b1cd7df1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-1533.91,2789.308;Inherit;False;Layer4_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-400.1227,947.5696;Inherit;False;112;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;42;-1908.678,2159.636;Inherit;True;Property;_Layer3_Normal;Layer3_Normal;16;0;Create;True;0;0;False;0;False;-1;None;a624cf88c42842d41a00ee64a6ec5a6d;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;154;-455.5864,1891.714;Inherit;False;1236.335;596.8286;Normal;12;152;151;147;146;145;148;144;149;150;153;194;195;Normal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;56;-505.05,69.18512;Inherit;False;1154.524;538.8975;BaseColor;11;54;121;118;119;120;114;117;48;49;115;178;BaseColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;143;-452.25,1325.649;Inherit;False;1222.335;555.8287;AO;12;141;140;136;134;135;138;137;133;139;142;190;191;AO;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;29;-1906.229,947.1718;Inherit;True;Property;_Layer2_BaseColor;Layer2_BaseColor;9;0;Create;True;0;0;False;0;False;-1;None;d40d103b99fa9584ab5439aca118ffaf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-1512.91,2990.308;Inherit;False;Layer4_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-1536.676,1959.668;Inherit;False;Layer3_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-1527.676,2060.668;Inherit;False;Layer3_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1916.781,132.8616;Inherit;True;Property;_Layer1_BaseColor;Layer1_BaseColor;4;0;Create;True;0;0;False;0;False;-1;None;a51e35cd577187f4ebc43215c0a8fd71;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;30;-1903.367,1393.36;Inherit;True;Property;_Layer2_Normal;Layer2_Normal;11;0;Create;True;0;0;False;0;False;-1;None;047fcc97941555f4a9ec6313d17db43e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;177;-1524.91,2890.308;Inherit;False;Layer4_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1425.893,423.8301;Inherit;False;Layer1_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-402.25,1526.671;Inherit;False;112;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1546.365,1204.392;Inherit;False;Layer2_Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;40;-1911.54,1713.448;Inherit;True;Property;_Layer3_BaseColor;Layer3_BaseColor;14;0;Create;True;0;0;False;0;False;-1;None;79cdfdd3029b5f24daa5bd72fd5ae2c0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;122;-219.771,943.576;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;153;-405.5863,2092.736;Inherit;False;112;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;6;-1913.92,579.0495;Inherit;True;Property;_Layer1_Normal;Layer1_Normal;6;0;Create;True;0;0;False;0;False;-1;None;dcaefaeab85f0be409c91786faebb73b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;187;25.63959,1168.009;Inherit;False;174;Layer4_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1515.676,2160.668;Inherit;False;Layer3_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-479.2608,255.2073;Inherit;False;112;BlendWeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-1543.91,2555.308;Inherit;False;Layer4_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;22.10163,1633.678;Inherit;False;46;Layer3_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1431.73,527.712;Inherit;False;Layer1_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1551.918,145.0812;Inherit;False;Layer1_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1534.918,611.0812;Inherit;False;Layer1_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1524.365,1425.392;Inherit;False;Layer2_Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;253.6396,1185.009;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;20.22885,1034.576;Inherit;False;45;Layer3_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;144;-225.2347,2088.741;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1541.365,959.3914;Inherit;False;Layer2_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1530.365,1292.392;Inherit;False;Layer2_AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;18.76523,2199.742;Inherit;False;47;Layer3_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;117;-298.9092,251.2137;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;133;-221.8983,1522.678;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;127;25.93253,796.5472;Inherit;False;14;Layer1_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;26.81272,920.7394;Inherit;False;31;Layer2_Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-1546.676,1725.668;Inherit;False;Layer3_BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;25.11816,1772.722;Inherit;False;177;Layer4_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;194;21.79639,2313.229;Inherit;False;175;Layer4_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;178;-75.71036,521.1752;Inherit;False;176;Layer4_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;253.1016,1668.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;189;382.6396,1109.009;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;250.2289,957.576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-52.32544,228.3773;Inherit;False;34;Layer2_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;24.68549,1499.841;Inherit;False;33;Layer2_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;257.7964,2365.229;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;249.1182,1777.722;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;-54.90929,362.2135;Inherit;False;43;Layer3_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;250.2289,1067.576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;21.34909,2065.906;Inherit;False;32;Layer2_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;186.3459,510.8375;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;23.80527,1375.649;Inherit;False;15;Layer1_AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;264.2289,853.5759;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;249.7653,2234.742;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;20.46888,1941.714;Inherit;False;16;Layer1_Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-53.20564,104.1851;Inherit;False;11;Layer1_BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;185.0908,161.2138;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;248.1017,1536.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;262.1016,1432.678;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;192;346.1182,1640.722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;171.0908,265.2137;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;197;365.7964,2205.229;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;186;345.7617,451.147;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;258.7654,1998.742;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;176.0908,397.2135;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;244.7653,2102.741;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;196;339.7964,2195.229;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;400.1992,947.049;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;193;392.1182,1719.722;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;380.0611,272.6868;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;517.4127,875.8395;Inherit;False;Roughness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;151;394.7356,2092.215;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;398.0719,1526.151;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;438.2745,183.4773;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;511.949,2021.006;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;721.7692,255.5625;Inherit;False;130;Roughness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;141;515.2853,1454.941;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;898.7693,182.5625;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;802.3428,7.795639;Inherit;False;54;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;893.7693,331.5626;Inherit;False;141;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;21;899.7693,255.5625;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;836.6624,109.9835;Inherit;False;152;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomStandardSurface;1;1183.036,157.7946;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;165;-537.1476,2810.455;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1456.466,52.27184;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;MaterialBlend;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;27;0;25;0
WireConnection;27;1;26;0
WireConnection;169;0;168;0
WireConnection;169;1;167;0
WireConnection;28;1;27;0
WireConnection;5;1;8;0
WireConnection;38;0;37;0
WireConnection;38;1;39;0
WireConnection;41;1;38;0
WireConnection;170;1;169;0
WireConnection;200;7;28;1
WireConnection;200;3;201;0
WireConnection;198;7;5;1
WireConnection;198;3;199;0
WireConnection;204;7;170;1
WireConnection;204;3;205;0
WireConnection;13;0;198;0
WireConnection;202;7;41;1
WireConnection;202;3;203;0
WireConnection;162;1;163;0
WireConnection;35;0;200;0
WireConnection;164;0;162;0
WireConnection;44;0;202;0
WireConnection;171;0;204;0
WireConnection;157;0;160;0
WireConnection;157;1;164;1
WireConnection;156;0;159;0
WireConnection;156;1;164;0
WireConnection;95;0;156;0
WireConnection;95;1;157;0
WireConnection;181;0;180;0
WireConnection;181;1;164;3
WireConnection;158;0;161;0
WireConnection;158;1;164;2
WireConnection;183;0;181;0
WireConnection;96;0;95;0
WireConnection;96;1;158;0
WireConnection;182;0;96;0
WireConnection;182;1;183;0
WireConnection;97;0;182;0
WireConnection;97;1;98;0
WireConnection;101;0;158;0
WireConnection;101;1;97;0
WireConnection;184;0;181;0
WireConnection;184;1;97;0
WireConnection;100;0;157;0
WireConnection;100;1;97;0
WireConnection;99;0;156;0
WireConnection;99;1;97;0
WireConnection;106;0;100;0
WireConnection;105;0;99;0
WireConnection;107;0;101;0
WireConnection;185;0;184;0
WireConnection;110;0;105;0
WireConnection;110;1;106;0
WireConnection;110;2;107;0
WireConnection;110;3;185;0
WireConnection;109;0;105;0
WireConnection;109;1;106;0
WireConnection;109;2;107;0
WireConnection;109;3;185;0
WireConnection;111;0;109;0
WireConnection;111;1;110;0
WireConnection;112;0;111;0
WireConnection;172;1;169;0
WireConnection;173;1;169;0
WireConnection;174;0;170;2
WireConnection;42;1;38;0
WireConnection;29;1;27;0
WireConnection;175;0;172;0
WireConnection;45;0;41;2
WireConnection;46;0;41;3
WireConnection;2;1;8;0
WireConnection;30;1;27;0
WireConnection;177;0;170;3
WireConnection;14;0;5;2
WireConnection;31;0;28;2
WireConnection;40;1;38;0
WireConnection;122;0;131;0
WireConnection;6;1;8;0
WireConnection;47;0;42;0
WireConnection;176;0;173;0
WireConnection;15;0;5;3
WireConnection;11;0;2;0
WireConnection;16;0;6;0
WireConnection;32;0;30;0
WireConnection;188;0;122;3
WireConnection;188;1;187;0
WireConnection;144;0;153;0
WireConnection;34;0;29;0
WireConnection;33;0;28;3
WireConnection;117;0;115;0
WireConnection;133;0;142;0
WireConnection;43;0;40;0
WireConnection;136;0;137;0
WireConnection;136;1;133;2
WireConnection;189;0;188;0
WireConnection;124;0;128;0
WireConnection;124;1;122;1
WireConnection;195;0;194;0
WireConnection;195;1;144;3
WireConnection;191;0;133;3
WireConnection;191;1;190;0
WireConnection;125;0;126;0
WireConnection;125;1;122;2
WireConnection;179;0;117;3
WireConnection;179;1;178;0
WireConnection;123;0;127;0
WireConnection;123;1;122;0
WireConnection;147;0;148;0
WireConnection;147;1;144;2
WireConnection;118;0;48;0
WireConnection;118;1;117;0
WireConnection;135;0;139;0
WireConnection;135;1;133;1
WireConnection;134;0;138;0
WireConnection;134;1;133;0
WireConnection;192;0;136;0
WireConnection;119;0;49;0
WireConnection;119;1;117;1
WireConnection;197;0;195;0
WireConnection;186;0;179;0
WireConnection;145;0;149;0
WireConnection;145;1;144;0
WireConnection;120;0;114;0
WireConnection;120;1;117;2
WireConnection;146;0;150;0
WireConnection;146;1;144;1
WireConnection;196;0;147;0
WireConnection;129;0;123;0
WireConnection;129;1;124;0
WireConnection;129;2;125;0
WireConnection;129;3;189;0
WireConnection;193;0;191;0
WireConnection;121;0;118;0
WireConnection;121;1;119;0
WireConnection;121;2;120;0
WireConnection;121;3;186;0
WireConnection;130;0;129;0
WireConnection;151;0;145;0
WireConnection;151;1;146;0
WireConnection;151;2;196;0
WireConnection;151;3;197;0
WireConnection;140;0;134;0
WireConnection;140;1;135;0
WireConnection;140;2;192;0
WireConnection;140;3;193;0
WireConnection;54;0;121;0
WireConnection;152;0;151;0
WireConnection;141;0;140;0
WireConnection;21;0;20;0
WireConnection;1;0;55;0
WireConnection;1;1;23;0
WireConnection;1;3;22;0
WireConnection;1;4;21;0
WireConnection;1;5;19;0
WireConnection;0;13;1;0
ASEEND*/
//CHKSM=00D27F42F77ACC7C9D580A41B02BB5809B54C766