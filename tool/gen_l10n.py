#!/usr/bin/env python3
"""Gera lib/l10n/app_{pt,en,es}.arb a partir de tool/l10n_strings.py.

Uso: python tool/gen_l10n.py && flutter gen-l10n
Cada entrada: chave: (pt, en, es) ou (pt, en, es, {placeholder: tipo}).
Placeholders aparecem como {nome} no texto.
"""
import importlib.util
import json
import pathlib

root = pathlib.Path(__file__).resolve().parent.parent
STRINGS = {}
for f in sorted((root / 'tool').glob('l10n_strings*.py')):
    spec = importlib.util.spec_from_file_location(f.stem, f)
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    dup = STRINGS.keys() & m.STRINGS.keys()
    assert not dup, f'chaves repetidas: {dup}'
    STRINGS.update(m.STRINGS)

out = {'pt': {'@@locale': 'pt'}, 'en': {'@@locale': 'en'}, 'es': {'@@locale': 'es'}}
for key, entry in STRINGS.items():
    pt, en, es = entry[0], entry[1], entry[2]
    ph = entry[3] if len(entry) > 3 else None
    for lang, text in (('pt', pt), ('en', en), ('es', es)):
        out[lang][key] = text
    if ph:
        out['pt']['@' + key] = {'placeholders': {name: {'type': typ} for name, typ in ph.items()}}

for lang, data in out.items():
    (root / 'lib' / 'l10n' / f'app_{lang}.arb').write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + '\n', encoding='utf-8'
    )
print(f'{len(STRINGS)} chaves em 3 idiomas')
