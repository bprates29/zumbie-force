using { /Fortnite.com/Devices }

# Habilita volumes de dano do “flood” em degraus conforme o tier de dificuldade.
# Coloque os volumes do mais baixo ao mais alto no array @editable do device raiz.
flood_phase_driver := class:
    Stages: []damage_volume_device = array{}

    OnRoundStart<public>(Tier: int): void =
        if (Stages.Length <= 0):
            return
        var CappedTier: int = Tier
        if (CappedTier >= Stages.Length):
            set CappedTier = Stages.Length - 1
        var Idx: int = 0
        for (Vol: Stages):
            if (Idx <= CappedTier):
                Vol.Enable()
            else:
                Vol.Disable()
            set Idx += 1

    OnRoundEnd<public>(): void =
        for (Vol: Stages):
            Vol.Disable()
