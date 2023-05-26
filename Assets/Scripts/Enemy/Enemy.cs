using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Enemy : MonoBehaviour
{
    [SerializeField] bool isMelee = true;
    public GameObject attack;
    Health health;
   
    public EnemyStatsSO enemyStats;
    private Transform wayPoint;
    private NavMeshAgent agent;
    private GameObject tower;

    private float rateOfFire;
    private float rangeOfFire;
    private float timer;

    private void Awake()
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
    }
    private void Start()
    {
        health.SetHealth(enemyStats.Enemy_Melee_Health);
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
        Vector3 dir = tower.transform.position - transform.position;

        Quaternion quaternion = Quaternion.identity;
        quaternion.SetLookRotation(dir.normalized);
        GameObject go = GameObject.Instantiate(attack, gameObject.transform.position, quaternion);

        Rigidbody rigidbody;
        if (go.TryGetComponent(out rigidbody))
        {
            rigidbody.AddForce(dir * 10, ForceMode.Impulse);
        }
        timer = 0.0f;
    }
}
