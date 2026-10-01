# Assets do app antigo (LH_MTGapp, 2022)

Origem: github.com/frcc24/LH_MTGapp, `app/src/main/res`. Para o design usar como referência ou reaproveitar.
Em cada nome repetido entre densidades, ficou a versão de maior resolução.

## images/
- **Mana (cores):** `w.png` (250px), `u.png` (2400px), `b.png` (2400px), `r.png` (300px), `g.png` (800px). Resoluções inconsistentes: normalizar ou trocar pela fonte Mana / SVGs do Scryfall.
- **Contadores:** `hourglass.png` (tempo).
- **Dados / UI:** `d20.png`, `dado.png`, `relogio.png`, `restart.png`, `config.png`, `arrow.png`, `balao.png`, `ic_action_*.png`.
- **Fundos:** `bg.png`, `bgdark.png`, `bgup.png`, `rodape.png`, `rodape2.png`.
- **Marca / arte:** `logo.png`, `logo1.png` (1200px).
- **Bandeiras:** `br_flag.png`, `eua_flag.png`, `es_flag.png`.

## sounds/
`btn.mp3`, `btn1.mp3`, `btn2.mp3` (toques), `dice_shake.mp3`, `explode.mp3`, `restart.mp3`, `ticking_countdown.mp3` (timer de turno).

## fonts/
`cinzel.otf`, `cinzel_black.otf`, `simplifica.ttf`, `simplifica2.ttf`.

## app_icon/
`ic_launcher.png` (xxxhdpi, 192px), ícone antigo, a ser redesenhado.

## Removidos de propósito
Logos de doação (PicPay, PayPal) e todo arquivo de arte ou símbolo da Wizards que não seja mana: `magic_symbol.png`, `phyrexia.png`, `war_manzali.png`, `pw_symbol.png`, `card_back.jpg`, `energy.png`. Os únicos ativos da Wizards que ficam são os símbolos de mana (`w`, `u`, `b`, `r`, `g`), para uso só como elementos funcionais da interface.

## mana/ (novo)
52 SVGs de símbolos de mana baixados da Scryfall (`svgs.scryfall.io/card-symbols`, via `GET /symbology`): as 6 cores, `X`, `S`, números 0 a 16,
híbridos (`WU`, `BR`...), híbridos com incolor (`CW`...), híbridos de 2 (`2W`...) e phyrexianos (`WP`, `GUP`...).
Nome do arquivo = código sem as barras (`{W/U}` vira `WU.svg`). Usados por `ManaSymbol` (`lib/shared/widgets/mana_token.dart`) no custo das
cartas, nos filtros de cor e na calculadora de base de mana. Só como elemento funcional da interface; crédito "Scryfall" em Sobre.
Para atualizar: `python` + `GET https://api.scryfall.com/symbology` e filtrar `appears_in_mana_costs`.
