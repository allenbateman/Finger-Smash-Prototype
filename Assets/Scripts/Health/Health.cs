using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class Health : MonoBehaviour
{
    [SerializeField] int health;
    [SerializeField] private GameObject goldParticlePrefab;
    [SerializeField] HealthBar healthBar;

    public int maxHealth;
    private bool isAlive;
    // Start is called before the first frame update
    void Start()
    {
        isAlive = true;

        if (healthBar)
            healthBar.UpdateHealthBar(maxHealth, health);
    }

    public void DoDamage(int damage)
    {
        health -= damage;
        if (health <= 0)
        {
            isAlive = false;
            Instantiate(goldParticlePrefab);
            Debug.Log("instantiating gold particle");
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