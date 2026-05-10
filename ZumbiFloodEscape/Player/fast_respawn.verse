using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Fortnite.com/FortPlayerUtilities }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Respawn rápido: ouve o elimination_manager e chama agent.Respawn na posição do marcador.
fast_respawn_policy<public> := class:
    EliminationManager<public>: elimination_manager_device = elimination_manager_device{}
    SafeRespawnMarker<public>: player_spawner_device = player_spawner_device{}
    DelaySeconds<public>: float = 3.0

    OnEliminatedCallback<public>(Victim: agent): void =
        spawn{DelayedRespawn(Victim)}

    DelayedRespawn(Victim: agent)<suspends>: void =
        Sleep(DelaySeconds)
        Spot := SafeRespawnMarker.GetTransform()
        Victim.Respawn(Spot.Translation, Spot.Rotation)

    Register<public>(): void =
        EliminationManager.EliminatedEvent.Subscribe(OnEliminatedCallback)
