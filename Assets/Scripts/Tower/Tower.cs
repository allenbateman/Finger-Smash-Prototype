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
    public List<Transform> wizardsList = new List<Transform>();

    [SerializeField] int rayDamage = 1;

    private GameObject gameEntitiesGO;
    public static int projectileDamage { get; private set; } = 10;

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
        GameObject go = Instantiate(TargetPrefab, GameManager.Instance.gameEntitiesGO.transform);
        Target target = go.AddComponent<Target>();

        targets.Enqueue(target);
        idSet.Add(targetGo.GetInstanceID());

        int count = targets.Count;
        Transform wizardTr = wizardsList[count - 1];
        go.transform.position = wizardTr.position;

        target.target = targetGo;
        target.tickDamage = rayDamage;
        target.SetDebugDraw(true);

    }
    private void OnTargetDeath(Target target)
    {
        // Remove the dead enemy from the target queue
        if (targets.Contains(target))
        {
            Target tmp = targets.Dequeue();
            idSet.Remove(tmp.gameObject.GetInstanceID());
        }
    }

    private void OnChildTriggerStay(Collider other)
    {
        if (targets.Count < wizardsList.Count && other.CompareTag("Enemy"))
        {
            int instanceID = other.gameObject.GetInstanceID();
            if (!idSet.Contains(instanceID))
                AddTarget(other.gameObject);
        }
    }
}
