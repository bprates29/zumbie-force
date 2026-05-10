using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

# Upgrades locais por jogador a cada aumento de tier (dano sempre; vida a cada N tiers).
upgrade_pickup_router<public> := class:
    DamageBoost<public>: damage_amplifier_powerup_device = damage_amplifier_powerup_device{}
    HealthBoost<public>: health_powerup_device = health_powerup_device{}
    GrantHealthEveryNTiers<public>: int = 2

    OnDifficultyMilestone<public>(Agent: agent, Tier: int): void =
        if (Tier <= 0):
            return
        DamageBoost.Pickup(Agent)
        if (GrantHealthEveryNTiers <= 0):
            return
        var R: int = Tier
        loop:
            if (R < GrantHealthEveryNTiers):
                break
            set R -= GrantHealthEveryNTiers
        if (R = 0):
            HealthBoost.Pickup(Agent)
