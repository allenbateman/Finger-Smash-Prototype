using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class GoToWaypoint : MonoBehaviour
{
    private Transform m_WayPoint;
    private NavMeshAgent m_Agent;
    private int m_FrameInterval = 4;
    // Start is called before the first frame update
    void Start()
    {
        m_WayPoint = FindObjectOfType<WayPoint>().transform;
        TryGetComponent(out m_Agent);
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.frameCount % m_FrameInterval == 0)
        {
            m_Agent.SetDestination(m_WayPoint.position);
        }
    }
}
