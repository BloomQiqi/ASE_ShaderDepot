// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Toon_Water"
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
		_ReflectionTex("ReflectionTex", 2D) = "white" {}
		_ReflectionDistort("ReflectionDistort", Float) = 1
		_ReflectionIntensity("ReflectionIntensity", Float) = 0
		_ReflectionPower("ReflectionPower", Float) = 0
		_UnderWaterDistort("UnderWaterDistort", Float) = 1
		_CausticIntensity("CausticIntensity", Float) = 0
		_CausticScale("CausticScale", Float) = 1
		_CausticSpeed("CausticSpeed", Vector) = (0,0,0,0)
		_CausticTex("CausticTex", 2D) = "white" {}
		_CausticRange("CausticRange", Float) = 0
		_ShoreRange("ShoreRange", Float) = 0
		_ShoreColor("ShoreColor", Color) = (0,0,0,0)
		_ShoreEdgeWidth("ShoreEdgeWidth", Range( 0 , 1)) = 0
		_ShoreEdgeIntensity("ShoreEdgeIntensity", Float) = 0
		_FoamColor("FoamColor", Color) = (1,1,1,1)
		_FoamRange("FoamRange", Float) = 0
		_FoamBlend("FoamBlend", Range( 0 , 1)) = 0
		_FoamFrequency("FoamFrequency", Float) = 0
		_FoamSpeed("FoamSpeed", Float) = 0
		_FoamNoiseSize("FoamNoiseSize", Vector) = (10,10,0,0)
		_FoamDisslove("FoamDisslove", Float) = 0
		_FoamWidth("FoamWidth", Float) = 0
		_FoamPower("FoamPower", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
			float3 worldNormal;
			float2 uv_texcoord;
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
		uniform sampler2D _ReflectionTex;
		uniform sampler2D _NormalMap;
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
		uniform float4 _ShoreColor;
		uniform float _ShoreRange;
		uniform float _FoamBlend;
		uniform float _FoamRange;
		uniform float _FoamWidth;
		uniform float _FoamFrequency;
		uniform float _FoamSpeed;
		uniform float _FoamPower;
		uniform float2 _FoamNoiseSize;
		uniform float _FoamDisslove;
		uniform float4 _FoamColor;
		uniform float _ShoreEdgeWidth;
		uniform float _ShoreEdgeIntensity;


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


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
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

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
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
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV241 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode241 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV241, _SufFresnelPower ) );
			float4 lerpResult243 = lerp( lerpResult232 , _SurFresnelColor , fresnelNode241);
			float4 WaterColor234 = lerpResult243;
			float2 temp_output_253_0 = ( (ase_worldPos).xz / _NormalScale );
			float2 temp_output_257_0 = ( _NormalSpeed * _Time.y * 0.1 );
			float3 SurfaceNormal261 = BlendNormals( UnpackNormal( tex2D( _NormalMap, ( temp_output_253_0 + temp_output_257_0 ) ) ) , UnpackNormal( tex2D( _NormalMap, ( ( temp_output_253_0 * 1.2 ) + ( temp_output_257_0 * -0.7 ) ) ) ) );
			float fresnelNdotV301 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode301 = ( 0.0 + _ReflectionIntensity * pow( max( 1.0 - fresnelNdotV301 , 0.0001 ), _ReflectionPower ) );
			float clampResult305 = clamp( fresnelNode301 , 0.0 , 1.0 );
			float4 ReflectionColor282 = ( tex2D( _ReflectionTex, ( (ase_screenPosNorm).xy + ( (SurfaceNormal261).xz * ( _ReflectionDistort * 0.01 ) ) ) ) * clampResult305 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor295 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( ( SurfaceNormal261 * _UnderWaterDistort * 0.01 ) , 0.0 ) ).xy/( ase_grabScreenPosNorm + float4( ( SurfaceNormal261 * _UnderWaterDistort * 0.01 ) , 0.0 ) ).w);
			float2 temp_output_308_0 = ( (PositionFromDepth219).xz / _CausticScale );
			float2 temp_output_311_0 = ( _Time.y * _CausticSpeed * 0.01 );
			float clampResult332 = clamp( exp( ( -WaterDepth222 / _CausticRange ) ) , 0.0 , 1.0 );
			float4 CausticColor322 = ( ( min( tex2D( _CausticTex, ( temp_output_308_0 + temp_output_311_0 ) ) , tex2D( _CausticTex, ( -temp_output_308_0 + temp_output_311_0 ) ) ) * _CausticIntensity ) * clampResult332 );
			float4 UnderWaterColor296 = ( screenColor295 + CausticColor322 );
			float WaterOpacity249 = ( 1.0 - (lerpResult243).a );
			float4 lerpResult299 = lerp( ( WaterColor234 + ReflectionColor282 ) , UnderWaterColor296 , WaterOpacity249);
			float4 UnderWaterSceneColor334 = screenColor295;
			float3 ShoreColor347 = (( UnderWaterSceneColor334 * _ShoreColor )).rgb;
			float clampResult342 = clamp( exp( ( -WaterDepth222 / _ShoreRange ) ) , 0.0 , 1.0 );
			float WaterShore343 = clampResult342;
			float4 lerpResult350 = lerp( lerpResult299 , float4( ShoreColor347 , 0.0 ) , WaterShore343);
			float clampResult367 = clamp( ( WaterDepth222 / _FoamRange ) , 0.0 , 1.0 );
			float temp_output_368_0 = ( 1.0 - clampResult367 );
			float smoothstepResult384 = smoothstep( _FoamBlend , 1.0 , temp_output_368_0);
			float simplePerlin2D383 = snoise( ( i.uv_texcoord * _FoamNoiseSize ) );
			simplePerlin2D383 = simplePerlin2D383*0.5 + 0.5;
			float4 FoamColor377 = ( ( smoothstepResult384 * step( ( temp_output_368_0 + _FoamWidth ) , ( ( pow( sin( ( ( temp_output_368_0 * _FoamFrequency ) + ( _Time.y * _FoamSpeed ) ) ) , _FoamPower ) + simplePerlin2D383 ) - _FoamDisslove ) ) ) * _FoamColor );
			float4 lerpResult397 = lerp( lerpResult350 , ( lerpResult350 + float4( (FoamColor377).rgb , 0.0 ) ) , (FoamColor377).a);
			float smoothstepResult353 = smoothstep( ( 1.0 - _ShoreEdgeWidth ) , 1.1 , WaterShore343);
			float ShoreEdge358 = ( smoothstepResult353 * _ShoreEdgeIntensity );
			o.Emission = max( ( lerpResult397 + ShoreEdge358 ) , float4( 0,0,0,0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
0;5.6;1536;796;-3117.587;-889.1333;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;229;655.5964,845.4196;Inherit;False;1395.008;326.1035;WaterDepth;7;217;220;215;222;221;219;218;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;215;705.5964,1061.123;Inherit;False;Reconstruct World Position From Depth;-1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.SwizzleNode;217;1062.804,1055.42;Inherit;False;FLOAT3;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;270;386.5771,2167.534;Inherit;False;1743.447;617.9792;SurfaceNormal;18;267;266;257;264;268;251;255;259;256;253;260;258;250;263;261;262;265;254;SurfaceNormal;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;1246.804,1055.42;Inherit;False;PositionFromDepth;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;218;1298.804,897.0545;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;250;436.5771,2222.508;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;220;1492.804,1055.42;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;221;1631.804,951.4196;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;583.9001,2665.064;Inherit;False;Constant;_Float1;Float 1;12;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;258;606.9001,2459.064;Inherit;False;Property;_NormalSpeed;NormalSpeed;5;0;Create;True;0;0;False;0;False;0,0;2,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;254;619.5217,2354.534;Inherit;False;Property;_NormalScale;NormalScale;4;0;Create;True;0;0;False;0;False;0;26.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;256;603.9001,2581.064;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;251;656.5217,2217.534;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;267;981.732,2670.114;Inherit;False;Constant;_Float3;Float 3;13;0;Create;True;0;0;False;0;False;-0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;1825.804,947.4196;Inherit;False;WaterDepth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;333;406.9668,4206.633;Inherit;False;1882.254;869.2212;CausticColor;24;306;309;307;313;312;308;310;326;311;321;330;328;314;319;329;315;316;325;320;331;332;324;327;322;CausticColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;406;2764.205,2508.057;Inherit;False;2538.853;1101.281;FoamColor;29;364;366;365;367;368;374;372;370;373;369;380;382;371;381;403;375;402;383;389;392;387;379;405;388;390;386;394;393;377;FoamColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;253;900.5217,2251.534;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;265;980.7319,2477.114;Inherit;False;Constant;_Float2;Float 2;13;0;Create;True;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;257;861.9001,2508.064;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;366;2841.205,2715.61;Inherit;False;Property;_FoamRange;FoamRange;27;0;Create;True;0;0;False;0;False;0;2.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;1157.732,2462.114;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;364;2814.205,2607.61;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;1141.732,2610.114;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;306;456.9668,4256.633;Inherit;False;219;PositionFromDepth;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;365;3053.205,2654.61;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;309;690.3599,4382.686;Inherit;False;Property;_CausticScale;CausticScale;18;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;255;1147.522,2331.534;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;268;1266.732,2550.114;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;307;708.9668,4283.633;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;260;1399.329,2299.604;Inherit;True;Property;_NormalMap;NormalMap;6;0;Create;True;0;0;False;0;False;-1;None;2aab2b9fb283e6646ad7f1df2f799dc1;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;313;658.9002,4771.869;Inherit;False;Constant;_Float6;Float 6;18;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;367;3211.205,2654.61;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;262;1400.096,2552.271;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Instance;260;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;310;661.9002,4543.869;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;308;931.3599,4317.686;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;240;351.4345,1237.905;Inherit;False;1891.406;685.2443;WaterColor;18;244;234;243;232;241;230;231;242;245;239;246;237;235;236;233;247;248;249;WaterColor;0,0.7505074,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;312;669.9002,4634.869;Inherit;False;Property;_CausticSpeed;CausticSpeed;19;0;Create;True;0;0;False;0;False;0,0;8,8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;236;445.8149,1786.668;Inherit;False;Property;_DeepRange;DeepRange;9;0;Create;True;0;0;False;0;False;1;3.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;321;1048.508,4489.832;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;866.9002,4591.869;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;263;1708.104,2441.44;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;370;3220.205,2925.61;Inherit;False;Property;_FoamFrequency;FoamFrequency;29;0;Create;True;0;0;False;0;False;0;28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;372;3203.205,3088.609;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;374;3226.205,3200.609;Inherit;False;Property;_FoamSpeed;FoamSpeed;30;0;Create;True;0;0;False;0;False;0;-2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;3396.205,2740.61;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;401.4345,1667.105;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;326;1129.883,4874.221;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;369;3531.205,2885.61;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;373;3447.205,3133.609;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;314;1141.9,4358.869;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;261;1903.624,2300.598;Inherit;False;SurfaceNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;283;476.1409,2903.001;Inherit;False;1671.283;577.2224;ReflectionColor;16;278;272;273;277;280;279;281;275;274;271;282;301;302;303;304;305;ReflectionColor;1,0.8254717,0.8254717,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;319;1178.679,4566.387;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;298;474.8837,3590.317;Inherit;False;1324.8;509.5317;UnderWaterColor;11;296;295;290;288;292;291;293;294;334;335;336;UnderWaterColor;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;330;1298.296,4960.454;Inherit;False;Property;_CausticRange;CausticRange;21;0;Create;True;0;0;False;0;False;0;1.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;235;634.9507,1675.955;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;328;1339.456,4881.662;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;371;3677.205,2988.61;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;380;3255.985,3319.718;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;382;3300.271,3447.138;Inherit;False;Property;_FoamNoiseSize;FoamNoiseSize;31;0;Create;True;0;0;False;0;False;10,10;5,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;294;532.8837,3983.449;Inherit;False;Constant;_Float5;Float 5;15;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;237;773.0151,1675.168;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;563.1409,3364.824;Inherit;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;547.1409,3177.824;Inherit;False;261;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;291;526.8837,3828.449;Inherit;False;261;SurfaceNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;315;1333.766,4332.376;Inherit;True;Property;_CausticTex;CausticTex;20;0;Create;True;0;0;False;0;False;-1;None;72417ee6f632e4e4aabc8c81143957bf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;293;524.8837,3907.449;Inherit;False;Property;_UnderWaterDistort;UnderWaterDistort;16;0;Create;True;0;0;False;0;False;1;0.47;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;329;1470.296,4904.454;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;316;1336.622,4557.504;Inherit;True;Property;_TextureSample1;Texture Sample 1;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;315;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;279;526.1409,3281.824;Inherit;False;Property;_ReflectionDistort;ReflectionDistort;13;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;325;1688.378,4602.78;Inherit;False;Property;_CausticIntensity;CausticIntensity;17;0;Create;True;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;272;588.894,2955.001;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;320;1688.679,4459.387;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;3545.271,3362.138;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;403;3718.479,3202.509;Inherit;False;Property;_FoamPower;FoamPower;34;0;Create;True;0;0;False;0;False;5;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;375;3789.314,3059.685;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;754.1409,3308.824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;239;922.0206,1676.558;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;288;545.7649,3640.317;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;277;772.1409,3177.824;Inherit;False;FLOAT2;0;2;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;292;786.8836,3872.449;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;246;813.5508,1817.905;Inherit;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;False;2.132;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;331;1594.296,4905.454;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;1357.179,3365.742;Inherit;False;Property;_ReflectionPower;ReflectionPower;15;0;Create;True;0;0;False;0;False;0;12.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;242;1137.997,1790.527;Inherit;False;Property;_SufFresnelPower;SufFresnelPower;10;0;Create;True;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;349;453.9633,5179.652;Inherit;False;1788.83;620.5146;WaterShore;18;343;347;348;342;341;345;340;344;346;339;338;337;353;354;355;356;357;358;WaterShore;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;245;988.7026,1759.323;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;932.1409,3233.824;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;273;818.894,2953.001;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;231;734.0345,1464.905;Inherit;False;Property;_ShallowColor;ShallowColor;8;0;Create;True;0;0;False;0;False;0,0,0,0;0,0.9898967,1,0.4666667;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;332;1718.296,4905.454;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;324;1884.378,4534.78;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;230;728.0345,1287.905;Inherit;False;Property;_DeepColor;DeepColor;7;0;Create;True;0;0;False;0;False;0,0,0,0;0.2122639,0.4532186,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;402;3889.638,3181.721;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;383;3715.271,3371.138;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;290;932.8836,3679.449;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;302;1384.179,3275.742;Inherit;False;Property;_ReflectionIntensity;ReflectionIntensity;14;0;Create;True;0;0;False;0;False;0;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;389;4133.627,3407.506;Inherit;False;Property;_FoamDisslove;FoamDisslove;32;0;Create;True;0;0;False;0;False;0;-0.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;295;1096.884,3676.449;Inherit;False;Global;_GrabScreen0;Grab Screen 0;15;0;Create;True;0;0;False;0;False;Object;-1;False;True;1;0;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;244;1140.811,1532.188;Inherit;False;Property;_SurFresnelColor;SurFresnelColor;11;0;Create;True;0;0;False;0;False;0,0,0,0;0.2877353,0.6711032,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;301;1603.851,3230.613;Inherit;False;Standard;WorldNormal;ViewDir;True;True;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;274;1135.126,3089.263;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;232;1143.034,1385.905;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;337;503.9633,5229.652;Inherit;False;222;WaterDepth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;2029.107,4755.341;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;379;4173.051,3184.954;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;4067.491,3058.53;Inherit;False;Property;_FoamWidth;FoamWidth;33;0;Create;True;0;0;False;0;False;0;0.73;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;387;3751.289,2558.057;Inherit;False;540.2336;271.5073;FoamMask;2;384;385;FoamMask;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;241;1343.657,1666.663;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;388;4391.217,3314.905;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;385;3710.21,2687.164;Inherit;False;Property;_FoamBlend;FoamBlend;28;0;Create;True;0;0;False;0;False;0;0.32;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;405;4223.159,2966.08;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;271;1278.499,3017.65;Inherit;True;Property;_ReflectionTex;ReflectionTex;12;0;Create;True;0;0;False;0;False;-1;None;;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;243;1549.627,1508.114;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;334;1336.228,3674.753;Inherit;False;UnderWaterSceneColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;305;1900.245,3253.268;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;339;694.8564,5233.696;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;322;2064.421,4445.462;Inherit;False;CausticColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;338;577.2796,5334.565;Inherit;False;Property;_ShoreRange;ShoreRange;22;0;Create;True;0;0;False;0;False;0;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;384;4012.508,2605.618;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;390;4511.658,3111.756;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;193;-115.4068,6045.981;Inherit;False;2542.907;761.6924;Wave Vertex Animation ;21;203;196;189;200;194;192;199;191;198;197;188;202;190;204;207;206;208;209;210;211;212;Wave Vertex Animation ;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;340;844.3762,5259.885;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;247;1719.908,1629.874;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;1129.228,3916.753;Inherit;False;322;CausticColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;346;752.0777,5569.488;Inherit;False;Property;_ShoreColor;ShoreColor;23;0;Create;True;0;0;False;0;False;0,0,0,0;0.9056604,0.9056604,0.9056604,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;1737.179,3119.742;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;344;719.9988,5461.632;Inherit;False;334;UnderWaterSceneColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;996.6219,5506.267;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;282;1883.215,3019.733;Inherit;False;ReflectionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;394;4792.862,3015.145;Inherit;False;Property;_FoamColor;FoamColor;26;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;248;1865.908,1634.874;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ExpOpNode;341;1002.634,5260.885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;386;4553.457,2817.637;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;1818.214,1356.046;Inherit;False;WaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;335;1373.228,3818.753;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;189;5.016447,6127.708;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector4Node;190;-36.98307,6425.707;Inherit;False;Property;_WaveASpeedXYSteepnesswavelength;WaveA(SpeedXY,Steepness,wavelength);0;0;Create;True;0;0;False;0;False;1,1,2,50;0,-1,1.6,50;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;1612.884,3689.449;Inherit;False;UnderWaterColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;342;1165.563,5260.885;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;2291.659,926.877;Inherit;False;282;ReflectionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;348;1143.078,5494.488;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;238;2316.266,845.506;Inherit;False;234;WaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;249;2018.908,1632.874;Inherit;False;WaterOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;354;1244.627,5381.607;Inherit;False;Property;_ShoreEdgeWidth;ShoreEdgeWidth;24;0;Create;True;0;0;False;0;False;0;0.39;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;202;376.2455,6498.129;Inherit;False;Property;_WaveB;WaveB;1;0;Create;True;0;0;False;0;False;1,1,2,50;-0.5,-0.5,1.6,30;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;4885.719,2883.1;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomExpressionNode;188;364.1906,6324.435;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;347;1311.078,5497.488;Inherit;False;ShoreColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;284;2556.659,895.877;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;204;795.053,6514.918;Inherit;False;Property;_WaveC;WaveC;2;0;Create;True;0;0;False;0;False;1,1,2,50;1,0.5,1,20;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;297;2425.864,1027.255;Inherit;False;296;UnderWaterColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;377;5078.26,2894.08;Inherit;False;FoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;343;1356.677,5250.987;Inherit;False;WaterShore;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;355;1517.627,5359.607;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;300;2513.702,1140.109;Inherit;False;249;WaterOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;196;700.173,6324.522;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.CustomExpressionNode;203;1040.505,6299.711;Inherit;False;float steepness = wave.z * 0.01@$float wavelength = wave.w@$float k = 2 * UNITY_PI / wavelength@$float c = sqrt(9.8 / k)@$float2 d = normalize(wave.xy)@$float f = k * (dot(d, position.xz) - c * _Time.y)@$float a = steepness / k@$			$$tangent += float3($-d.x * d.x * (steepness * sin(f)),$d.x * (steepness * cos(f)),$-d.x * d.y * (steepness * sin(f))$)@$$binormal += float3($-d.x * d.y * (steepness * sin(f)),$d.y * (steepness * cos(f)),$-d.y * d.y * (steepness * sin(f))$)@$$return float3($d.x * (a * cos(f)),$a * sin(f),$d.y * (a * cos(f))$)@;3;False;4;True;position;FLOAT3;0,0,0;In;;Inherit;False;True;tangent;FLOAT3;1,0,0;InOut;;Inherit;False;True;binormal;FLOAT3;0,0,1;InOut;;Inherit;False;True;wave;FLOAT4;0,0,0,0;In;;Inherit;False;GerstnerWave;True;False;0;4;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT3;0,0,1;False;3;FLOAT4;0,0,0,0;False;3;FLOAT3;0;FLOAT3;2;FLOAT3;3
Node;AmplifyShaderEditor.GetLocalVarNode;351;2752.249,1087.818;Inherit;False;347;ShoreColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;299;2760.769,938.3815;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;352;2762.249,1207.818;Inherit;False;343;WaterShore;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;353;1728.627,5258.607;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;357;1715.627,5428.607;Inherit;False;Property;_ShoreEdgeIntensity;ShoreEdgeIntensity;25;0;Create;True;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;378;2997.311,1168.723;Inherit;False;377;FoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CrossProductOpNode;197;1375.715,6572.312;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;395;3170.066,1114.368;Inherit;False;FLOAT3;0;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;398;3193.066,1236.368;Inherit;False;FLOAT;3;1;2;3;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;356;1912.627,5316.607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;350;2993.249,1019.818;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;358;2052.627,5326.607;Inherit;False;ShoreEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;396;3333.066,1088.368;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;399;3470.066,1104.368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;1295.392,6116.941;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;198;1574.715,6606.312;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformDirectionNode;199;1774.715,6584.312;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;397;3483.066,962.3679;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;360;3618.726,1023.87;Inherit;False;358;ShoreEdge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;192;1528.069,6117.234;Inherit;False;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;2024.714,6601.312;Inherit;False;WaveVertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;1831.549,6127.313;Inherit;False;WaveVertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;359;3787.726,953.87;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;208;1715.185,6336.448;Inherit;False;FLOAT;1;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;209;1893.477,6277.896;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;206;1543.185,6328.448;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;2097.476,6346.896;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;207;1358.185,6380.447;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;211;1810.247,6411.563;Inherit;False;Property;_WaveColor;WaveColor;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.3098039,0.5333334,0.7921569,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;361;3909.726,952.87;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;3799.594,1090.127;Inherit;False;194;WaveVertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;2212.537,6224.663;Inherit;False;WaveColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;201;3777.889,1173.313;Inherit;False;200;WaveVertexNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4068.768,809.0941;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Toon_Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;217;0;215;0
WireConnection;219;0;217;0
WireConnection;220;0;219;0
WireConnection;221;0;218;2
WireConnection;221;1;220;0
WireConnection;251;0;250;0
WireConnection;222;0;221;0
WireConnection;253;0;251;0
WireConnection;253;1;254;0
WireConnection;257;0;258;0
WireConnection;257;1;256;0
WireConnection;257;2;259;0
WireConnection;264;0;253;0
WireConnection;264;1;265;0
WireConnection;266;0;257;0
WireConnection;266;1;267;0
WireConnection;365;0;364;0
WireConnection;365;1;366;0
WireConnection;255;0;253;0
WireConnection;255;1;257;0
WireConnection;268;0;264;0
WireConnection;268;1;266;0
WireConnection;307;0;306;0
WireConnection;260;1;255;0
WireConnection;367;0;365;0
WireConnection;262;1;268;0
WireConnection;308;0;307;0
WireConnection;308;1;309;0
WireConnection;321;0;308;0
WireConnection;311;0;310;0
WireConnection;311;1;312;0
WireConnection;311;2;313;0
WireConnection;263;0;260;0
WireConnection;263;1;262;0
WireConnection;368;0;367;0
WireConnection;369;0;368;0
WireConnection;369;1;370;0
WireConnection;373;0;372;0
WireConnection;373;1;374;0
WireConnection;314;0;308;0
WireConnection;314;1;311;0
WireConnection;261;0;263;0
WireConnection;319;0;321;0
WireConnection;319;1;311;0
WireConnection;235;0;233;0
WireConnection;235;1;236;0
WireConnection;328;0;326;0
WireConnection;371;0;369;0
WireConnection;371;1;373;0
WireConnection;237;0;235;0
WireConnection;315;1;314;0
WireConnection;329;0;328;0
WireConnection;329;1;330;0
WireConnection;316;1;319;0
WireConnection;320;0;315;0
WireConnection;320;1;316;0
WireConnection;381;0;380;0
WireConnection;381;1;382;0
WireConnection;375;0;371;0
WireConnection;280;0;279;0
WireConnection;280;1;281;0
WireConnection;239;0;237;0
WireConnection;277;0;275;0
WireConnection;292;0;291;0
WireConnection;292;1;293;0
WireConnection;292;2;294;0
WireConnection;331;0;329;0
WireConnection;245;0;239;0
WireConnection;245;1;246;0
WireConnection;278;0;277;0
WireConnection;278;1;280;0
WireConnection;273;0;272;0
WireConnection;332;0;331;0
WireConnection;324;0;320;0
WireConnection;324;1;325;0
WireConnection;402;0;375;0
WireConnection;402;1;403;0
WireConnection;383;0;381;0
WireConnection;290;0;288;0
WireConnection;290;1;292;0
WireConnection;295;0;290;0
WireConnection;301;2;302;0
WireConnection;301;3;303;0
WireConnection;274;0;273;0
WireConnection;274;1;278;0
WireConnection;232;0;230;0
WireConnection;232;1;231;0
WireConnection;232;2;245;0
WireConnection;327;0;324;0
WireConnection;327;1;332;0
WireConnection;379;0;402;0
WireConnection;379;1;383;0
WireConnection;241;3;242;0
WireConnection;388;0;379;0
WireConnection;388;1;389;0
WireConnection;405;0;368;0
WireConnection;405;1;392;0
WireConnection;271;1;274;0
WireConnection;243;0;232;0
WireConnection;243;1;244;0
WireConnection;243;2;241;0
WireConnection;334;0;295;0
WireConnection;305;0;301;0
WireConnection;339;0;337;0
WireConnection;322;0;327;0
WireConnection;384;0;368;0
WireConnection;384;1;385;0
WireConnection;390;0;405;0
WireConnection;390;1;388;0
WireConnection;340;0;339;0
WireConnection;340;1;338;0
WireConnection;247;0;243;0
WireConnection;304;0;271;0
WireConnection;304;1;305;0
WireConnection;345;0;344;0
WireConnection;345;1;346;0
WireConnection;282;0;304;0
WireConnection;248;0;247;0
WireConnection;341;0;340;0
WireConnection;386;0;384;0
WireConnection;386;1;390;0
WireConnection;234;0;243;0
WireConnection;335;0;295;0
WireConnection;335;1;336;0
WireConnection;296;0;335;0
WireConnection;342;0;341;0
WireConnection;348;0;345;0
WireConnection;249;0;248;0
WireConnection;393;0;386;0
WireConnection;393;1;394;0
WireConnection;188;0;189;0
WireConnection;188;3;190;0
WireConnection;347;0;348;0
WireConnection;284;0;238;0
WireConnection;284;1;285;0
WireConnection;377;0;393;0
WireConnection;343;0;342;0
WireConnection;355;0;354;0
WireConnection;196;0;189;0
WireConnection;196;1;188;2
WireConnection;196;2;188;3
WireConnection;196;3;202;0
WireConnection;203;0;189;0
WireConnection;203;1;196;2
WireConnection;203;2;196;3
WireConnection;203;3;204;0
WireConnection;299;0;284;0
WireConnection;299;1;297;0
WireConnection;299;2;300;0
WireConnection;353;0;343;0
WireConnection;353;1;355;0
WireConnection;197;0;203;3
WireConnection;197;1;203;2
WireConnection;395;0;378;0
WireConnection;398;0;378;0
WireConnection;356;0;353;0
WireConnection;356;1;357;0
WireConnection;350;0;299;0
WireConnection;350;1;351;0
WireConnection;350;2;352;0
WireConnection;358;0;356;0
WireConnection;396;0;350;0
WireConnection;396;1;395;0
WireConnection;399;0;398;0
WireConnection;191;0;189;0
WireConnection;191;1;188;0
WireConnection;191;2;196;0
WireConnection;191;3;203;0
WireConnection;198;0;197;0
WireConnection;199;0;198;0
WireConnection;397;0;350;0
WireConnection;397;1;396;0
WireConnection;397;2;399;0
WireConnection;192;0;191;0
WireConnection;200;0;199;0
WireConnection;194;0;192;0
WireConnection;359;0;397;0
WireConnection;359;1;360;0
WireConnection;208;0;206;0
WireConnection;209;0;208;0
WireConnection;206;0;191;0
WireConnection;206;1;207;0
WireConnection;210;0;209;0
WireConnection;210;1;211;0
WireConnection;361;0;359;0
WireConnection;212;0;210;0
WireConnection;0;2;361;0
WireConnection;0;11;195;0
WireConnection;0;12;201;0
ASEEND*/
//CHKSM=7CEC80A0D6F4116FD40561F958F1FF7A2A5847D1