using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Combat }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Flood }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Progression }

# Intermissão → rodada (timer em race com spawn loop) → fim; tier sobe e upgrades aplicam no fim.
session_controller<public> := class:
    FloodDriver<public>: Flood.flood_phase_driver = Flood.flood_phase_driver{}
    Waves<public>: Combat.wave_director = Combat.wave_director{}
    Upgrades<public>: Progression.upgrade_pickup_router = Progression.upgrade_pickup_router{}

    var Phase: session_phase = session_phase.Lobby
    var DifficultyTier: int = 0
    var ExtractionCount: int = 0

    IntermissionDurationSec<public>: float = 4.0
    RoundDurationSec<public>: float = 120.0
    PostRoundPauseSec<public>: float = 2.0

    NotifyExtraction<public>(): void =
        set ExtractionCount += 1

    ApplyUpgradesToAllPlayers<private>(PS: fort_playspace, Tier: int): void =
        for (P: PS.GetPlayers()):
            if (FC := P.GetFortCharacter[]):
                if (A := FC.GetAgent[]):
                    Upgrades.OnDifficultyMilestone(A, Tier)

    RunSession<public>(PS: fort_playspace)<suspends>: void =
        set Phase = session_phase.Lobby
        Sleep(1.0)
        loop:
            set Phase = session_phase.Intermission
            Sleep(IntermissionDurationSec)
            set Phase = session_phase.InRound
            FloodDriver.OnRoundStart(DifficultyTier)
            Waves.OnRoundStart()
            race:
                Sleep(RoundDurationSec)
                Waves.RunSpawnLoop(DifficultyTier)
            Waves.Stop()
            FloodDriver.OnRoundEnd()
            Waves.OnRoundEnd()
            set DifficultyTier += 1
            ApplyUpgradesToAllPlayers(PS, DifficultyTier)
            set Phase = session_phase.ExtractionWindow
            Sleep(PostRoundPauseSec)
