using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class ShootProjectile : MonoBehaviour
{
    private Tap tap;
    public GameObject projectile;
    public Transform towerTransform;

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
        Debug.Log("Shoot!");
        GameObject go = Instantiate(projectile);
        go.transform.position = towerTransform.position;

        Vector3 direction = position - go.transform.position;
        float distance = direction.magnitude;

        if (go.TryGetComponent(out Rigidbody rb))
        {
            rb.AddForce(direction, ForceMode.Impulse);
        }
    }
}
