using { /Fortnite.com/Devices }
using { /Fortnite.com/Playspaces }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Combat }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Extraction }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Flood }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Player }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Progression }
using { /nindogames@fortnite.com/SurvivalZombie/zumbie_force/ZumbiFloodEscape/Session }

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

    # Countdown visível na HUD; duração é igual a RoundDurationSec (ajuste via Verse ou duração no device).
    @editable
    RoundHudTimer: timer_device = timer_device{}

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

    var SessionCtrl: Session.session_controller = Session.session_controller{}

    var ExtractionMgr: Extraction.extraction_manager = Extraction.extraction_manager{}

    var RespawnPolicy: Player.fast_respawn_policy = Player.fast_respawn_policy{}

    OnBegin<override>()<suspends>: void =
        Print("ZFE: Zombie Flood Escape — iniciando sessão.")
        set SessionCtrl = Session.session_controller:
            IntermissionDurationSec := IntermissionSec
            RoundDurationSec := RoundDurationSec
            PostRoundPauseSec := PostRoundSec
            RoundHudTimer := RoundHudTimer
            FloodDriver := Flood.flood_phase_driver:
                Stages := FloodVolumes
            Waves := Combat.wave_director:
                Spawners := CreatureSpawners
                BaseSpawnIntervalSec := WavePulseSeconds
                MinSpawnIntervalSec := MinWavePulseSeconds
                MaxCreaturesBudgetBase := WaveBudgetBase
            Upgrades := Progression.upgrade_pickup_router:
                DamageBoost := DamagePowerup
                HealthBoost := HealthPowerup
                GrantHealthEveryNTiers := HealthEveryNTiers
        set ExtractionMgr = Extraction.extraction_manager:
            EscapeTeleporter := ExtractionTeleport
            ExtractScore := ExtractionScore
            ExtractAccolade := ExtractionAccolade
            OptionalAnnounce := ExtractionPopup
        set RespawnPolicy = Player.fast_respawn_policy:
            EliminationManager := EliminationManager
            SafeRespawnMarker := SafeRespawnMarker
            DelaySeconds := FastRespawnDelaySec
        RespawnPolicy.Register()
        ExtractionVolume.AgentEntersEvent.Subscribe(OnExtractionEntered)
        spawn { SessionCtrl.RunSession(GetPlayspace()) }

    OnExtractionEntered(Agent: agent): void =
        SessionCtrl.NotifyExtraction()
        ExtractionMgr.RunSequence(Agent)
