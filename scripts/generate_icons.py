#!/usr/bin/env python3
"""
Génère les icônes Mental E.T. (logo statique) pour web et iOS.

Logo : tête silhouette + 3 orbites elliptiques + 6 points aux extrémités
Fond : crème #FAF9F6 / Logo : vert #4D7C4A
"""

import math
import os
import cairosvg
from PIL import Image
import io

# Couleurs
BG_COLOR = "#FAF9F6"
ACCENT = "#4D7C4A"

def generate_svg(size: int, bg_color: str = BG_COLOR, padding_ratio: float = 0.12) -> str:
    """Génère le SVG du logo Mental E.T. statique à la taille donnée."""

    pad = size * padding_ratio
    cx = size / 2
    cy = size / 2

    # Échelle relative à la taille (basé sur 80px original → s=2.5 pour logo 80px)
    # Le logo "utile" fait ~80px de large dans le canvas original
    logo_size = size - 2 * pad
    s = logo_size / 32  # 32 = taille "unité" de référence du painter

    # ── Tête (silhouette Bézier) ──────────────────────────────────────────────
    # Reproduit exactement le headPath du Flutter CustomPainter (_OrbitPainter)
    head = (
        f"M {cx},{cy - 8*s} "
        f"C {cx + 9*s},{cy - 8.5*s} {cx + 9.5*s},{cy - 2*s} {cx + 8*s},{cy + 1.5*s} "
        f"C {cx + 6*s},{cy + 5*s} {cx + 3.5*s},{cy + 7*s} {cx},{cy + 7*s} "
        f"C {cx - 3.5*s},{cy + 7*s} {cx - 6*s},{cy + 5*s} {cx - 8*s},{cy + 1.5*s} "
        f"C {cx - 9.5*s},{cy - 2*s} {cx - 9*s},{cy - 8.5*s} {cx},{cy - 8*s} "
        f"Z"
    )
    stroke_w = 1.5 * s

    # ── Orbites elliptiques ───────────────────────────────────────────────────
    a = 15.0 * s   # demi-grand axe (agrandi ×1.25 pour meilleure visibilité)
    b = 5.0 * s    # demi-petit axe
    orbit_stroke = 0.9 * s
    thetas = [0.0, math.pi / 3, -math.pi / 3]

    orbit_paths = []
    for theta in thetas:
        # Ellipse orientée : on dessine en coordonnées locales puis on applique
        # une rotation via transform="rotate(deg cx cy)"
        deg = math.degrees(theta)
        orbit_paths.append(
            f'<ellipse cx="{cx}" cy="{cy}" rx="{a}" ry="{b}" '
            f'fill="none" stroke="{ACCENT}" stroke-opacity="0.25" stroke-width="{orbit_stroke}" '
            f'transform="rotate({deg} {cx} {cy})"/>'
        )

    # ── Points aux extrémités ─────────────────────────────────────────────────
    # Extrémités = bouts du grand axe de chaque ellipse (angle 0 et π)
    # Dans le repère local : (a, 0) et (-a, 0)
    # Après rotation theta : (a*cos(theta) + cx, a*sin(theta) + cy) et symétrique
    dot_r = 2.0 * s
    dot_circles = []
    for theta in thetas:
        x1 = cx + a * math.cos(theta)
        y1 = cy + a * math.sin(theta)
        x2 = cx - a * math.cos(theta)
        y2 = cy - a * math.sin(theta)
        dot_circles.append(f'<circle cx="{x1:.2f}" cy="{y1:.2f}" r="{dot_r}" fill="{ACCENT}"/>')
        dot_circles.append(f'<circle cx="{x2:.2f}" cy="{y2:.2f}" r="{dot_r}" fill="{ACCENT}"/>')

    eye_r = 2.5 * s
    eye_stroke = 1.2 * s
    nose_r = 0.8 * s

    svg = f"""<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="{size}" height="{size}" viewBox="0 0 {size} {size}">
  <!-- Fond -->
  <rect width="{size}" height="{size}" fill="{bg_color}"/>

  <!-- Orbites -->
  {''.join(orbit_paths)}

  <!-- Tête silhouette -->
  <path d="{head}" fill="none" stroke="{ACCENT}" stroke-width="{stroke_w}" stroke-linejoin="round"/>

  <!-- Yeux -->
  <circle cx="{cx - 6*s:.2f}" cy="{cy - 2.5*s:.2f}" r="{eye_r:.2f}" fill="none" stroke="{ACCENT}" stroke-width="{eye_stroke:.2f}"/>
  <circle cx="{cx + 6*s:.2f}" cy="{cy - 2.5*s:.2f}" r="{eye_r:.2f}" fill="none" stroke="{ACCENT}" stroke-width="{eye_stroke:.2f}"/>

  <!-- Nez -->
  <circle cx="{cx - 1.5*s:.2f}" cy="{cy:.2f}" r="{nose_r:.2f}" fill="{ACCENT}"/>
  <circle cx="{cx + 1.5*s:.2f}" cy="{cy:.2f}" r="{nose_r:.2f}" fill="{ACCENT}"/>

  <!-- Points aux extrémités des orbites -->
  {''.join(dot_circles)}
</svg>"""
    return svg


def svg_to_png(svg_str: str, output_path: str, size: int):
    """Convertit SVG en PNG."""
    png_bytes = cairosvg.svg2png(bytestring=svg_str.encode(), output_width=size, output_height=size)
    with open(output_path, "wb") as f:
        f.write(png_bytes)
    print(f"  ✓ {output_path} ({size}×{size})")


def generate_maskable(size: int) -> str:
    """Version maskable : fond vert foncé, logo crème — marge safe zone 20%."""
    bg = "#0B1F17"
    fg = "#FAF9F6"

    pad = size * 0.22  # safe zone maskable = ~20-25%
    cx = size / 2
    cy = size / 2
    logo_size = size - 2 * pad
    s = logo_size / 32

    a = 15.0 * s
    b = 5.0 * s
    orbit_stroke = 0.9 * s
    stroke_w = 1.5 * s
    dot_r = 2.0 * s
    thetas = [0.0, math.pi / 3, -math.pi / 3]

    head = (
        f"M {cx},{cy - 8*s} "
        f"C {cx + 9*s},{cy - 8.5*s} {cx + 9.5*s},{cy - 2*s} {cx + 8*s},{cy + 1.5*s} "
        f"C {cx + 6*s},{cy + 5*s} {cx + 3.5*s},{cy + 7*s} {cx},{cy + 7*s} "
        f"C {cx - 3.5*s},{cy + 7*s} {cx - 6*s},{cy + 5*s} {cx - 8*s},{cy + 1.5*s} "
        f"C {cx - 9.5*s},{cy - 2*s} {cx - 9*s},{cy - 8.5*s} {cx},{cy - 8*s} Z"
    )

    orbit_paths = []
    for theta in thetas:
        deg = math.degrees(theta)
        orbit_paths.append(
            f'<ellipse cx="{cx}" cy="{cy}" rx="{a}" ry="{b}" '
            f'fill="none" stroke="{fg}" stroke-opacity="0.3" stroke-width="{orbit_stroke}" '
            f'transform="rotate({deg} {cx} {cy})"/>'
        )

    dot_circles = []
    for theta in thetas:
        x1 = cx + a * math.cos(theta)
        y1 = cy + a * math.sin(theta)
        x2 = cx - a * math.cos(theta)
        y2 = cy - a * math.sin(theta)
        dot_circles.append(f'<circle cx="{x1:.2f}" cy="{y1:.2f}" r="{dot_r}" fill="{fg}"/>')
        dot_circles.append(f'<circle cx="{x2:.2f}" cy="{y2:.2f}" r="{dot_r}" fill="{fg}"/>')

    eye_r = 2.5 * s
    eye_stroke = 1.2 * s
    nose_r = 0.8 * s

    return f"""<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="{size}" height="{size}" viewBox="0 0 {size} {size}">
  <rect width="{size}" height="{size}" fill="{bg}"/>
  {''.join(orbit_paths)}
  <path d="{head}" fill="none" stroke="{fg}" stroke-width="{stroke_w}" stroke-linejoin="round"/>
  <circle cx="{cx - 6*s:.2f}" cy="{cy - 2.5*s:.2f}" r="{eye_r:.2f}" fill="none" stroke="{fg}" stroke-width="{eye_stroke:.2f}"/>
  <circle cx="{cx + 6*s:.2f}" cy="{cy - 2.5*s:.2f}" r="{eye_r:.2f}" fill="none" stroke="{fg}" stroke-width="{eye_stroke:.2f}"/>
  <circle cx="{cx - 1.5*s:.2f}" cy="{cy:.2f}" r="{nose_r:.2f}" fill="{fg}"/>
  <circle cx="{cx + 1.5*s:.2f}" cy="{cy:.2f}" r="{nose_r:.2f}" fill="{fg}"/>
  {''.join(dot_circles)}
</svg>"""


def main():
    base = "/home/ubuntu/mentalite_site_web_flutter"

    print("\n🎨 Génération des icônes Mental E.T. (logo statique)\n")

    # ── Web icons ─────────────────────────────────────────────────────────────
    web_icons_dir = os.path.join(base, "web", "icons")
    os.makedirs(web_icons_dir, exist_ok=True)

    print("Web icons (fond crème):")
    for size in [192, 512]:
        svg = generate_svg(size)
        svg_to_png(svg, os.path.join(web_icons_dir, f"Icon-{size}.png"), size)

    print("\nWeb icons maskable (fond vert foncé):")
    for size in [192, 512]:
        svg = generate_maskable(size)
        svg_to_png(svg, os.path.join(web_icons_dir, f"Icon-maskable-{size}.png"), size)

    print("\nFavicon:")
    svg = generate_svg(32)
    svg_to_png(svg, os.path.join(base, "web", "favicon.png"), 32)

    # ── iOS icons ─────────────────────────────────────────────────────────────
    ios_dir = os.path.join(base, "ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")

    ios_sizes = [
        ("Icon-App-20x20@1x.png", 20),
        ("Icon-App-20x20@2x.png", 40),
        ("Icon-App-20x20@3x.png", 60),
        ("Icon-App-29x29@1x.png", 29),
        ("Icon-App-29x29@2x.png", 58),
        ("Icon-App-29x29@3x.png", 87),
        ("Icon-App-40x40@1x.png", 40),
        ("Icon-App-40x40@2x.png", 80),
        ("Icon-App-40x40@3x.png", 120),
        ("Icon-App-60x60@2x.png", 120),
        ("Icon-App-60x60@3x.png", 180),
        ("Icon-App-76x76@1x.png", 76),
        ("Icon-App-76x76@2x.png", 152),
        ("Icon-App-83.5x83.5@2x.png", 167),
        ("Icon-App-1024x1024@1x.png", 1024),
    ]

    print("\niOS icons (fond crème):")
    for filename, size in ios_sizes:
        svg = generate_svg(size)
        svg_to_png(svg, os.path.join(ios_dir, filename), size)

    print("\n✅ Toutes les icônes générées avec succès !")


if __name__ == "__main__":
    main()
