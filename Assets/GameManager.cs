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

    public EnemyManager EnemyManager;
    public Spawner EnemySpawner;
    public GoldCounter goldCounter;
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

        EnemySpawner.Spawn(true);

        AddGold(0);
    }   

    public void OnMainMenu()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(true);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);
        EnemySpawner.Spawn(false);
    }

    public void OnGameOver()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(true);
        PauseCanvas.SetActive(false);
        EnemySpawner.Spawn(false);
    }

    public void OnPause()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(true);
        EnemySpawner.Spawn(false);
    }

    public void OnContinue()
    {
        GameplayCanvas.SetActive(true);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
        PauseCanvas.SetActive(false);
        EnemySpawner.Spawn(true);
    }
}
