using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# Sequência de recompensa ao entrar na zona de extração (sem exigir coop).
extraction_manager<public> := class:
    EscapeTeleporter<public>: teleporter_device = teleporter_device{}
    ExtractScore<public>: score_manager_device = score_manager_device{}
    ExtractAccolade<public>: accolades_device = accolades_device{}
    OptionalAnnounce<public>: popup_dialog_device = popup_dialog_device{}

    RunSequence<public>(Agent: agent): void =
        EscapeTeleporter.Activate(Agent)
        ExtractScore.Activate(Agent)
        ExtractAccolade.Award(Agent)
        OptionalAnnounce.Show(Agent)
