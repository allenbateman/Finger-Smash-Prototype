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
        GameplayCanvas.SetActive(true);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);

        enemyManager.StartSpawning();

        AddGold(0);
    }   

    public void OnMainMenu()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(true);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);
        enemyManager.StopSpawning();
        towerManager.ResetTowerLevel();
    }

    public void OnGameOver()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(true);
        PauseCanvas.SetActive(false);
        enemyManager.StopSpawning();
        towerManager.ResetTowerLevel();
    }

    public void OnPause()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(true);
        enemyManager.StopSpawning();
    }

    public void OnContinue()
    {
        GameplayCanvas.SetActive(true);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);
        enemyManager.StartSpawning();
    }
}
