# Lighthouse Life

Contador de vida e ferramentas para jogos de cartas colecionáveis (1 a 4 jogadores), em Flutter para iOS, iPadOS, Android e tablets.
App não oficial. Substitui o app Android antigo (Java, 2022) do mesmo pacote `com.francocorrea.magiccounter`.

- Especificação e design: [`design/HANDOFF.md`](design/HANDOFF.md) · divergências: [`design/DECISOES.md`](design/DECISOES.md)
- Regras do projeto: [`CLAUDE.md`](CLAUDE.md)

## Rodar

```bash
flutter pub get
flutter run
flutter test
```

## Textos (pt-BR, en, es)

Edite `tool/l10n_strings*.py` e rode:

```bash
python tool/gen_l10n.py && flutter gen-l10n
```

## Release Android

Precisa de `android/key.properties` e do keystore (fora do git, veja `design/DECISOES.md`):

```bash
flutter build appbundle --release
```

Antes de publicar: Game IDs da Unity em `lib/features/monetization/ads_config.dart`, URLs reais em `lib/core/links.dart`,
produto `lighthouse_pro` (não consumível) criado nas lojas, e os itens de "iOS" e "Anúncios e privacidade" em `design/DECISOES.md`.
