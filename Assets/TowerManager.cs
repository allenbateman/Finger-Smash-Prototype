using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TowerManager : MonoBehaviour
{
    [SerializeField] private GameObject towerLevel_1;
    [SerializeField] private GameObject towerLevel_2;
    [SerializeField] private GameObject towerLevel_3;
    int level = 1;

    public void UpgradeTower()
    {
        level++;

        if (level >= 3)
            level = 3;

        ActivateTower(level);
    }

    public void ResetTowerLevel()
    {
        level = 1;
        ActivateTower(level);
    }

    public int GetLevel()
    {
        return level;
    }
    void ActivateTower(int level)
    {
        if (towerLevel_1)
        {
            towerLevel_1.GetComponent<Health>().ResetHealth();
            towerLevel_1.SetActive(false); 
        }
        if (towerLevel_2)
        {
            towerLevel_2.GetComponent<Health>().ResetHealth();
            towerLevel_2.SetActive(false); 
        }
        if (towerLevel_3)
        {
            towerLevel_3.GetComponent<Health>().ResetHealth();
            towerLevel_3.SetActive(false); 
        }

        switch (level)
        {
            case 1:
                {
                    if (towerLevel_1)
                        towerLevel_1.SetActive(true);
                }
                break;
            case 2:
                {
                    if (towerLevel_2)
                        towerLevel_2.SetActive(true);
                }
                break;
            case 3:
                {
                    if (towerLevel_3)
                        towerLevel_3.SetActive(true);
                }
                break;
        }
    }
}
