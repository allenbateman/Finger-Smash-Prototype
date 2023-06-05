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
    private GameObject gameEntitiesGO;
    public float force;
    private void Awake()
    {
        if (TryGetComponent(out tap))
            tap.hitAction += Shoot;
    }

    private void Start()
    {

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

        GameObject go = Instantiate(projectile, GameManager.Instance.GetEntityTransform());
        go.transform.position = towerTransform.position;

        Vector3 direction = position - go.transform.position;
        float distance = direction.magnitude;

        Damage damage = go.GetComponentInChildren<Damage>(true);
        if (damage)
        {
            damage.damage = Tower.projectileDamage;
        }

        if (go.TryGetComponent(out Rigidbody rb))
        {
            rb.AddForce(direction * force, ForceMode.Impulse);
        }
    }
}