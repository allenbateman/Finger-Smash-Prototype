using UnityEngine;

public class ColliderVisibility : MonoBehaviour
{
    private void OnDrawGizmos()
    {
        Collider collider = GetComponent<Collider>();

        if (collider != null)
        {
            Gizmos.color = Color.green;

            if (collider is BoxCollider boxCollider)
            {
                Gizmos.DrawWireCube(transform.position + boxCollider.center, boxCollider.size);
            }
            else if (collider is SphereCollider sphereCollider)
            {
                Gizmos.DrawWireSphere(transform.position + sphereCollider.center, sphereCollider.radius * transform.localScale.y);
            }
            // Add support for other collider types as needed
        }
    }
}
