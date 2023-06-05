using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;
using TMPro;
public class ShopManager : MonoBehaviour
{


    public GameObject upgradeButton;
    public TMP_Text towerPrice;

    public static ShopManager Instance;

    private void Awake()
    {
        Instance = this;

        upgradeButton.SetActive(false);
        towerPrice.transform.gameObject.SetActive(false);
    }

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

    }


    public void CheckPurchases()
    {
        int CurrentGold = GameManager.Instance.GetCurrentGold();

        switch (GameManager.Instance.towerManager.GetLevel())
        {
            case 1:
                if (GameManager.Instance.towerCosts[0] <= CurrentGold)
                {
                    EnableUpgradeButton();
                    UpdateTowerPrice();
                }
                else
                {
                    DisableUpgradeButton();
                }
                break;

            case 2:
                if (GameManager.Instance.towerCosts[1] <= CurrentGold)
                {
                    EnableUpgradeButton();
                    UpdateTowerPrice();
                }
                else
                {
                    DisableUpgradeButton();
                }
                break;
            default:
                return;
        }
    }

    void UpdateTowerPrice()
    {
        towerPrice.SetText(GameManager.Instance.towerCosts[GameManager.Instance.towerManager.GetLevel()-1].ToString());
    }

    public void EnableUpgradeButton()
    {
        upgradeButton.SetActive(true);
    }

    public void DisableUpgradeButton()
    {
        upgradeButton.SetActive(false);
    }
}
