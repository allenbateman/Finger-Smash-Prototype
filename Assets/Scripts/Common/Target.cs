    using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Target : MonoBehaviour
{
    public GameObject target;
    public GameObject attackPrefab;

    private LineDrawer lineDrawer;
    private Health targetHealth;

    public float rateOfFire = 1.0f;
    public int damage = 1;

    private float timer = 0.0f;

    private void Awake()
    {
        TryGetComponent(out lineDrawer);
    }

    void Start()
    {
        lineDrawer.startPoint = gameObject.transform.position;
        targetHealth = target.GetComponentInParent<Health>();
    }

    void Update()
    {
        lineDrawer.endPoint = target.transform.position;

        timer += Time.deltaTime;

        if (timer >= rateOfFire)
        {
            targetHealth.DoDamage(damage);
            timer = 0.0f;
        }

        if (!targetHealth.IsAlive())
            Die();
    }

    // Event declaration for target death
    public static event System.Action<Target> OnDeath;

    // Call this method when the target dies
    private void Die()
    {
        // Invoke the death event and pass the target instance
        OnDeath?.Invoke(this);
        Destroy(gameObject);    
    }

    public void SetDebugDraw(bool debugDraw) {
        lineDrawer.enable = debugDraw; 
    }    
}
