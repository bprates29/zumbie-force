using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { /ZumbiFloodEscape/Combat }
using { /ZumbiFloodEscape/Extraction }
using { /ZumbiFloodEscape/Flood }
using { /ZumbiFloodEscape/Player }
using { /ZumbiFloodEscape/Progression }
using { /ZumbiFloodEscape/Session }

# Coloque este creative_device na ilha e associe os devices nos campos @editable.
# Instruções de cópia do código Verse para o UEFN: veja UEFN_SETUP.txt na raiz do repositório.

zombie_flood_escape_device := class(creative_device):
    @editable
    EliminationManager: elimination_manager_device = elimination_manager_device{}

    @editable
    SafeRespawnMarker: player_spawner_device = player_spawner_device{}

    @editable
    FastRespawnDelaySec: float = 3.0

    @editable
    FloodVolumes: []damage_volume_device = array{}

    @editable
    CreatureSpawners: []creature_spawner_device = array{}

    @editable
    WavePulseSeconds: float = 5.0

    @editable
    MinWavePulseSeconds: float = 1.25

    @editable
    WaveBudgetBase: int = 8

    @editable
    IntermissionSec: float = 4.0

    @editable
    RoundDurationSec: float = 120.0

    @editable
    PostRoundSec: float = 2.0

    @editable
    ExtractionVolume: mutator_zone_device = mutator_zone_device{}

    @editable
    ExtractionTeleport: teleporter_device = teleporter_device{}

    @editable
    ExtractionScore: score_manager_device = score_manager_device{}

    @editable
    ExtractionAccolade: accolades_device = accolades_device{}

    @editable
    ExtractionPopup: popup_dialog_device = popup_dialog_device{}

    @editable
    DamagePowerup: damage_amplifier_powerup_device = damage_amplifier_powerup_device{}

    @editable
    HealthPowerup: health_powerup_device = health_powerup_device{}

    @editable
    HealthEveryNTiers: int = 2

    var Session: session_controller = session_controller{}

    var Extraction: extraction_manager = extraction_manager{}

    var RespawnPolicy: fast_respawn_policy = fast_respawn_policy{}

    OnBegin<override>()<suspends>: void =
        Print("ZFE: Zombie Flood Escape — iniciando sessão.")
        set Session = session_controller:
            IntermissionDurationSec := IntermissionSec
            RoundDurationSec := RoundDurationSec
            PostRoundPauseSec := PostRoundSec
            Flood := flood_phase_driver:
                Stages := FloodVolumes
            Waves := wave_director:
                Spawners := CreatureSpawners
                BaseSpawnIntervalSec := WavePulseSeconds
                MinSpawnIntervalSec := MinWavePulseSeconds
                MaxCreaturesBudgetBase := WaveBudgetBase
            Upgrades := upgrade_pickup_router:
                DamageBoost := DamagePowerup
                HealthBoost := HealthPowerup
                GrantHealthEveryNTiers := HealthEveryNTiers
        set Extraction = extraction_manager:
            EscapeTeleporter := ExtractionTeleport
            ExtractScore := ExtractionScore
            ExtractAccolade := ExtractionAccolade
            OptionalAnnounce := ExtractionPopup
        set RespawnPolicy = fast_respawn_policy:
            EliminationManager := EliminationManager
            SafeRespawnMarker := SafeRespawnMarker
            DelaySeconds := FastRespawnDelaySec
        RespawnPolicy.Register()
        ExtractionVolume.AgentEntersEvent.Subscribe(OnExtractionEntered)
        spawn { Session.RunSession(GetPlayspace()) }

    OnExtractionEntered(Agent: agent): void =
        Session.NotifyExtraction()
        Extraction.RunSequence(Agent)
