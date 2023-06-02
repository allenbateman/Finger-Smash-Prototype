using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfBounds : MonoBehaviour
{
    private void OnCollisionExit(Collision collision)
    {
        GameObject.Destroy(collision.gameObject);
    }

    private void OnTriggerExit(Collider other)
    {
        GameObject.Destroy(other.gameObject);
    }
}
