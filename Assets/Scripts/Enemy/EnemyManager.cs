using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    // Singleton manager
    public static EnemyManager instance;
    public List<GameObject> enemies = new List<GameObject>();
    [SerializeField] private List<Spawner> spawners;
    [SerializeField] GameObject enemyRangedPrefab;
    [SerializeField] GameObject enemyMeleePrefab;

    private GameObject gameEntitiesGO;
    public GameObject spawnParticle;
    private Queue<GameObject> spawnParticles = new Queue<GameObject>();
    public bool enemiesLimit = false;
    public int maxEnemiesLimit = 15;
    void Awake()
    {
        instance = this;
        gameEntitiesGO = GameManager.Instance.gameEntitiesGO;
    }

    public Enemy SpawnEnemy(Vector3 pos, Quaternion rot, bool isMelee)
    {
        // Setting the spawning particle
        if (spawnParticles.Count >= spawners.Count)
        {
            Destroy(spawnParticles.Dequeue());
        }

        spawnParticles.Enqueue(Instantiate(spawnParticle, pos, rot, gameEntitiesGO.transform));

        GameObject newEnemy = null;
        if (isMelee)
        {
            newEnemy = Instantiate(enemyMeleePrefab, pos, rot, gameEntitiesGO.transform);

        }
        else
        {
            newEnemy = Instantiate(enemyRangedPrefab, pos, rot, gameEntitiesGO.transform);
        }
        
        Enemy enemyCmp;
        newEnemy.TryGetComponent<Enemy>(out enemyCmp);
        enemies.Add(newEnemy);
        return enemyCmp;
    }

    void Update()
    {
        // Useful for UI purposes, visual cues, etc.
        for (int i = 0; i < enemies.Count; i++)
        {
            if (enemies[i] == null)
                enemies.RemoveAt(i);
        }

        if (enemies.Count > maxEnemiesLimit)
        {
            enemiesLimit = true;
        }
        else
            enemiesLimit = false;
    }

    public void StartSpawning()
    {
        foreach (Spawner s in spawners)
        {
            s.Spawn(true);
        }
    }
    public void StopSpawning()
    {
        foreach (Spawner s in spawners)
        {
            s.Spawn(false);
        }
    }

    public void KillAllEnemies()
    {
        foreach (GameObject e in enemies)
        {
            Destroy(e);
        }

        enemies.Clear();
    }

    public void ResetSpawners()
    {
        foreach (Spawner s in spawners)
        {
            s.ResetTimer();
        }
    }
}
