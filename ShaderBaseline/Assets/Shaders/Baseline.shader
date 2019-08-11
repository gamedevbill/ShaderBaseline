Shader "Custom/Baseline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TintShade ("Tint Shade", Color) = (0.2,0.2,0.9,1.0)
    }
    SubShader
    {
        //** No culling or depth -- use for post proc
        //Cull Off ZWrite Off ZTest Always
        //** No culling -- use for non-transparent sprites.
        //Cull Off ZWrite On ZTest Always
        //** transparent sprite
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Zwrite On 
        Blend SrcAlpha OneMinusSrcAlpha
        //** 3D things
        //Tags { "Queue"="Geometry" "RenderType"="Opaque" }
        //Zwrite On 
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment sampling

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _TintShade;

            fixed4 sampling (v2f iTexCoord) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, iTexCoord.uv);
                return texColor;
            }
            
            ENDCG
        }
    }
}
