using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Health : MonoBehaviour
{
    [SerializeField] int health;
    public TMPro.TextMeshPro uiText;
    [SerializeField] private GameObject goldParticlePrefab;
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
    }

    public void DoDamage(int damage)
    {
        health -= damage;
        Debug.Log("Damage: " + damage + " -- Health: " + health);
        if (health <= 0)
        {
            isAlive = false;
            Instantiate(goldParticlePrefab,transform);
            Destroy(gameObject);
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
