using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionRedirector : MonoBehaviour
{
    // Redirect the collision event to the parent object

    public bool onCollisionEnter = false;
    public bool onCollisionStay = false;
    public bool onCollisionExit = false;
    public bool onTriggerEnter = false;
    public bool onTriggerStay = false;
    public bool onTriggerExit = false;

    private void OnCollisionEnter(Collision collision) {
        if (onCollisionEnter) SendMessageUpwards("OnChildCollisionEnter", collision, SendMessageOptions.DontRequireReceiver);
    }
    private void OnCollisionStay(Collision collision){
        if (onCollisionStay) SendMessageUpwards("OnChildCollisionStay", collision, SendMessageOptions.DontRequireReceiver);
    }
    private void OnCollisionExit(Collision collision){
        if (onCollisionExit) SendMessageUpwards("OnChildCollisionExit", collision, SendMessageOptions.DontRequireReceiver);
    }
    private void OnTriggerEnter(Collider other){
        if (onTriggerEnter) SendMessageUpwards("OnChildTriggerEnter", other, SendMessageOptions.DontRequireReceiver);
    }
    private void OnTriggerStay(Collider other){
        if (onTriggerStay) SendMessageUpwards("OnChildTriggerStay", other, SendMessageOptions.DontRequireReceiver);
    }
    private void OnTriggerExit(Collider other){
        if (onTriggerExit) SendMessageUpwards("OnChildTriggerExit", other, SendMessageOptions.DontRequireReceiver);
    }
}
