using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Target : MonoBehaviour
{
    public GameObject m_Target;

    private LineDrawer m_LineDrawer;
    private Health m_TargetHealth;

    public float m_RateOfFire = 1.0f;
    public int m_Damage = 1;

    private float m_Timer = 0.0f;

    private void Awake()
    {
        TryGetComponent(out m_LineDrawer);
    }

    void Start()
    {
        m_LineDrawer.m_StartPoint = gameObject.transform.position;
        m_TargetHealth = m_Target.GetComponentInParent<Health>();
    }

    void Update()
    {
        m_LineDrawer.m_EndPoint = m_Target.transform.position;

        m_Timer += Time.deltaTime;

        if (m_Timer >= m_RateOfFire)
        {
            m_TargetHealth.DoDamage(m_Damage);
            m_Timer = 0.0f;
        }

        if (!m_TargetHealth.IsAlive())
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
        m_LineDrawer.m_Enable = debugDraw; 
    }    
}
