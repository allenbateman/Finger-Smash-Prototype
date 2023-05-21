using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DragDrop : MonoBehaviour
{
    private float dist;
    private bool dragging = false;
    private Vector3 offset;
    private Transform draggTransform;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        Vector3 vec;
        if(Input.touchCount != 1)
        {
            dragging = false;
            return;
        }

        dragging = true;

        Touch touch = Input.touches[0];
        Vector3 pos = touch.position;

        if(touch.phase == TouchPhase.Began)
        {
            Ray raycast = Camera.main.ScreenPointToRay(pos);
            RaycastHit hit;
            if (Physics.Raycast(raycast, out hit))
            {
                if(hit.collider.tag == "Enemy")
                {
                    draggTransform = hit.transform;
                    dist = hit.transform.position.z;
                    vec = new Vector3(pos.x, pos.y, dist);
                    offset = draggTransform.position - vec;
                    dragging = true;
                    Debug.Log("Touch" + hit.transform.tag);
                }
            }
        }

        if(dragging && touch.phase == TouchPhase.Moved)
        {
            vec = new Vector3(Input.mousePosition.x, Input.mousePosition.y, dist);

            vec = Camera.main.ScreenToWorldPoint(vec);

            draggTransform.position = vec + offset;
        }

        if(dragging && (touch.phase == TouchPhase.Ended || touch.phase == TouchPhase.Canceled))
        {
            dragging = false;
        }
    }
}
