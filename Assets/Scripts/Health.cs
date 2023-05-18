using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Health : MonoBehaviour
{
    private int m_Health;
    public int m_MaxHealth;
    private bool m_IsAlive;
    // Start is called before the first frame update
    void Start()
    {
        m_Health = m_MaxHealth;
        m_IsAlive = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (!m_IsAlive)
            Destroy(gameObject);

        if (m_Health <= 0)
            m_IsAlive = false;

    }

    public void DoDamage(int damage)
    {
        if (m_IsAlive)
        {
            Debug.Log("Damage: " + damage + " -- Health: " + m_Health);
            m_Health -= damage;
        }
    }

    public bool IsAlive()
    {
        return m_IsAlive;
    }
}
