using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleScript : MonoBehaviour {

    public ParticleSystem ps, ps2;
    Color Default;
    public GameObject anchor;
    void Start () 
    {
        // Get Particle system component
        // Call particle play function

        Default = ps2.startColor;
	}

	void Update () {
    
		int numPartitions = 1;
		float[] aveMag = new float[numPartitions];
		float partitionIndx = 0;
		int numDisplayedBins = 512 / 2; 

		for (int i = 0; i < numDisplayedBins; i++) 
		{
			if(i < numDisplayedBins * (partitionIndx + 1) / numPartitions){
				aveMag[(int)partitionIndx] += AudioPeer.spectrumData [i] / (512/numPartitions);
			}
			else{
				partitionIndx++;
				i--;
			}
		}

		for(int i = 0; i < numPartitions; i++)
		{
			aveMag[i] = (float)0.5 + aveMag[i]*100;
			if (aveMag[i] > 100) {
				aveMag[i] = 100;
			}
		}

		float mag = aveMag[0];

        // if mag is greater than some threshold(0.6)
        // emit particle using emit function
        ps.subEmitters.SetSubEmitterEmitProbability(0, Mathf.Lerp(0f, 1f, mag));
        ps.subEmitters.SetSubEmitterEmitProbability(1, mag > .6 ? 0.1f : 0);

        if (Input.GetKeyDown(KeyCode.Space))
        {
            ps2.startColor = Default;
        }

        if (Input.GetKeyDown(KeyCode.R))
        {
            ps2.startColor = new Color(Mathf.Abs(ps2.startColor.r - 1f), ps2.startColor.g, ps2.startColor.b, ps2.startColor.a);
        }
        if (Input.GetKeyDown(KeyCode.G))
        {
            ps2.startColor = new Color(ps2.startColor.r, Mathf.Abs(ps2.startColor.g - 1f), ps2.startColor.b, ps2.startColor.a);
        }
        if (Input.GetKeyDown(KeyCode.B))
        {
            ps2.startColor = new Color(ps2.startColor.r, ps2.startColor.g, Mathf.Abs(ps2.startColor.b - 1f), ps2.startColor.a);
        }

        anchor.transform.Rotate(new Vector3(0, .5f, 0));
    }
}

