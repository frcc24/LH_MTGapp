# Lighthouse Life · Handoff de design para implementação em Flutter

Direção de arte escolhida: **A · Sinal** (preto OLED, bordas de luz na cor de cada jogador).
Este documento é a especificação. Os mockups em `design/mockups/` são a referência visual; quando houver conflito entre um PNG e este texto, vale o texto, e entre o texto e o HTML do mockup, vale o valor numérico do HTML.

Índice

1. Decisões já tomadas
2. Como ler os mockups
3. Tokens e fontes
4. Arquitetura do app
5. Modelo de domínio e regras do jogo
6. Motor de layout da partida (1 a 4 jogadores, celular e tablet)
7. Componentes
8. Telas e rotas
9. Interação, gestos e movimento
10. Consulta de cartas (Scryfall)
11. Calculadora de base de mana
12. Monetização (Unity Ads + IAP)
13. Acessibilidade
14. Conformidade com as lojas
15. Plano de implementação por fases, com critérios de aceite
16. Cortes para a versão 2
17. Capturas de tela da loja

---

## 1. Decisões já tomadas

| Tema | Decisão |
|---|---|
| Nome | Lighthouse Life. Nunca usar "Magic" no nome, no ícone ou no subtítulo da loja. |
| Contas e sincronização | Nenhuma na v1. Tudo fica no aparelho. |
| Compras | Um único IAP não consumível: **Lighthouse Pro** (`lighthouse_pro`). Remove anúncios e libera os extras. Sem assinatura. |
| Anúncio premiado | Fora da v1. |
| Anúncios | Unity Ads apenas. Banner na Home e em Ferramentas (só quando aberta fora da partida). Intersticial só ao voltar para a Home depois do fim de uma partida, com limite de frequência. Nunca na partida, na gaveta, no menu da partida ou em diálogos. |
| Preços de cartas | Não exibir de nenhuma fonte. Não ler os campos `prices` da Scryfall. |
| Idiomas | pt-BR (principal), en, es. |
| Tema | Escuro por padrão. Claro e "sistema" ficam nos ajustes, mas o tema claro é **v1.1** (ver cortes). |
| Orientação do 4J no celular | Coluna da esquerda girada 90°, coluna da direita girada 270° (jogadores nas laterais compridas). A versão com a fileira de cima girada 180° fica como opção em Configurar e é o padrão no tablet em paisagem. |
| Passar o turno | Botão "Passar" na faixa central (2J), toque no selo "TURNO" do jogador ativo (3–4J) ou item do menu. **Não** usar toque duplo no painel: ele conflita com toques rápidos de +1 e geraria +2 acidental. |

## 2. Como ler os mockups

`design/mockups/png/` tem cada tela renderizada em 2x. **As fontes nesses PNGs são substitutas** (o render foi feito sem acesso ao Google Fonts), então números aparecem mais largos do que ficarão com Big Shoulders Display. Cores, tamanhos, espaçamentos e layout estão corretos.

`design/mockups/html/` tem o código-fonte de cada tela (formato `.dc.html`: HTML com estilos inline, `{{variáveis}}`, `<sc-for>` para listas e `<sc-if>` para condicionais, e uma classe JS no fim com o estado de exemplo e a lógica de interação). Use o HTML para tirar valores exatos (px, cores, raios, pesos). 1 px CSS = 1 pt lógico no Flutter.

O canvas interativo (com Play) está no link do artefato que o Franco tem; os arquivos aqui são uma cópia.

| Arquivo | Tela | Rota |
|---|---|---|
| Main | Direção de arte, paleta, ícone | — |
| A-Componentes | Biblioteca de componentes e estados | — |
| A-Onboarding | Onboarding em 3 passos (interativo) | `/onboarding` |
| A-Home | Home | `/` |
| A-Configurar | Configurar partida (interativo) | `/setup` |
| A-Partida-1J / 2J / 3J / 4J | Partida, retrato, celular | `/match` |
| A-Partida-2J-Paisagem | Partida 2J, celular em paisagem | `/match` |
| A-Tablet-4J | Partida 4J, tablet em paisagem | `/match` |
| A-Gaveta | Gaveta do jogador (abas Contadores, Comandante, Histórico) | sheet sobre `/match` |
| A-Menu-Partida | Menu da partida | diálogo sobre `/match` |
| A-Fim-Partida | Fim de partida | `/match/result` |
| A-Ferramentas | Dados, moeda, dado planar, sorteio, timer | `/tools` e sheet sobre `/match` |
| A-Mana | Calculadora de base de mana | `/mana` |
| A-Cartas-Busca / A-Cartas-Detalhe | Consulta de cartas | `/cards`, `/cards/:id` |
| A-Estados | Vazio, carregando, erro de rede | estados de `/cards` |
| A-Historico | Histórico e estatísticas | `/history` |
| A-Ajustes | Ajustes | `/settings` |
| A-Paywall | Lighthouse Pro | `/pro` (modal em tela cheia) |
| A-Sobre | Sobre, créditos, aviso legal | `/settings/about` |
| A-Dialogos | Reiniciar, pré-prompt ATT, continuar partida salva | diálogos |

## 3. Tokens e fontes

O arquivo `design/flutter/app_tokens.dart` já está escrito em Dart: cores, enum de cores de jogador (cor + glifo + nome + traço daltônico), cores de mana, tipografia, espaçamento, raios, tamanhos, sombras, durações, curvas, `ThemeExtension` e `buildDarkTheme()`. Copie para `lib/core/theme/` e use só esses nomes; não escreva cores soltas nos widgets.

`design/tokens.json` traz os mesmos valores em JSON, se quiser gerar código.

### Fontes

- **Big Shoulders Display** (pesos 700, 800, 900) para vida, contadores e títulos curtos em caixa alta.
- **Instrument Sans** (400, 500, 600, 700) para todo o resto.
- Ambas são SIL OFL. Baixe os TTF estáticos em fonts.google.com e coloque em `assets/fonts/`. Empacote no app (não use `google_fonts` em tempo de execução: o app precisa funcionar offline na mesa).
- As fontes antigas (`cinzel`, `simplifica`) não são usadas.

```yaml
flutter:
  fonts:
    - family: BigShouldersDisplay
      fonts:
        - asset: assets/fonts/BigShouldersDisplay-Bold.ttf
          weight: 700
        - asset: assets/fonts/BigShouldersDisplay-ExtraBold.ttf
          weight: 800
        - asset: assets/fonts/BigShouldersDisplay-Black.ttf
          weight: 900
    - family: InstrumentSans
      fonts:
        - asset: assets/fonts/InstrumentSans-Regular.ttf
        - asset: assets/fonts/InstrumentSans-Medium.ttf
          weight: 500
        - asset: assets/fonts/InstrumentSans-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/InstrumentSans-Bold.ttf
          weight: 700
    - family: Mana
      fonts:
        - asset: assets/fonts/mana.ttf
```

### Ícones

- Ícones gerais: `font_awesome_flutter`. Equivalências dos mockups: voltar `chevronLeft`, ajustes `gear`, dado `diceD20`, cartas `clone`, histórico `clockRotateLeft`, gráfico `chartSimple`, desfazer `rotateLeft`, pausa `pause`, play `play`, fechar `xmark`, coroa `crown`, caveira/veneno `skull`, energia `bolt`, comandante `shieldHalved` ou `khanda`, moeda `coins`, sorteio `bullseye`, timer `stopwatch`, Wi‑Fi cortado `wifi` + barra.
- Glifos dos jogadores (`PlayerGlyph`): `fire`, `droplet`, `gem`, `leaf`, `star`, `shieldHalved`.
- O **farol** (hub central e logo) é desenhado por código com `CustomPainter`. Geometria no `viewBox 0 0 24 24` do hub: torre `M9.5 21l1-11h3l1 11`, base `M8 21h8`, lanterna `M10.5 10V7.5L12 6l1.5 1.5V10`, feixes `M16 7.5l4-1.5 M16 9.5l4 1.5 M8 7.5L4 6 M8 9.5L4 11`, traço 2, cantos arredondados. O ícone do app (viewBox 100) está no SVG de `Main.dc.html`.
- Símbolos de mana: fonte **Mana** de Andrew Gioia (SIL OFL), só como elemento funcional. Fallback: círculo com a letra (como nos mockups). Os PNG antigos `w/u/b/r/g.png` não devem ser usados (resoluções inconsistentes).

## 4. Arquitetura do app

Pacotes: `flutter_riverpod` (+ `riverpod_annotation`, `riverpod_generator`), `go_router`, `freezed` + `json_serializable`, `shared_preferences`, `path_provider`, `dio`, `cached_network_image`, `font_awesome_flutter`, `wakelock_plus`, `in_app_purchase`, `unity_ads_plugin`, `app_tracking_transparency`, `flutter_localizations` + `intl`, `audioplayers` (sons), `sensors_plus` (agitar para desfazer, opcional), `url_launcher`, `package_info_plus`.

Persistência: `shared_preferences` para ajustes e última configuração; arquivos JSON em `getApplicationDocumentsDirectory()` para partida em andamento e histórico. Volume é minúsculo (dezenas de partidas), então não vale um banco. [Isar: o pacote original está sem manutenção; se quiser banco depois, prefira `drift`.]

```
lib/
  main.dart
  app.dart                      # MaterialApp.router, tema, locale
  core/
    theme/app_tokens.dart       # copiado de design/flutter
    layout/breakpoints.dart     # compact < 600, medium 600–839, expanded ≥ 840
    haptics.dart, sounds.dart, wakelock.dart
    l10n/                       # arb pt, en, es
  features/
    home/
    onboarding/
    setup/                      # configurar partida, presets
    match/
      domain/                   # modelos freezed + GameController (reducer puro)
      layout/                   # MatchLayout: calcula seats e geometria
      widgets/                  # PlayerPanel, LifeNumber, CenterHub, TurnTimerBar, DeltaBadge...
      drawer/                   # CounterDrawer
      menu/                     # MatchMenu
      result/                   # tela de fim
    tools/                      # DiceSheet, CoinFlip, PlanarDie, PlayerPicker, TurnTimer
    cards/                      # Scryfall: data, repo, telas
    mana/
    history/
    settings/
    monetization/               # ads_service, iap_service, consent
  shared/widgets/               # LhButton, LhStepper, LhToggleChip, LhSegmented, SectionHeader...
```

Regra: o estado da partida muda **só** por um reducer puro `GameState reduce(GameState s, GameAction a)` dentro de um `Notifier`. Isso dá desfazer de graça (pilha de estados ou de ações inversas), testes unitários simples e restauração após o app ser morto.

## 5. Modelo de domínio e regras do jogo

```dart
@freezed class GameConfig { formatId, startingLife, players: List<PlayerConfig>, enabledCounters: Set<CounterType>,
  teams: List<List<String>>?, turnTimerSeconds: int?, chessClock: bool, starter: StarterMode, cmdDamageAffectsLife: bool (padrão true),
  layoutVariant: LayoutVariant }
@freezed class PlayerConfig { id, name, PlayerColor color, String? deck, int? seatQuarterTurns }
@freezed class PlayerState { id, life, counters: Map<CounterType,int>, cmdDamage: Map<String opponentId, CmdDamage>, castCount, castCountPartner,
  eliminated, eliminatedReason, eliminatedRound, statuses: Set<Status> }
@freezed class CmdDamage { int main, int partner }
@freezed class GameState { config, players, activePlayerId, round, turnStartedAt, timerRemaining, paused, dayNight, monarchId, initiativeId,
  ringTemptation: Map<String,int>, log: List<LifeEvent>, startedAt, endedAt, winnerIds }
@freezed class LifeEvent { at, round, playerId, kind (life|counter|cmd|status), delta, sourceId?, after }
@freezed class MatchRecord { id, formatId, players (nome, cor, vida final, colocação, motivo), winnerIds, duration, rounds, endedAt, finished: bool }
@freezed class SavedPlayer { id, name, color, glyph, defaultDeck }
```

### Presets de formato (editáveis e lembrados)

| id | Nome | Vida | Contadores ligados por padrão | Observação |
|---|---|---|---|---|
| standard | Standard | 20 | — | Modern, Pioneer, Legacy, Vintage usam o mesmo preset com nome próprio |
| pauper | Pauper | 20 | — | |
| commander | Commander | 40 | Dano de comandante, Veneno, Monarca | Taxa de comandante na gaveta |
| brawl | Brawl | 25 (2J) / 30 (3–4J) | Dano de comandante | A vida muda sozinha quando o número de jogadores muda |
| thg | Two-Headed Giant | 30 por time | Veneno | 2 vs 2, vida e veneno **compartilhados** pelo time; veneno letal = 15 |
| oathbreaker | Oathbreaker | 20 | Dano de comandante (tratado como "assinatura"), Veneno | |
| custom | Livre | definida pelo usuário | escolhidos pelo usuário | |

### Regras de alerta e eliminação

- Vida ≤ 0 → eliminado (motivo "vida"). Vida negativa é permitida e exibida.
- Veneno: aviso visual em ≥ 8, letal em ≥ 10 (15 no 2HG) → eliminado (motivo "veneno").
- Dano de comandante: aviso em ≥ 15 de um mesmo comandante, letal em ≥ 21 → eliminado (motivo "comandante"). Partner: duas contagens separadas por oponente, cada uma com seu limite de 21.
- Com `cmdDamageAffectsLife` ligado, somar dano de comandante também subtrai a mesma quantidade da vida (e desfazer reverte os dois).
- Monarca e Iniciativa são exclusivos: dar a um jogador tira de quem tinha. Dia/Noite é global. Tentação do Anel: 0 a 4 por jogador.
- Eliminado não bloqueia nada: o painel fica a 45% de opacidade com selo "ELIMINADO", continua aceitando toques; voltar acima do limite desfaz a eliminação. Toque longo no selo = "Reviver" explícito.
- Fim de partida: quando sobra exatamente um jogador (ou um time) não eliminado, espere `AppMotion.endGameDelay` (1,2 s) e mostre um snackbar "Ana venceu? [Ver resultado] [Continuar jogando]". Só vá para a tela de resultado com confirmação; isso evita encerrar por um toque errado.
- Cada mudança gera `LifeEvent` e entra na pilha de desfazer (limite 200).

### Persistência

- Salvar `GameState` (debounce 300 ms) a cada ação. No próximo lançamento, se houver partida não terminada, mostrar o diálogo "Continuar de onde parou?" (A-Dialogos, 3º quadro) e a linha "Continuar partida" na Home.
- Grátis guarda as últimas 20 partidas no histórico; Pro guarda todas.

## 6. Motor de layout da partida

Uma única tela `/match` monta o layout a partir de `(número de jogadores, largura, orientação, LayoutVariant)`. Nada de telas separadas por aparelho.

Cada jogador recebe um **seat**: retângulo + `quarterTurns` (0, 1, 2, 3). O painel é desenhado sempre "em pé" e girado com `RotatedBox(quarterTurns: ...)`, que gira também o layout e a área de toque. Não use `Transform.rotate` para isso.

| Jogadores | Celular retrato (compact) | Celular paisagem | Tablet (expanded) |
|---|---|---|---|
| 1 | Painel único + cabeçalho (turno) + chips + gráfico de vida por turno + "Próximo turno" (A-Partida-1J) | Painel à esquerda (60%), chips e gráfico à direita | Igual ao paisagem, com gráfico maior |
| 2 | Dois painéis empilhados; o de cima `qt=2`. Faixa central de 72 pt com pausar, R/passar, hub, d20, desfazer (A-Partida-2J) | Lado a lado, esquerda `qt=1`, direita `qt=3`, faixa central vertical (A-Partida-2J-Paisagem) | Igual ao celular, com faixa central mais larga e rótulos |
| 3 | Duas células em cima (56% da altura), esquerda `qt=1`, direita `qt=3`; uma embaixo em largura total `qt=0`. Hub na junção (A-Partida-3J). **Recomendado.** Alternativa "três faixas" (todas `qt=0`, empilhadas): pior para quem está nas laterais, oferecer só como opção | Mesmo arranjo girado 90° | Mesmo arranjo, células maiores |
| 4 | Grade 2×2, coluna esquerda `qt=1`, coluna direita `qt=3` (A-Partida-4J). Opção: fileira de cima `qt=2` | Grade 2×2, fileira de cima `qt=2` | Grade 2×2, fileira de cima `qt=2` (A-Tablet-4J). Hub 88 pt |

Medidas no celular: padding externo 8, espaço entre painéis 8, raio 24 (3–4J) ou 28 (1–2J), borda 2 px na cor do jogador. No tablet: padding 16, espaço 12, raio 32.

Safe areas: os painéis vão até as bordas da tela (é uma superfície de jogo), mas nenhum conteúdo interativo ou texto pode cair sob a Dynamic Island, o notch, o home indicator ou cantos arredondados. Use `MediaQuery.paddingOf` para empurrar o conteúdo do painel, não o painel.

Tela sempre ligada (`wakelock_plus`) só enquanto `/match` está visível e o ajuste estiver ligado. Barra de status escondida em `/match` (`SystemUiMode.immersiveSticky` no Android, `statusBarHidden` no iOS).

## 7. Componentes

Todos em `shared/widgets` ou `features/match/widgets`. Cada um com variantes de tamanho, `quarterTurns` (quando aplicável), estado (normal, pressionado, desabilitado, alerta, eliminado) e cor do jogador. Faça um golden test por variante.

**PlayerPanel** (A-Componentes, linha de cima). Container com borda 2 px `player.color`, fundo `RadialGradient(center, [player.tint, AppColors.panel], stops [0, .72])`, sombra `AppShadow.panelIdle` ou `panelActive`. Conteúdo, de cima para baixo no referencial do jogador: linha de selos (TURNO + tempo, DeltaBadge), LifeNumber centralizado, linha inferior com nome (chip com glifo) e CounterChips ativos. Duas áreas de toque invisíveis: metade esquerda = −1, metade direita = +1, com glifos `−`/`+` em `AppColors.iconIdle` encostados nas bordas. Estados: ativo (anel de 3 px + brilho + TurnTimerBar de 4 px no topo, proporcional ao tempo restante), alerta (o chip em alerta muda de cor; o painel não pisca), eliminado (opacidade 0,45, selo ELIMINADO), daltônico (borda com `colorBlindDash`).

**LifeNumber**. Big Shoulders 800, algarismos tabulares. Tamanho = `min(alturaÚtil × 0,62, larguraÚtil × (dígitos ≤ 2 ? 0,55 : 0,40))`, limitado entre 40 e 260. Não escala com o tamanho de fonte do sistema (já é enorme); o resto da UI escala. Sombra de texto `player.color` a 33%, blur 28–44. Animação de rolagem (seção 9).

**DeltaBadge**. "−3" / "+5" em Big Shoulders 800, 30–44 pt. Cor `AppColors.loss`/`gain`. O sinal sempre aparece (não depende de cor). Acumula enquanto houver mudanças em menos de 2 s; some 2 s depois da última.

**CounterChip**. Altura 28 (no painel) ou 40 (fora), raio pill, fundo `elevated`; ícone 14–18 + número Big Shoulders. Alvo de toque mínimo 56 com `MaterialTapTargetSize`/padding invisível. Estados: normal, pressionado (fundo `pressed`, escala 0,96), desabilitado, aviso, letal (fundo `poisonAlertBg`/`cmdAlertBg`, borda 2 px, rótulo "LETAL").

**CounterDrawer** (A-Gaveta). Abre ao tocar no chip do nome ou arrastar a partir da borda do jogador. É uma folha que sobe **a partir do lado do jogador** (respeita o `quarterTurns` dele) e ocupa a metade dele da tela, com a vida compacta (60 pt) e ±1 no topo: a vida nunca fica coberta. Abas: Contadores (linhas com −/valor/+ de 48 pt, marcadores Monarca/Iniciativa/Anel), Comandante (dano recebido de cada comandante oponente, com linha de parceiro, e taxa do próprio comandante: conjurações × 2), Histórico (linha do tempo do jogador com desfazer). Fecha arrastando para baixo, tocando fora ou no hub.

**CenterHub**. Círculo 76 pt (88 no tablet), fundo `bg`, borda 2 px `lineStrong`, anel de 6 px da cor do fundo para "recortar" os painéis, brilho âmbar. Toque: MatchMenu. Toque longo: rola um d20 e mostra o resultado espelhado nos dois sentidos.

**MatchMenu** (A-Menu-Partida). Diálogo central com relógio da partida e rodada, grade 3×2 de atalhos (Dados, Moeda, Sortear, Timer, Passar turno, Ajustes rápidos), "Pausar timer" e as ações destrutivas "Segure: reiniciar" e "Segure: encerrar" (HoldToConfirmButton). Botão "girar" vira o diálogo 180° para o outro lado da mesa.

**HoldToConfirmButton**. Preenchimento da esquerda para a direita durante 800 ms; soltar antes cancela; ao completar, háptico forte. Usado para reiniciar, encerrar e sair da partida.

**TurnTimerBar**. Barra de 4 pt no topo do painel ativo. Nos últimos 10 s fica `AppColors.loss`, pulsa e toca o tique (som opcional).

**DiceSheet / ToolsPanel** (A-Ferramentas). Abas Dados, Moeda, Planar, Sorteio, Timer. Resultado grande ao centro e repetido girado 180° no topo, para os dois lados da mesa. Dados: d4, d6, d8, d10, d12, d20, d100, 1 a 6 dados, soma + valores individuais. Últimos 5 resultados no rodapé. Dentro da partida abre como sheet sem anúncio.

**FormatPresetCard**, **LhStepper** (−/valor/+ em pílula de 56), **LhToggleChip**, **LhSegmented**, **LhSwitch**, **SettingsRow**, **CardTile** (miniatura 44×60, nome, linha de tipo, custo em símbolos de mana), **ManaToken**, **StatTile**, **EmptyState**, **ErrorState**, **SkeletonTile**, **PaywallSheet**, **AdBanner** (placeholder de 50 pt reservado para não "pular" o layout).

## 8. Telas e rotas

```
/onboarding            (só na primeira abertura; "Pular" sempre visível)
/                      Home
/setup                 Configurar partida
/match                 Partida (layout pelo motor da seção 6)
/match/result          Fim de partida
/tools                 Ferramentas
/cards                 Busca de cartas
/cards/:id             Detalhe
/mana                  Base de mana
/history               Histórico e estatísticas
/settings              Ajustes
/settings/about        Sobre
/pro                   Paywall (fullscreenDialog)
```

Fluxo crítico, no máximo 2 toques: ícone → Home → "Nova partida" (com a última configuração) → partida rodando. "Configurar outra partida" fica logo abaixo do botão.

Notas por tela:

- **Home**: botão herói "Nova partida" âmbar, 220 pt, com a última configuração por extenso. "Continuar partida" só aparece se houver partida não terminada. Grade 2×2: Ferramentas, Cartas, Base de mana, Histórico. Banner de 50 pt no rodapé com link "Remover" (abre `/pro`). Sem banner para usuário Pro.
- **Configurar**: número de jogadores (1–4), formato (grade de presets), vida inicial (stepper, toque no número abre teclado numérico), lista de jogadores (cor/glifo, nome, deck opcional, assento, arrastar para reordenar), "Jogar em times", contadores na partida (chips liga/desliga), quem começa (Sortear com animação / Escolher), timer de turno (Sem / 60 / 90 / 120 s; relógio de xadrez por jogador é v2). Botão fixo "Começar · resumo".
- **Partida**: ver seções 6, 7 e 9.
- **Fim de partida**: vencedor com coroa e brilho, duração, rodadas, formato, classificação com motivo da eliminação, "Revanche" (mesma config, mesmos assentos), "Mudar configuração", "Início". O intersticial, quando for a vez, aparece **depois** de tocar em "Início", antes de mostrar a Home.
- **Cartas**: busca com debounce, filtros por cor (tokens de mana), tipo e valor de mana, lista de CardTile, detalhe com imagem sem corte, custo, linha de tipo, texto oracle, legalidade por formato (texto + ícone + cor), link "Ver no Scryfall". Sem preços. Estados vazio, carregando (skeleton + barra de progresso), erro de rede, nenhum resultado com sugestão via autocomplete (A-Estados).
- **Histórico**: 3 StatTiles, barras por formato e por jogador nomeado, lista das últimas partidas.
- **Ajustes**: card do Pro no topo; grupos Partida (tela ligada, vibração, sons, travar orientação, contadores padrão, timer padrão), Aparência (tema, modo daltônico, movimento segue o sistema, tamanho do texto segue o sistema), Idioma, Compras e privacidade (Restaurar compras, anúncios e rastreamento, política), Sobre.
- **Paywall**: fechar sempre visível no canto, lista do que o Pro dá ao lado do limite grátis, preço vindo da loja (`ProductDetails.price`), "Restaurar compras" visível, texto "Compra única. Não é assinatura." Sem contagem regressiva, sem urgência falsa.
- **Sobre**: logo, versão, aviso legal fixo (texto exato na seção 14), Enviar sugestão (mailto com versão e aparelho), Avaliar, Apoiar o projeto (só como gorjeta IAP consumível; ver seção 12), privacidade, termos, licenças (`showLicensePage`), créditos.

## 9. Interação, gestos e movimento

| Gesto no painel | Efeito |
|---|---|
| Toque na metade direita / esquerda (no referencial do jogador) | +1 / −1 |
| Segurar | após 450 ms repete a cada 120 ms; depois de 10 repetições, a cada 60 ms; depois de 2,5 s passa a ±5 por passo |
| Arrastar na vertical (para cima = ganhar) | prévia do valor durante o arraste; ±5 depois de 40 pt, ±10 depois de 100 pt; aplica ao soltar; voltar ao ponto inicial cancela |
| Toque no chip do nome | abre a gaveta |
| Toque no selo TURNO | passa o turno (snackbar "Turno de Bruno · Desfazer" por 3 s) |
| Toque longo no número | campo para digitar valor exato |
| Agitar o aparelho (opcional, desligado por padrão) | desfazer a última ação, com snackbar |

Feedback:

- Háptico em toda mudança de vida: `HapticFeedback.selectionClick()` para ±1, `lightImpact` para ±5/±10, `heavyImpact` para eliminação e para confirmar ações de segurar. Respeitar o ajuste.
- Sons (desligados por padrão), reaproveitando `assets/sounds`: `btn.mp3` toque, `dice_shake.mp3` rolagem, `ticking_countdown.mp3` últimos 10 s do timer, `restart.mp3` reiniciar, `explode.mp3` eliminação.

Movimento (todas as durações em `AppMotion`; com "reduzir movimento" do sistema ou do app, trocar tudo por um crossfade de 100 ms):

- **Número rolando**: o dígito antigo sai para cima (perda: para baixo) e o novo entra, 180 ms, `easeOutCubic`, só nos dígitos que mudaram.
- **Pulso de perda**: o painel encolhe para 0,985 e volta, e a borda acende `AppColors.loss` por 220 ms.
- **Onda de ganho**: círculo na cor do jogador a 20% expande a partir do ponto do toque, 420 ms.
- **DeltaBadge**: entra com fade + subida de 6 pt em 120 ms, sai com fade em 250 ms.
- **Gaveta e sheets**: 280 ms, `AppMotion.emphasized`.
- **Navegação**: transição padrão de cada plataforma (Cupertino no iOS com gesto de voltar, predictive back no Android 14+). Na partida, o gesto de voltar do sistema **não sai**: abre o MatchMenu.
- **Sorteio de quem começa**: destaque passa pelos painéis acelerando e desacelerando (1,6 s), termina com háptico forte.

## 10. Consulta de cartas (Scryfall)

- Base: `https://api.scryfall.com`. Cabeçalhos obrigatórios em toda requisição: `User-Agent: LighthouseLife/<versão> (contato: <e-mail>)` e `Accept: application/json`.
- Respeitar o limite pedido pela Scryfall: no máximo 10 requisições por segundo, com 50–100 ms entre elas. Implementar uma fila no `Dio` (interceptor) com intervalo mínimo de 100 ms. Tratar HTTP 429 com espera e nova tentativa.
- Endpoints: `GET /cards/autocomplete?q=` (sugestões enquanto digita), `GET /cards/search?q=<consulta>&order=name&unique=cards` (lista, paginada por `next_page`), `GET /cards/{id}` (detalhe). Montagem da consulta: nome digitado + `c:` (cores) + `t:` (tipo) + `mv<=` (valor de mana). Debounce de 350 ms, mínimo 2 caracteres.
- Exibir: `name`, `mana_cost` (convertido em ManaTokens), `type_line`, `oracle_text`, `legalities`, `image_uris.normal` (ou `card_faces[i].image_uris` em cartas de duas faces, com botão de virar), `scryfall_uri`. Para pt-BR, quando existir `printed_name`/`printed_text`, oferecer alternância PT/EN.
- **Não ler nem exibir `prices`** nem links de compra (`purchase_uris`).
- Imagens: mostrar inteiras, sem corte, sem filtro, sem sobrepor elementos; cantos arredondados de 4,75% como a carta física é o único tratamento. Crédito "Dados e imagens: Scryfall" visível na busca e no detalhe. Cache com `cached_network_image`.
- Offline: o resto do app funciona; a busca mostra o estado de erro de rede.
- O endpoint `/symbology` pode servir os SVG de mana se a fonte Mana não for usada.

## 11. Calculadora de base de mana

Entrada: total de terrenos (stepper; dicas 24 para 60 cartas, 37 para Commander) e quantidade de símbolos por cor (W, U, B, R, G, C). Saída: terrenos por cor proporcionais aos símbolos, arredondados pelo método do maior resto (a soma fecha exatamente no total), barra empilhada e linhas com percentual. Estado vazio explicativo. "Limpar" zera tudo. Lógica pura e testada (mesma do mockup A-Mana).

## 12. Monetização

**Unity Ads** (`unity_ads_plugin`), inicializado só depois do consentimento.

| Formato | Onde | Regra |
|---|---|---|
| Banner 320×50 | Home; Ferramentas aberta pela Home | espaço reservado mesmo antes de carregar; some para Pro |
| Intersticial | ao tocar em "Início" na tela de fim de partida | no máximo 1 a cada 2 partidas terminadas e com pelo menos 4 min entre exibições; nunca na primeira sessão; nunca se a partida durou menos de 3 min |
| Premiado | não usar na v1 | |

Proibido: anúncio em `/match`, na gaveta, no menu da partida, em diálogos, no paywall e em Sobre.

**IAP** (`in_app_purchase`): produto não consumível `lighthouse_pro`. Ouvir `purchaseStream` desde o início do app, concluir transações pendentes, guardar o direito localmente e revalidar na abertura. "Restaurar compras" em Ajustes e no paywall (exigência da Apple). **Sem gorjetas** (decisão posterior): o `lighthouse_pro` é o único produto.

Pro libera: sem anúncios, temas extras (v1.1), jogadores salvos ilimitados (grátis: 6), histórico ilimitado (grátis: 20), contadores personalizados ilimitados (grátis: 2), pacote de sons.

**Consentimento e privacidade**

- iOS: mostrar o pré-prompt (A-Dialogos, 2º quadro) com um único botão "Continuar" e, em seguida, `AppTrackingTransparency.requestTrackingAuthorization()`. Só na segunda abertura do app ou depois da primeira partida, nunca no primeiro segundo. Se negado, Unity recebe o sinal de não personalizar.
- UE/Reino Unido: pedir consentimento GDPR antes de inicializar anúncios e repassar à Unity (`MetaData` `gdpr.consent`). EUA: opção "Não vender meus dados" (`privacy.consent`). Ajuste "Anúncios e rastreamento" permite mudar depois.
- iOS `PrivacyInfo.xcprivacy` do app: declarar uso de UserDefaults (motivo `CA92.1`) e de horário do sistema se usado; o SDK da Unity traz o próprio manifesto. Rótulos da App Store e "Segurança dos dados" do Google Play: o app não coleta dados próprios; declarar o que o SDK da Unity coleta (identificadores de dispositivo, dados de uso para publicidade).

## 13. Acessibilidade

- Contraste: texto comum ≥ 4,5:1 e números grandes ≥ 3:1 contra o fundo do painel. As cores dos tokens já passam; não escureça `textMuted`/`textFaint` além do definido.
- Não depender de cor: cada jogador tem cor + glifo + nome; delta sempre com sinal; legalidade com ícone e texto; contadores em alerta com rótulo "LETAL".
- Modo daltônico: borda do painel com traço próprio por jogador (`colorBlindDash`).
- Semântica: cada metade do painel é um botão com rótulo ("Ana, ganhar 1 de vida"); o número é um `Semantics(liveRegion: true, label: 'Ana, 31 de vida')`. Ações customizadas do VoiceOver/TalkBack no painel: +1, −1, +5, −5, abrir gaveta. Ordem de foco: por jogador, na ordem dos assentos, depois o hub.
- Tamanho de fonte do sistema: toda a UI escala (teste a 200%); o LifeNumber e o DeltaBadge não, porque já são dimensionados pelo painel.
- Alvos de toque ≥ 56 pt em toda a UI da partida.
- Reduzir movimento: ver seção 9.

## 14. Conformidade com as lojas

- **Aviso fixo em Sobre**, texto exato: "App não oficial, não afiliado nem endossado pela Wizards of the Coast. Magic: The Gathering é marca registrada da Wizards of the Coast LLC." (traduzir nas três línguas).
- Sem logotipo da marca, sem arte de carta como identidade, sem "Magic" no título, subtítulo ou ícone. Símbolos de mana só como elementos funcionais.
- Imagens de cartas só vindas da API, sem alteração.
- 3.1.1: desbloqueios só por IAP; Restaurar compras visível.
- 4.2: o app entrega valor além de um contador (ferramentas, cartas, mana, histórico) e acabamento nativo.
- 5.1.1: sem coleta de dados pessoais; histórico local.
- iPad e tablets Android com layouts próprios (seção 6), não esticados.
- Android: `targetSdk` atual exigido pela Play, predictive back, ícone adaptativo (farol em primeiro plano sobre `#0E1014`), ícone monocromático para Android 13+.
- iOS: ícone 1024 sem transparência; variantes escura e tingida do iOS 18+.

## 15. Plano de implementação por fases

Cada fase termina com `flutter analyze` sem avisos, testes passando e o app rodando em um iPhone e um Android pequenos.

| Fase | Entrega | Critérios de aceite |
|---|---|---|
| F0 Projeto | `flutter create`, pacotes, estrutura de pastas, fontes, tokens, tema, go_router com telas vazias, l10n pt/en/es | App abre em `/`, tema escuro com as fontes certas, troca de idioma funciona |
| F1 Componentes | LhButton, LhStepper, toggles, segmented, CounterChip, DeltaBadge, LifeNumber, PlayerPanel, CenterHub, HoldToConfirmButton | Golden tests por variante batendo com A-Componentes |
| F2 Motor da partida | modelos freezed, reducer, desfazer, eliminação, persistência da partida em andamento | Testes unitários: ±1, segurar, desfazer, veneno 10, comandante 21 com partner, 2HG compartilhado, fim de partida, restauração depois de matar o app |
| F3 Layouts | motor de seats para 1–4 jogadores, retrato/paisagem, celular/tablet, safe areas, wakelock, imersivo | Golden tests das 7 telas de partida; nenhum texto sob notch/home indicator; toques no referencial certo em todos os `quarterTurns` |
| F4 Gaveta e contadores | CounterDrawer com 3 abas, marcadores exclusivos, Dia/Noite global | A vida continua visível com a gaveta aberta; tudo desfazível |
| F5 Turno e ferramentas | passar turno, timer de turno, sorteio de quem começa, ToolsPanel, MatchMenu | Timer pausa com o menu; resultados legíveis dos dois lados |
| F6 Home, Configurar, Fim, Histórico | fluxo completo de 2 toques, presets lembrados, revanche, histórico com limite grátis | Do ícone à partida em 2 toques com a última configuração |
| F7 Cartas | cliente Scryfall com fila e cabeçalhos, busca, filtros, detalhe, estados | Nunca passa de 10 req/s; sem preços; funciona com dupla face |
| F8 Base de mana | tela + lógica | Soma sempre igual ao total; testes do maior resto |
| F9 Ajustes, onboarding, Sobre, acessibilidade | todos os ajustes ligados de verdade; VoiceOver/TalkBack; fonte 200% | Auditoria manual com leitor de tela no 2J e no 4J |
| F10 Monetização | Unity Ads com regras de frequência, IAP Pro, restaurar, consentimento, ATT | Nenhum anúncio na partida (teste automatizado de rota); compra e restauração em sandbox |
| F11 Loja | ícones, splash nativo (`flutter_native_splash`, fundo `#050608` + farol), manifesto de privacidade, capturas, textos da loja | Checklist da seção 14 completo |

## 16. Cortes para a versão 2

Tema claro e temas extras do Pro, relógio de xadrez por jogador, modo "mesa redonda" no tablet, layout "três faixas" para 3J, agitar para desfazer (deixar atrás de ajuste já na v1 só se sobrar tempo), contadores personalizados com ícone escolhido, estatísticas além das básicas, alternância PT/EN de texto de carta, widgets de tela inicial.

O dado planar entrou na v1 porque custa uma aba e é pedido do público de Commander casual; se apertar o prazo, ele é o primeiro a sair.

## 17. Capturas de tela da loja

1. Partida 4 jogadores (Commander, com um painel ativo e um chip de comandante em alerta).
2. Partida 2 jogadores com delta "−3" visível e timer correndo.
3. Ferramentas (d20 em destaque).
4. Cartas: detalhe com legalidade (usar carta cuja imagem a Scryfall libera; nunca recortar).
5. Gaveta de contadores aberta.

Formatos: iPhone 6,9" e 6,5", iPad 13", Android celular e tablet 10".
