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
    private void Awake()
    {
        DontDestroyOnLoad(this);

        Instance = this;
    }
    void Start()
    {
        currentGold = 0;
        OnMainMenu(); 
    }

    void Update()
    {
        
    }

    public void AddGold(int amount)
    {
        currentGold += amount;

        goldCounter.UpdateText(currentGold);

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

        Debug.Log("Button cliked");
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
}
