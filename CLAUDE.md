# Lighthouse Life

App Flutter (iOS, iPadOS, Android, tablets Android) de contador de vida e ferramentas para partidas de Magic: The Gathering. Não oficial. Substitui o app Android antigo (Java, 2022). Idioma principal: pt-BR; também en e es.

## Leia antes de escrever código

1. `design/HANDOFF.md`: especificação completa (decisões, tokens, arquitetura, regras do jogo, layouts, componentes, telas, gestos, Scryfall, monetização, acessibilidade, lojas e plano por fases com critérios de aceite).
2. `design/flutter/app_tokens.dart`: tokens prontos. Copie para `lib/core/theme/app_tokens.dart` e use só esses nomes.
3. `design/mockups/png/`: referência visual de cada tela (fontes substitutas no render; os números ficarão mais estreitos com Big Shoulders Display).
4. `design/mockups/html/`: código-fonte dos mockups com os valores exatos (1 px = 1 pt lógico).
5. `assets/ASSETS.md`: sons e imagens do app antigo que podem ser reaproveitados.

## Regras que não podem ser quebradas

- Nunca exibir preços de cartas, de nenhuma fonte. Não ler `prices` nem `purchase_uris` da Scryfall.
- Nunca mostrar anúncio na tela de partida, na gaveta, no menu da partida, em diálogos, no paywall ou em Sobre.
- Nunca usar "Magic" no nome do app, no ícone ou no subtítulo. Nada de logotipo da Wizards nem arte de carta como identidade. Símbolos de mana só como elementos funcionais.
- Imagens de carta só da API da Scryfall, exibidas inteiras e sem alteração.
- Toda requisição à Scryfall leva `User-Agent` e `Accept` e passa pela fila de no mínimo 100 ms entre chamadas.
- O estado da partida muda só pelo reducer puro em `features/match/domain`; toda ação é desfazível.
- Nenhuma cor, tamanho ou duração solta em widget: sempre pelos tokens.
- Alvos de toque na partida ≥ 56 pt. Respeitar safe areas, "reduzir movimento" e tamanho de fonte do sistema.
- Ações destrutivas (reiniciar, encerrar, sair) só com HoldToConfirmButton (800 ms).

## Como trabalhar

- Siga as fases F0 → F11 do HANDOFF (seção 15). Não comece uma fase sem os critérios de aceite da anterior.
- Depois de cada fase: `dart run build_runner build --delete-conflicting-outputs`, `flutter analyze`, `flutter test`.
- Golden tests para PlayerPanel, CounterChip e para as telas de partida de 1 a 4 jogadores.
- Commits pequenos por fase, mensagem em português.
- Se algo do design não couber na plataforma (gesto do sistema, safe area, política de loja), siga a plataforma e registre a divergência em `design/DECISOES.md`.
