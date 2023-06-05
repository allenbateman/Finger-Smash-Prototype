using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEditor.PlayerSettings;

public class OnDestroyParticle : MonoBehaviour
{
    public GameObject onDestroyParticle;
    private GameObject gameEntitiesGO;
    private GameObject particleRef;
    public Vector3 offset = Vector3.zero;

    void Awake()
    {
        gameEntitiesGO = GameManager.Instance.gameEntitiesGO;
    }

    private void Start()
    {
        particleRef = Instantiate(onDestroyParticle, transform.position, transform.rotation, gameEntitiesGO.transform);
        particleRef.SetActive(false);
    }

    private void OnDestroy()
    {
        particleRef.transform.position = transform.position - offset;
        particleRef.SetActive(true);
    }
}
