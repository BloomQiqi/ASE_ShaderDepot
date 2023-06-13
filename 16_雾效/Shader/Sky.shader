// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sky"
{
	Properties
	{
		[HDR]_HDR("HDR", 2D) = "white" {}
		_FogIntensity("FogIntensity", Range( 0 , 1)) = 0
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogHeightStart("Fog Height Start", Range( 0 , 1)) = 0
		_FogHeightEnd("Fog Height End", Range( 0 , 1)) = 0
		_SunFogColor("SunFogColor", Color) = (0,0,0,0)
		_SunFogIntensity("Sun Fog Intensity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			float3 worldPos;
		};

		uniform sampler2D _HDR;
		uniform float4 _HDR_ST;
		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		uniform float _SunFogIntensity;
		uniform float _FogHeightEnd;
		uniform float _FogHeightStart;
		uniform float _FogIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_HDR = i.uv_texcoord * _HDR_ST.xy + _HDR_ST.zw;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult33 = dot( -i.viewDir , ase_worldlightDir );
			float clampResult50 = clamp( pow( (dotResult33*0.5 + 0.5) , 10.0 ) , 0.0 , 1.0 );
			float SunFog52 = ( clampResult50 * _SunFogIntensity );
			float4 lerpResult24 = lerp( _FogColor , _SunFogColor , SunFog52);
			float temp_output_11_0_g2 = _FogHeightEnd;
			float3 objToWorld53 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float3 normalizeResult55 = normalize( ( ase_worldPos - objToWorld53 ) );
			float FogHeight48 = ( 1.0 - ( 1.0 - ( ( temp_output_11_0_g2 - (normalizeResult55).y ) / ( temp_output_11_0_g2 - _FogHeightStart ) ) ) );
			float clampResult25 = clamp( ( FogHeight48 * _FogIntensity ) , 0.0 , 1.0 );
			float4 lerpResult26 = lerp( tex2D( _HDR, uv_HDR ) , lerpResult24 , clampResult25);
			o.Emission = lerpResult26.rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
-262.4;316;1523;560;4168.24;-264.2444;3.603862;True;False
Node;AmplifyShaderEditor.CommentaryNode;9;-3085.146,878.4109;Inherit;False;1372.435;541.5806;Fog Horizon;10;54;53;35;48;45;38;36;32;55;56;Fog Horizon;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-3066.018,1456.115;Inherit;False;1465.565;454.4534;SunFog;11;52;51;50;49;46;42;40;33;31;30;29;SunFog;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;29;-3016.018,1506.115;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;53;-3058.724,1179.87;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;35;-3029.948,1013.652;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;30;-2964.25,1674.014;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;31;-2836.175,1545.261;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;-2834.724,1109.87;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;33;-2694.374,1594.27;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;55;-2691.015,1115.405;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2700.496,1021.313;Inherit;False;Property;_FogHeightEnd;Fog Height End;4;0;Create;True;0;0;False;0;False;0;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;56;-2542.158,1117.281;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2603.654,1745.968;Inherit;False;Constant;_SunFogRange;Sun Fog Range;6;0;Create;True;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2696.618,931.6432;Inherit;False;Property;_FogHeightStart;Fog Height Start;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;40;-2531.857,1593.138;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;46;-2325.815,1639.401;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;38;-2324.783,1044.688;Inherit;False;FogLinear;-1;;2;9cf027ca7e5344b4a8e390a553d102eb;0;3;12;FLOAT;0;False;11;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-2085.088,1077.364;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2283.253,1795.17;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;6;0;Create;True;0;0;False;0;False;1;1.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;50;-2160.454,1643.569;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;11;-1531.544,851.621;Inherit;False;1021.879;763.9537;FogCombine;9;26;25;24;20;19;18;17;16;13;FogCombine;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1985.054,1663.77;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-1931.547,1026.754;Inherit;False;FogHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;-1266.922,1401.904;Inherit;False;48;FogHeight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-1825.255,1661.769;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1276.147,1500.175;Inherit;False;Property;_FogIntensity;FogIntensity;1;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-942.2646,1427.714;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-1481.544,1088.877;Inherit;False;Property;_SunFogColor;SunFogColor;5;0;Create;True;0;0;False;0;False;0,0,0,0;0.6313726,0.572549,0.8352942,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;17;-1179.77,1182.456;Inherit;False;52;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-1399.462,901.6209;Inherit;False;Property;_FogColor;FogColor;2;0;Create;True;0;0;False;0;False;0,0,0,0;0.2156863,0.4627451,0.8627452,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1333.36,482.9916;Inherit;False;0;5;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;25;-837.7303,1276.562;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1026.365,457.7671;Inherit;True;Property;_HDR;HDR;0;1;[HDR];Create;True;0;0;False;0;False;-1;None;36f26b379a20f9e41af29996d16e8202;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;24;-908.8777,1104.436;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;26;-691.6641,988.6382;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;57;30.72606,639.9081;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sky;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;31;0;29;0
WireConnection;54;0;35;0
WireConnection;54;1;53;0
WireConnection;33;0;31;0
WireConnection;33;1;30;0
WireConnection;55;0;54;0
WireConnection;56;0;55;0
WireConnection;40;0;33;0
WireConnection;46;0;40;0
WireConnection;46;1;42;0
WireConnection;38;12;36;0
WireConnection;38;11;32;0
WireConnection;38;10;56;0
WireConnection;45;0;38;0
WireConnection;50;0;46;0
WireConnection;51;0;50;0
WireConnection;51;1;49;0
WireConnection;48;0;45;0
WireConnection;52;0;51;0
WireConnection;20;0;13;0
WireConnection;20;1;16;0
WireConnection;25;0;20;0
WireConnection;5;1;6;0
WireConnection;24;0;18;0
WireConnection;24;1;19;0
WireConnection;24;2;17;0
WireConnection;26;0;5;0
WireConnection;26;1;24;0
WireConnection;26;2;25;0
WireConnection;57;2;26;0
ASEEND*/
//CHKSM=EAC4C8779002137457D03B832941772C0C1675BC