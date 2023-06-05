using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnDestroyParticleClip : MonoBehaviour
{
    public List<GameObject> onDestroyParticle;
    private GameObject gameEntitiesGO;
    private GameObject particleRef;
    public Vector3 offset = Vector3.zero;

    void Awake()
    {
        gameEntitiesGO = GameManager.Instance.gameEntitiesGO;
    }

    private void Start()
    {
        particleRef = Instantiate(onDestroyParticle[(Random.Range(0, onDestroyParticle.Count - 1))], transform.position, transform.rotation, gameEntitiesGO.transform);
        particleRef.SetActive(false);
    }

    private void OnDestroy()
    {
        particleRef.transform.position = transform.position - offset;
        particleRef.SetActive(true);
    }
}
