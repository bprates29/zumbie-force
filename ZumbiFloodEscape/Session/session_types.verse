using { /Verse.org/Simulation }

# Fases do loop de sessão (lobby curto → rodada → janela de extração).
session_phase := enum:
    Lobby
    Intermission
    InRound
    ExtractionWindow
