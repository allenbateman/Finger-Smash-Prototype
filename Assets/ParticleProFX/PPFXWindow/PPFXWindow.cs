/*=========================================================
	PARTICLE PRO FX volume one 
	PPFXWindow.cs
	
	Library window
	
	(c) 2014
=========================================================*/

using UnityEngine;
#if UNITY_EDITOR  && !UNITY_WEBPLAYER
using UnityEditor;
using System.Collections.Generic;
using System.IO;

public class PPFXWindow : EditorWindow {
		
	static string pfxAssetPath = "ParticleProFX/Resources/Library";
	//static string pfxLogoPath = "ParticleProFX/PPFXEditor/logo.png";
	//static string pfxEditorPath = "ParticleProFX/PPFXEditor";
	
	//folders
	static string[] pfxFolders = new string[]{};
	//Save Prefabs
	static List<Object[] > pfxPrefabList = new List<Object[]>(); 
	//Save Preview images
	static List<Texture[]> pfxPreviewImageList = new List<Texture[]>();
	
	
	static int[] pfxAssetCount = new int[]{};
	
	//Container
	private GameObject pfxTransformContainer = null;
	private GameObject pfxPreviewContainer = null;
	private GameObject pfxParentContainer = null;
	
	
	//=======================================
	//GUI Properties
	//=======================================
	static PPFXWindow window;
	//using enum for eventually adding further toolbar actions
	enum toolbarActions{
		Refresh,
	};
	
	int selIndex = 0; //store current selected preset index
	int selFolderIndex = 0; 
	string selPrefabName = ""; //current selected prefab name
	
	static List<Vector2> pfxGUIScrollPos = new List<Vector2>();
	
	int pfxGUIButtonWidth = 80;
	int pfxGUIButtonHeight = 80;
	
	//Gui Toggle
	static List<bool> pfxListToggle = new List<bool>();
	
	//preview texture
	Camera pfxPreviewCam;
	RenderTexture pfxPreview;
	int pfxPreviewHeight = 200;
	
	bool pfxTurntable = false;
	
	//static Texture pfxLogo;
	//=======================================

	
	[MenuItem ("Window/Particle Pro FX")]
	static void Init () 
	{
		// Get existing open window or if none, make a new one:
		window = (PPFXWindow)EditorWindow.GetWindow (typeof (PPFXWindow));
			
		//load all prefabs to prefab lists
		LoadPrefabs();
		
		window.autoRepaintOnSceneChange = true;
		window.Show();
	}
	
	void OnEnable(){
	#if UNITY_EDITOR
	    EditorApplication.playmodeStateChanged += StateChange;
	#endif
	}
	 
	#if UNITY_EDITOR
	void StateChange(){
	    if (!EditorApplication.isPlayingOrWillChangePlaymode && !Application.isPlaying)
	    {
	   
	    	pfxPreview = new RenderTexture((int)position.width, pfxPreviewHeight, (int)RenderTextureFormat.ARGB32 );
	    	pfxPrefabList = new List<Object[]>();
			pfxPreviewImageList = new List<Texture[]>();
			pfxAssetCount = new int[]{0,0,0,0};
			LoadPrefabs();
	    }
	}
	#endif
	void Awake(){
		InitGameObjects();
		
	}
	
	void InitGameObjects(){
		pfxPreview = new RenderTexture((int)position.width, pfxPreviewHeight, (int)RenderTextureFormat.ARGB32 );
		
		//create new GameObject in Scene with preview camera
		if(pfxPreviewCam == null)
		{
			try{
				pfxPreviewCam = GameObject.Find("PPFXPreviewCam").GetComponent<Camera>();
				pfxTransformContainer = GameObject.Find("PPFX");
			}
			catch{}
			
			if(pfxPreviewCam == null)
			{
				GameObject _tmp = new GameObject();
				_tmp.AddComponent<Camera>();
				_tmp.name = "PPFXPreviewCam";
				
				pfxPreviewCam = _tmp.GetComponent<Camera>();
				
				pfxPreviewCam.backgroundColor = new Color(60f/255f, 60f/255f, 60f/255f);
				pfxPreviewCam.depth = -100;
			}
			
			if(pfxTransformContainer == null)
			{
				GameObject _tmp2 = new GameObject();
				_tmp2.name = "PPFX";
				
				pfxTransformContainer = _tmp2;
				pfxTransformContainer.transform.position = new Vector3(1000,1000,1000);
			}else{
				Transform _transform = GameObject.Find("PPFX").GetComponent<Transform>();
			    foreach (Transform _t in _transform) {
			        if (_t.gameObject.name != "PPFXPreviewCam"){
			        	DestroyImmediate(_t.gameObject);
			        }
			    }
					
			}
			
			pfxPreviewCam.transform.parent = pfxTransformContainer.transform;
			pfxPreviewCam.transform.localPosition = new Vector3(0,0,-10);
		}
	}
	
	void Update()
	{
		if(!Application.isPlaying && pfxPreview != null){
			
			if(pfxFolders.Length == 0){
				LoadPrefabs();
			}
			//update render texture
			if(pfxPreviewCam != null) {
					pfxPreviewCam.targetTexture = pfxPreview;
					pfxPreviewCam.Render();
					pfxPreviewCam.targetTexture = null;	
			}
			if(pfxPreview.width != position.width || 
				pfxPreview.height != pfxPreviewHeight)
				pfxPreview = new RenderTexture((int)position.width, 
								pfxPreviewHeight, 
								(int)RenderTextureFormat.ARGB32 );
			if(pfxTurntable && pfxPreviewContainer != null){
				pfxParentContainer.transform.Rotate(Vector3.up * Time.deltaTime*100000f, Space.Self);
			}
		}
	}
	
	//=======================================
	//Load all prefabs and images
	//from folder
	//=======================================
	static void LoadPrefabs(){	
		
		//load logo
		//pfxLogo = (Texture)AssetDatabase.LoadAssetAtPath("Assets/"+pfxLogoPath, typeof(Texture));
		
		//get all folders inside of asset path
		string _getFoldersIn = Application.dataPath + "/" + pfxAssetPath;
		string[] _folders = Directory.GetDirectories(_getFoldersIn);
		
		pfxFolders = new string[_folders.Length];
		pfxFolders = _folders;
		
		//rename folders list
		for (int fn = 0; fn < pfxFolders.Length; fn ++)
		{
			//mac
			#if UNITY_EDITOR_OSX
			
				pfxFolders[fn] = pfxFolders[fn].Replace(_getFoldersIn+"/","");
			
			#endif
			//win
			#if UNITY_EDITOR_WIN
			
				pfxFolders[fn] = pfxFolders[fn].Replace(_getFoldersIn + '\\',"");
		
			#endif
			//Debug.Log(pfxFolders[fn]);
		}
		
		pfxAssetCount = new int[_folders.Length];
		
		//load each folder
		for(int i = 0; i < pfxFolders.Length; i ++)
		{
			
			string _path = Path.Combine(Path.Combine(Application.dataPath,pfxAssetPath),pfxFolders[i]);
			//Debug.Log(_path);
			
			var info = new DirectoryInfo(_path);
			
			FileInfo[] fileInfo = info.GetFiles();
			
			
			pfxListToggle.Add ( false );
			pfxGUIScrollPos.Add (new Vector2(0,0));
			
			//only add assets if new prefabs were added
			if(fileInfo.Length != pfxAssetCount[i]){
				
				//count how many prefabs are in each folder
				int _c = 0;
				foreach (FileInfo file in fileInfo)
				{
					string _ext = Path.GetExtension(file.ToString());
					if(_ext == ".prefab"){
						_c ++;
					}
				}
				
				Object[] _prefabs = new Object[_c];
				Texture[] _prevImg = new Texture[_c];
				
				int _inx = 0;					
				
				foreach (FileInfo file in fileInfo)
				{
					
					string _assetName = Path.GetFileName(file.ToString());
					string _extension = Path.GetExtension(file.ToString());
					string _assetPath = Path.Combine(Path.Combine(pfxAssetPath, pfxFolders[i]), _assetName);
					
					string _imageName = _assetName.Replace(".prefab", "");
					//string _previewImagePath = Path.Combine(Path.Combine(pekAssetPath, pekFolders[i]), "/Preview/" + _imageName + ".png");
					
					
					if(_extension == ".prefab")
					{					
						//Windows Paths
						//string _objPath = _assetPath;
						//string _imgPath = pekFolders[i]+"/Preview/"+_imageName + ".png";
						//Mac Paths
						string _objPath = "Assets/"+_assetPath;
						string _imgPath = "Assets/"+pfxAssetPath+"/"+pfxFolders[i]+"/Preview/"+_imageName + ".png";
						
						//load prefabs and preview image
						Object _obj = AssetDatabase.LoadAssetAtPath(_objPath, typeof (GameObject));
						Texture _img = (Texture)AssetDatabase.LoadAssetAtPath(_imgPath, typeof(Texture));
						
						_prefabs[_inx] = _obj;
						_prevImg[_inx] = _img;
						_inx ++;
					}
				}
				
				pfxPrefabList.Add(_prefabs);
				pfxPreviewImageList.Add(_prevImg);
				
				pfxAssetCount[i] = fileInfo.Length;
			}
		}
	}
	
	
	void OnGUI () 
	{	
		
		//show preview image
		PreviewGUI();
		//show toolbar
		ToolbarGUI();
		//show library
		LibraryGUI();	

	}
	
	
	//=======================================
	//TOOLBAR
	//=======================================
	void ToolbarGUI()
	{
		//logo
		EditorGUILayout.BeginHorizontal();
			
			//var _blackImg = (Texture)AssetDatabase.LoadAssetAtPath("Assets/" + pfxEditorPath + "/black.png", typeof(Texture));
			//GUI.DrawTexture(new Rect(0,position.height-40, position.width, 40), _blackImg);
			
			//if(pfxLogo!=null)
			//{
			//	EditorGUI.DrawPreviewTexture(new Rect(0,position.height-40,40, 40), pfxLogo);
			//}
		
		EditorGUILayout.EndHorizontal();
		
		EditorGUILayout.BeginHorizontal();
			if(GUILayout.Button("refresh", EditorStyles.toolbarButton))
			{
				ToolbarActions(toolbarActions.Refresh);
			}	
		EditorGUILayout.EndHorizontal();
		
		//show current selected prefab name
		GUILayout.BeginArea(new Rect (10, 20, position.width, 100)); 
		if(!Application.isPlaying && selFolderIndex < pfxFolders.Length)
		{
			EditorGUILayout.LabelField(pfxFolders[selFolderIndex] + "/" + selPrefabName);
		}
		
		pfxTurntable = GUILayout.Toggle(pfxTurntable,"Turntable");
		GUILayout.EndArea();
		
		
		//Change camera background color
		GUILayout.BeginArea(new Rect (10, 170, position.width, pfxPreviewHeight)); 
			EditorGUILayout.BeginHorizontal();
				GUI.color = Color.black;
				if(GUILayout.Button("", GUILayout.Width(20)))
				{
					pfxPreviewCam.backgroundColor = Color.black;
				}
				GUI.color = Color.grey;
				if(GUILayout.Button("", GUILayout.Width(20)))
				{
					pfxPreviewCam.backgroundColor =  new Color(60f/255f, 60f/255f, 60f/255f);
				}
				GUI.color = Color.white;
				
				if(GUILayout.Button("", GUILayout.Width(20)))
				{
					pfxPreviewCam.backgroundColor = Color.white;
				}
				
			EditorGUILayout.EndHorizontal();
			
		//GUILayout.Label("Not all effects are previewed correctly, use the demo scene for correct preview");
		GUILayout.EndArea();
		
		//Set Preview image
		GUILayout.BeginArea(new Rect (position.width - 160, 170, position.width, pfxPreviewHeight)); 
			if(GUILayout.Button("Set new preview image", GUILayout.Width(150)))
			{
				SetPreviewImage();
			}
		GUILayout.EndArea();
	}
	
	//=======================================
	//PREVIEW IMAGE
	//=======================================
	void PreviewGUI()
	{
        if(!Application.isPlaying && pfxPreview != null)
		{
			EditorGUILayout.BeginHorizontal();
			EditorGUI.DrawPreviewTexture(new Rect(0,0,position.width, pfxPreviewHeight), pfxPreview);
			EditorGUILayout.EndHorizontal();
		}
	}
	
	//=======================================
	//LIBRARY
	//=======================================
	void LibraryGUI()
	{
	
		//define some custom gui styles
		GUIStyle pfxGUIBoxWhite = new GUIStyle(GUI.skin.box);
		pfxGUIBoxWhite.normal.textColor = Color.white;
		
		//GUI.skin.button.alignment = TextAnchor.MiddleCenter;
		int _colCount = (int)Mathf.Abs(position.width / pfxGUIButtonWidth);
			 
		//build first folder library
		////////////////////////////
		GUILayout.BeginArea(new Rect (0, pfxPreviewHeight, position.width, position.height-pfxPreviewHeight)); 
		
		EditorGUILayout.Space();
	
		//Info message box
		EditorGUILayout.BeginHorizontal();
			if(pfxPreviewContainer!=null)
			{
				GUI.color = Color.green;
				if(GUILayout.Button("Add Prefab", GUILayout.Height (40)))
				{
					GameObject _inst = Instantiate(pfxPrefabList[selFolderIndex][selIndex], Vector3.zero, Quaternion.Euler(-90,0,0)) as GameObject;
					
					//pekPreviewContainer.transform.parent = null;
					_inst.transform.position = new Vector3(0,0,0);
					_inst.name = pfxPreviewContainer.name.Replace("(Clone)","");
					
					DestroyImmediate(pfxPreviewContainer);
					pfxPreviewContainer = null;
				}
			}
			else
			{ //just do nothing
				GUI.color = Color.red;
				if(GUILayout.Button("Add Prefab", GUILayout.Height (40))){}
			}	
			GUI.color = Color.white;
		EditorGUILayout.EndHorizontal();
		
		//icon size slider
		GUILayout.BeginArea(new Rect (0, 55, position.width, 20), EditorStyles.toolbarButton); 
		pfxGUIButtonWidth = EditorGUILayout.IntSlider( pfxGUIButtonWidth,0,200);
		pfxGUIButtonHeight = pfxGUIButtonWidth;
		GUILayout.EndArea();
		
		
		//=======================================
		//Particle Library
		//=======================================
		EditorGUILayout.Space();
		EditorGUILayout.Space();
		EditorGUILayout.Space();

		
		EditorGUILayout.Space();
		
		for(int f = 0; f < pfxFolders.Length; f ++)
		{
			
			pfxListToggle[f] = GUILayout.Toggle( pfxListToggle[f], (pfxListToggle[f] ? "close " + pfxFolders[f] : "open " + pfxFolders[f]), GUI.skin.GetStyle("toolbarButton"), GUILayout.ExpandWidth(true), GUILayout.Height(18));
    	
		
			if(pfxListToggle[f])
			{
				int _rows = 0;
				pfxGUIScrollPos[f] = EditorGUILayout.BeginScrollView(pfxGUIScrollPos[f] , GUILayout.Height(_rows*pfxGUIButtonHeight));
				
				EditorGUILayout.BeginHorizontal();
				
				for(int x = 0; x < pfxPrefabList[f].Length; x ++)
				{	
					//Debug.Log(pekPrefabList[f].Length);
					if (x % _colCount == 0 && x > 0) 
					{
						_rows ++;
						EditorGUILayout.EndHorizontal();
						EditorGUILayout.BeginHorizontal();	
		        	}
					
					Texture _tex =  pfxPreviewImageList[f][x] as Texture; //pekPrefabList1[x].name
				
        			
					if(GUILayout.Button(_tex, GUILayout.Width (pfxGUIButtonWidth), GUILayout.Height (pfxGUIButtonHeight)))
					{
						//Debug.Log(pekPrefabList[f][x].name);
						GameObject _inst = Instantiate(pfxPrefabList[f][x], Vector3.zero, Quaternion.Euler(-90,0,0)) as GameObject;
						Build(_inst);
						
						selIndex = x;
						selFolderIndex = f;
						selPrefabName = pfxPrefabList[f][x].name;
					}
				
				}
				
				EditorGUILayout.EndHorizontal();
				EditorGUILayout.EndScrollView();
			}
		
		}
		
		GUILayout.EndArea();
	}
	
	
	//=======================================
	//CREATE PARTICLES IN SCENE
	//=======================================
	void Build(GameObject _particle)
	{

		DestroyImmediate(pfxPreviewContainer);
		pfxPreviewContainer = _particle;
		
		if(pfxTransformContainer != null)
		{
			_particle.transform.parent = pfxTransformContainer.transform;
		}
		else
		{
			InitGameObjects();
			_particle.transform.parent = pfxTransformContainer.transform;
		}
		
		//we have to parent the particles prefab to make sure 
		//the turntable rotation works as expected.
		pfxParentContainer = GameObject.Find("PPFXParent");
		if(pfxParentContainer!=null)
		{
			_particle.transform.parent = pfxParentContainer.transform;
		}
		else
		{
			pfxParentContainer = new GameObject();
			pfxParentContainer.name = "PPFXParent";
			pfxParentContainer.transform.parent = pfxTransformContainer.transform;
			
			_particle.transform.parent = pfxParentContainer.transform;
			
		}
		pfxParentContainer.transform.localPosition = new Vector3(0,0,0);
		
		//set loop true
		ParticleSystem _pSys = _particle.GetComponent<ParticleSystem>();
		if(_pSys!=null)
		{
			#if UNITY_5_5_OR_NEWER
				var _m = _pSys.main;
				_m.loop = true;
			#else
				_pSys.loop = true;
			#endif	
		}
		
		ParticleSystem[] _pSysChild = _particle.GetComponentsInChildren<ParticleSystem>();
        foreach (ParticleSystem _p in _pSysChild) 
        {
           #if UNITY_5_5_OR_NEWER
		        var _m = _p.main;
		        _m.loop = true;
			#else
				_p.loop = true;
			#endif	
        }
		
		
		pfxPreviewContainer.transform.localPosition = new Vector3(0,0,0);
		
		Selection.activeGameObject = pfxPreviewContainer;
	
	}
	
	//=======================================
	//TOOLBAR ACTIONS
	//=======================================
	void ToolbarActions(toolbarActions _action)
	{
		switch(_action)
		{
			case toolbarActions.Refresh:
				pfxPrefabList = new List<Object[]>();
				pfxPreviewImageList = new List<Texture[]>();
				pfxAssetCount = new int[]{0,0,0,0};
				LoadPrefabs();
				break;
		}
	}
	
	//=======================================
	//CREATE NEW PRPEVIEW IMAGE
	//=======================================
	void SetPreviewImage()
	{
	
		//pekPreview	
		RenderTexture.active = pfxPreview;
		pfxPreviewCam.targetTexture = pfxPreview; 
		Texture2D _previewImg =  new Texture2D(200,200, TextureFormat.RGB24, false);
		
		_previewImg.ReadPixels(new Rect((position.width-200)/2, 0, pfxPreview.width, 200), 0, 0);
		_previewImg.Apply();
		
		#if !UNITY_WEBPLAYER
		byte[] bytes = _previewImg.EncodeToPNG();
		System.IO.File.WriteAllBytes( Application.dataPath + "/" + pfxAssetPath + "/" + pfxFolders[selFolderIndex] + "/Preview/" + selPrefabName + ".png", bytes );
		#endif
		
		pfxAssetCount = new int[]{0,0,0,0};
		LoadPrefabs();
		
		
		this.Repaint();
	}
}
#endif
