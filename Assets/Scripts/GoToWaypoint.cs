using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class GoToWaypoint : MonoBehaviour
{
    private Transform m_WayPoint;
    private NavMeshAgent m_Agent;
    //private int m_FrameInterval = 20;

    ////private bool hasFinishedPath = false;
    //private bool pathFailed = false;

    private void Awake()
    {
        TryGetComponent(out m_Agent);
    }

    void Start()
    {
        m_WayPoint = FindObjectOfType<WayPoint>().transform;
        m_Agent.SetDestination(m_WayPoint.position);
    }

    void Update()
    {
        //// Check if the agent has finished its path
        //if (m_Agent.pathStatus == NavMeshPathStatus.PathComplete && !m_Agent.hasPath && !m_Agent.pathPending){
        //    //hasFinishedPath = true;
        //    Debug.Log("Path has finished.");
        //    Destroy(gameObject);
        //}

        //// Check if the agent failed to complete the path
        //if (m_Agent.pathStatus == NavMeshPathStatus.PathInvalid && !pathFailed) {
        //    pathFailed = true;
        //    Debug.LogWarning("Path couldn't be completed.");
        //    Destroy(gameObject);
        //}

        //if (Time.frameCount % m_FrameInterval == 0){
        //    float distance = Vector3.Distance(transform.position, m_WayPoint.position);
        //    if (distance < 4.3f){
        //        Destroy(gameObject);
        //    }
        //}
       
    }
}
