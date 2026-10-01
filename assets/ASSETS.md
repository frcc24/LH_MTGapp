# Assets

- `mana/`: 52 SVGs de símbolos de mana da Scryfall (`{W/U}` vira `WU.svg`), usados por `ManaSymbol`. Atualizar: `GET https://api.scryfall.com/symbology`,
  filtrando `appears_in_mana_costs`. Só como elemento funcional da interface; crédito "Scryfall" em Sobre.
- `icon/`: ícone do app e splash (gerados por `python tool/make_icons.py`, depois `dart run flutter_launcher_icons` e `dart run flutter_native_splash:create`).
- `fonts/`: Big Shoulders Display (números) e Instrument Sans (texto), SIL OFL.
- `sounds/`: `btn`, `dice_shake`, `ticking_countdown`, `restart`, `explode` (do app antigo). Desligados por padrão em Ajustes.

As imagens do app antigo (PNGs de interface, bandeiras, símbolos de mana em PNG e arte) foram removidas: nada no app as usa. Continuam no histórico do git.
