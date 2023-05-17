using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    // Singleton manager
    public static EnemyManager instance;
    [SerializeField] private Enemy m_EnemyPrefab;
    public List<Enemy> enemies = new List<Enemy>();

    void Awake() => instance = this;

    public Enemy SpawnEnemy(Vector3 pos, Quaternion rot)
    {
        Enemy newEnemy = Instantiate(m_EnemyPrefab, pos, rot);
        enemies.Add(newEnemy);

        // TODO: set a starting position in the navmesh
        return newEnemy;
    }

    void Update()
    {
        // Useful for UI purposes, visual cues, etc.
    }
}
