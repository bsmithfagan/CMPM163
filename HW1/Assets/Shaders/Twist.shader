//Adapted for Unity from GLSL code at http://www.ozone3d.net/tutorials/mesh_deformer_p3.php

Shader "Custom/Flip"
{
    Properties
    {
    }
    SubShader
    {
     
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;  
                float3 normal : NORMAL;
                
            };
            
            
         
            v2f vert (appdata v)
            {
                v2f o;
               
                float newx = v.vertex.x * _SinTime.y; 
                float newz = v.vertex.z * _SinTime.y; 
                float newy = v.vertex.y * _SinTime.y;
                
                float4 xyz = float4(newx, newy, newz, 1.0);
                
                o.vertex = UnityObjectToClipPos(xyz);
                o.normal = v.normal;
                
                return o;
            }

            float4 normalToColor (float3 n) {
                return float4( (normalize(n) + 1.0) / 2.0, 1.0) ;
            }
           

            fixed4 frag (v2f i) : SV_Target
            {
                return normalToColor(i.normal);
            }
       
            ENDCG
        }
    }
}
