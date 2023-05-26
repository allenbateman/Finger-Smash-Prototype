using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    // Singleton manager
    public static EnemyManager instance;
    [SerializeField] GameObject enemyPrefab;
    public List<Enemy> enemies = new List<Enemy>();

    void Awake() => instance = this;

    public Enemy SpawnEnemy(Vector3 pos, Quaternion rot)
    {
        Enemy newEnemy = Instantiate<Enemy>(enemyPrefab, pos, rot);
        enemies.Add(newEnemy);

        // TODO: set a starting position in the navmesh
        return newEnemy;
    }

    private T Instantiate<T>(GameObject enemyPrefab, Vector3 pos, Quaternion rot)
    {
        GameObject go = Instantiate(enemyPrefab, pos, rot);
        T comp;
        go.TryGetComponent(out comp);
        return comp;
    }

    void Update()
    {
        // Useful for UI purposes, visual cues, etc.
    }
}
