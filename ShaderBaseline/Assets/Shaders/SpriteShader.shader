Shader "Custom/Image"
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
            //#pragma fragment sampling
            #pragma fragment transparent
            //#pragma fragment timeShift
            //#pragma fragment swizzle
            //#pragma fragment timeShift
            //#pragma fragment tinted
			//#pragma fragment hueshift
			//#pragma fragment swirl
			//#pragma fragment inversion

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
            
            fixed4 transparent(v2f iTexCoord) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, iTexCoord.uv);
                texColor.a = saturate(texColor.a*(1-iTexCoord.uv.x)*10 - 2);
                return texColor;
            }
            
            fixed4 swizzle (v2f iTexCoord) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, iTexCoord.uv);
                texColor = texColor.gbra;
                return texColor;
            }
            
            fixed4 inversion (v2f iTexCoord) : SV_Target
            { 
                fixed4 texColor = tex2D(_MainTex, iTexCoord.uv);
                texColor.rgb = 1 - texColor.rgb;
                return texColor;
            }

            fixed4 timeShift (v2f iTexCoord) : SV_Target
            {
                float2 texCoord = iTexCoord.uv;
                texCoord.x +=_SinTime;
                float4 texColor = tex2D(_MainTex, texCoord);

                return texColor;
            }

            fixed4 greyscale (v2f iTexCoord) : SV_Target
            {
                float4 texColor = tex2D(_MainTex, iTexCoord.uv);
                float grey = texColor.r * 0.3 + texColor.g * 0.5 + texColor.b * 0.11;

                return float4(grey, grey, grey, texColor.a);
            }

            fixed4 tinted (v2f iTexCoord) : SV_Target
            {
                float4 texColor = tex2D(_MainTex, iTexCoord.uv);
                float grey = texColor.r * 0.3 + texColor.g * 0.5 + texColor.b * 0.11;
                
                return float4(grey, grey, grey, texColor.a).rgba * _TintShade.rgba;
            }
              
            
            fixed4 swirl (v2f iTexCoord ) : SV_Target
            {
                float2 texCoord = iTexCoord.uv;
                texCoord -= float2(0.5,0.5);
                
                float radius = sqrt(texCoord.x * texCoord.x + texCoord.y * texCoord.y);
                float angle = 0;
                if(texCoord.x != 0)
                    angle = atan(texCoord.y / texCoord.x);
                if(texCoord.x < 0)
                    angle += 3.141592;
                
                angle += _SinTime.x * radius*10;
                
                texCoord.x = radius * cos(angle);
                texCoord.y = radius * sin(angle);
                
                
                texCoord += float2(0.5,0.5);
                fixed4 col = tex2D(_MainTex, texCoord);
                return col;
            }
            
            ENDCG
        }
    }
}
