# -*- coding: utf-8 -*-
# Modo solo, contadores na partida, retomar partida. Mesmo formato de l10n_strings.py.

STRINGS = {
    'soloLabel': ('Solo', 'Solo', 'Solo'),
    'turnTitle': ('TURNO {n}', 'TURN {n}', 'TURNO {n}', {'n': 'int'}),
    'lifePerTurn': ('Vida por turno', 'Life per turn', 'Vida por turno'),
    'lifeStartNow': ('início {start} · atual {now}', 'start {start} · now {now}', 'inicio {start} · ahora {now}', {'start': 'int', 'now': 'int'}),
    'nextTurn': ('Próximo turno', 'Next turn', 'Siguiente turno'),
    'typeValue': ('Digitar', 'Type', 'Escribir'),
    'cmdAffectsLife': ('Dano de comandante também tira vida', 'Commander damage also removes life', 'El daño de comandante también quita vida'),
    'countersInMatch': ('Contadores nesta partida', 'Counters in this match', 'Contadores en esta partida'),
    'resumeTitle': ('Continuar de onde parou?', 'Pick up where you left off?', '¿Continuar donde lo dejaste?'),
    'resumeDiscard': ('Descartar', 'Discard', 'Descartar'),
}
