using UnityEngine.AI;
using UnityEngine;

using System.Collections;
using System.Collections.Generic;

public class DragDrop : MonoBehaviour
{
    public float maxForce;
    public float minForce;
    private float dist;
    private bool dragging = false;
    private Vector3 offset;
    private GameObject draggObj = null;
    private Vector3 hitPos;

    private Vector2 initialMousePos;
    private Vector2 endMousePos;
    void Start()
    {

    }
    void Update()
    {

        Vector3 vec = new Vector3(0, 0, 0);
        //Vector3 pos = Input.mousePosition;

        Touch touch = Input.touches[0];

        Vector3 pos = touch.position;

        if (Input.GetMouseButton(0) || Input.touchCount == 1)
        {
            Ray raycast = Camera.main.ScreenPointToRay(pos);
            RaycastHit hit;
            if (Physics.Raycast(raycast, out hit))
            {
                if (hit.collider.CompareTag("Enemy") && draggObj == null)
                {
                    draggObj = hit.transform.gameObject;
                    dist = hit.transform.position.z;
                    vec = new Vector3(pos.x, pos.y, dist);
                    offset = draggObj.transform.position - vec;
                    dragging = true;

                    initialMousePos = Input.mousePosition;

                    NavMeshAgent agent;
                    if (draggObj.transform.parent.TryGetComponent<NavMeshAgent>(out agent))
                    {
                        agent.enabled = false;
                    }
                    else
                    {
                        Debug.Log("Failed to get agent");
                    }
                }
                else if (!hit.collider.CompareTag("Enemy"))
                {
                    hitPos = hit.point;
                }

            }

        }
        endMousePos = Input.mousePosition;
        if (dragging && touch.phase == TouchPhase.Moved)
        {
            Vector2 mouseDir = endMousePos - initialMousePos;
            draggObj.transform.position = hitPos + new Vector3(0, 1 + mouseDir.magnitude * 0.1f, 0);

        }

        if (dragging && !Input.GetMouseButton(0) ||( (touch.phase == TouchPhase.Ended || touch.phase == TouchPhase.Canceled)))
        {
            Vector3 throwDirUp = Camera.main.transform.position - hitPos;
            Vector2 mouseDir = endMousePos - initialMousePos;

            Vector3 throwDirHor = new Vector3(-mouseDir.y, 0, mouseDir.x);

            Vector3 finalDir = throwDirHor.normalized + Vector3.up;

            Vector3 force = finalDir * Mathf.Clamp(mouseDir.magnitude, minForce, maxForce);

            Debug.Log(force);
            Rigidbody rb;
            if (draggObj.TryGetComponent<Rigidbody>(out rb))
            {
                rb.useGravity = true;
                rb.AddForce(force, ForceMode.Impulse);
            }
            else
            {
                Debug.Log("Failed to get rigid body");
            }

            dragging = false;
            draggObj = null;
        }
    }
}

//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;

//public class DragDrop : MonoBehaviour
//{
//    private float dist;
//    private bool dragging = false;
//    private Vector3 offset;
//    private Transform draggTransform;

//    void Start()
//    {

//    }

//    // Update is called once per frame
//    void Update()
//    {

//        Vector3 vec;
//        if(Input.touchCount != 1)
//        {
//            dragging = false;
//            return;
//        }

//        dragging = true;

//        Touch touch = Input.touches[0];
//        Vector3 pos = touch.position;

//        if(touch.phase == TouchPhase.Began)
//        {
//            Ray raycast = Camera.main.ScreenPointToRay(pos);
//            RaycastHit hit;
//            if (Physics.Raycast(raycast, out hit))
//            {
//                if(hit.collider.tag == "Enemy")
//                {
//                    draggTransform = hit.transform;
//                    dist = hit.transform.position.z;
//                    vec = new Vector3(pos.x, pos.y, dist);
//                    offset = draggTransform.position - vec;
//                    dragging = true;
//                }
//            }
//        }

//        if(dragging && touch.phase == TouchPhase.Moved)
//        {
//            vec = new Vector3(Input.mousePosition.x, Input.mousePosition.y, dist);

//            vec = Camera.main.ScreenToWorldPoint(vec);

//            draggTransform.position = vec + offset;
//        }

//        if(dragging && (touch.phase == TouchPhase.Ended || touch.phase == TouchPhase.Canceled))
//        {
//            dragging = false;
//        }
//    }
//}
