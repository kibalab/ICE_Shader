Shader "Custom/Ice"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _NormalTex("Ice Normal", 2D) = "white" {}
        _DepthTex("Ice Depth Texture", 2D) = "white" {}
        _Tiling("Tiliing", Vector) = (0,0,0,0)
        
        _NormalStrenth("Ice Strength", Range(-1, 10)) = 1.0
        _Depth("Ice Depth", Range(-1, 10)) = 1.0
        _Distance("Ice Visible distance", Range(0, 0.1)) = 0.005
        _Alpha("Ice Alpha", Range(0, 0.1)) = 0.005
    }
    
    
    SubShader
    {
        Tags { "RenderType"="AlphaTest" "Queue"="AlphaTest" "IgnoreProjector"="True"}
        GrabPass{}
        LOD 200
        
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows 

        #pragma target 4.0

        sampler2D _GrabTexture;
        sampler2D _DepthTex;
        sampler2D _NormalTex;

        fixed3 _Color;

        fixed4 _Tiling;

        fixed _NormalStrenth;
        fixed _Depth;
        fixed _Distance;
        fixed _Alpha;
        
        struct Input
        {
            float2 uv_DepthTex;
            float2 uv_NormalTex;
            float4 screenPos;
            float3 worldPos;
            float3 viewDir;

            INTERNAL_DATA
        };
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 t = (_Tiling.x, _Tiling.y);

            fixed4 d = tex2D (_DepthTex, IN.uv_DepthTex * t);
            
            fixed3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            
            fixed3 n = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex * t));
            fixed4 c = tex2D (_GrabTexture, screenUV + n * _NormalStrenth);

            fixed da = _Alpha * 14;

            float3 viewD = normalize(-IN.viewDir);
                float3 pos = (0, 0, 0);
                float3 id = 1.0 / (viewD+0.00001);
                float3 k = abs(id) - pos * id;
                float kMin = min(min(k.x, k.y),k.z);
                pos += kMin * viewD;
            
            float2 of = ParallaxOffset(d, _Distance, clamp(IN.viewDir, 0, 1) );

            of = (of.x, -of.y);
            
            fixed4 d1 = tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            of *= _Depth;
            d1 += tex2D (_DepthTex, (IN.uv_DepthTex + of) * t) * da; da-=_Distance;
            
            o.Albedo = c.rgb + d1 + _Color * d;
            o.Alpha = d;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
