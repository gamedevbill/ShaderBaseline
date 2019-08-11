using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderInputSample : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        var sprite = GetComponent<SpriteRenderer>();
        var mat = sprite.material;
        mat.SetColor("_TintShade", Color.red);
    }
}
