using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public GameObject MainMenuCanvas;
    public GameObject GameplayCanvas;
    public GameObject GameOverCanvas;
    public GameObject PauseCanvas;

    public EnemyManager enemyManager;
 
    public GoldCounter goldCounter;
    public TowerManager towerManager;

    public GameObject gameEntitiesGO;

    private int currentGold = 0;

    public int[] towerCosts;


    private void Awake()
    {
        DontDestroyOnLoad(this);

        Instance = this;

        gameEntitiesGO = new GameObject("Entities go");


        gameEntitiesGO.transform.parent = transform;

    }
    void Start()
    {
        currentGold = 0;
        OnMainMenu(); 
    }

    void Update()
    {
        
    }

    public void UpgradeTower()
    {
       switch(towerManager.GetLevel())
       {
         case 1:
             if (towerCosts[0] <= currentGold)
             {
                 towerManager.UpgradeTower();
                 AddGold(-towerCosts[0]);
             }
             break;

         case 2:
             if (towerCosts[1] <= currentGold)
             {
                 towerManager.UpgradeTower();
                 AddGold(-towerCosts[1]);
             }
             break;
         default:
             return;
       }
    }
    public void AddGold(int amount)
    {
        currentGold += amount;

        goldCounter.UpdateText(currentGold);


        ShopManager.Instance.CheckPurchases();
    }

    public void OnStartGame()
    {
        Time.timeScale = 1;

        GameplayCanvas.SetActive(true);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);

        enemyManager.StartSpawning();

        currentGold = 0;
        AddGold(0);

        Time.timeScale = 1;
    }   

    public void OnMainMenu()
    {
        DeleteAllEntities();

        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(true);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);

        enemyManager.StopSpawning();
        enemyManager.ResetSpawners();
        towerManager.ResetTowerLevel();

        Time.timeScale = 1;
    }

    public void OnGameOver()
    {

        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(true);
        PauseCanvas.SetActive(false);

        enemyManager.StopSpawning();
        towerManager.ResetTowerLevel();

        Time.timeScale = 0;
    }

    public void OnPause()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(true);

        enemyManager.StopSpawning();

        Time.timeScale = 0;
    }

    public void OnContinue()
    {
        GameplayCanvas.SetActive(true);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);

        enemyManager.StartSpawning();

        Time.timeScale = 1;
    }

    void DeleteAllEntities()
    {
        int count = gameEntitiesGO.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            Destroy(gameEntitiesGO.transform.GetChild(i).gameObject);       
        }
    }

    public Transform GetEntityTransform()
    {

        if(gameEntitiesGO == null)
        {
            return transform;
        }
        else
        {
            return gameEntitiesGO.transform;
        }
    }

    public int GetCurrentGold()
    {
        return currentGold;
    }
}
