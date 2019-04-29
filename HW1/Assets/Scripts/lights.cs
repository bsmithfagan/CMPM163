using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class lights : MonoBehaviour
{
    public Light R, G, B;

    void Update()
    {
        R.transform.RotateAround(new Vector3(0, 0, 0), new Vector3(0, 1, 0), 2);
        G.transform.RotateAround(new Vector3(0, 0, 0), new Vector3(1, 0, 0), 2);
        B.transform.RotateAround(new Vector3(0, 0, 0), new Vector3(0, 0, 1), 2);
    }
}
