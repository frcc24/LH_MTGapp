# Roadmap · o que falta para publicar o Lighthouse Life

Estado em 01/10/2026. App Flutter pronto e testado no emulador Android (87 testes passando). Legenda: **[você]** só você consegue
fazer (contas, consoles, lojas); **[eu]** dá para fazer no código; **[ambos]** precisa dos dois.

## 0. Bloqueadores do envio ao Google Play (fazer primeiro)

- [ ] **[você]** Redefinição da chave de upload: no formulário do Play Console, enviar `upload_certificate_ks_lh.pem` (já gerado em
      `Documents\magiccounter-upload-key\`). O Play avisou que a nova chave só vale a partir de **02/10/2026 23:57 UTC**; até lá nenhum AAB novo é aceito.
      O SHA-1 da notificação (`E1:99:05:A5...:FC:1D`) é o do `ks_lh.jks`, já conferido.
- [ ] **[você]** Renomear o app na Play: o título atual é "Lighthouse Magic the Gathering". A regra do projeto (e a política da Wizards)
      proíbe "Magic" no nome. Novo título: **Lighthouse Life**.
- [ ] **[você]** Declarações pendentes em Conteúdo do app: **recursos financeiros** (não tem) e **apps de saúde** (não tem).
- [ ] **[você]** Declarar anúncios ("contém anúncios"), **ID de publicidade** (a permissão `AD_ID` já está no manifesto) e atualizar a
      **Segurança dos dados** com o que a Unity Ads coleta (identificadores de dispositivo, dados de uso para publicidade).
- [ ] **[você]** Classificação etária e público-alvo (não infantil) refeitos para a versão nova.
- [ ] **[você]** Perfil de pagamentos ativo e produtos de compra criados: `lighthouse_pro` (única, não consumível). É o único produto.
- [ ] **[você]** Textos da loja (pt-BR, en, es), ícone 512, gráfico de recursos 1024×500 e 5 capturas (ver `design/HANDOFF.md`, seção 17).
- [ ] **[ambos]** Primeiro envio na faixa de **teste interno** com um AAB novo (o que está em `build/app/outputs/bundle/release/` é anterior à remoção das gorjetas e aos símbolos de mana: rebuildar antes); conferir o
      relatório de pré-lançamento; só então produção.

## 1. Anúncios e privacidade

- [x] Projeto criado na Unity (Android 6198412, iOS 6198413) e IDs em `lib/features/monetization/ads_config.dart`; banner e intersticial
      testados no emulador. `testMode` segue o build (debug = teste, release = real).
- [ ] **[você]** Em Unity > Monetization > Ad Units, conferir que existem `Banner_Android`, `Interstitial_Android`, `Banner_iOS` e
      `Interstitial_iOS` (são os nomes que o app usa) e que o app aparece como publicado na Play/Apple, senão o preenchimento real demora.
- [x] Intersticial no fim da partida (tela de resultado).
- [ ] **[você]** Publicar a **política de privacidade** e os **termos** (a Play e a Apple exigem a URL). **[eu]** troco as URLs em
      `lib/core/links.dart`.
- [ ] **[você]** Consentimento na **Europa/Reino Unido**: decidido publicar **fora da UE e do Reino Unido por enquanto** (tirar esses países da
      distribuição na Play e na App Store). Para entrar na UE depois: integrar o Google UMP (precisa de conta AdMob e mensagem de consentimento).
- [ ] **[ambos]** Testar anúncio de teste e a regra de frequência do intersticial em aparelho real.

## 2. iOS (precisa de um Mac)

- [ ] **[você]** Conta Apple Developer, App ID `com.francocorrea.magiccounter`, registro do app no App Store Connect.
- [ ] **[ambos]** Abrir `ios/` no Xcode: adicionar `Runner/PrivacyInfo.xcprivacy` ao target, configurar assinatura, rodar em iPhone e iPad.
- [ ] **[ambos]** Conferir a lista de `SKAdNetworkItems` do `Info.plist` (76 IDs copiados do cardkingdoms) com a lista atual da Unity.
- [ ] **[você]** Produto `lighthouse_pro` no App Store Connect; rótulos de privacidade; classificação etária; capturas iPhone 6,9" e iPad 13".
- [ ] **[você]** Notas para a revisão: app não oficial (aviso em Sobre), sem preços de cartas, imagens só da Scryfall.
- [ ] **[ambos]** TestFlight antes de enviar. Risco conhecido: guideline 5.2 (propriedade intelectual) por causa dos símbolos de mana
      e do uso comercial; o plano B (ícones Font Awesome no lugar) já está previsto.

## 3. Qualidade do app (código)

- [x] Layout de 1 jogador (cabeçalho com turno, ±5 e Digitar, contadores, vida por turno e Próximo turno), retrato e paisagem.
- [x] Diálogo "Continuar de onde parou?" na abertura.
- [x] Golden tests dispensados por decisão (os testes de gesto, layout e regras já existem).
- [ ] **[ambos]** Auditoria de acessibilidade com TalkBack/VoiceOver e fonte do sistema a 200%.
- [ ] **[ambos]** Testar em **celular de verdade** (o Galaxy S24 aparece pelo adb sem fio) e tablet em retrato; medir desempenho.
- [x] Ícone conferido no emulador (ícone adaptativo aparece no menu de apps). Falta só ver a tela de abertura em aparelho real.
- [ ] **[ambos]** Compra e restauração em sandbox (testadores de licença na Play, conta sandbox na Apple).
- [ ] **[você]** Revisar os textos em en e es com falante nativo (hoje são traduções minhas).

## 4. Contadores (melhorias já identificadas)

- [x] Ligar e desligar contadores durante a partida (gaveta, aba Contadores).
- [x] Interruptor "dano de comandante também tira vida" na tela Configurar.
- [ ] **[ambos]** Conferir no aparelho os estados de alerta do veneno (8 e 10) e do comandante (15 e 21) e a aba Comandante.
- [ ] **[eu]** Contadores personalizados (nome, valor, limites) — v1.1.

## 5. Depois da v1 (v1.1 e v2)

Tema claro e temas extras do Pro; jogadores salvos; relógio de xadrez por jogador; modo "mesa redonda" no tablet; agitar para desfazer;
alternância PT/EN no texto de cartas; widgets de tela inicial; abrir a gaveta arrastando da borda.

## 6. Higiene

- [ ] **[você]** Guardar o `ks_lh.jks` e as senhas em pelo menos dois lugares (gerenciador de senhas e nuvem).
- [ ] **[você]** Apagar `Documents\magiccounter-upload-key\` (chave aleatória que não será usada), mantendo só o `.pem` certo.
- [x] Removidas de `assets/` as imagens do app antigo que nada usava (continuam no histórico do git); os símbolos novos estão em `assets/mana/`.
- [ ] **[você]** Decidir se o repositório continua público (contém o handoff de design completo).

## Ordem sugerida

1. Chave de upload + renomear o app + declarações (seção 0) — em paralelo com criar a conta e os IDs da Unity (seção 1).
2. Eu faço o código das seções 1, 3 e 4 enquanto o Google aprova a chave.
3. Teste interno na Play, depois produção.
4. iOS (seção 2) em seguida, quando houver um Mac.
