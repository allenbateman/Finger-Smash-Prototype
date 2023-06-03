using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using Unity.VisualScripting;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class Tower : MonoBehaviour
{
    public GameObject TargetPrefab;

    private Queue<Target> targets= new Queue<Target>();
    private HashSet<int> idSet = new HashSet<int>();

    private SphereCollider m_Collider;
    public int maxTargets = 4;
    public float rateOfFire = 1.0f;

    [SerializeField] int rayDamage = 1;
    [SerializeField] int projectileDamage = 10; 
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

        foreach (var item in targets)
        {
            if (item.IsDestroyed() == false)
                GameObject.Destroy(item.gameObject);    
        }
    }
    private void AddTarget(GameObject targetGo)
    {
        GameObject go = Instantiate(TargetPrefab);
        Target target = go.AddComponent<Target>();

        targets.Enqueue(target);
        idSet.Add(targetGo.GetInstanceID());
        go.transform.position = new Vector3(gameObject.transform.position.x, 3, gameObject.transform.position.z);

        target.target = targetGo;
        target.damage = rayDamage;
        target.rateOfFire = rateOfFire;
        target.SetDebugDraw(true);

    }
    private void OnTargetDeath(Target target)
    {
        // Remove the dead enemy from the target queue
        if (targets.Contains(target))
        {
            Target tmp = targets.Dequeue();
            idSet.Remove(tmp.gameObject.GetInstanceID());
            Debug.Log("Enemy died!");
        }
    }

    private void OnChildTriggerStay(Collider other)
    {
        if (targets.Count < maxTargets && other.CompareTag("Enemy"))
        {
            int instanceID = other.gameObject.GetInstanceID();
            if (!idSet.Contains(instanceID))
                AddTarget(other.gameObject);
        }
    }
}
