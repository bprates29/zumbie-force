using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# Até N spawners ficam ativos por vez, conforme o orçamento do tier; intervalo diminui com a dificuldade.
wave_director := class:
    Spawners: []creature_spawner_device = array{}
    BaseSpawnIntervalSec: float = 5.0
    MinSpawnIntervalSec: float = 1.25
    MaxCreaturesBudgetBase: int = 8

    var IsActive: logic = false

    Stop<public>(): void =
        set IsActive = false

    OnRoundStart<public>(): void =
        set IsActive = true

    OnRoundEnd<public>(): void =
        set IsActive = false
        for (S: Spawners):
            S.Disable()
            S.EliminateCreatures()

    BudgetForTier<public>(Tier: int): int =
        MaxCreaturesBudgetBase + Tier * 2

    RunSpawnLoop<public>(Tier: int)<suspends>: void =
        loop:
            if (IsActive = false):
                return
            Budget: int = BudgetForTier(Tier)
            var Limit: int = Budget
            if (Limit > Spawners.Length):
                set Limit = Spawners.Length
            var Idx: int = 0
            for (S: Spawners):
                if (Idx < Limit):
                    S.Enable()
                else:
                    S.Disable()
                set Idx += 1
            Interval: float = BaseSpawnIntervalSec
            if (Tier > 0):
                var Step: float = 0.35 * (Tier * 1.0)
                set Interval = BaseSpawnIntervalSec - Step
            if (Interval < MinSpawnIntervalSec):
                set Interval = MinSpawnIntervalSec
            Sleep(Interval)
