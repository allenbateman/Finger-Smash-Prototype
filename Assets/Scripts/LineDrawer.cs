using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineDrawer : MonoBehaviour
{
    public LineRenderer m_LineRenderer;  // Reference to the LineRenderer component
    public Vector3 m_StartPoint;
    public Vector3 m_EndPoint;
    public bool m_Enable = true;

    void Start()
    {
        // Initialize the line renderer component
        m_LineRenderer = GetComponent<LineRenderer>();
        m_LineRenderer.positionCount = 2;  // Set the number of positions (start and end points)
    }

    void Update()
    {
        if(!m_Enable)
            return;

        m_LineRenderer.SetPosition(0, m_StartPoint);
        m_LineRenderer.SetPosition(1, m_EndPoint);
    }
}
