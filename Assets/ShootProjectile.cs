using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShootProjectile : MonoBehaviour
{
    private Tap tap;
    private void Awake()
    {
        if (TryGetComponent(out tap))
            tap.hitAction += Shoot;
    }

    private void OnDestroy()
    {
        if (tap != null)
            tap.hitAction -= Shoot;
    }

    void Shoot(Vector3 position)
    {

    }
}
