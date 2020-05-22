Shader "Unlit/Mosic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LEDTex ("LEDTex", 2D) = "white" {}
        _Lightness ("_Lightness",float) = 1
        
        _TileX ("TileX", float) = 1
        _TileY ("TileY", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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

            sampler2D _MainTex;
            sampler2D _LEDTex;
            float4 _MainTex_ST;
            float _tiling;
            float _Lightness;
            float _TileX;
            float _TileY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 UVxy = float2(floor(i.uv.x * _TileX)/_TileX, floor(i.uv.y * _TileY)/_TileY);
                fixed4 col = tex2D(_MainTex, UVxy);
                
                float2 b = float2(i.uv.x * _TileX, i.uv.y * _TileY);
                fixed4 LED = tex2D(_LEDTex, b);
                
                return col * LED * _Lightness;
            }
            ENDCG
        }
    }
}
