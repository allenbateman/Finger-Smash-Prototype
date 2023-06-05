/*=========================================================
	PARTICLE PRO FX volume one 
	PPFXSpawnOnClick.cs
	
	Spawns prefabs at mouseposition when user clicks 
	on object with assigned tag
	
	(c) 2014
=========================================================*/

using UnityEngine;
using System.Collections;

public class PPFXSpawnOnClick : MonoBehaviour {
 
	public GameObject inst;
	public string tagName;
	
	GameObject container;
	
	void Start()
	{
		container = new GameObject();
		container.name = "_Container";
	}
	
	void Update ()
    {
    	if(Input.GetMouseButtonDown(0) ||  Input.touchCount > 0)
    	{
        
         
	        Ray ray;
	       
	        if(Application.platform == RuntimePlatform.Android)
	        {
		    	ray = Camera.main.ScreenPointToRay(Input.GetTouch(0).position);
	        }else{
	        	ray = Camera.main.ScreenPointToRay(Input.mousePosition);
	        }
	       
	        RaycastHit hit;
	       
	        if(Physics.Raycast(ray,out hit) && GUIUtility.hotControl == 0)
	        {
	            if(hit.collider.tag==tagName)
	            {                  
	                if(inst!=null)
	                {
	                	Vector3 _p = new Vector3(hit.point.x, 0f, hit.point.z);
	                	var _clone = Instantiate(inst, _p , inst.transform.rotation)as GameObject;
	            	
		            	if(container != null)
		            	{
		            		_clone.transform.parent = container.transform;
		            	}
		            	else
		            	{
		            		container = new GameObject();
							container.name = "_Container";
							_clone.transform.parent = container.transform;
		            	}

	            	}          	
	            	
	            }
	        }
	    }
    }
}