// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_ReflectionTex("ReflectionTex", 2D) = "white" {}
		_WaterNormal("WaterNormal", 2D) = "bump" {}
		_NormalTilling("NormalTilling", Float) = 8
		_TextureSample2("Texture Sample 2", 2D) = "bump" {}
		_WaterSpeed("WaterSpeed", Float) = 0
		_WaterNoise("WaterNoise", Float) = 1
		_SpecSmoothness("SpecSmoothness", Range( 0.001 , 1)) = 0.1
		_SpecTint("SpecTint", Color) = (0,0,0,0)
		_SpecIntensity("SpecIntensity", Float) = 1
		_SpecEnd("SpecEnd", Float) = 0
		_SpecStart("SpecStart", Float) = 0
		_UnderWaterColor("UnderWaterColor", 2D) = "white" {}
		_UnderWaterTilling("UnderWaterTilling", Float) = 4
		_WaterDepth("WaterDepth", Float) = -1
		_NormaIntensity("NormaIntensity", Float) = 0
		_BlinkTilling("BlinkTilling", Float) = 8
		_BlinkNoise("BlinkNoise", Float) = 1
		_BlinkSpeed("BlinkSpeed", Float) = 0
		_BlinkIntensity("BlinkIntensity", Float) = 0
		_BlinkThreshold("BlinkThreshold", Float) = 2
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
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
			float3 worldPos;
			float4 screenPos;
		};

		uniform sampler2D _WaterNormal;
		uniform float _NormalTilling;
		uniform float _WaterSpeed;
		uniform float _NormaIntensity;
		uniform float _SpecSmoothness;
		uniform float4 _SpecTint;
		uniform float _SpecIntensity;
		uniform float _SpecEnd;
		uniform float _SpecStart;
		uniform sampler2D _UnderWaterColor;
		uniform float _UnderWaterTilling;
		uniform float _WaterDepth;
		uniform sampler2D _ReflectionTex;
		uniform float _WaterNoise;
		uniform float _BlinkNoise;
		uniform sampler2D _TextureSample2;
		uniform float _BlinkTilling;
		uniform float _BlinkSpeed;
		uniform float _BlinkThreshold;
		uniform float _BlinkIntensity;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldPos = i.worldPos;
			float2 temp_output_14_0 = ( (ase_worldPos).xz / _NormalTilling );
			float temp_output_10_0 = ( _Time.y * 0.1 * _WaterSpeed );
			float2 temp_output_35_0 = ( (( UnpackScaleNormal( tex2D( _WaterNormal, ( temp_output_14_0 + temp_output_10_0 ) ), _NormaIntensity ) + UnpackScaleNormal( tex2D( _WaterNormal, ( ( temp_output_14_0 * 1.3 ) + ( temp_output_10_0 * -1.2 ) ) ), _NormaIntensity ) )).xy * 0.5 );
			float dotResult37 = dot( temp_output_35_0 , temp_output_35_0 );
			float3 appendResult41 = (float3(temp_output_35_0 , sqrt( ( 1.0 - dotResult37 ) )));
			float3 WaterWorldNormal43 = (WorldNormalVector( i , appendResult41 ));
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult56 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float dotResult58 = dot( WaterWorldNormal43 , normalizeResult56 );
			float clampResult85 = clamp( ( ( _SpecEnd - distance( ase_worldPos , _WorldSpaceCameraPos ) ) / ( _SpecEnd - _SpecStart ) ) , 0.0 , 1.0 );
			float4 SpecColor68 = ( ( pow( max( dotResult58 , 0.0 ) , ( _SpecSmoothness * 256.0 ) ) * _SpecTint ) * _SpecIntensity * clampResult85 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_tanViewDir = mul( ase_worldToTangent, ase_worldViewDir );
			float2 paralaxOffset106 = ParallaxOffset( 0 , _WaterDepth , ase_tanViewDir );
			float4 UnderWaterColor91 = tex2D( _UnderWaterColor, ( ( (ase_worldPos).xz / _UnderWaterTilling ) + ( (WaterWorldNormal43).xz * 0.1 ) + paralaxOffset106 ) );
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos48 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 temp_output_123_0 = ( (ase_worldPos).xz / _BlinkTilling );
			float temp_output_124_0 = ( _Time.y * 0.1 * _BlinkSpeed );
			float2 temp_output_136_0 = ( (( UnpackNormal( tex2D( _TextureSample2, ( temp_output_123_0 + temp_output_124_0 ) ) ) + UnpackNormal( tex2D( _WaterNormal, ( ( temp_output_123_0 * 1.3 ) + ( temp_output_124_0 * -1.2 ) ) ) ) )).xy * 0.5 );
			float dotResult137 = dot( temp_output_136_0 , temp_output_136_0 );
			float3 appendResult140 = (float3(temp_output_136_0 , sqrt( ( 1.0 - dotResult137 ) )));
			float3 WorldNormalBlink142 = (WorldNormalVector( i , appendResult140 ));
			float4 temp_cast_0 = (_BlinkThreshold).xxxx;
			float4 ReflectBlink158 = max( float4( 0,0,0,0 ) , ( ( tex2D( _ReflectionTex, ( ( _BlinkNoise * (WorldNormalBlink142).xz ) + (ase_screenPosNorm).xy ) ) - temp_cast_0 ) * _BlinkIntensity ) );
			float4 ReflectColor72 = ( tex2D( _ReflectionTex, ( ( _WaterNoise * ( (WaterWorldNormal43).xz / ( 1.0 + unityObjectToClipPos48.w ) ) ) + (ase_screenPosNorm).xy ) ) + ReflectBlink158 );
			float dotResult96 = dot( ase_worldNormal , ase_worldViewDir );
			float clampResult97 = clamp( dotResult96 , 0.0 , 1.0 );
			float temp_output_98_0 = ( 1.0 - clampResult97 );
			float clampResult112 = clamp( ( 0.17 + temp_output_98_0 ) , 0.0 , 1.0 );
			float4 lerpResult99 = lerp( UnderWaterColor91 , ( ReflectColor72 * clampResult112 ) , temp_output_98_0);
			o.Emission = ( SpecColor68 + lerpResult99 ).rgb;
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
				float4 screenPos : TEXCOORD1;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
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
472;662;1725.333;955.6667;2880.932;-1223.433;1.608248;False;True
Node;AmplifyShaderEditor.CommentaryNode;116;-5903.045,-1095.415;Inherit;False;2807.771;720.2195;WaterWorldNormal;26;142;141;140;139;138;137;136;135;134;133;132;131;130;129;128;127;126;125;124;123;122;121;120;119;118;117;WaterWorldNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;117;-5792.245,-1045.415;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;120;-5590.205,-1037.221;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-5841.447,-532.207;Inherit;False;Property;_BlinkSpeed;BlinkSpeed;16;0;Create;True;0;0;True;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-5703.205,-866.2215;Inherit;False;Property;_BlinkTilling;BlinkTilling;14;0;Create;True;0;0;False;0;False;8;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-5827.045,-641.3149;Inherit;False;Constant;_Float6;Float 6;2;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;119;-5853.045,-732.315;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-5516.628,-782.133;Inherit;False;Constant;_Float8;Float 8;4;0;Create;True;0;0;False;0;False;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-5535.549,-515.6248;Inherit;False;Constant;_Float7;Float 7;4;0;Create;True;0;0;False;0;False;-1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;123;-5433.205,-939.2215;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-5553.045,-667.3149;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-5319.55,-552.6249;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-5351.114,-806.1415;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;44;-2618.947,-1128.873;Inherit;False;2807.771;720.2195;WaterWorldNormal;27;8;4;5;13;16;14;17;12;9;10;29;31;30;28;32;34;18;27;36;35;37;38;40;41;42;43;143;WaterWorldNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;5;-2508.147,-1078.873;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-5170.745,-802.9151;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;-5155.55,-577.6249;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2542.947,-674.7728;Inherit;False;Constant;_Float0;Float 0;2;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;13;-2306.107,-1070.679;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2558.349,-565.6649;Inherit;False;Property;_WaterSpeed;WaterSpeed;3;0;Create;True;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;131;-4987.853,-850.6709;Inherit;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;False;0;False;-1;None;d2f6e43c4f1e05740be8686ed5ac85d4;True;0;True;bump;Auto;True;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-2419.107,-899.6794;Inherit;False;Property;_NormalTilling;NormalTilling;2;0;Create;True;0;0;False;0;False;8;16.79;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;132;-4982.473,-605.1952;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;4;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;9;-2568.947,-765.7729;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2222.516,-786.7996;Inherit;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;False;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2251.451,-549.0827;Inherit;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;False;0;False;-1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;14;-2149.107,-972.6795;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;133;-4629.202,-707.061;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2268.947,-700.7728;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2035.452,-586.0828;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2067.016,-839.5994;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;134;-4476.695,-711.4717;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-4485.572,-615.2367;Inherit;False;Constant;_Float9;Float 9;4;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1871.452,-611.0828;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;143;-1913.566,-716.0831;Inherit;False;Property;_NormaIntensity;NormaIntensity;13;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-4312.571,-678.2367;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1886.647,-836.373;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;27;-1698.375,-638.6531;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;4;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;137;-4155.571,-608.2367;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1703.755,-884.1288;Inherit;True;Property;_WaterNormal;WaterNormal;1;0;Create;True;0;0;False;0;False;-1;None;d2f6e43c4f1e05740be8686ed5ac85d4;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;138;-4020.572,-604.2367;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1345.104,-740.5189;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;18;-1192.597,-744.9296;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1201.474,-648.6946;Inherit;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;139;-3861.573,-601.2367;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1028.473,-711.6946;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-3748.573,-681.2367;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;37;-871.4733,-641.6946;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;141;-3594.25,-681.2802;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;38;-736.4733,-637.6946;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;145;-5890.631,-162.8139;Inherit;False;2344.822;656.4017;ReflectBlinkColor;14;158;157;156;155;154;150;153;152;148;161;162;163;164;169;ReflectBlinkColor;0.9811321,0.6247775,0.6247775,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-3344.875,-671.2644;Inherit;False;WorldNormalBlink;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;40;-577.4733,-634.6946;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;148;-5388.345,36.65144;Inherit;False;142;WorldNormalBlink;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;150;-5145.155,43.03904;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;152;-4969.453,178.5878;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;153;-4980.823,-47.81395;Inherit;False;Property;_BlinkNoise;BlinkNoise;15;0;Create;True;0;0;False;0;False;1;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-464.4733,-714.6946;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;51;-1909.094,-290.1341;Inherit;False;2052.322;552.4017;ReflectColor;15;72;1;23;26;22;25;2;47;50;46;48;45;49;165;166;ReflectColor;0.9811321,0.6247775,0.6247775,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;42;-310.1506,-714.7381;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-4715.239,5.761441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;155;-4728.752,144.5926;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;49;-1856.494,46.84723;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-4528.771,79.14124;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-60.77594,-704.7223;Inherit;False;WaterWorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;157;-4382.351,0.09494853;Inherit;True;Property;_TextureSample3;Texture Sample 3;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;71;-1795.678,383.4295;Inherit;False;2005.837;1021.209;SpecColor;25;78;77;68;69;70;66;60;67;65;62;64;63;58;56;59;55;54;53;79;80;81;83;84;85;82;SpecColor;0.495283,0.6696644,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1780.441,-140.8325;Inherit;False;43;WaterWorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;48;-1661.44,46.86033;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;162;-4213.556,238.3276;Inherit;False;Property;_BlinkThreshold;BlinkThreshold;18;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;-4019.616,364.9639;Inherit;False;Property;_BlinkIntensity;BlinkIntensity;17;0;Create;True;0;0;False;0;False;0;1.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;53;-1693.678,447.4294;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;161;-4037.458,83.4276;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;54;-1745.678,671.4294;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;46;-1537.251,-134.4449;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1448.094,-8.952776;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;109;-2180.05,1474.427;Inherit;False;1511.144;921.5612;UnderWaterColor;14;87;102;105;107;90;88;103;108;89;106;104;101;86;91;UnderWaterColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-987.9156,51.26763;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-3803.616,246.9639;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;47;-1303.44,-56.13964;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-999.2859,-175.1341;Inherit;False;Property;_WaterNoise;WaterNoise;4;0;Create;True;0;0;False;0;False;1;1.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1492.678,553.4294;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;94;276.0948,-4.455461;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;102;-2130.05,1823.183;Inherit;False;43;WaterWorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;22;-747.2156,17.27244;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-1371.678,433.4294;Inherit;False;43;WaterWorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;56;-1322.678,554.4294;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;169;-3682.791,191.2543;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;87;-1918.701,1524.427;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;78;-1694.808,1125.095;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;77;-1628.58,906.1499;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;95;298.0948,156.5445;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-733.7019,-121.5587;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1152.068,1184.651;Inherit;False;Property;_SpecStart;SpecStart;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-1919.832,2117.391;Inherit;False;Property;_WaterDepth;WaterDepth;12;0;Create;True;0;0;False;0;False;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;79;-1403.068,1030.651;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1248.678,687.4294;Inherit;False;Property;_SpecSmoothness;SpecSmoothness;5;0;Create;True;0;0;False;0;False;0.1;0.1;0.001;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;103;-1856.05,1823.183;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1126.678,797.4294;Inherit;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;False;0;False;256;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;107;-1939.832,2210.391;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-547.2334,-48.17891;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-1892.652,1967.303;Inherit;False;Constant;_Float5;Float 5;13;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-1145.068,953.6506;Inherit;False;Property;_SpecEnd;SpecEnd;8;0;Create;True;0;0;False;0;False;0;141.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;58;-1081.678,494.4294;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-3720.663,-11.3322;Inherit;False;ReflectBlink;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;88;-1703.701,1530.427;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;96;526.0947,82.54453;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-1755.701,1701.427;Inherit;False;Property;_UnderWaterTilling;UnderWaterTilling;11;0;Create;True;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;83;-930.0684,1151.651;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;82;-931.0684,995.6506;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;89;-1521.701,1618.427;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;-275.7576,120.5802;Inherit;False;158;ReflectBlink;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-937.6779,709.4294;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOffsetHlpNode;106;-1704.832,2104.391;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;62;-917.6779,533.4295;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;97;706.6702,78.44833;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-1684.652,1881.303;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-430.3824,-118.4954;Inherit;True;Property;_ReflectionTex;ReflectionTex;0;0;Create;True;0;0;False;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;67;-789.3809,789.5409;Inherit;False;Property;_SpecTint;SpecTint;6;0;Create;True;0;0;False;0;False;0,0,0,0;0.3882353,0.1411765,0.003921569,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-1423.05,1846.183;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;98;848.67,79.04834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;60;-758.577,605.1294;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;165;-59.8071,37.08441;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;84;-747.0684,1079.651;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-33.73827,-122.7499;Inherit;False;ReflectColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;86;-1280.701,1589.126;Inherit;True;Property;_UnderWaterColor;UnderWaterColor;10;0;Create;True;0;0;False;0;False;-1;None;58ca8c4d023b55940b0c68768ee43a88;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-534.3805,785.5409;Inherit;False;Property;_SpecIntensity;SpecIntensity;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-536.3805,667.5409;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;909.2693,-32.01386;Inherit;False;2;2;0;FLOAT;0.17;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;85;-585.0684,1078.651;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-348.3808,686.5409;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;112;1028.669,-33.31376;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;707.1859,-160.4264;Inherit;False;72;ReflectColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-908.7068,1589.688;Inherit;True;UnderWaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;1166.887,-126.605;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-170.2217,681.1885;Inherit;False;SpecColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;916.7084,-251.7507;Inherit;False;91;UnderWaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;99;1447.87,-81.75176;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;1196.073,-318.7848;Inherit;False;68;SpecColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;1399.086,-278.8264;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1727.606,-24.5619;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;120;0;117;0
WireConnection;123;0;120;0
WireConnection;123;1;118;0
WireConnection;124;0;119;0
WireConnection;124;1;122;0
WireConnection;124;2;121;0
WireConnection;127;0;124;0
WireConnection;127;1;125;0
WireConnection;128;0;123;0
WireConnection;128;1;126;0
WireConnection;130;0;123;0
WireConnection;130;1;124;0
WireConnection;129;0;128;0
WireConnection;129;1;127;0
WireConnection;13;0;5;0
WireConnection;131;1;130;0
WireConnection;132;1;129;0
WireConnection;14;0;13;0
WireConnection;14;1;16;0
WireConnection;133;0;131;0
WireConnection;133;1;132;0
WireConnection;10;0;9;0
WireConnection;10;1;12;0
WireConnection;10;2;17;0
WireConnection;30;0;10;0
WireConnection;30;1;31;0
WireConnection;28;0;14;0
WireConnection;28;1;29;0
WireConnection;134;0;133;0
WireConnection;32;0;28;0
WireConnection;32;1;30;0
WireConnection;136;0;134;0
WireConnection;136;1;135;0
WireConnection;8;0;14;0
WireConnection;8;1;10;0
WireConnection;27;1;32;0
WireConnection;27;5;143;0
WireConnection;137;0;136;0
WireConnection;137;1;136;0
WireConnection;4;1;8;0
WireConnection;4;5;143;0
WireConnection;138;0;137;0
WireConnection;34;0;4;0
WireConnection;34;1;27;0
WireConnection;18;0;34;0
WireConnection;139;0;138;0
WireConnection;35;0;18;0
WireConnection;35;1;36;0
WireConnection;140;0;136;0
WireConnection;140;2;139;0
WireConnection;37;0;35;0
WireConnection;37;1;35;0
WireConnection;141;0;140;0
WireConnection;38;0;37;0
WireConnection;142;0;141;0
WireConnection;40;0;38;0
WireConnection;150;0;148;0
WireConnection;41;0;35;0
WireConnection;41;2;40;0
WireConnection;42;0;41;0
WireConnection;154;0;153;0
WireConnection;154;1;150;0
WireConnection;155;0;152;0
WireConnection;156;0;154;0
WireConnection;156;1;155;0
WireConnection;43;0;42;0
WireConnection;157;1;156;0
WireConnection;48;0;49;0
WireConnection;161;0;157;0
WireConnection;161;1;162;0
WireConnection;46;0;45;0
WireConnection;50;1;48;4
WireConnection;163;0;161;0
WireConnection;163;1;164;0
WireConnection;47;0;46;0
WireConnection;47;1;50;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;22;0;2;0
WireConnection;56;0;55;0
WireConnection;169;1;163;0
WireConnection;26;0;25;0
WireConnection;26;1;47;0
WireConnection;79;0;77;0
WireConnection;79;1;78;0
WireConnection;103;0;102;0
WireConnection;23;0;26;0
WireConnection;23;1;22;0
WireConnection;58;0;59;0
WireConnection;58;1;56;0
WireConnection;158;0;169;0
WireConnection;88;0;87;0
WireConnection;96;0;94;0
WireConnection;96;1;95;0
WireConnection;83;0;80;0
WireConnection;83;1;81;0
WireConnection;82;0;80;0
WireConnection;82;1;79;0
WireConnection;89;0;88;0
WireConnection;89;1;90;0
WireConnection;65;0;63;0
WireConnection;65;1;64;0
WireConnection;106;1;108;0
WireConnection;106;2;107;0
WireConnection;62;0;58;0
WireConnection;97;0;96;0
WireConnection;104;0;103;0
WireConnection;104;1;105;0
WireConnection;1;1;23;0
WireConnection;101;0;89;0
WireConnection;101;1;104;0
WireConnection;101;2;106;0
WireConnection;98;0;97;0
WireConnection;60;0;62;0
WireConnection;60;1;65;0
WireConnection;165;0;1;0
WireConnection;165;1;166;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;72;0;165;0
WireConnection;86;1;101;0
WireConnection;66;0;60;0
WireConnection;66;1;67;0
WireConnection;111;1;98;0
WireConnection;85;0;84;0
WireConnection;69;0;66;0
WireConnection;69;1;70;0
WireConnection;69;2;85;0
WireConnection;112;0;111;0
WireConnection;91;0;86;0
WireConnection;110;0;74;0
WireConnection;110;1;112;0
WireConnection;68;0;69;0
WireConnection;99;0;92;0
WireConnection;99;1;110;0
WireConnection;99;2;98;0
WireConnection;76;0;100;0
WireConnection;76;1;99;0
WireConnection;0;2;76;0
ASEEND*/
//CHKSM=5CE44C5415D564D25E1892179B1F80D3A20ADD84