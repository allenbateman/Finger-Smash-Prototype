/*=========================================================
	PARTICLE PRO FX volume one 
	PPFXDemoScene.cs
	
	Demo scene for previewing prefabs
	
	(c) 2014
=========================================================*/

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class PPFXDemoScene : MonoBehaviour {
	
	public PPFXSpawnOnClick spawnScript;
	public GameObject plane; 
	public GameObject pyramid;
	public GameObject cameraRotate;
	public Camera cam;
	
	//gui properties
	bool hideGUI = false;
	bool hidePlane = false;
	bool rotateCamera = false;
	float zoomSlider = 60;
	int selectedIndex = 0;
	
	//Vector2 scrollPos = new Vector2(0,0);
	public Texture2D logo;
	
	public GameObject[] prefabs; 
	public Texture2D[] previews; 
	
	void Start()
	{
		prefabs = Resources.LoadAll<GameObject>("Library");
		previews = Resources.LoadAll<Texture2D>("library");
		spawnScript.inst = prefabs[0];
	}

	void OnGUI()
	{
		
	GUILayout.Label("Press H to hide/show GUI\nPress R to reset scene");
		
		if(!hideGUI)
		{
		
		
			//scrollPos = GUILayout.BeginScrollView(scrollPos, GUILayout.Width(150), GUILayout.Height(250));
			
			//for(int i = 0; i < prefabs.Length; i ++)
			//{
			//	if(prefabs[i] != null)
			//	{
			//		string _name = prefabs[i].name.Replace("ppfx","");
			//		if(GUILayout.Button(_name,GUILayout.Width(120), GUILayout.Height(20)))
			//		{
			//			spawnScript.inst = prefabs[i];
			//		}
			//	}
			//}
			
			
			//GUILayout.EndScrollView();
	
			if (GUI.Button(new Rect(Screen.width / 2 - 100, Screen.height - 95, 50,50),"<<"))
			{
				if (selectedIndex - 1 > -1)
				{
					selectedIndex --;
					spawnScript.inst = prefabs[selectedIndex];
				}
				else
				{
					selectedIndex = prefabs.Length - 1;
					spawnScript.inst = prefabs[selectedIndex];
				}
			}
			
			if (GUI.Button(new Rect(Screen.width / 2 + 50, Screen.height - 95, 50,50),">>"))
			{
				if (selectedIndex + 1 < prefabs.Length)
				{
					selectedIndex ++;
					spawnScript.inst = prefabs[selectedIndex];
				}
				else
				{
					selectedIndex = 0;
					spawnScript.inst = prefabs[selectedIndex];
				}
			}
			
			GUI.Box(new Rect(Screen.width / 2 - 100, Screen.height - 120, 200, 100), previews[selectedIndex]);
			GUI.Label(new Rect(Screen.width / 2 - 100, Screen.height - 20, 200, 20), prefabs[selectedIndex].name);
			
			hidePlane = GUI.Toggle(new Rect(0,Screen.height-100, 150, 20),hidePlane,"Hide Plane");
			
			if(hidePlane)
			{
				plane.transform.GetComponent<Renderer>().material.SetColor("_Color", new Color(1,1,1,0));
			}
			else
			{
				plane.transform.GetComponent<Renderer>().material.SetColor("_Color", new Color(1,1,1,1));
			}
			
			rotateCamera = GUI.Toggle(new Rect(0, Screen.height-80, 150, 20), rotateCamera, "Rotate Camera");
			

			GUI.Label(new Rect(0, Screen.height - 60, 150, 20),"Field of view:");
			zoomSlider = GUI.HorizontalSlider(new Rect(0, Screen.height-40,150,20),zoomSlider, 60f, 125f);
			
			
			if(GUI.Button(new Rect(0, Screen.height-20, 150,20),"Reset"))
			{
				Reset();
			}
			
		}
		
		if (rotateCamera)
		{
			cameraRotate.transform.Rotate( Vector3.up * Time.deltaTime * 5f);
		}
		
		cam.fieldOfView = (int)zoomSlider;
		
		GUI.DrawTexture(new Rect(Screen.width-90, Screen.height-155, 64, 155),logo);
		
	}
	
	void Update()
	{
		if(Input.GetKeyDown("h"))
		{
			if(hideGUI)
			{
				hideGUI = false;
			}else{
				hideGUI = true;
			}
		}
		
		if(Input.GetKeyDown("r"))
		{
			Reset();
		}
	}
	
	void Reset()
	{
		var _container = GameObject.Find("_Container");
		if (_container != null)
		{
			Destroy(_container.gameObject);
		}
		
		var _pyramid = GameObject.FindWithTag("pyramid");
		Destroy(_pyramid.gameObject);
		Instantiate(pyramid);
		
		cameraRotate.transform.rotation = Quaternion.Euler(new Vector3(0,0,0));
	}
}
