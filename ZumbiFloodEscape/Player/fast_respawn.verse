using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Respawn rápido: ouve o elimination_manager e chama agent.Respawn na posição do marcador.
fast_respawn_policy := class:
    EliminationManager: elimination_manager_device = elimination_manager_device{}
    SafeRespawnMarker: player_spawner_device = player_spawner_device{}
    DelaySeconds: float = 3.0

    OnEliminatedCallback<public>(Victim: agent): void =
        spawn{DelayedRespawn(Victim)}

    DelayedRespawn(Victim: agent)<suspends>: void =
        Sleep(DelaySeconds)
        if (SafeRespawnMarker.IsValid[]):
            Spot := SafeRespawnMarker.GetTransform()
            Victim.Respawn(Spot.Translation, Spot.Rotation)
        else:
            Print("ZFE: configure SafeRespawnMarker (player_spawner_device).")

    Register<public>(): void =
        EliminationManager.EliminatedEvent.Subscribe(OnEliminatedCallback)
