using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting.Antlr3.Runtime.Tree;
using UnityEngine;

public class MissileScript : MonoBehaviour
{
    private int groundTagHashCode;
    private int towerTagHashCode;

    private void Awake()
    {
        groundTagHashCode = "Ground".GetHashCode();
        towerTagHashCode = "Tower".GetHashCode();
    }
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
        int code = other.transform.tag.GetHashCode();
        if (code == groundTagHashCode || code == towerTagHashCode && other is BoxCollider)
            GameObject.Destroy(this.gameObject);
    }

    private void OnCollisionEnter(Collision collision)
    {
        GameObject.Destroy(this);
    }
}
