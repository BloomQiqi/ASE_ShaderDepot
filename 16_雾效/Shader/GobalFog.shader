// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GobalFog"
{
	Properties
	{
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogIntensity("FogIntensity", Range( 0 , 1)) = 0
		_FogDistanceStart("Fog Distance Start", Float) = 0
		_FogDistanceEnd("Fog Distance End", Float) = 0
		_FogMonHeightStart("Fog Mon Height Start", Float) = 0
		_FogMonHeightEnd("Fog Mon Height End", Float) = 0
		_FogSkyHeightStart("Fog Sky Height Start", Range( 0 , 1)) = 0
		_FogSkyHeightEnd("Fog Sky Height End", Range( 0 , 1)) = 0
		_SunFogColor("SunFogColor", Color) = (0,0,0,0)
		_SunFogRange("Sun Fog Range", Float) = 10
		_SunFogIntensity("Sun Fog Intensity", Float) = 1
		_IsSky("IsSky", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
		};

		uniform float4 _FogColor;
		uniform float4 _SunFogColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _SunFogRange;
		uniform float _SunFogIntensity;
		uniform float _FogDistanceEnd;
		uniform float _FogDistanceStart;
		uniform float _IsSky;
		uniform float _FogSkyHeightEnd;
		uniform float _FogSkyHeightStart;
		uniform float _FogMonHeightEnd;
		uniform float _FogMonHeightStart;
		uniform float _FogIntensity;


		float2 UnStereo( float2 UV )
		{
			#if UNITY_SINGLE_PASS_STEREO
			float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
			UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
			#endif
			return UV;
		}


		float3 InvertDepthDir72_g4( float3 In )
		{
			float3 result = In;
			#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
			result *= float3(1,1,-1);
			#endif
			return result;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 UV22_g5 = ase_screenPosNorm.xy;
			float2 localUnStereo22_g5 = UnStereo( UV22_g5 );
			float2 break64_g4 = localUnStereo22_g5;
			float clampDepth69_g4 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g4 = ( 1.0 - clampDepth69_g4 );
			#else
				float staticSwitch38_g4 = clampDepth69_g4;
			#endif
			float3 appendResult39_g4 = (float3(break64_g4.x , break64_g4.y , staticSwitch38_g4));
			float4 appendResult42_g4 = (float4((appendResult39_g4*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g4 = mul( unity_CameraInvProjection, appendResult42_g4 );
			float3 In72_g4 = ( (temp_output_43_0_g4).xyz / (temp_output_43_0_g4).w );
			float3 localInvertDepthDir72_g4 = InvertDepthDir72_g4( In72_g4 );
			float4 appendResult49_g4 = (float4(localInvertDepthDir72_g4 , 1.0));
			float4 WorldPosFromDepth45 = mul( unity_CameraToWorld, appendResult49_g4 );
			float4 normalizeResult56 = normalize( ( WorldPosFromDepth45 - float4( _WorldSpaceCameraPos , 0.0 ) ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult9 = dot( normalizeResult56 , float4( ase_worldlightDir , 0.0 ) );
			float clampResult25 = clamp( pow( (dotResult9*0.5 + 0.5) , _SunFogRange ) , 0.0 , 1.0 );
			float SunFog31 = ( clampResult25 * _SunFogIntensity );
			float4 lerpResult41 = lerp( _FogColor , _SunFogColor , SunFog31);
			o.Emission = lerpResult41.rgb;
			float temp_output_11_0_g14 = _FogDistanceEnd;
			float FogDistance23 = ( 1.0 - ( ( temp_output_11_0_g14 - distance( WorldPosFromDepth45 , float4( _WorldSpaceCameraPos , 0.0 ) ) ) / ( temp_output_11_0_g14 - _FogDistanceStart ) ) );
			float3 worldToView77 = mul( UNITY_MATRIX_V, float4( WorldPosFromDepth45.xyz, 1 ) ).xyz;
			float IsSky82 = step( _IsSky , worldToView77.z );
			float temp_output_11_0_g12 = _FogSkyHeightEnd;
			float3 objToWorld73 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float4 normalizeResult74 = normalize( ( WorldPosFromDepth45 - float4( objToWorld73 , 0.0 ) ) );
			float temp_output_11_0_g13 = _FogMonHeightEnd;
			float FogHeight24 = ( 1.0 - ( 0.0 == IsSky82 ? ( ( 1.0 - ( ( temp_output_11_0_g12 - ( (normalizeResult74).y - -0.58 ) ) / ( temp_output_11_0_g12 - _FogSkyHeightStart ) ) ) / 1.75 ) : ( 1.0 - ( ( temp_output_11_0_g13 - (WorldPosFromDepth45).y ) / ( temp_output_11_0_g13 - _FogMonHeightStart ) ) ) ) );
			float clampResult40 = clamp( ( ( FogDistance23 * FogHeight24 ) * _FogIntensity ) , 0.0 , 1.0 );
			o.Alpha = clampResult40;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

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
				float3 worldPos : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
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
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.worldPos = worldPos;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
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
252;702.6667;1725.333;961.6667;3809.106;-243.8392;1.911652;False;True
Node;AmplifyShaderEditor.CommentaryNode;46;-3755.838,165.6808;Inherit;False;687.6648;165.4;WorldPosFromDepth;2;44;45;WorldPosFromDepth;0.2651744,0.6525087,0.9528302,1;0;0
Node;AmplifyShaderEditor.FunctionNode;44;-3703.838,221.8426;Inherit;False;Reconstruct World Position From Depth;-1;;4;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-3337.012,202.4224;Inherit;False;WorldPosFromDepth;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;78;-3018.43,-30.28162;Inherit;False;1663.564;732.9605;FogHeight;22;60;24;51;68;17;19;70;59;77;52;75;71;11;8;69;74;72;73;82;88;93;94;FogHeight;0.8490566,0.484603,0.484603,1;0;0
Node;AmplifyShaderEditor.TransformPositionNode;73;-2958.961,439.6327;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2940.759,177.8341;Inherit;False;45;WorldPosFromDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;72;-2747.159,379.079;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;1;-3115.416,816.7262;Inherit;False;1718.565;451.4534;SunFog;13;55;53;56;54;9;6;31;28;26;25;21;18;15;SunFog;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;74;-2649.259,520.8793;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;55;-3067.659,986.7422;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;53;-3052.659,890.7422;Inherit;False;45;WorldPosFromDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-2620.573,654.6013;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;False;0;False;-0.58;-0.5871438;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;75;-2493.959,581.7618;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;77;-2670.326,64.12413;Inherit;False;World;View;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;54;-2808.659,941.7422;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2499.768,491.2878;Inherit;False;Property;_FogSkyHeightEnd;Fog Sky Height End;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-2344.253,602.4694;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2503.746,411.7326;Inherit;False;Property;_FogSkyHeightStart;Fog Sky Height Start;7;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2467.706,46.24479;Inherit;False;Property;_IsSky;IsSky;12;0;Create;True;0;0;False;0;False;0;-778.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;70;-2159.484,448.0641;Inherit;False;FogLinear;-1;;12;9cf027ca7e5344b4a8e390a553d102eb;0;3;12;FLOAT;0;False;11;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2393.585,183.8567;Inherit;False;Property;_FogMonHeightStart;Fog Mon Height Start;5;0;Create;True;0;0;False;0;False;0;-100.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2416.607,282.3123;Inherit;False;Property;_FogMonHeightEnd;Fog Mon Height End;6;0;Create;True;0;0;False;0;False;0;178.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;59;-2277.135,41.35845;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;3;-2913.222,-548.5557;Inherit;False;1197.678;479.4176;Fog Distance;7;23;20;16;14;13;7;47;Fog Distance;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;52;-2663.716,229.8863;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-2078.622,598.1708;Inherit;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;False;0;False;1.75;1.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;6;-2786.648,1097.624;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;56;-2662.693,950.8962;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;9;-2481.772,1006.881;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;93;-1912.009,511.4034;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;-2115.431,65.79553;Inherit;False;IsSky;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;17;-2165.125,188.688;Inherit;False;FogLinear;-1;;13;9cf027ca7e5344b4a8e390a553d102eb;0;3;12;FLOAT;0;False;11;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;7;-2863.222,-228.511;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2832.299,-436.6055;Inherit;False;45;WorldPosFromDepth;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2525.247,-402.8851;Inherit;False;Property;_FogDistanceEnd;Fog Distance End;4;0;Create;True;0;0;False;0;False;0;613.95;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;16;-2590.699,-297.5464;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2523.369,-498.5557;Inherit;False;Property;_FogDistanceStart;Fog Distance Start;3;0;Create;True;0;0;False;0;False;0;113.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2400.053,1106.579;Inherit;False;Property;_SunFogRange;Sun Fog Range;10;0;Create;True;0;0;False;0;False;10;15.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;68;-1919.484,100.5536;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;15;-2328.256,953.7483;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;19;-1760.088,112.8365;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;20;-2319.533,-394.5101;Inherit;False;FogLinear;-1;;14;9cf027ca7e5344b4a8e390a553d102eb;0;3;12;FLOAT;0;False;11;FLOAT;0;False;10;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-2122.214,1000.011;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1611.03,111.485;Inherit;False;FogHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2036.296,-400.4445;Inherit;False;FogDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;22;-1227.469,-660.6294;Inherit;False;1021.879;763.9537;FogCombine;10;41;40;38;37;36;34;32;30;29;27;FogCombine;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-2079.652,1155.78;Inherit;False;Property;_SunFogIntensity;Sun Fog Intensity;11;0;Create;True;0;0;False;0;False;1;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;25;-1956.852,1004.179;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-963.0736,-222.3781;Inherit;False;23;FogDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1781.452,1024.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-962.8476,-110.3467;Inherit;False;24;FogHeight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-649.2582,-157.5766;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-972.0725,-12.07568;Inherit;False;Property;_FogIntensity;FogIntensity;1;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1621.652,1022.379;Inherit;False;SunFog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;37;-1075.387,-600.8868;Inherit;False;Property;_FogColor;FogColor;0;0;Create;True;0;0;False;0;False;0,0,0,0;0.259434,0.5590523,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;36;-1177.469,-423.3734;Inherit;False;Property;_SunFogColor;SunFogColor;9;0;Create;True;0;0;False;0;False;0,0,0,0;0.9716981,0.6473894,0.3911237,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-528.6237,-58.37132;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-809.3956,-411.6945;Inherit;True;31;SunFog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;41;-557.8693,-518.9245;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-887.6176,-987.3844;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;80;-537.4866,-961.0989;Inherit;True;Property;_HDR;HDR;2;1;[HDR];Create;True;0;0;False;0;False;-1;None;36f26b379a20f9e41af29996d16e8202;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;84;-119.038,160.3369;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;40;-409.3714,-191.5344;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;130.0038,-587.6398;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;GobalFog;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;44;0
WireConnection;72;0;51;0
WireConnection;72;1;73;0
WireConnection;74;0;72;0
WireConnection;75;0;74;0
WireConnection;77;0;51;0
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;88;0;75;0
WireConnection;88;1;85;0
WireConnection;70;12;69;0
WireConnection;70;11;71;0
WireConnection;70;10;88;0
WireConnection;59;0;60;0
WireConnection;59;1;77;3
WireConnection;52;0;51;0
WireConnection;56;0;54;0
WireConnection;9;0;56;0
WireConnection;9;1;6;0
WireConnection;93;0;70;0
WireConnection;93;1;94;0
WireConnection;82;0;59;0
WireConnection;17;12;8;0
WireConnection;17;11;11;0
WireConnection;17;10;52;0
WireConnection;16;0;47;0
WireConnection;16;1;7;0
WireConnection;68;1;82;0
WireConnection;68;2;93;0
WireConnection;68;3;17;0
WireConnection;15;0;9;0
WireConnection;19;0;68;0
WireConnection;20;12;13;0
WireConnection;20;11;14;0
WireConnection;20;10;16;0
WireConnection;21;0;15;0
WireConnection;21;1;18;0
WireConnection;24;0;19;0
WireConnection;23;0;20;0
WireConnection;25;0;21;0
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;32;0;29;0
WireConnection;32;1;27;0
WireConnection;31;0;28;0
WireConnection;38;0;32;0
WireConnection;38;1;30;0
WireConnection;41;0;37;0
WireConnection;41;1;36;0
WireConnection;41;2;34;0
WireConnection;80;1;79;0
WireConnection;40;0;38;0
WireConnection;0;2;41;0
WireConnection;0;9;40;0
ASEEND*/
//CHKSM=E9956AE44BE6306D1E629347C8CDD2077E065F01