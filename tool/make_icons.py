#!/usr/bin/env python3
"""Desenha o farol (mesma geometria do LighthouseIcon, viewBox 24) em PNGs para o ícone do app e o splash.

Saída em assets/icon/: icon.png (iOS/legado, fundo sólido), foreground.png (adaptativo Android),
monochrome.png (Android 13+) e splash.png. Uso: python tool/make_icons.py
"""
import pathlib

from PIL import Image, ImageDraw

OUT = pathlib.Path(__file__).resolve().parent.parent / 'assets' / 'icon'
OUT.mkdir(parents=True, exist_ok=True)
AMBER = (255, 176, 32, 255)
BG = (14, 16, 20, 255)  # #0E1014
SS = 4  # supersampling para bordas lisas


def lighthouse(size, scale, color, bg=None):
    """Farol centralizado ocupando `scale` da tela. Traço 2/24, pontas arredondadas."""
    s = size * SS
    img = Image.new('RGBA', (s, s), bg or (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    k = s * scale / 24  # px por unidade do viewBox
    ox = oy = s * (1 - scale) / 2
    # o desenho ocupa x 4..20, y 6..21 no viewBox: centra pelo meio (12, 13.5)
    ox += (12 - 12) * k
    oy += (12 - 13.5) * k

    def p(x, y):
        return (ox + x * k, oy + y * k)

    w = 2 * k

    def line(pts):
        d.line([p(*a) for a in pts], fill=color, width=int(w), joint='curve')
        for a in (pts[0], pts[-1]):  # pontas arredondadas
            x, y = p(*a)
            d.ellipse([x - w / 2, y - w / 2, x + w / 2, y + w / 2], fill=color)

    line([(9.5, 21), (10.5, 10), (13.5, 10), (14.5, 21)])  # torre
    line([(8, 21), (16, 21)])  # base
    line([(10.5, 10), (10.5, 7.5), (12, 6), (13.5, 7.5), (13.5, 10)])  # lanterna
    line([(16, 7.5), (20, 6)])  # feixes
    line([(16, 9.5), (20, 11)])
    line([(8, 7.5), (4, 6)])
    line([(8, 9.5), (4, 11)])
    return img.resize((size, size), Image.LANCZOS)


lighthouse(1024, 0.62, AMBER, BG).convert('RGB').save(OUT / 'icon.png')  # sem transparência (iOS)
lighthouse(1024, 0.46, AMBER).save(OUT / 'foreground.png')  # zona segura do ícone adaptativo
lighthouse(1024, 0.46, (255, 255, 255, 255)).save(OUT / 'monochrome.png')
lighthouse(512, 0.7, AMBER).save(OUT / 'splash.png')
print('ok', sorted(p.name for p in OUT.iterdir()))
