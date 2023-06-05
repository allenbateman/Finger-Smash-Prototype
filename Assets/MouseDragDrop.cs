using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class MouseDragDrop : MonoBehaviour
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

    public float maxHeight = 10;
    void Start()
    {
        
    }
    void Update()
    {

        Vector3 vec  = new Vector3(0,0,0);
        Vector3 pos = Input.mousePosition;

        if (Input.GetMouseButton(0))
        {
            Ray raycast = Camera.main.ScreenPointToRay(pos);
            RaycastHit hit;
            if (Physics.Raycast(raycast, out hit))
            {
                if (hit.collider.CompareTag("Enemy") && draggObj == null )
                {
                    draggObj = hit.transform.gameObject;
                    dist = hit.transform.position.z;
                    vec = new Vector3(pos.x, pos.y, dist);
                    offset = draggObj.transform.position - vec;
                    dragging = true;
                    hitPos = hitPos;

                    initialMousePos = Input.mousePosition;
                    
                    NavMeshAgent agent;
                    if (draggObj.transform.TryGetComponent<NavMeshAgent>(out agent))
                    {
                        agent.enabled = false;
                    }
                    else
                    {
                        Debug.Log("Failed to get agent");
                    }

                    Enemy enemy;
                    if (draggObj.transform.TryGetComponent<Enemy>(out enemy))
                    {
                        enemy.Dragged = true;
                    }
                    else
                    {
                        Debug.Log("Failed to get enemy");
                    }
                }
                else if(!hit.collider.CompareTag("Enemy"))
                {
                    hitPos = hit.point;
                }     
          
            }
                
        }
        endMousePos = Input.mousePosition;
        if (dragging && draggObj != null)
        {
            Vector2 mouseDir = endMousePos - initialMousePos;

            float height = 1 + mouseDir.magnitude * 0.01f;
            if (height >= maxHeight)
            { 
                draggObj.transform.position = hitPos + new Vector3(0, maxHeight, 0);
            }
            else
            {
                draggObj.transform.position = hitPos + new Vector3(0, height, 0);
            }

        }

        if (dragging && !Input.GetMouseButton(0))
        {
            Vector3 throwDirUp = Camera.main.transform.position - hitPos;
            Vector2 mouseDir = endMousePos - initialMousePos;

            Vector3 throwDirHor = new Vector3(-mouseDir.y, 0, mouseDir.x);

            Vector3 finalDir = throwDirHor.normalized + Vector3.up;

            Vector3 force = finalDir * Mathf.Clamp(mouseDir.magnitude,minForce, maxForce);

            Debug.Log(force);
            Rigidbody rb;
            if (draggObj != null && draggObj.TryGetComponent<Rigidbody>(out rb))
            {
                rb.useGravity = true;
                rb.AddForce(force,ForceMode.Impulse); 
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
