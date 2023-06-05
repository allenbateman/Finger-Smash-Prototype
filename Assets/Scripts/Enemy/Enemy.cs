using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;
using static UnityEngine.GraphicsBuffer;

public class Enemy : MonoBehaviour
{
    [SerializeField] bool isMelee = true;
    public GameObject attack;
    Health health;
   
    public EnemyStatsObject enemyStats;
    private Transform wayPoint;
    private NavMeshAgent agent;
    private GameObject tower;

    private GameObject gameEntitiesGO;
    public GameObject fallParticlePrefab;

    [SerializeField] private GameObject fireChild;

    private float rateOfFire;
    private float rangeOfFire;
    private float timer;

    public float launchAngle = 45f;

    public bool Dragged = false;

    private Animator animator;

    public AudioClip fallScreamSound;
    public AudioClip hitGroundSound;

    private void Awake()
    {
        Init();
    }
    public void Init()
    {
        TryGetComponent(out health);
        TryGetComponent(out agent);
        TryGetComponent(out animator);
        tower = GameObject.FindGameObjectWithTag("Tower");

        if (isMelee)
        {
            rateOfFire = enemyStats.Enemy_Melee_RateOfAttack;
            rangeOfFire = enemyStats.Enemy_Melee_RangeOfAttack;
            health.SetHealth(enemyStats.Enemy_Melee_Health);
        }
        else
        {
            rateOfFire = enemyStats.Enemy_Ranged_RateOfAttack;
            rangeOfFire = enemyStats.Enemy_Ranged_RangeOfAttack;
            health.SetHealth(enemyStats.Enemy_Ranged_Health);
        }

    }
    private void Start()
    {
        if (tower == null)
            return;

        agent.SetDestination(tower.transform.position);

        gameEntitiesGO = GameManager.Instance.gameEntitiesGO;
    }

    private void Update()
    {
        if (tower == null)
            return;

        float distance = Vector3.Distance(transform.position, tower.transform.position);
        
        if (distance <= rangeOfFire && timer >= rateOfFire)
        {
            AttackAnim();
        }

        timer += Time.deltaTime;

    }

    void Attack()
    {
        Vector3 dir = tower.transform.position - fireChild.transform.position;
        Quaternion quaternion = Quaternion.identity;
        quaternion.SetLookRotation(dir.normalized);
        GameObject go = GameObject.Instantiate(attack, fireChild.transform.position, quaternion, gameEntitiesGO.transform);

        if (go.TryGetComponent(out Rigidbody rb))
        {
            //rb.AddForce(dir.normalized * 6, ForceMode.Impulse);
            //rb.AddForce(0, 100, 0);

            Vector3 direction = tower.transform.position - fireChild.transform.position;
            float distance = direction.magnitude;

            float projectileTime = CalculateProjectileTime(distance);
            Vector3 projectileVelocity = CalculateProjectileVelocity(direction, projectileTime);

            rb.velocity = projectileVelocity;
        }

        if (go.TryGetComponent(out Damage damage))
        {
            damage.damage = enemyStats.Enemy_Ranged_Damage;
            damage.ownerHashCode = tag.GetHashCode();
        }
    }

    void AttackAnim()
    {
        animator.Play("Attacking.Anim_Ranged");

        timer = 0.0f;
    }

    private float CalculateProjectileTime(float distance)
    {
        float gravity = Physics.gravity.magnitude;
        float projectileTime = Mathf.Sqrt((2f * distance) / gravity);
        return projectileTime;
    }

    private Vector3 CalculateProjectileVelocity(Vector3 direction, float time)
    {
        Vector3 projectileVelocity = direction / time;
        return projectileVelocity;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(Dragged && collision.transform.CompareTag("Ground"))
        {
            health.DoDamage((int)GetComponent<Rigidbody>().velocity.magnitude * 2);

            GetComponent<NavMeshAgent>().enabled = true;

            if (fallParticlePrefab != null)
            { 
                Instantiate(fallParticlePrefab, GameManager.Instance.GetEntityTransform()).transform.position = transform.position;
                GetComponent<AudioSource>().clip = hitGroundSound;
                GetComponent<AudioSource>().Play();
            }
        }
    }

    public void PlayAudioScream()
    {

        GetComponent<AudioSource>().clip = fallScreamSound;
        GetComponent<AudioSource>().Play();
        
    }
}
