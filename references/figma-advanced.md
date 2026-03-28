# Figma Advanced Effects — ZeroDrift Reference

> Load when implementing blend modes, backdrop-filter, inner shadow, stroke alignment.

---

## FA-01 — Layer Blend Modes

```
Figma blend mode   →   CSS mix-blend-mode

Normal             →   normal
Multiply           →   multiply
Screen             →   screen
Overlay            →   overlay
Darken             →   darken
Lighten            →   lighten
Color Dodge        →   color-dodge
Color Burn         →   color-burn
Hard Light         →   hard-light
Soft Light         →   soft-light
Difference         →   difference
Exclusion          →   exclusion
Hue                →   hue
Saturation         →   saturation
Color              →   color
Luminosity         →   luminosity
```

```css
/* ❌ VIOLATION */
.layer { opacity: 0.5; }

/* ✅ 1:1 — Figma: Multiply, opacity 50% */
.layer { mix-blend-mode: multiply; opacity: 0.5; }
```

---

## FA-02 — Background Blur → backdrop-filter

```css
/* Figma: Layer Effects → Background Blur: 16 */
/* Fill: #FFFFFF at 20% */

/* ❌ */
background: rgba(255,255,255,0.8);

/* ✅ 1:1 */
backdrop-filter: blur(16px);
-webkit-backdrop-filter: blur(16px);
background: rgba(255, 255, 255, 0.20);
```

---

## FA-03 — Inner Shadow → box-shadow inset

```css
/* Figma Effects: Inner Shadow X:0 Y:2 Blur:8 Spread:0 Color:#000 20% */

/* ❌ */
box-shadow: 0 2px 8px rgba(0,0,0,0.2);

/* ✅ 1:1 */
box-shadow: inset 0px 2px 8px 0px rgba(0, 0, 0, 0.20);

/* Multiple effects — Figma order = CSS order */
box-shadow:
  0px 4px 24px 0px rgba(0, 0, 0, 0.12),
  inset 0px 2px 8px 0px rgba(0, 0, 0, 0.08);
```

---

## FA-04 — Stroke Alignment

```css
/* Figma: Inside stroke 2px */
box-shadow: inset 0 0 0 2px #E5E7EB;  /* no dimension added */

/* Figma: Center stroke 2px (default) */
border: 2px solid #E5E7EB;

/* Figma: Outside stroke 2px */
box-shadow: 0 0 0 2px #E5E7EB;
```

---

## FA-05 — Gradient fills: exact angle, exact stops

```css
/* Figma: linear 135deg, #667EEA 0%, #764BA2 100% */
background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);

/* ❌ */
background: linear-gradient(to right, purple, blue);
```
