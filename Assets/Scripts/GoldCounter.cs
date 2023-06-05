using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UIElements;

public class GoldCounter : MonoBehaviour
{

    TMP_Text goldDisplay;
    private void Awake()
    {
        goldDisplay = GetComponent<TMP_Text>();   
    }
    public void UpdateText(int amount)
    {
        goldDisplay.SetText(amount.ToString());   
    }
}
