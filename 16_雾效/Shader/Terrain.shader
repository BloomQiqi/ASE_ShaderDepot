// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Terrain"
{
	Properties
	{
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 0
		_FogHeightStart("Fog Height Start", Float) = 0
		_FogHeightEnd("Fog Height End", Float) = 0
		_Smothness("Smothness", Range( 0 , 1)) = 0.5
		_SunFogColor("SunFogColor", Color) = (0,0,0,0)
		_SunFogIntensity("Sun Fog Intensity", Float) = 1
		_FogIntensity("FogIntensity", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float3 viewDir;
			float3 worldPos;
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

		uniform float _Smothness;
		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		uniform float _SunFogIntensity;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _FogHeightEnd;
		uniform float _FogHeightStart;
		uniform float _FogIntensity;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = i.worldNormal;
			Unity_GlossyEnvironmentData g1 = UnityGlossyEnvironmentSetup( _Smothness, data.worldViewDir, ase_worldNormal, float3(0,0,0));
			float3 indirectSpecular1 = UnityGI_IndirectSpecular( data, 1.0, ase_worldNormal, g1 );
			float4 color4 = IsGammaSpace() ? float4(0.3113208,0.3113208,0.3113208,1) : float4(0.07896996,0.07896996,0.07896996,1);
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult40 = dot( -i.viewDir , ase_worldlightDir );
			float clampResult44 = clamp( pow( (dotResult40*0.5 + 0.5) , 10.0 ) , 0.0 , 1.0 );
			float SunFog47 = ( clampResult44 * _SunFogIntensity );
			float4 lerpResult52 = lerp( _FogColor , _SunFogColor , SunFog47);
			float temp_output_11_0_g3 = _FogDistanceEnd;
			float FogDistance22 = ( 1.0 - ( ( temp_output_11_0_g3 - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( temp_output_11_0_g3 - _FogDistanceStart ) ) );
			float temp_output_11_0_g2 = _FogHeightEnd;
			float FogHeight29 = ( 1.0 - ( 1.0 - ( ( temp_output_11_0_g2 - ase_worldPos.y ) / ( temp_output_11_0_g2 - _FogHeightStart ) ) ) );
			float clampResult35 = clamp( ( ( FogDistance22 * FogHeight29 ) * _FogIntensity ) , 0.0 , 1.0 );
			float4 lerpResult16 = lerp( ( float4( indirectSpecular1 , 0.0 ) * color4 ) , lerpResult52 , clampResult35);
			c.rgb = lerpResult16.rgb;
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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
611.2;223.2;1523;623;1627.675;444.1582;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;50;-2707.981,1473.747;Inherit;False;1465.565;454.4534;SunFog;11;38;49;40;39;41;43;42;44;45;46;47;SunFog;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;38;-2657.981,1523.747;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;21;-2622.095,192.3982;Inherit;False;1197.678;479.4176;Fog Distance;7;15;9;8;7;6;5;22;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.NegateNode;49;-2478.138,1562.893;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2585.814,860.397;Inherit;False;1197.678;479.4176;Fog Height;6;25;28;29;30;31;33;Fog Height;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;39;-2606.213,1691.645;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;6;-2572.095,512.4429;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;30;-2213.043,931.6291;Inherit;False;Property;_FogHeightStart;Fog Height Start;3;0;Create;True;0;0;False;0;False;0;-79.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;40;-2336.337,1611.902;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-2514.571,326.4075;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;31;-2201.921,1014.299;Inherit;False;Property;_FogHeightEnd;Fog Height End;4;0;Create;True;0;0;False;0;False;0;108.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;25;-2419.373,1087.638;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;9;-2232.242,242.3982;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;1;0;Create;True;0;0;False;0;False;0;52.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2234.12,338.0688;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;2;0;Create;True;0;0;False;0;False;0;613.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;41;-2173.82,1610.769;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;7;-2299.572,443.4075;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;28;-2000.208,1026.674;Inherit;False;FogLinear;-1;;2;9cf027ca7e5344b4a8e390a553d102eb;0;3;12;FLOAT;0;False;11;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2245.617,1763.6;Inherit;False;Constant;_SunFogRange;Sun Fog Range;6;0;Create;True;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;33;-1760.513,1059.351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;15;-2029.406,346.4438;Inherit;False;FogLinear;-1;;3;9cf027ca7e5344b4a8e390a553d102eb;0;3;12;FLOAT;0;False;11;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;42;-1967.778,1657.032;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-936.3428,80.32445;Inherit;False;1021.879;763.9537;FogCombine;11;52;51;14;53;23;32;34;55;54;35;16;FogCombine;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1745.169,340.5093;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-1606.971,1008.74;Inherit;False;FogHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;44;-1802.417,1661.2;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1925.216,1812.801;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;7;0;Create;True;0;0;False;0;False;1;0.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-671.721,630.6072;Inherit;False;29;FogHeight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1627.016,1681.401;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-671.947,518.5758;Inherit;False;22;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-680.9459,728.8782;Inherit;False;Property;_FogIntensity;FogIntensity;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-1467.216,1679.4;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-451.6985,563.024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1225.575,-307.96;Inherit;False;Property;_Smothness;Smothness;5;0;Create;True;0;0;False;0;False;0.5;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-584.5689,411.1593;Inherit;False;47;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-854.5742,-149.9595;Inherit;False;Constant;_Color0;Color 0;1;0;Create;True;0;0;False;0;False;0.3113208,0.3113208,0.3113208,1;0.4433962,0.4433962,0.4433962,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;51;-886.3428,317.5804;Inherit;False;Property;_SunFogColor;SunFogColor;6;0;Create;True;0;0;False;0;False;0,0,0,0;0.7649129,0.572549,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectSpecularLight;1;-869.5742,-322.9601;Inherit;False;Tangent;3;0;FLOAT3;0,0,1;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;14;-804.2607,130.3244;Inherit;False;Property;_FogColor;FogColor;0;0;Create;True;0;0;False;0;False;0,0,0,0;0.259434,0.5590523,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-347.064,656.4173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-570.5742,-231.9597;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;35;-242.5296,505.2656;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;-313.677,333.1394;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;367.3019,217.6595;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;16;-96.46358,217.3417;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;726,-18;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Terrain;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;0;38;0
WireConnection;40;0;49;0
WireConnection;40;1;39;0
WireConnection;41;0;40;0
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;28;12;30;0
WireConnection;28;11;31;0
WireConnection;28;10;25;2
WireConnection;33;0;28;0
WireConnection;15;12;9;0
WireConnection;15;11;8;0
WireConnection;15;10;7;0
WireConnection;42;0;41;0
WireConnection;42;1;43;0
WireConnection;22;0;15;0
WireConnection;29;0;33;0
WireConnection;44;0;42;0
WireConnection;45;0;44;0
WireConnection;45;1;46;0
WireConnection;47;0;45;0
WireConnection;34;0;23;0
WireConnection;34;1;32;0
WireConnection;1;1;2;0
WireConnection;54;0;34;0
WireConnection;54;1;55;0
WireConnection;3;0;1;0
WireConnection;3;1;4;0
WireConnection;35;0;54;0
WireConnection;52;0;14;0
WireConnection;52;1;51;0
WireConnection;52;2;53;0
WireConnection;57;0;16;0
WireConnection;57;1;16;0
WireConnection;16;0;3;0
WireConnection;16;1;52;0
WireConnection;16;2;35;0
WireConnection;0;13;16;0
ASEEND*/
//CHKSM=8BD227FF33E0E4D3B0DB070B48D9642F18D659BF