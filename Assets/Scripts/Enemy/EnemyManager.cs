using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    // Singleton manager
    public static EnemyManager instance;
    [SerializeField] GameObject enemyPrefab;
    public List<GameObject> enemies = new List<GameObject>();

    void Awake() => instance = this;

    public Enemy SpawnEnemy(Vector3 pos, Quaternion rot)
    {
        GameObject newEnemy = Instantiate(enemyPrefab, pos, rot);

        // TODO: set a starting position in the navmesh

        Enemy enemyCmp;
        newEnemy.TryGetComponent<Enemy>(out enemyCmp);
        enemies.Add(newEnemy);
        return enemyCmp;
    }

    void Update()
    {
        // Useful for UI purposes, visual cues, etc.
    }
}
