using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LineDrawer : MonoBehaviour
{
    public LineRenderer lineRenderer;  // Reference to the LineRenderer component
    public Vector3 startPoint;
    public Vector3 endPoint;
    public bool enable = true;

    void Start()
    {
        // Initialize the line renderer component
        lineRenderer = GetComponent<LineRenderer>();
        lineRenderer.positionCount = 2;  // Set the number of positions (start and end points)
    }

    void Update()
    {
        if(!enable)
            return;

        lineRenderer.SetPosition(0, startPoint);
        lineRenderer.SetPosition(1, endPoint);
    }
}
