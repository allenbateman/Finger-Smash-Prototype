using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
public class Health : MonoBehaviour
{
    [SerializeField] int health;
    [SerializeField] private GameObject goldParticlePrefab;
    [SerializeField] HealthBar healthBar;
    [SerializeField] int goldValue;
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
        healthBar.UpdateHealthBar(maxHealth, health);
        if (health <= 0)
        {
            isAlive = false;
            GameManager.Instance.AddGold(goldValue);

            if (goldParticlePrefab != null)
            {
                GameObject particle = Instantiate(goldParticlePrefab);
                TextMesh text = particle.GetComponentInChildren<TextMesh>();
                text.text = "+" + goldValue.ToString();
                particle.transform.position = transform.position;
            }
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

    public void ResetHealth()
    {
        SetHealth(maxHealth);
    }
}