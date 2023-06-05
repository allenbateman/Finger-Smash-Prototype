using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OutOfBounds : MonoBehaviour
{
    private void OnCollisionExit(Collision collision)
    {
        if (collision.transform.CompareTag("Enemy"))
            collision.gameObject.GetComponent<Health>().DoDamage(1000);
        GameObject.Destroy(collision.gameObject);
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.transform.CompareTag("Enemy"))
            other.gameObject.GetComponent<Health>().DoDamage(1000);
        GameObject.Destroy(other.gameObject);
    }
}

