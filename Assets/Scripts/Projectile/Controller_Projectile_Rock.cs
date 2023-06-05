using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class Controller_Projectile_Rock : MonoBehaviour
{
    public GameObject ExplosionGameObject;
    private ParticleSystem explosionParticle;
    private Rigidbody body;

    public GameObject explosionPrefab;

    public float explosionMaxTime = 1.0f;
    private bool hasEnabledExplosion = false;
    private float explosionCounter = 0.0f;

    private int towerTagHashCode;

    private void Awake()
    {
        ExplosionGameObject.SetActive(false);
        ExplosionGameObject.TryGetComponent(out explosionParticle);
        TryGetComponent(out body);
        towerTagHashCode = "Tower".GetHashCode();
    }

    private void Update()
    {
        if (hasEnabledExplosion)
        {
            if (explosionCounter > explosionMaxTime)
            {
                // Disable explosion
                GameObject.Destroy(ExplosionGameObject.gameObject);
                GameObject.Destroy(this.gameObject);
                explosionCounter = 0.0f;
                hasEnabledExplosion = false;
            }

            explosionCounter += Time.deltaTime;
        }

    }

    // Rock has collided
    private void OnCollisionEnter(Collision collision)
    {
        int code = collision.transform.tag.GetHashCode();
        if (code == towerTagHashCode)
            return;
        
            // Enable explosion
            hasEnabledExplosion = true;
            ExplosionGameObject.SetActive(true);

            GameObject go = Instantiate(explosionPrefab);
            go.transform.position = transform.position;

            // Deatach explosion and it's particle
            body.velocity = Vector3.zero;
            GetComponent<Renderer>().enabled = false;   
            ExplosionGameObject.transform.localScale = Vector3.one;

            if (explosionParticle)
                explosionParticle.Play();
        
    }
}
