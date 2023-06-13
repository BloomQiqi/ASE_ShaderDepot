// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "flowmiss"
{
	Properties
	{
		[HDR]_InnerColor("InnerColor", Color) = (0.000303527,0.006048833,0.05286065,1)
		[HDR]_RimColor("RimColor", Color) = (1,1,1,1)
		_RimColor_Intensity("RimColor_Intensity", Range( 0 , 3)) = 0
		_Fresnel_Power("Fresnel_Power", Float) = 0
		_Fresnel_bias("Fresnel_bias", Float) = 0
		_Fresnel_Scale("Fresnel_Scale", Float) = 0
		_FlowEmiss("FlowEmiss", 2D) = "white" {}
		_FlowSpeed("FlowSpeed", Vector) = (0,0,0,0)
		_FlowTilling("FlowTilling", Vector) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_TexPower("TexPower", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float4 _InnerColor;
		uniform float4 _RimColor;
		uniform float _RimColor_Intensity;
		uniform float _Fresnel_Power;
		uniform float _Fresnel_bias;
		uniform float _Fresnel_Scale;
		uniform sampler2D _FlowEmiss;
		uniform float2 _FlowTilling;
		uniform float2 _FlowSpeed;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _TexPower;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult4 = dot( ase_normWorldNormal , ase_worldViewDir );
			float saferPower6 = max( ( 1.0 - dotResult4 ) , 0.0001 );
			float clampResult17 = clamp( ( ( pow( saferPower6 , _Fresnel_Power ) + _Fresnel_bias ) * _Fresnel_Scale ) , 0.0 , 1.0 );
			float FresnelFactor15 = clampResult17;
			float3 objToWorld25 = mul( unity_ObjectToWorld, float4( float3( 0,0,0 ), 1 ) ).xyz;
			float2 appendResult23 = (float2(ase_worldPos.x , ( ase_worldPos.y - objToWorld25.y )));
			float FlowFactor33 = tex2D( _FlowEmiss, ( ( appendResult23 * _FlowTilling ) + ( _FlowSpeed * _Time.y ) ) ).r;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float clampResult38 = clamp( ( FresnelFactor15 + FlowFactor33 + pow( tex2D( _Albedo, uv_Albedo ).r , _TexPower ) ) , 0.0 , 1.0 );
			float4 lerpResult14 = lerp( _InnerColor , ( _RimColor * _RimColor_Intensity ) , clampResult38);
			o.Emission = lerpResult14.rgb;
			o.Alpha = clampResult38;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
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
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Version=17800
641.3334;936.6667;1725.333;907.6667;4607.904;269.4612;5.285728;True;True
Node;AmplifyShaderEditor.CommentaryNode;21;-3156.578,485.0412;Inherit;False;1742.841;679.9936;Comment;12;2;3;4;8;5;10;6;9;12;11;17;15;边缘因子;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-3282.35,1261.014;Inherit;False;1964.963;594.9139;Comment;12;25;22;24;29;31;27;23;30;28;26;20;33;流光;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;3;-3106.578,710.6183;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-3103.443,535.0411;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;22;-3232.35,1311.014;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformPositionNode;25;-3204.376,1529.743;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;4;-2879.792,612.3782;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;5;-2730.343,619.694;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;24;-2945.376,1417.743;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2788.869,770.1896;Inherit;False;Property;_Fresnel_Power;Fresnel_Power;3;0;Create;True;0;0;False;0;0;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-2548.012,1745.928;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;31;-2764.01,1457.208;Inherit;False;Property;_FlowTilling;FlowTilling;8;0;Create;True;0;0;False;0;0,0;1,0.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;29;-2520.01,1601.208;Inherit;False;Property;_FlowSpeed;FlowSpeed;7;0;Create;True;0;0;False;0;0,0;0,0.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-2614.175,976.0372;Inherit;False;Property;_Fresnel_bias;Fresnel_bias;4;0;Create;True;0;0;False;0;0;-0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-2769.344,1336.648;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;6;-2565.096,682.2184;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2242.175,1050.037;Inherit;False;Property;_Fresnel_Scale;Fresnel_Scale;5;0;Create;True;0;0;False;0;0;1.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2292.01,1651.208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2440.01,1376.208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-2288.175,796.0369;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2162.707,1406.705;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2038.127,845.3956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1928.574,1407.887;Inherit;True;Property;_FlowEmiss;FlowEmiss;6;0;Create;True;0;0;False;0;-1;None;6e07fffb02234bf48972babb05711c4d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;41;368.8015,782.502;Inherit;False;678.5193;337.0212;Comment;3;35;13;34;有些原始贴图的轮廓;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;17;-1823.17,845.8469;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-1641.738,832.7736;Inherit;False;FresnelFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;730.0661,1004.523;Inherit;False;Property;_TexPower;TexPower;10;0;Create;True;0;0;False;0;0;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;418.8015,851.3362;Inherit;True;Property;_Albedo;Albedo;9;0;Create;True;0;0;False;0;-1;None;e747c7b1da556924ba4109f4375118f5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1545.387,1431.533;Inherit;False;FlowFactor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;27.93337,389.6199;Inherit;False;15;FresnelFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;41.05455,499.0133;Inherit;False;33;FlowFactor;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;34;869.9875,832.502;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;108.6255,222.8588;Inherit;False;Property;_RimColor_Intensity;RimColor_Intensity;2;0;Create;True;0;0;False;0;0;1.701081;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-71.80006,53.42722;Inherit;False;Property;_RimColor;RimColor;1;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.01228649,0.04091521,0.6172068,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;32;440.9419,428.1907;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;326.6263,66.58716;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;19;-72.13438,-158.2034;Inherit;False;Property;_InnerColor;InnerColor;0;1;[HDR];Create;True;0;0;False;0;0.000303527,0.006048833,0.05286065,1;0.000607054,0.006048833,0.04231142,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;38;810.7213,418.2946;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;714.3819,97.09086;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1302.385,143.8435;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;flowmiss;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;11;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;5;0;4;0
WireConnection;24;0;22;2
WireConnection;24;1;25;2
WireConnection;23;0;22;1
WireConnection;23;1;24;0
WireConnection;6;0;5;0
WireConnection;6;1;8;0
WireConnection;28;0;29;0
WireConnection;28;1;27;0
WireConnection;30;0;23;0
WireConnection;30;1;31;0
WireConnection;9;0;6;0
WireConnection;9;1;10;0
WireConnection;26;0;30;0
WireConnection;26;1;28;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;20;1;26;0
WireConnection;17;0;11;0
WireConnection;15;0;17;0
WireConnection;33;0;20;1
WireConnection;34;0;13;1
WireConnection;34;1;35;0
WireConnection;32;0;18;0
WireConnection;32;1;16;0
WireConnection;32;2;34;0
WireConnection;36;0;1;0
WireConnection;36;1;37;0
WireConnection;38;0;32;0
WireConnection;14;0;19;0
WireConnection;14;1;36;0
WireConnection;14;2;38;0
WireConnection;0;2;14;0
WireConnection;0;9;38;0
ASEEND*/
//CHKSM=7455A4503CF455304715CAD9AFF99EA44544CDEA