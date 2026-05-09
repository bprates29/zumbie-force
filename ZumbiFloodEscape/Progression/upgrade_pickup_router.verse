using { /Fortnite.com/Devices }

# Upgrades locais por jogador a cada aumento de tier (dano sempre; vida a cada N tiers).
upgrade_pickup_router := class:
    DamageBoost: damage_amplifier_powerup_device = damage_amplifier_powerup_device{}
    HealthBoost: health_powerup_device = health_powerup_device{}
    GrantHealthEveryNTiers: int = 2

    OnDifficultyMilestone<public>(Agent: agent, Tier: int): void =
        if (Tier <= 0):
            return
        DamageBoost.Pickup(Agent)
        if (GrantHealthEveryNTiers <= 0):
            return
        var Q: int = Tier / GrantHealthEveryNTiers
        var R: int = Tier - Q * GrantHealthEveryNTiers
        if (R = 0):
            HealthBoost.Pickup(Agent)
