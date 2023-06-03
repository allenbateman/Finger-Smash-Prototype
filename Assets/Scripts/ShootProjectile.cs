using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class ShootProjectile : MonoBehaviour
{
    private Tap tap;
    public GameObject projectile;
    public Transform towerTransform;

    float timer;
    public float cooldownTime = 1.5f;
    bool canShoot = false;

    private void Awake()
    {
        if (TryGetComponent(out tap))
            tap.hitAction += Shoot;
    }

    private void Update()
    {
        if (!canShoot)
        {
            timer += Time.deltaTime;

            if (timer > cooldownTime)
            {
                timer = 0.0f;
                canShoot = true;
            }
        }
    }

    private void OnDestroy()
    {
        if (tap != null)
            tap.hitAction -= Shoot;
    }

    void Shoot(Vector3 position)
    {
        if (!canShoot)
            return;

        canShoot = false;

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