Shader "Toon_Eye"
{
    Properties
    {
        _BaseMap("Base Map", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "Bump"{}
        _DecalMap("Decal Map", 2D) = "white"{}
        _Parallax("Parallax", Float) = 1
        _SpecShinness("Spec Shiness", Float) = 1.0
        _SpecIntensity("Spec Intensity", Float) = 1.0
        _SpecColor("Spec Color", Color) = (1,1,1,1) 

        _Roughness("Roughness", Float) = 1
        _ENVMap("ENV map", Cube) = "white"{}
        _ENVIntensity("ENV Intensity", Float) = 1.0
        _RotatedDegree("Rotate Degree", Range(0, 300)) = 0
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                float3 normal_world : TEXCOORD1;
                float3 tangent_world : TEXCOORD2;
                float3 binormal_world : TEXCOORD3;
                float3 pos_world : TEXCOORD4;
                float4 vertex_color : TEXCOORD5;
            };

            sampler2D _BaseMap;
            sampler2D _NormalMap;
            sampler2D _DecalMap;

            float _Parallax;

            float4 _TintLayer1Color;
            float _TintLayer1Offset;

            float _SpecShinness;
            float4 _SpecColor;         
            float _SpecIntensity;

            float _Roughness;

            samplerCUBE _ENVMap;
            float4 _ENVMap_HDR;
            float _ENVIntensity;

            float _RotatedDegree;


			float3 RotateAround(float degree, float3 target)
			{
				float rad = degree * UNITY_PI / 180;
				float2x2 m_rotate = float2x2(cos(rad), -sin(rad),
					sin(rad), cos(rad));
				float2 dir_rotate = mul(m_rotate, target.xz);
				target = float3(dir_rotate.x, -target.y, dir_rotate.y);
				return target;
			}           

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.pos_world = mul(unity_ObjectToWorld, v.vertex);
                o.normal_world = UnityObjectToWorldNormal(v.normal);
                o.tangent_world = UnityObjectToWorldDir(v.tangent.xyz);
                o.binormal_world = cross(o.tangent_world, o.normal_world) * v.tangent.w;
                o.vertex_color = v.color;

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                //向量
                half3 normalDir = normalize(i.normal_world);
                half3 tangentDir = normalize(i.tangent_world);
                half3 binormalDir = normalize(i.binormal_world);
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.pos_world);
                //TBN矩阵
                float3x3 TBN = float3x3(tangentDir, binormalDir, normalDir);
                //Normal 
                half4 normal_map = tex2D(_NormalMap, i.uv);
                half3 normalData = UnpackNormal(normal_map);
                normalDir = normalize(mul(normalData.xyz, TBN));

                //视差偏移
                half3 tanViewDir = normalize(mul(TBN, viewDir)); 
                half2 Parallax_offset = (tanViewDir.xy / (tanViewDir.z + 0.42f)) * _Parallax;//若有高度图做权重更好 

                //Base 贴图
                half3 base_color = tex2D(_BaseMap, i.uv + Parallax_offset).rgb;//采样时进行视差偏移
                half3 decal_color = tex2D(_DecalMap, i.uv + Parallax_offset).rgb;

                //漫反射 
                half NdotL = max(0.0001, dot(normalDir, lightDir));
                half half_lambert = (NdotL + 1.0) * 0.5;
                half diffuse_term = half_lambert;
                half3 final_diffuse = diffuse_term * base_color * base_color + decal_color;

                //高光反射
                half NdotH = dot(normalDir, normalize(viewDir + lightDir));
                half spec_term = max(0.0001, pow(NdotH, _SpecShinness));
                half3 final_spec = spec_term  * _SpecIntensity * _SpecColor;

                //环境光
                half3 reflectDir = reflect(-viewDir, normalDir);  
                reflectDir = RotateAround(_RotatedDegree, reflectDir);
                float roughness = lerp(0.0, 0.95, saturate(_Roughness));
                roughness = roughness * (1.7 - 0.7 * roughness);//计算mipmap层级
                float mip_level = roughness * 6.0;
                float4 color_cubemap = texCUBElod(_ENVMap, float4(reflectDir, mip_level));
                half3 env_color = DecodeHDR(color_cubemap, _ENVMap_HDR);//防止手机平台不支持HDR
                half3 final_env = env_color * _ENVIntensity;
                half env_lumin = dot(final_env, float3(0.299f, 0.587f, 0.114f));
                final_env = env_lumin * final_env;

                half3 final_color = final_diffuse + final_spec + final_env;
                
                return half4(final_color, 1.0);
            }
            ENDCG
        }
    }
}
