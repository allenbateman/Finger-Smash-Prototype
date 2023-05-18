using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using Unity.VisualScripting;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class Tower : MonoBehaviour
{
    public GameObject TargetPrefab;

    private Queue<Target> m_Targets= new Queue<Target>();
    private HashSet<int> m_IdSet = new HashSet<int>();

    private SphereCollider m_Collider;
    public int m_MaxTargets = 4;
    public float m_RateOfFire = 1.0f;
    public int m_Damage = 1;

    private void Awake()
    {
        TryGetComponent(out m_Collider);
    }
    void Start()
    {
        // Subscribe to the target's death event
        Target.OnDeath += OnTargetDeath;
    }

    void Update()
    {
        
    }
    private void OnDestroy()
    {
        // Unsubscribe from the target's death event when the tower is destroyed
        Target.OnDeath -= OnTargetDeath;
    }
    private void AddTarget(GameObject targetGo)
    {
        GameObject go = Instantiate(TargetPrefab);
        Target target = go.AddComponent<Target>();

        m_Targets.Enqueue(target);
        m_IdSet.Add(targetGo.GetInstanceID());
        go.transform.position = new Vector3(gameObject.transform.position.x, 3, gameObject.transform.position.z);

        target.m_Target = targetGo;
        target.m_Damage = m_Damage;
        target.m_RateOfFire = m_RateOfFire;
        target.SetDebugDraw(true);

    }
    private void OnTargetDeath(Target target)
    {
        // Remove the dead enemy from the target queue
        if (m_Targets.Contains(target))
        {
            Target tmp = m_Targets.Dequeue();
            m_IdSet.Remove(tmp.gameObject.GetInstanceID());
            Debug.Log("Enemy died!");
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (m_Targets.Count < m_MaxTargets && other.CompareTag("Enemy"))
        {
            int instanceID = other.gameObject.GetInstanceID();
            if (!m_IdSet.Contains(instanceID))
                AddTarget(other.gameObject);
        }
    }
}
