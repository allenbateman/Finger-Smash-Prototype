using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Health : MonoBehaviour
{
    [SerializeField] int health;
    public TMPro.TextMeshPro uiText;

    public int maxHealth;
    private bool isAlive;
    // Start is called before the first frame update
    void Start()
    {
        //m_Health = m_MaxHealth;
        uiText = gameObject.GetComponentInChildren<TMPro.TextMeshPro>();
        isAlive = true;
    }

    // Update is called once per frame
    void Update()
    {
        if(uiText)
            uiText.text = health.ToString();

        if (!isAlive)
            Destroy(gameObject);

        if (health <= 0)
            isAlive = false;
    }

    public void DoDamage(int damage)
    {
        if (isAlive)
        {
            Debug.Log("Damage: " + damage + " -- Health: " + health);
            health -= damage;
        }
    }

    public bool IsAlive()
    {
        return isAlive;
    }

    public void SetHealth(int health)
    {
        this.health = health;
        maxHealth = health;
    }
}
