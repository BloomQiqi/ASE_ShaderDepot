// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MatCap"
{
	Properties
	{
		_MatCap("MatCap", 2D) = "white" {}
		_MatCap_Intensity("MatCap_Intensity", Float) = 1
		_MatCap_ADD("MatCap_ADD", 2D) = "white" {}
		_MatCapADD_Intensity("MatCapADD_Intensity", Float) = 1
		_RampTex("RampTex", 2D) = "white" {}
		_Diffuse("Diffuse", 2D) = "white" {}
		_Ramp_Intensity("Ramp_Intensity", Float) = 0
		_Diffuse_Intensity("Diffuse_Intensity", Float) = 0
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
		struct Input
		{
			float3 worldNormal;
			float2 uv_texcoord;
			float3 viewDir;
		};

		uniform sampler2D _MatCap;
		uniform float _MatCap_Intensity;
		uniform sampler2D _MatCap_ADD;
		uniform float _MatCapADD_Intensity;
		uniform sampler2D _Diffuse;
		uniform float4 _Diffuse_ST;
		uniform float _Diffuse_Intensity;
		uniform sampler2D _RampTex;
		uniform float _Ramp_Intensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = i.worldNormal;
			float3 worldToViewDir2 = normalize( mul( UNITY_MATRIX_V, float4( ase_worldNormal, 0 ) ).xyz );
			float2 temp_output_11_0 = ( ( (worldToViewDir2).xy + 1.0 ) * 0.5 );
			float2 uv_Diffuse = i.uv_texcoord * _Diffuse_ST.xy + _Diffuse_ST.zw;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult21 = dot( ase_normWorldNormal , i.viewDir );
			float clampResult32 = clamp( dotResult21 , 0.0 , 1.0 );
			float2 appendResult29 = (float2(( 1.0 - clampResult32 ) , 0.5));
			o.Albedo = ( ( ( tex2D( _MatCap, temp_output_11_0 ) * _MatCap_Intensity ) + ( tex2D( _MatCap_ADD, temp_output_11_0 ) * _MatCapADD_Intensity ) ) * ( tex2D( _Diffuse, uv_Diffuse ) * _Diffuse_Intensity ) * ( tex2D( _RampTex, appendResult29 ) * _Ramp_Intensity ) ).rgb;
			o.Alpha = 1;
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
				surfIN.viewDir = worldViewDir;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Version=17800
411.3333;403.3333;1725.333;927.6667;4350.257;1210.069;3.664945;True;True
Node;AmplifyShaderEditor.CommentaryNode;39;-2387.015,-655.6929;Inherit;False;1045.006;399.4203;Comment;7;1;2;5;10;12;9;11;将法线转换到相机空间用XY作为UV采样;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-2330.921,388.5655;Inherit;False;1528.002;424.1233;Comment;7;19;20;21;32;31;30;29;NdotV可以表示从中心到边缘的一个线性从1到0变换的过程，适合采样渐变贴图;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;1;-2337.015,-597.2615;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;20;-2267.41,628.6889;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;19;-2280.921,438.5655;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TransformDirectionNode;2;-2091.227,-596.0115;Inherit;False;World;View;True;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;21;-1847.83,470.3876;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1801.343,-478.2726;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;5;-1834.176,-605.6929;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;32;-1566.362,509.0537;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1657.342,-566.2726;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1751.343,-371.2726;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;31;-1121.061,670.3358;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1505.343,-535.2726;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1327.061,544.3358;Inherit;False;Constant;_Float4;Float 4;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-964.2537,515.7633;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;13;-722.6506,-289.3625;Inherit;True;Property;_MatCap_ADD;MatCap_ADD;2;0;Create;True;0;0;False;0;-1;f33207bce9b77ca46a730470da95f9a9;25032a54c6c442a4cacf22666413a1da;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-726.222,-590.0439;Inherit;True;Property;_MatCap;MatCap;0;0;Create;True;0;0;False;0;-1;f33207bce9b77ca46a730470da95f9a9;7b6c994ca124f7844933ff29a828e014;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-400.6039,-486.8447;Inherit;False;Property;_MatCap_Intensity;MatCap_Intensity;1;0;Create;True;0;0;False;0;1;1.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-406.6499,-221.4761;Inherit;False;Property;_MatCapADD_Intensity;MatCapADD_Intensity;3;0;Create;True;0;0;False;0;1;1.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2.677216,177.9554;Inherit;False;Property;_Diffuse_Intensity;Diffuse_Intensity;7;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;128,576;Inherit;False;Property;_Ramp_Intensity;Ramp_Intensity;6;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-165.1307,-18.24431;Inherit;True;Property;_Diffuse;Diffuse;5;0;Create;True;0;0;False;0;-1;None;bbac4f3721624824880d5c754c065238;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-234.8244,487.579;Inherit;True;Property;_RampTex;RampTex;4;0;Create;True;0;0;False;0;-1;None;428382bf0a6fe5546a3de070a8af86a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-107.4504,-565.5818;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-80.77197,-333.6827;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;100.7564,-434.5579;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;206.1317,67.91277;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;336,464;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;500.9778,-159.6324;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1333.882,-88.19485;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;MatCap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;5;0;2;0
WireConnection;32;0;21;0
WireConnection;9;0;5;0
WireConnection;9;1;10;0
WireConnection;31;0;32;0
WireConnection;11;0;9;0
WireConnection;11;1;12;0
WireConnection;29;0;31;0
WireConnection;29;1;30;0
WireConnection;13;1;11;0
WireConnection;4;1;11;0
WireConnection;22;1;29;0
WireConnection;14;0;4;0
WireConnection;14;1;15;0
WireConnection;17;0;13;0
WireConnection;17;1;18;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;38;0;33;0
WireConnection;38;1;37;0
WireConnection;34;0;22;0
WireConnection;34;1;35;0
WireConnection;36;0;16;0
WireConnection;36;1;38;0
WireConnection;36;2;34;0
WireConnection;0;0;36;0
ASEEND*/
//CHKSM=B3E2FF27B17A0791C46B1B76972D78D427EE7449