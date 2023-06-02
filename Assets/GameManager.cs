using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public GameObject MainMenuCanvas;
    public GameObject GameplayCanvas;
    public GameObject GameOverCanvas;

    public EnemyManager EnemyManager;

    private void Awake()
    {
        DontDestroyOnLoad(this);
    }
    void Start()
    {
        
    }

    void Update()
    {
        
    }


    public void OnStartGame()
    {
        GameplayCanvas.SetActive(true);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(false);
    }   

    public void OnMainMenu()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(true);
        GameOverCanvas.SetActive(false);
    }

    public void OnGameOver()
    {
        GameplayCanvas.SetActive(false);
        MainMenuCanvas.SetActive(false);
        GameOverCanvas.SetActive(true);
    }
}
