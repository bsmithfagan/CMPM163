Shader "Custom/RenderToTexture_CA"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {} 
    }
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		
		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize;
           
            
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};
   
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            
           
            sampler2D _MainTex;
            
			fixed4 frag(v2f i) : SV_Target
			{

				float2 texel = float2(
					_MainTex_TexelSize.x,
					_MainTex_TexelSize.y
				);

				float cx = i.uv.x;
				float cy = i.uv.y;

				float4 C = tex2D(_MainTex, float2(cx, cy));

				float up = i.uv.y + texel.y * 1;
				float down = i.uv.y + texel.y * -1;
				float right = i.uv.x + texel.x * 1;
				float left = i.uv.x + texel.x * -1;

				float4 arr[8];

				arr[0] = tex2D(_MainTex, float2(cx   , up));   //N
				arr[1] = tex2D(_MainTex, float2(right, up));   //NE
				arr[2] = tex2D(_MainTex, float2(right, cy));   //E
				arr[3] = tex2D(_MainTex, float2(right, down)); //SE
				arr[4] = tex2D(_MainTex, float2(cx   , down)); //S
				arr[5] = tex2D(_MainTex, float2(left , down)); //SW
				arr[6] = tex2D(_MainTex, float2(left , cy));   //W
				arr[7] = tex2D(_MainTex, float2(left , up));   //NW

				int r = 0, g = 0, b = 0;

				for (int i = 0; i < 8; i++) {
					if (arr[i].r >= C.r) {
						r++;
					}
					if (arr[i].g >= C.g) {
						g++;
					}
					if (arr[i].b >= C.b) {
						b++;
					}
				}

				if ((r >= 2 || C.b >= 1) && C.r < 1) {
					C.r += .1;
				}
				else {
					C.r = 0;
				}

				if ((g >= 2 || C.r >= 1) && C.g < 1) {
					C.g += .1;
				}
				else {
					C.g = 0;
				}

				if ((b >= 2 || C.g >= 1) && C.b < 1) {
					C.b += .1;
				}
				else {
					C.b = 0;
				}

				return C;
            }

			ENDCG
		}

	}
	FallBack "Diffuse"
}