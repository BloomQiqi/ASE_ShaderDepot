Shader "Toon_shader"
{
    Properties
    {
        _BaseMap("Base Map", 2D) = "white" {}
        _NormalMap("Normal Map", 2D) = "Bump"{}
        _AOMap("AO Map", 2D) = "black"{}
        _MaskMap("Mask Map", 2D) = "black"{}
        _RampMap("Ramp Map", 2D) = "white"{}
        _TintLayer1Color("TintLayer1 Color", Color) = (1.0,1.0,1.0,1.0)
        _TintLayer1Offset("TintLayer1 Offset", Range(-1,1)) = 0.0
        _TintLayer2Color("TintLayer2 Color", Color) = (1.0,1.0,1.0,0.0)
        _TintLayer2Offset("TintLayer2 Offset", Range(-1,1)) = 0.0
        _TintLayer3Color("TintLayer3 Color", Color) = (1.0,1.0,1.0,0.0)
        _TintLayer3Offset("TintLayer3 Offset", Range(-1,1)) = 0.0
        _SpecShinness("Spec Shiness", Float) = 1.0
        _SpecIntensity("Spec Intensity", Float) = 1.0
        _SpecColor("Spec Color", Color) = (1,1,1,1) 
        _FresnelMin("Fresnel Min", Range(0,1)) = 0
        _FresnelMax("Fresnel Max", Range(0,1)) = 1
        _Roughness("Roughness", Float) = 1
        _ENVMap("ENV map", Cube) = "white"{}
        _ENVIntensity("ENV Intensity", Float) = 1.0
        _OutlineColor("Outline Color", Color) = (1,1,1,1)
        _OutlineWidth("Outline Width", Float) = 0.01
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
            sampler2D _AOMap;
            sampler2D _MaskMap;
            sampler2D _RampMap;

            float4 _TintLayer1Color;
            float _TintLayer1Offset;
            float4 _TintLayer2Color;
            float _TintLayer2Offset;
            float4 _TintLayer3Color;
            float _TintLayer3Offset;   

            float _SpecShinness;
            float4 _SpecColor;         
            float _SpecIntensity;

            float _FresnelMin;
            float _FresnelMax;

            float _Roughness;

            samplerCUBE _ENVMap;
            float4 _ENVMap_HDR;
            float _ENVIntensity;

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
                //Base 贴图
                half3 base_color = tex2D(_BaseMap, i.uv).rgb;
                //Normal 
                half4 normal_map = tex2D(_NormalMap, i.uv);
                half3 normalData = UnpackNormal(normal_map);
                normalDir = mul(normalData.xyz, TBN);
                //AO Map
                half ao = tex2D(_AOMap, i.uv);
                //Mask map
                half4 mask_map = tex2D(_MaskMap, i.uv);
                half spec_mask = mask_map.b;
                half spec_smoothness = mask_map.a;

                //漫反射 Ramp map
                half NdotL = dot(normalDir, lightDir);
                half half_lambert = (NdotL + 1.0) * 0.5;
                half diffuse_term = half_lambert * ao;
                
                //第一层 暗部上色
                half2 ramp1_uv = half2(diffuse_term + _TintLayer1Offset, 0.5);
                half toon_diffuse1 = tex2D(_RampMap, ramp1_uv).r;
                half3 toon_color1 = lerp(half3(1.0, 1.0, 1.0), _TintLayer1Color.rgb, toon_diffuse1 * _TintLayer1Color.a * i.vertex_color.r); //可以通过a值来控制是否开启第几层颜色
                //第二层 上色
                half2 ramp2_uv = half2(diffuse_term + _TintLayer2Offset, 1 - i.vertex_color.g);//利用顶点色g通道来控制第二层上色的柔和度
                half toon_diffuse2 = tex2D(_RampMap, ramp2_uv).r;
                half3 toon_color2 = lerp(half3(1.0, 1.0, 1.0), _TintLayer2Color.rgb, toon_diffuse2 * _TintLayer2Color.a); 
                //第三层 上色
                half2 ramp3_uv = half2(diffuse_term + _TintLayer3Offset, 1 - i.vertex_color.b);//利用顶点色g通道来控制第二层上色的柔和度
                half toon_diffuse3 = tex2D(_RampMap, ramp3_uv).r;
                half3 toon_color3 = lerp(half3(1.0, 1.0, 1.0), _TintLayer3Color.rgb, toon_diffuse3 * _TintLayer3Color.a); 

                half3 final_diffuse = base_color * toon_color1 * toon_color2 * toon_color3;
                                

                //高光反射
                half NdotH = dot(normalDir, normalize(viewDir + lightDir));
                half spec_term = max(0.0001, pow(NdotH, _SpecShinness)) * ao;
                half3 final_spec = spec_term * spec_mask * _SpecIntensity * _SpecColor;

                //环境光、边缘光
                half fresnel = 1.0 - dot(normalDir, viewDir);
                fresnel = smoothstep(_FresnelMin, _FresnelMax, fresnel);
                half3 reflectDir = reflect(-viewDir, normalDir);
                float roughness = lerp(0.0, 0.95, saturate(_Roughness));
                roughness = roughness * (1.7 - 0.7 * roughness);//计算mipmap层级
                float mip_level = roughness * 6.0;
                float4 color_cubemap = texCUBElod(_ENVMap, float4(reflectDir, mip_level));
                half3 env_color = DecodeHDR(color_cubemap, _ENVMap_HDR);//防止手机平台不支持HDR
                half3 final_env = env_color * spec_mask * fresnel * _ENVIntensity;


                half3 final_color = final_diffuse + final_spec + final_env;
                
                return half4(final_color, 1.0);
            }
            ENDCG
        }
        Pass
        {
            cull front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 pos_world : TEXCOORD1;
                float4 vertex_color : TEXCOORD2;
            };

            sampler2D _BaseMap;

            float _OutlineWidth;
            float4 _OutlineColor;

            v2f vert (appdata v)
            {
                v2f o;
                float3 pos_view = mul(UNITY_MATRIX_MV, v.vertex);
                float3 normal_world = UnityObjectToWorldNormal(v.normal);
                float3 normal_view = normalize(mul((float3x3)UNITY_MATRIX_V, normal_world));

                pos_view = pos_view + normal_view * _OutlineWidth * v.color.a;
                o.pos = mul(UNITY_MATRIX_P, float4(pos_view, 1.0));

                // float3 pos_world = mul(UNITY_MATRIX_M, v.vertex);
                // float3 normal_world = UnityObjectToWorldNormal(v.normal);
                // pos_world = pos_world + normal_world * _OutlineWidth;
                // o.pos = mul(UNITY_MATRIX_VP, float4(pos_world, 1.0));

                o.uv = v.texcoord0;
                o.vertex_color = v.color;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                //Base 贴图
                half3 base_color = tex2D(_BaseMap, i.uv).rgb;
                half maxComponent = max(max(base_color.r, base_color.g), base_color.b);
                half3 saturatedColor = step(maxComponent, base_color) * base_color;//让rgb通道中值更大的一个保留原值，其余通道值置0
                saturatedColor = lerp(base_color.rgb, saturatedColor, 0.6);//插值混合
                half3 outlineColor = 0.8 * saturatedColor * base_color * _OutlineColor;

                return half4(outlineColor, 1.0);
            }
            ENDCG
        }
    }
}
