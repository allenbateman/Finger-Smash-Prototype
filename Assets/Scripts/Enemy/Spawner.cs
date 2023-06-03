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

    public float maxDistance = 10f;
    public int maxAttempts = 50;

    bool CanSpawn = true;

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

        if (timer > spawnTime ) {
            Vector3 pos = GetRandomPosition();
            Quaternion rot = Quaternion.LookRotation(pos, Vector3.up);
            enemyManager.SpawnEnemy(pos, rot);
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
                break; // Exit the loop if a valid random position is found
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
}
