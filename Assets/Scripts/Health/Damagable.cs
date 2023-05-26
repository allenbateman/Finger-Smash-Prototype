using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Damagable : MonoBehaviour
{
    private Health selfHealth;
    private int hashCodeTag;

    private void Awake()
    {
        TryGetComponent(out selfHealth);
        hashCodeTag = tag.GetHashCode();
    }

    private void OnCollisionEnter(Collision collision)
    {
        // Receive damage
        Damage damage;
        if (collision.gameObject.TryGetComponent<Damage>(out damage))
        {
            // Don't do damage to ourselves
            if (hashCodeTag == damage.ownerHashCode)
                return;

            selfHealth.DoDamage(damage.damage);
        }
    }
}
