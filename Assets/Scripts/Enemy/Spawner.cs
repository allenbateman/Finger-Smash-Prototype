using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;

public class Spawner : MonoBehaviour
{
    public float spawnTime = 1.0f;
    private float timer = 0.0f;
    private EnemyManager enemyManager;

    public float minDistance = 10f;
    public float maxDistance = 30f;
    public int maxAttempts = 50;

    bool CanSpawn = true;
    public bool spawnMelee = false;

    void Start()
    {
        timer = spawnTime;
        enemyManager = EnemyManager.instance;
        CanSpawn = false;
    }
    void Update()
    {
        if (!CanSpawn) return;

        timer += Time.deltaTime;

        if (timer > spawnTime && enemyManager.enemiesLimit == false) {
            Vector3 pos = GetRandomPosition();
            Quaternion rot = Quaternion.LookRotation(pos, Vector3.up);
            enemyManager.SpawnEnemy(pos, rot, spawnMelee);
            timer = 0.0f;   
        }
    }

    private Vector3 GetRandomPosition()
    {
        NavMeshHit hit;
        Vector3 randomPosition = Vector3.zero;
        int attempts = 0;

        while (attempts < maxAttempts)
        {
            // Generate a random point within the m_MaxDistance range from the current position
            Vector3 randomOffset = UnityEngine.Random.insideUnitSphere * maxDistance;
            Vector3 newPosition = transform.position + randomOffset;

            // Check if the random position is within the desired area mask
            if (NavMesh.SamplePosition(newPosition, out hit, maxDistance, 3))
            {
                randomPosition = hit.position;

                if (Vector3.Distance(hit.position, transform.position) > minDistance)
                {
                    break; // Exit the loop if a valid random position is found
                }
            }

            attempts++;
        }

        if (randomPosition == Vector3.zero)
        {
            // No valid random position found
            Debug.LogWarning("Failed to find a valid random position within the specified area mask.");
        }

        return randomPosition;
    }

    public void Spawn(bool can_spawn)
    {
        CanSpawn = can_spawn;
    }

    public void ResetTimer()
    {
        timer = spawnTime;
    }
}
