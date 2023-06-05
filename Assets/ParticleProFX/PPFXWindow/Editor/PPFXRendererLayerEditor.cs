/*=========================================================
	PARTICLE PRO FX volume one 
	PPFXRendererLayerEditor.cs
	
	RendererLayer Editor
	
	(c) 2014
=========================================================*/
using System;
using UnityEngine;
using UnityEditor;
using UnityEditorInternal;
using System.Reflection;
 
[CanEditMultipleObjects()]
[CustomEditor(typeof(PPFXRendererLayer))]
public class PPFXRendererLayerEditor : Editor
{
	ParticleSystem[] l_particleSystems; //reference to our particle systems
	Renderer[] l_renderers;//reference to our renderers
 
	string[] sortingLayerNames;//we load here our Layer names to be displayed at the popup GUI
	int popupMenuIndex;//The selected GUI popup Index
	bool applyToChild = false;//Turn on/off if the effect will be extended to all renderers in child transforms
	bool applyToChildOldValue = false;//Used this old value to detect changes in applyToChild boolean
 
	
   //set some references and do some initialization. I don`t figured out how to make a variable persistent in Unity Editor yet so most of the codes here can useless
	void OnEnable()
	{
		sortingLayerNames = GetSortingLayerNames(); //First we load the name of our layers
		l_particleSystems = (target as PPFXRendererLayer).gameObject.GetComponentsInChildren<ParticleSystem>();//Then we load our ParticleSystems
		l_renderers = new Renderer[l_particleSystems.Length];//and Initialize our renderers array with the right size
		
		for (int i = 0; i<l_particleSystems.Length;i++) //here we loads all renderers to our renderersarray
		{
			l_renderers[i] = l_particleSystems[i].GetComponent<Renderer>();
		}
		
		for (int i = 0; i<sortingLayerNames.Length;i++) //here we initialize our popupMenuIndex with the current Sort Layer Name
		{
			if (l_particleSystems.Length > 0)
			{
				if (sortingLayerNames[i] == l_particleSystems[0].GetComponent<Renderer>().sortingLayerName)
					popupMenuIndex = i;		
			}
		}
	}
	
	
	public override void OnInspectorGUI()
	{
		DrawDefaultInspector(); //first we draw our DefaultInspector
		
		if (l_renderers.Length == 0) //if there`s no Renderer at this object
		{
			return; //returns
		}
		
		popupMenuIndex = EditorGUILayout.Popup("Sorting Layer", popupMenuIndex, sortingLayerNames);//The popup menu is displayed simple as that
		int newSortingLayerOrder = EditorGUILayout.IntField("Order in Layer", l_renderers[0].sortingOrder); //Specifies the order to be drawed in this particular SortLayer
		applyToChild = EditorGUILayout.ToggleLeft("Apply to Childs", applyToChild);//If this change will be applyed to every renderer or just this one
		
		if (sortingLayerNames[popupMenuIndex] != l_renderers[0].sortingLayerName ||
			newSortingLayerOrder != l_renderers[0].sortingOrder ||
			applyToChild != applyToChildOldValue) //if there`s some change
		{
			Undo.RecordObject(l_renderers[0], "Change Particle System Renderer Order"); //first let record this change into Undo class so if the user did a mess, he can use ctrl+z to undo
			
			if (applyToChild) //change sortingLayerName and sortingOrder in each Renderer
			{
				for (int i = 0; i<l_renderers.Length;i++)
				{
					l_renderers[i].sortingLayerName = sortingLayerNames[popupMenuIndex];
					l_renderers[i].sortingOrder = newSortingLayerOrder;
				}
			}
			else //or at least at this one
			{
				l_renderers[0].sortingLayerName = sortingLayerNames[popupMenuIndex];
				l_renderers[0].sortingOrder = newSortingLayerOrder;
			}
			
			EditorUtility.SetDirty(l_renderers[0]); //saves
		}
	}
 
    // Get the sorting layer names
	public string[] GetSortingLayerNames()
	{
		Type internalEditorUtilityType = typeof(InternalEditorUtility);
		PropertyInfo sortingLayersProperty = internalEditorUtilityType.GetProperty("sortingLayerNames", BindingFlags.Static | BindingFlags.NonPublic);
		return (string[])sortingLayersProperty.GetValue(null, new object[0]);
	}
}