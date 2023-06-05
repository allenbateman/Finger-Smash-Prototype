using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
public class ShopManager : MonoBehaviour
{


    public GameObject upgradeButton;
    public TMP_Text towerPrice;

    public static ShopManager Instance;


    public Button RepairButton;
    public TMP_Text repairPrice;
    public int repairCost = 1000;
    public AudioClip repairPurchaseSFX;

    public Button ability1Button;
    public TMP_Text ability1PriceText;
    public int ability1Cost= 50;
    public AudioClip abilityPurchaseSFX;


    public ShootProjectile ShootProjectile;
    public GameObject tap;
    private void Awake()
    {
        Instance = this;

        upgradeButton.SetActive(false);
        towerPrice.transform.gameObject.SetActive(false);
        RepairButton.interactable = false;
    }

    void Start()
    {
        repairPrice.SetText(repairCost.ToString() +"g");
        ability1PriceText.SetText(ability1Cost.ToString() +"g");

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


        if(CurrentGold >= repairCost)
        {
            RepairButton.interactable = true;
        }
        else
        {
            RepairButton.interactable = false;
        }


        if (CurrentGold >= ability1Cost)
        {
            ability1Button.interactable = true;
        }
        else
        {
            ability1Button.interactable = false;
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

    public void PurchaseAttack()
    {
        if (GameManager.Instance.GetCurrentGold() >= ability1Cost)
        {
            GameManager.Instance.AddGold(-ability1Cost);
            ShootProjectile.CanShoot();
            GetComponent<AudioSource>().clip = abilityPurchaseSFX;
            GetComponent<AudioSource>().Play();
            tap.SetActive(true);
        }
    }

    public void RepairTower()
    {
        if (GameManager.Instance.GetCurrentGold() >= repairCost)
        {
            GameManager.Instance.AddGold(-repairCost);
            GameManager.Instance.towerManager.Repair();
            GetComponent<AudioSource>().clip = repairPurchaseSFX;
            GetComponent<AudioSource>().Play();
        }
    }
}
