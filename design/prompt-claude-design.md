# Prompt para o Claude Design — Contador de vida para Magic (iOS + Android, Flutter)

> Cole tudo abaixo da linha no Claude Design. O texto está em português; peça a interface final em pt-BR, com en e es previstos.

---

## 1. Objetivo

Redesenhar do zero todas as telas de um app mobile de **contador de vida e ferramentas para jogos de Magic: The Gathering**, em Flutter, para **iPhone, iPad, Android e tablets Android**. O app atual (Android nativo, Java, 2022) tem contador para 2 e 3 jogadores, veneno, energia, dado, timer de turno, consulta de cartas e calculadora de base de mana, com visual datado. Quero um app **novo, arrojado, rápido de usar numa mesa de jogo e aprovado na App Store e na Google Play**.

Nome: **Lighthouse Life** (definido; a loja física Lighthouse não existe mais, o nome fica só como marca do app, sem nenhuma referência a preços ou à loja). Não usar "Magic" nem "Magic: The Gathering" no nome nem no ícone. A identidade é original; o app é **não oficial** e deve ter um aviso na tela Sobre (ver seção 8).

## 2. Princípios de design

1. **Mesa primeiro.** O app é usado em pé, ao redor de uma mesa, com a mão suja de carta, o celular deitado no meio e gente lendo de ângulos diferentes. Números **enormes**, alvos de toque **grandes** (mínimo 56 pt, ideal 72+), nada de menus escondidos durante a partida.
2. **Zero atrito para começar.** Do ícone ao jogo rodando em **no máximo 2 toques**, com a última configuração lembrada.
3. **Arrojado, não poluído.** Tema escuro por padrão (OLED, bom em ambiente de jogo), cores vivas por jogador, gradientes sutis, tipografia numérica gigante, movimento com propósito (o número "rola" ao mudar, pulso ao perder vida, brilho ao ganhar).
4. **Um app só para todos os formatos.** Mesmo layout base serve Standard, Commander, Brawl, Two-Headed Giant, Pauper etc. O que muda é o preset de vida e quais contadores aparecem.
5. **Acessível.** Contraste AA ou melhor, não depender só de cor (cada jogador tem cor **e** ícone **e** nome), suporte a tamanho de fonte do sistema, semântica para VoiceOver/TalkBack, modo daltônico.
6. **Pronto para loja.** Seguir Human Interface Guidelines (iOS) e Material 3 (Android), sem parecer "porte": mesma identidade, mas respeitar gestos de voltar, safe areas, Dynamic Island e home indicator.

## 3. Jogadores e layouts (1 a 4)

Telas de partida para **1, 2, 3 e 4 jogadores**, em retrato e paisagem, celular e tablet. Cada painel de jogador pode ser **rotacionado** (0°, 90°, 180°, 270°) para ficar legível por quem está sentado naquele lado.

| Jogadores | Layout sugerido (celular deitado na mesa) |
|---|---|
| 1 | Painel único: modo solo / goldfish / rastreador de vida, com histórico de turnos e contadores. |
| 2 | Dois painéis frente a frente (um de cabeça para baixo), centro com ferramentas. |
| 3 | Dois painéis em cima (lado a lado, rotacionados) e um embaixo; ou três faixas. Mostrar as duas opções e recomendar uma. |
| 4 | Grade 2×2, os dois de cima rotacionados 180° (ou laterais 90° em tablet). Modo alternativo "mesa redonda" para tablet no meio da mesa. |

Ponto de atenção: **nada pode ficar ilegível de cabeça para baixo** nem ser coberto por dedos; os controles de cada jogador ficam na própria metade.

## 4. Mecânica do contador (a melhor jogabilidade possível)

**Vida**
- Toque na metade direita do painel = +1, esquerda = −1. **Segurar** = repetição acelerada. **Arrastar vertical** = ajuste rápido ±5/±10 com feedback visual. Botões ±1, ±5 e campo para digitar um valor exato.
- Indicador temporário do **delta** da jogada (ex.: "−3") que se acumula durante 2 s e some, para o grupo ver o dano.
- **Histórico e desfazer**: linha do tempo de mudanças por jogador, com botão Desfazer (e agitar o aparelho = desfazer, opcional).
- Vida abaixo de 0 não bloqueia nada; o painel mostra estado "eliminado" claro, com opção de reviver.
- Cada jogador tem: nome editável, cor, ícone e, opcionalmente, o comandante/deck (texto livre).

**Presets de formato** (editáveis, lembrados):
Standard/Modern/Pioneer/Legacy/Vintage (20), Pauper (20), Commander/EDH (40), Brawl (25 para 2 jogadores, 30 para multiplayer), Two-Headed Giant (30 **compartilhados** por time, 2 vs 2), Oathbreaker (20), Free-for-all personalizado e **Vida inicial livre**. Times: possibilidade de agrupar jogadores (2v2, 2v1 etc.).

**Contadores por jogador** (ligáveis/desligáveis, tela de contador deve ser uma gaveta que não cobre o número da vida):
- Veneno (alerta visual em 10)
- Energia
- Experiência
- Radiação
- **Dano de comandante**: por oponente, com alerta em 21, e **taxa de comandante** (+2 por conjuração) e suporte a **dois comandantes/partner**.
- Marcadores de status: **Monarca**, **Iniciativa**, **Dia/Noite** (global), Tentação do Anel (0–4).
- Contadores **personalizados**: nome, ícone, valor inicial, mínimo/máximo.
- **Contador de tempestade (storm)** e mana flutuante como ferramenta rápida opcional.

**Turno e tempo**
- Indicador claro de **quem é o jogador ativo** e botão "passar o turno" (toque duplo no painel ou botão central).
- **Timer de turno** configurável (ex.: 60/90/120 s) e **relógio de xadrez** por jogador para torneio, com alerta visual e sonoro; pausa fácil.
- **Escolher quem começa** (aleatório com animação) e contador de rodada.

**Ferramentas rápidas** (botão central, abre sobre a partida sem esconder a vida):
- **Dados**: d4, d6, d8, d10, d12, d20, d100, vários dados de uma vez, resultado grande e legível dos dois lados da mesa.
- **Moeda** (cara/coroa).
- **Dado planar** do Planechase.
- **Sorteio** de jogador.

**Feedback**: háptico (iOS Taptic / Android vibração) em cada mudança, som opcional, **tela sempre ligada** durante a partida, bloqueio de orientação opcional, **trava anti-toque acidental** (segurar para sair/reiniciar, confirmação antes de zerar a partida).

**Fim de partida**: detectar o último jogador vivo, tela de vencedor com resumo (duração, rodadas, vida final) e botão Revanche com mesmas configurações. Histórico das últimas partidas salvo **localmente**.

## 5. Telas a desenhar (todas, com estados vazio, carregando, erro e sucesso)

1. **Splash** curto + onboarding de 3 passos opcional (jogadores, formatos, ferramentas), pulável.
2. **Home**: botão grande **Nova partida** (com a última config), **Continuar partida** (se houver), atalhos para Ferramentas, Cartas e Ajustes. Banner de anúncio **somente aqui**, se o usuário não tiver comprado remoção de anúncios.
3. **Configurar partida**: número de jogadores (1–4), formato/preset, vida inicial, contadores ativos, nomes, cores, ícones, times, quem começa.
4. **Tela de partida** para 1, 2, 3 e 4 jogadores, retrato e paisagem, celular e tablet.
5. **Gaveta do jogador** (contadores, dano de comandante, marcadores, histórico).
6. **Menu da partida** (pausa, reiniciar com confirmação, configurações rápidas, sair).
7. **Ferramentas**: dados, moeda, dado planar, sorteio, timer/relógio.
8. **Calculadora de base de mana** (substitui a atual): símbolos por cor do deck, total de terrenos, resultado claro com barras por cor. Usar os símbolos de mana (ver seção 7).
9. **Consulta de cartas**: busca, lista, filtros (nome, cor, tipo, custo), **detalhe da carta** com imagem, texto, e legalidades. **Sem preços** (o preço da loja Lighthouse foi removido; não exibir preço de nenhuma fonte). Fonte de dados: **Scryfall API** (gratuita, exige cabeçalhos `User-Agent` e `Accept` e respeito ao rate limit; imagens exibidas sem corte ou alteração).
10. **Histórico de partidas** e estatísticas simples (partidas jogadas, formatos mais usados, vitórias por jogador nomeado).
11. **Ajustes**: idioma (pt-BR/en/es), tema (escuro/claro/sistema), tamanho do texto, som, háptico, tela ligada, modo daltônico, orientação, contadores padrão, restaurar compras, privacidade e consentimento de anúncios.
12. **Loja / Remover anúncios (paywall)**.
13. **Sobre, créditos, contato, privacidade e termos**, com o aviso de conteúdo não oficial.
14. **Diálogos e bottom sheets**: reiniciar, fim de partida, erro de rede, consentimento de rastreamento (pré-prompt antes do sistema).

## 6. Monetização (planejar o design já com ela)

Regras: **nunca interromper a partida em andamento.** Anúncio só em momentos naturais.

- **IAP "Remover anúncios"** (não consumível, 1 compra, com **Restaurar compras** visível, exigência da Apple).
- **IAP "Pro" opcional** (decidir no design se vale separar): temas extras, mais jogadores nomeados salvos, histórico ilimitado, contadores personalizados ilimitados, sons extras. Mostrar a versão com e sem Pro.
- **Unity Ads é a única rede de anúncios** (o AdMob do app antigo sai): banner na Home e Ferramentas; **intersticial** só entre partidas (ao voltar para Home depois de fim de jogo), com limite de frequência; **anúncio premiado** opcional para desbloquear um tema por um tempo.
- Nenhum anúncio na tela de partida, na gaveta, nem nos diálogos.
- Paywall honesto: preço claro, sem urgência falsa, botão fechar sempre visível.
- **iOS**: pré-prompt explicando o ATT antes do pedido do sistema, rótulos de privacidade corretos e manifesto de privacidade.

## 7. Identidade visual e ícones

- **Sem assets pesados no início.** Ícones gerais com **Font Awesome** (vetorial) e formas geradas por código.
- **Símbolos de mana oficiais podem ser usados** (W, U, B, R, G, incolor, X, números, híbridos), em formato vetorial: a fonte open source **Mana** (Andrew Gioia, licença SIL OFL) ou os SVGs do endpoint de simbologia do Scryfall. Cada cor tem um token (cor + símbolo + nome) e deve funcionar também em tamanho pequeno e para daltônicos. Como reserva, ícones Font Awesome equivalentes (`sun`, `droplet`, `skull`, `fire`, `tree`).
- Paleta por jogador (até 4 + extras), com versão para daltônicos (padrões ou formas além da cor).
- Tipografia: uma família display **muito legível em números grandes** (peso alto, algarismos tabulares) para a vida, e uma família sem serifa limpa para o resto. Sugerir 2 combinações.
- Raio de borda, sombras e blur coerentes. Superfícies em camadas, bordas luminosas por cor do jogador.
- Animações: número rolando, pulso ao perder vida, onda ao ganhar, transição suave entre telas. Respeitar "reduzir movimento" do sistema.
- Ícone do app: conceito de **farol** (Lighthouse) estilizado, forte em 1024 px e em tamanhos pequenos, sem usar símbolos de Magic nem arte de carta.

## 8. Requisitos de loja a refletir no design

- **Apple 4.2 (funcionalidade mínima)**: app com valor real, ferramentas variadas e boa qualidade de acabamento.
- **Apple 5.2 / política de conteúdo de fãs da Wizards**: nada de logotipo da marca, arte de carta como identidade do app, nem o nome da marca no título ou no ícone. Os símbolos de mana são permitidos só como elementos funcionais da interface. Aviso fixo em Sobre: *"App não oficial, não afiliado nem endossado pela Wizards of the Coast. Magic: The Gathering é marca registrada da Wizards of the Coast LLC."* Imagens de cartas só vêm da API e são exibidas inalteradas.
- **Apple 3.1.1**: IAP para desbloqueios, restaurar compras.
- **Privacidade**: tela de consentimento clara, sem coletar dados de pagamento ou pessoais no app. O histórico fica no aparelho.
- **Acessibilidade**: rótulos, ordem de foco, contraste, Dynamic Type.
- Telas de **iPad** e tablet Android pensadas, não esticadas.
- Capturas de tela da loja: prever as 5 telas mais fortes (partida 4 jogadores, 2 jogadores, ferramentas, cartas, gaveta de contadores).

## 9. Arquitetura que o design deve facilitar (Flutter)

Entregar o design de forma que mapeie direto para código:
- **Tokens de design** (cores, tipografia, espaçamento, raios, sombras, durações de animação) nomeados de forma que virem `ThemeData` + `ThemeExtension` do Flutter sem tradução.
- **Biblioteca de componentes** reutilizáveis: `PlayerPanel`, `LifeNumber`, `CounterChip`, `CounterDrawer`, `DiceSheet`, `TurnTimerBar`, `FormatPresetCard`, `CardTile`, `PaywallSheet`, botões, campos, diálogos.
- Todo componente com variantes: **tamanho**, **rotação**, **estado** (normal, pressionado, desabilitado, alerta, eliminado) e **cor do jogador**.
- Layouts **adaptativos** por largura (compacto, médio, expandido) e orientação, em vez de telas separadas por aparelho.
- Pacotes previstos: `flutter_riverpod`, `go_router`, `freezed`, `shared_preferences` ou `isar`, `dio` (Scryfall), `font_awesome_flutter`, `wakelock_plus`, `in_app_purchase`, `unity_ads_plugin`, `app_tracking_transparency`, `flutter_localizations` + `intl`.

## 10. O que entregar

1. **Direção de arte**: 2 propostas visuais curtas (moodboard + paleta + tipografia) para eu escolher; depois detalhar a escolhida.
2. **Design system**: tokens e componentes.
3. **Todas as telas da seção 5**, em celular (retrato e paisagem) e tablet, com os estados.
4. **Protótipo navegável** do fluxo principal: Home → Configurar → Partida (1, 2, 3 e 4 jogadores) → Gaveta → Ferramentas → Fim de partida.
5. **Especificação de interação e movimento**: gestos, tempos, easings, estados de erro.
6. **Notas de acessibilidade** e de conformidade com as lojas.
7. **Lista de cortes**: o que sugere deixar para uma segunda versão para a primeira entrega ser enxuta e sólida.

## 11. Contexto do app atual (para não perder funções)

Funções existentes que devem continuar: contador de 2 e 3 jogadores com vida inicial configurável, veneno, energia, rolagem de dado (d20 e outros), timer de turno com som, reiniciar HP com confirmação, consulta de cartas com imagem (sem preço), calculadora de base de mana, idioma e tamanho de texto, tela de sugestões e doações, banner de anúncio (agora Unity Ads). A **aba Sugestões/Doações** pode virar um item discreto em Sobre. Idioma principal: **português do Brasil**.

Se faltar informação para decidir algo importante (por exemplo, o nome final, se o app terá contas ou sincronização, ou se a versão Pro vale a pena), **liste as perguntas no começo e proponha um padrão sensato** em vez de parar.
