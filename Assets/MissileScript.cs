using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MissileScript : MonoBehaviour
{
    //// Start is called before the first frame update
    //void Start()
    //{

    //}

    //void FixedUpdate()
    //{
    //    var q = Quaternion.LookAt(target.position - transform.position);
    //    rigidbody.MoveRotation(Quaternion.RotateToward(transform.rotation, q, speed * Time.deltaTime));

    //}

    private void OnTriggerEnter(Collider other)
    {
        GameObject.Destroy(this);
    }
}
