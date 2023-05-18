using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;

public class Spawner : MonoBehaviour
{
    public float m_SpawnTime = 1.0f;
    private float m_Timer = 0.0f;
    private EnemyManager m_EnemyManager;

    public float m_MaxDistance = 10f;
    public int m_MaxAttempts = 50;

    private void Awake()
    {
        m_EnemyManager = EnemyManager.instance;
    }

    void Start()
    {
        m_Timer = 0.0f;
    }
    void Update()
    {
        m_Timer += Time.deltaTime;

        if (m_Timer > m_SpawnTime) {
            Vector3 pos = GetRandomPosition();
            Quaternion rot = Quaternion.LookRotation(pos, Vector3.up);
            m_EnemyManager.SpawnEnemy(pos, rot);
            m_Timer = 0.0f;   
        }
    }

    private Vector3 GetRandomPosition()
    {
        NavMeshHit hit;
        Vector3 randomPosition = Vector3.zero;
        int attempts = 0;

        while (attempts < m_MaxAttempts)
        {
            // Generate a random point within the m_MaxDistance range from the current position
            Vector3 randomOffset = UnityEngine.Random.insideUnitSphere * m_MaxDistance;
            Vector3 newPosition = transform.position + randomOffset;

            // Check if the random position is within the desired area mask
            if (NavMesh.SamplePosition(newPosition, out hit, m_MaxDistance, 3))
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
}
