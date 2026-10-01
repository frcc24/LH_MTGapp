# Decisões e divergências do HANDOFF

Registro de onde a implementação saiu do `HANDOFF.md` e por quê.

## Código
- **Sem `freezed`, `json_serializable`, `build_runner` nem `riverpod_generator`.** Os pacotes não resolviam juntos com o Dart 3.12 / Flutter 3.44
  (`freezed` estável pede `source_gen` 3, `json_serializable` pede 4). Os modelos são classes imutáveis escritas à mão, com `copyWith`
  e `toJson/fromJson` (`features/match/domain/models.dart`). O reducer continua puro e testado. Riverpod usa a API `Notifier` sem gerador.
- **Sem `sensors_plus`.** "Agitar para desfazer" é opcional/v2; o desfazer fica no botão da faixa/hub e na gaveta.
- **Persistência:** `shared_preferences` para ajustes e última configuração; JSON em arquivo para a partida em andamento e o histórico (como o handoff).
- **Desfazer agrupado:** ações com a mesma `undoTag` em até 2 s viram uma só entrada (segurar o botão, arrastar, vários toques). Limite de 200 entradas.
  O log de vida também junta eventos do mesmo fluxo na mesma janela de 2 s.
- **Times (Two-Headed Giant):** vida e veneno são guardados em cada membro e mantidos iguais pelo reducer; colegas de time sentam do mesmo lado
  (colunas no 4J de celular, linhas quando a fileira de cima é girada).
- **Tema claro** não existe na v1 (como nos cortes do handoff); "seguir o sistema" resulta no escuro.
- **Fonte Mana:** não foi adicionada. `ManaToken` usa o círculo com a letra (fallback do handoff). Instrument Sans: só 400, 600 e 700
  (o 500 cai no mais próximo).

## Produto
- **Pro lista só o que existe:** sem anúncios e histórico ilimitado. Jogadores salvos, contadores personalizados, temas extras e pacote de sons
  **não** foram implementados e por isso não são prometidos no paywall.
- **Jogadores salvos / contadores personalizados / agitar para desfazer / relógio de xadrez / alternância PT-EN de texto de carta:** fora da v1.
- **Passar o turno:** botão "Passar" na faixa (1–2J), toque no selo TURNO (3–4J) ou item do menu. Toque duplo no painel não é usado.
- **Gorjeta:** produtos consumíveis `tip_small` e `tip_medium` aparecem em Sobre só se a loja os devolver. Nada de PIX/PayPal no iOS.
- **Segurar para sair da partida** foi acrescentado ao menu (além de reiniciar e encerrar), porque não havia outro jeito de descartar a partida sem registrar.
- **Preços de cartas:** o modelo `ScryCard` não lê `prices` nem `purchase_uris`; há teste cobrindo.

## Safe area
O `RotatedBox` não gira o `MediaQuery`. Por isso `rotateInsets` (match_layout.dart) rotaciona os insets da tela para cada painel e para a gaveta,
e `screenInsetsFor` só aplica nas bordas que realmente encostam na tela. Testado em `test/layout/match_layout_test.dart`.

## Anúncios e privacidade
- **Unity Ads:** `AdsConfig` tem Game IDs de exemplo (`0000000`) e `testMode = true`. Troque pelos IDs do painel da Unity antes de publicar.
- **Consentimento:** Android mostra um diálogo simples (personalizados / não personalizados); iOS mostra o pré-prompt e então o ATT.
  **Não há** plataforma de consentimento (UMP/CMP) para GDPR na UE: para publicar na Europa vale integrar uma antes.
- **iOS:** `PrivacyInfo.xcprivacy` está em `ios/Runner/`, mas **precisa ser adicionado ao target Runner no Xcode** (não dá para fazer no Windows).
  `SKAdNetworkItems` tem só o ID da Unity: copie a lista completa do painel da Unity.
- **Links:** `lib/core/links.dart` aponta para páginas de privacidade e termos que ainda não existem. Publique e troque.

## Android
- `targetSdk`/`compileSdk` vêm dos padrões do Flutter (36), que já atendem à exigência da Play que bloqueava o app antigo.
- Assinatura: `android/key.properties` + `android/app/ks_lh.jks` (fora do git), mesmo padrão dos outros apps. Sem o arquivo o release **falha**.
  O certificado público desta chave precisa ser aprovado como chave de upload no Play Console (redefinição de chave de upload) antes do primeiro envio.
- `versionCode` vem do `pubspec.yaml` (`3.0.0+100`); o último na Play era 22.
