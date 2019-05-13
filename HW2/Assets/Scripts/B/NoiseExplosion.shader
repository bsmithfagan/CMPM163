
Shader "Custom/NoiseExplosion" 
{
	Properties
	{
         _DisplacementAmt ("Displacement", Float) = 1.0 
		 _Cube("Cubemap", CUBE) = "" {}
		 _R("R", Range(0, 1)) = 0.1
		 _G("G", Range(0, 1)) = 1.0
		 _B("B", Range(0, 1)) = 1.0
		 _MainTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
        // Shader code
		Pass
        {
		
         
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
        
			// noise functions from https://github.com/keijiro/NoiseShader/blob/master/Assets/HLSL/ClassicNoise3D.hlsl        


			float3 mod(float3 x, float3 y)
			{
			  return x - y * floor(x / y);
			}

			float3 mod289(float3 x)
			{
			  return x - floor(x / 289.0) * 289.0;
			}

			float4 mod289(float4 x)
			{
			  return x - floor(x / 289.0) * 289.0;
			}

			float4 permute(float4 x)
			{
			  return mod289(((x*34.0)+1.0)*x);
			}

			float4 taylorInvSqrt(float4 r)
			{
			  return (float4)1.79284291400159 - r * 0.85373472095314;
			}

			float3 fade(float3 t) {
			  return t*t*t*(t*(t*6.0-15.0)+10.0);
			}
			// Classic Perlin noise, periodic variant
			float pnoise(float3 P, float3 rep)
			{
			  float3 Pi0 = mod(floor(P), rep); // Integer part, modulo period
			  float3 Pi1 = mod(Pi0 + (float3)1.0, rep); // Integer part + 1, mod period
			  Pi0 = mod289(Pi0);
			  Pi1 = mod289(Pi1);
			  float3 Pf0 = frac(P); // Fractional part for interpolation
			  float3 Pf1 = Pf0 - (float3)1.0; // Fractional part - 1.0
			  float4 ix = float4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
			  float4 iy = float4(Pi0.y, Pi0.y, Pi1.y, Pi1.y);
			  float4 iz0 = (float4)Pi0.z;
			  float4 iz1 = (float4)Pi1.z;

			  float4 ixy = permute(permute(ix) + iy);
			  float4 ixy0 = permute(ixy + iz0);
			  float4 ixy1 = permute(ixy + iz1);

			  float4 gx0 = ixy0 / 7.0;
			  float4 gy0 = frac(floor(gx0) / 7.0) - 0.5;
			  gx0 = frac(gx0);
			  float4 gz0 = (float4)0.5 - abs(gx0) - abs(gy0);
			  float4 sz0 = step(gz0, (float4)0.0);
			  gx0 -= sz0 * (step((float4)0.0, gx0) - 0.5);
			  gy0 -= sz0 * (step((float4)0.0, gy0) - 0.5);

			  float4 gx1 = ixy1 / 7.0;
			  float4 gy1 = frac(floor(gx1) / 7.0) - 0.5;
			  gx1 = frac(gx1);
			  float4 gz1 = (float4)0.5 - abs(gx1) - abs(gy1);
			  float4 sz1 = step(gz1, (float4)0.0);
			  gx1 -= sz1 * (step((float4)0.0, gx1) - 0.5);
			  gy1 -= sz1 * (step((float4)0.0, gy1) - 0.5);

			  float3 g000 = float3(gx0.x,gy0.x,gz0.x);
			  float3 g100 = float3(gx0.y,gy0.y,gz0.y);
			  float3 g010 = float3(gx0.z,gy0.z,gz0.z);
			  float3 g110 = float3(gx0.w,gy0.w,gz0.w);
			  float3 g001 = float3(gx1.x,gy1.x,gz1.x);
			  float3 g101 = float3(gx1.y,gy1.y,gz1.y);
			  float3 g011 = float3(gx1.z,gy1.z,gz1.z);
			  float3 g111 = float3(gx1.w,gy1.w,gz1.w);

			  float4 norm0 = taylorInvSqrt(float4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
			  g000 *= norm0.x;
			  g010 *= norm0.y;
			  g100 *= norm0.z;
			  g110 *= norm0.w;
			  float4 norm1 = taylorInvSqrt(float4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
			  g001 *= norm1.x;
			  g011 *= norm1.y;
			  g101 *= norm1.z;
			  g111 *= norm1.w;

			  float n000 = dot(g000, Pf0);
			  float n100 = dot(g100, float3(Pf1.x, Pf0.y, Pf0.z));
			  float n010 = dot(g010, float3(Pf0.x, Pf1.y, Pf0.z));
			  float n110 = dot(g110, float3(Pf1.x, Pf1.y, Pf0.z));
			  float n001 = dot(g001, float3(Pf0.x, Pf0.y, Pf1.z));
			  float n101 = dot(g101, float3(Pf1.x, Pf0.y, Pf1.z));
			  float n011 = dot(g011, float3(Pf0.x, Pf1.y, Pf1.z));
			  float n111 = dot(g111, Pf1);

			  float3 fade_xyz = fade(Pf0);
			  float4 n_z = lerp(float4(n000, n100, n010, n110), float4(n001, n101, n011, n111), fade_xyz.z);
			  float2 n_yz = lerp(n_z.xy, n_z.zw, fade_xyz.y);
			  float n_xyz = lerp(n_yz.x, n_yz.y, fade_xyz.x);
			  return 2.2 * n_xyz;
			}

			// If I remember correctly, I got this from https://iquilezles.org
			float turbulence( float3 p ) {
			  float w = 100.0;
			  float t = -.5;
			  for (float f = 1.0 ; f <= 10.0 ; f++ ){
				float power = pow( 2.0, f );
				t += abs( pnoise( float3( power * p ), float3( 10.0, 10.0, 10.0 ) ) / power );
			  }
			  return t;
			}

			uniform float _DisplacementAmt;
    
			sampler _MainTex;  

			struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
					float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                    float4 vertex : SV_POSITION;
					float3 normalInWorldCoords : NORMAL;
					float3 vertexInWorldCoords : TEXCOORD1;
                    float noise1 : TEXCOORD2;
                    float noise2 : TEXCOORD3;
					float displace : TEXCOORD4;
					float2 uv: TEXCOORD0;
            };

 
           v2f vert(appdata v)
           { 
                v2f o;
                
				float timeVal = _Time.y * 0.5;
                float3 timeVec = float3(timeVal, timeVal, timeVal);
                
               // get a 3d noise using the position, low frequency
                float lowFreq = pnoise( v.vertex.xyz + timeVec, float3(100.0,100.0,100.0) );
        
        
				// get a turbulent 3d noise using the normal, normal to high freq
				float highFreq = -.5 * turbulence( 0.7 * (v.vertex.xyz + timeVec) );
          
        
				//add high freq noise + low freq noise together
				//  float displacement = lowFreq;
				// float displacement = highFreq;
				float displacement = (lowFreq + highFreq) * _DisplacementAmt;

        
				o.noise1 = highFreq;
				o.noise2 = lowFreq;
            
				// move the position along the normal and transform it
				float3 displaceAlongNormal = v.normal.xyz * displacement;
				if (displacement > 20) {
					o.vertex = UnityObjectToClipPos(float4(v.vertex.xyz + displaceAlongNormal, 1.0));
				}
				else {
					o.vertex = UnityObjectToClipPos(float4(v.vertex.xyz, 1.0));
				}

				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal 
				o.displace = displacement;
				o.uv = v.uv;

				return o;
           }


		   samplerCUBE _Cube;
		   float _R, _G, _B;


           fixed4 frag(v2f i) : SV_Target
           {
				  float3 P = i.vertexInWorldCoords.xyz;
			if (i.displace < 0) {
				  //get normalized incident ray (from camera to vertex)
				  float3 vIncident = normalize(P - _WorldSpaceCameraPos);

				  //reflect that ray around the normal using built-in HLSL command
				  float3 vReflect = reflect(vIncident, i.normalInWorldCoords);


				  //use the reflect ray to sample the skybox
				  float4 reflectColor = texCUBE(_Cube, vReflect);

				  //refract the incident ray through the surface using built-in HLSL command
				  float3 vRefract = refract(vIncident, i.normalInWorldCoords, 0.5);

				  //float4 refractColor = texCUBE( _Cube, vRefract );


				  float3 vRefractRed = refract(vIncident, i.normalInWorldCoords, 0.1);
				  float3 vRefractGreen = refract(vIncident, i.normalInWorldCoords, 0.4);
				  float3 vRefractBlue = refract(vIncident, i.normalInWorldCoords, 0.7);

				  float4 refractColorRed = texCUBE(_Cube, float3(vRefractRed));
				  float4 refractColorGreen = texCUBE(_Cube, float3(vRefractGreen));
				  float4 refractColorBlue = texCUBE(_Cube, float3(vRefractBlue));
				  float4 refractColor = float4(refractColorRed.r, refractColorGreen.g, refractColorBlue.b, 1.0);


				  return float4(lerp(reflectColor, refractColor, 0.5).rgb, 1.0);	  
			}
			else {
				float3 color = float3(_R, _G, _B);
				float3 color1 = float3(0.0, 0.0, color.b * (1.0 - (3.0 * i.noise1)));
				float3 color2 = float3(color.r, color.g * (1.0 - (3.0 * i.noise2)), 0.0);

				 //float4 finalColor = float4(i.noise2,i.noise2,i.noise2,1.0);
				 //return finalColor;
				 float4 texColor = tex2D(_MainTex, i.uv);
				 //return texColor;
				 return float4(color2.rg, color1.b, 1.0)*texColor;
			}

           }
           ENDCG
        }
	} 
}
