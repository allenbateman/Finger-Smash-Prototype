using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu]
public class EnemyStatsSO : ScriptableObject
{
    public int Enemy_Melee_Health;
    public int Enemy_Melee_Damage;
    public float Enemy_Melee_RangeOfAttack;
    public float Enemy_Melee_RateOfAttack;

    public int Enemy_Ranged_Health;
    public int Enemy_Ranged_Damage;
    public float Enemy_Ranged_RangeOfAttack;
    public float Enemy_Ranged_RateOfAttack;
}
