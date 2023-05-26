using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Damage : MonoBehaviour
{
    public int damage = 1;
    public int ownerHashCode;

    public void SetParameters(int damage, int ownerHashCode)
    {
        this.damage = damage;
        this.ownerHashCode = ownerHashCode;
    }
}
