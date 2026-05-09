using { /Fortnite.com/Characters }
using { /Fortnite.com/Playspaces }
using { /Verse.org/Simulation }
using { /ZumbiFloodEscape/Combat }
using { /ZumbiFloodEscape/Flood }
using { /ZumbiFloodEscape/Progression }

# Intermissão → rodada (timer em race com spawn loop) → fim; tier sobe e upgrades aplicam no fim.
session_controller := class:
    Flood: flood_phase_driver = flood_phase_driver{}
    Waves: wave_director = wave_director{}
    Upgrades: upgrade_pickup_router = upgrade_pickup_router{}

    var Phase: session_phase = session_phase.Lobby
    var DifficultyTier: int = 0
    var ExtractionCount: int = 0

    IntermissionDurationSec: float = 4.0
    RoundDurationSec: float = 120.0
    PostRoundPauseSec: float = 2.0

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
            Flood.OnRoundStart(DifficultyTier)
            Waves.OnRoundStart()
            race:
                block:
                    Sleep(RoundDurationSec)
                    0
                block:
                    Waves.RunSpawnLoop(DifficultyTier)
                    0
            Waves.Stop()
            Flood.OnRoundEnd()
            Waves.OnRoundEnd()
            set DifficultyTier += 1
            ApplyUpgradesToAllPlayers(PS, DifficultyTier)
            set Phase = session_phase.ExtractionWindow
            Sleep(PostRoundPauseSec)
