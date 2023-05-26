using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Enemy : MonoBehaviour
{
    [SerializeField] bool isMelee = true;
    public GameObject attack;
    Health health;
   
    public EnemyStatsObject enemyStats;
    private Transform wayPoint;
    private NavMeshAgent agent;
    private GameObject tower;

    private GameObject fireChild;

    private float rateOfFire;
    private float rangeOfFire;
    private float timer;

    private void Awake()
    {
        Init();
    }

    public void Init()
    {
        TryGetComponent(out health);
        TryGetComponent(out agent);
        tower = GameObject.FindGameObjectWithTag("Tower");

        if (isMelee)
        {
            rateOfFire = enemyStats.Enemy_Melee_RateOfAttack;
            rangeOfFire = enemyStats.Enemy_Melee_RangeOfAttack;
        }
        else
        {
            rateOfFire = enemyStats.Enemy_Ranged_RateOfAttack;
            rangeOfFire = enemyStats.Enemy_Ranged_RangeOfAttack;
        }

        health.SetHealth(enemyStats.Enemy_Melee_Health);
    }
    private void Start()
    {
        fireChild = transform.GetChild(0).GetChild(1).gameObject;
        agent.SetDestination(tower.transform.position);
    }

    private void Update()
    {
        float distance = Vector3.Distance(transform.position, tower.transform.position);
        
        if (distance <= rangeOfFire && timer >= rateOfFire)
        {
            Attack();
        }

        timer += Time.deltaTime;
    }

    void Attack()
    {
        Debug.Log("Attack!");
        Vector3 dir = tower.transform.position - fireChild.transform.position;

        Quaternion quaternion = Quaternion.identity;
        quaternion.SetLookRotation(dir.normalized);
        GameObject go = GameObject.Instantiate(attack, fireChild.transform.position, quaternion);

        Rigidbody rb;
        if (go.TryGetComponent(out rb))
        {
            rb.AddForce(dir.normalized * 6, ForceMode.Impulse);
            rb.AddForce(0, 100, 0);
        }
        timer = 0.0f;
    }
}
