# design/

- `HANDOFF.md`: especificação para implementação (comece por aqui).
- `flutter/app_tokens.dart`: tokens de design em Dart (cores, tipografia, espaços, raios, sombras, movimento, tema).
- `tokens.json`: os mesmos tokens em JSON.
- `mockups/png/`: cada tela renderizada em 2x. Fontes substitutas no render: confie nas cores, medidas e layout, não no desenho das letras.
- `mockups/html/`: fonte de cada mockup (`.dc.html`). Estilos inline com valores exatos; `{{x}}` são variáveis calculadas na classe JS no fim do arquivo; `<sc-for>` repete, `<sc-if>` condiciona. Não rodam sozinhos no navegador (dependem do runtime do canvas), são para leitura.

Direção de arte: **Sinal**. A direção alternativa (Maré) foi descartada e não está aqui.
