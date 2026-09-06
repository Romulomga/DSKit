---
version: 1.0.21
name: DSKit
description: Um design system SwiftUI calmo e nativo da Apple para apps utilitários pequenos (sorteadores, conversores, timers). Um pacote, vários apps — cada app hospedeiro sobrescreve só o tint de accent, o nome e opcionalmente a família de fonte; todo o resto é cor semântica vinda de asset catalog, text styles do sistema, superfícies de canto contínuo e sombras quase imperceptíveis. O chrome recua para que a única ação primária de cada tela fale.

colors:
  accent: "#5856D6"
  accent-secondary: "#FF2D55"
  on-accent: "#FFFFFF"
  accent-wash: "#EFE7FA"
  background: "#FFFFFF"
  background-grouped: "#F2F2F7"
  surface: "#F0F0F9"
  surface-elevated: "#FFFFFF"
  on-surface-high: "#101010"
  on-surface-medium: "#5E5E5E"
  on-surface-light: "#BCBCBC"
  border: "#E5E5E5"
  hairline: "#E5E5E5 @ 50%"
  success-high: "#27BAA7"
  success-light: "#B0F3F5"
  warning-high: "#F1DA10"
  warning-light: "#FCFBBC"
  info-high: "#54AADF"
  info-light: "#D7E4EC"
  error-high: "#FF4425"
  error-light: "#FFB2A3"
  disabled: "#DCDBDC"
  on-disabled: "#BCBCBC"
  white: "#FFFFFF"

colors-dark:
  accent: "#5E5CE6"
  accent-secondary: "#FF375F"
  background: "#1A1A1A"
  background-grouped: "#111111"
  surface: "#313131"
  surface-elevated: "#3B3B3B"
  on-surface-high: "#D1D1D1"
  on-surface-medium: "#A3A3A3"
  on-surface-light: "#535353"
  border: "#414141"
  hairline: "#FFFFFF @ 10%"
  disabled: "#A4A4A4"
  on-disabled: "#707070"

typography:
  large-title:
    fontFamily: "SF Pro Display, system-ui, -apple-system, sans-serif"
    fontSize: 34pt
    fontWeight: 700
    lineHeight: 1.21
    letterSpacing: 0
    textStyle: largeTitle
  title:
    fontFamily: "SF Pro Display, system-ui, -apple-system, sans-serif"
    fontSize: 28pt
    fontWeight: 600
    lineHeight: 1.21
    letterSpacing: 0
    textStyle: title
  title2:
    fontFamily: "SF Pro Display, system-ui, -apple-system, sans-serif"
    fontSize: 22pt
    fontWeight: 600
    lineHeight: 1.27
    letterSpacing: 0
    textStyle: title2
  title3:
    fontFamily: "SF Pro Display, system-ui, -apple-system, sans-serif"
    fontSize: 20pt
    fontWeight: 600
    lineHeight: 1.25
    letterSpacing: 0
    textStyle: title3
  headline:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 17pt
    fontWeight: 600
    lineHeight: 1.29
    letterSpacing: 0
    textStyle: headline
  body:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 17pt
    fontWeight: 400
    lineHeight: 1.29
    letterSpacing: 0
    textStyle: body
  callout:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 16pt
    fontWeight: 400
    lineHeight: 1.31
    letterSpacing: 0
    textStyle: callout
  subheadline:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 15pt
    fontWeight: 400
    lineHeight: 1.33
    letterSpacing: 0
    textStyle: subheadline
  footnote:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 13pt
    fontWeight: 400
    lineHeight: 1.38
    letterSpacing: 0
    textStyle: footnote
  caption:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 12pt
    fontWeight: 400
    lineHeight: 1.33
    letterSpacing: 0
    textStyle: caption
  caption2:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 11pt
    fontWeight: 400
    lineHeight: 1.18
    letterSpacing: 0
    textStyle: caption2
  result-primary:
    fontFamily: "SF Pro Rounded, system-ui, -apple-system, sans-serif"
    fontSize: 34pt
    fontWeight: 700
    lineHeight: 1.21
    letterSpacing: 0
    textStyle: largeTitle
  result-secondary:
    fontFamily: "SF Pro Rounded, system-ui, -apple-system, sans-serif"
    fontSize: 22pt
    fontWeight: 600
    lineHeight: 1.27
    letterSpacing: 0
    textStyle: title2
  display:
    fontFamily: "SF Pro Display, system-ui, -apple-system, sans-serif"
    fontSize: 44pt
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: 0
    textStyle: fixo
  section-label:
    fontFamily: "SF Pro Text, system-ui, -apple-system, sans-serif"
    fontSize: 12pt
    fontWeight: 400
    lineHeight: 1.33
    letterSpacing: 0.5pt
    textCase: uppercase
    textStyle: caption

rounded:
  sm: 6pt
  md: 10pt
  lg: 14pt
  xl: 20pt
  capsule: 999pt

spacing:
  xxs: 2pt
  xs: 4pt
  sm: 8pt
  md: 12pt
  lg: 16pt
  xl: 24pt
  xxl: 32pt

shadow:
  none: "nenhuma"
  subtle: "rgba(0, 0, 0, 0.04) 0 2pt 6pt"
  card: "rgba(0, 0, 0, 0.06) 0 4pt 10pt"
  floating: "rgba(0, 0, 0, 0.10) 0 6pt 16pt"
  glass-fallback: "rgba(0, 0, 0, 0.16) 0 5pt 12pt"

motion:
  short: "easeInOut 180ms"
  medium: "easeInOut 280ms"
  spring: "spring(response: 0.36, damping: 0.78)"
  snappy: "interactiveSpring(response: 0.28, damping: 0.88)"
  emphasized: "spring(response: 0.5, damping: 0.82)"
  selection: "easeOut 150ms"
  press-scale: 0.97

components:
  button-primary:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.white}"
    typography: "{typography.headline}"
    rounded: "{rounded.lg}"
    minHeight: 50pt
    padding: 0 16pt
    haptic: medium
  button-primary-disabled:
    backgroundColor: "{colors.accent} @ 50%"
    textColor: "{colors.white}"
    rounded: "{rounded.lg}"
  button-primary-loading:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.white}"
    rounded: "{rounded.lg}"
    leading: "ProgressView circular, tint branco"
  button-secondary:
    backgroundColor: "{colors.accent} @ 12%"
    textColor: "{colors.accent}"
    typography: "{typography.headline}"
    rounded: "{rounded.lg}"
    minHeight: 50pt
    padding: 0 16pt
    haptic: light
  button-destructive:
    backgroundColor: "{colors.error-high} @ 12%"
    textColor: "{colors.error-high}"
    typography: "{typography.headline}"
    rounded: "{rounded.lg}"
    minHeight: 50pt
    padding: 0 16pt
    haptic: warning
  button-pill-primary:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.white}"
    typography: "{typography.headline}"
    rounded: "{rounded.capsule}"
    minHeight: 56pt
    padding: 0 16pt
    haptic: medium
  button-pill-secondary:
    backgroundColor: "{colors.accent} @ 12%"
    textColor: "{colors.accent}"
    typography: "{typography.headline}"
    rounded: "{rounded.capsule}"
    minHeight: 56pt
    padding: 0 16pt
    haptic: medium
  button-pill-outlined:
    backgroundColor: transparente
    textColor: "{colors.accent}"
    typography: "{typography.headline}"
    rounded: "{rounded.capsule}"
    border: "1.5pt {colors.accent}"
    minHeight: 56pt
    padding: 0 16pt
    haptic: medium
  button-icon-plain:
    backgroundColor: transparente
    textColor: "{colors.accent}"
    iconSize: 17pt / 600
    rounded: "{rounded.capsule}"
    size: 44pt
    haptic: light
  button-icon-tinted:
    backgroundColor: "{colors.accent} @ 15%"
    textColor: "{colors.accent}"
    iconSize: 17pt / 600
    rounded: "{rounded.capsule}"
    size: 44pt
    haptic: light
  button-icon-filled:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.white}"
    iconSize: 17pt / 600
    rounded: "{rounded.capsule}"
    size: 44pt
    haptic: light
  button-icon-rounded:
    backgroundColor: "{colors.accent} @ 15%"
    textColor: "{colors.accent}"
    rounded: "{rounded.md}"
    size: 44pt
  button-glass-action:
    backgroundColor: "Liquid Glass prominent, tint {colors.accent}"
    textColor: "{colors.white}"
    typography: "{typography.headline}"
    minHeight: 32pt
    padding: 4pt 0
    fallback: "{component.button-primary}"
    haptic: light
  card-default:
    backgroundColor: "{colors.surface} (nível 0) / {colors.surface-elevated} (aninhado ou canvas agrupado)"
    textColor: "{colors.on-surface-high}"
    rounded: "{rounded.lg}"
    padding: 16pt
    border: "0.75pt {colors.hairline}"
    shadow: "{shadow.subtle}"
  card-elevated:
    backgroundColor: "{colors.surface} (nível 0) / {colors.surface-elevated} (aninhado ou canvas agrupado)"
    textColor: "{colors.on-surface-high}"
    rounded: "{rounded.lg}"
    padding: 16pt
    border: "0.75pt {colors.hairline}"
    shadow: "{shadow.card}"
  card-material:
    backgroundColor: "regularMaterial"
    textColor: "{colors.on-surface-high}"
    rounded: "{rounded.lg}"
    padding: 16pt
    shadow: "{shadow.none}"
  feature-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.headline}"
    rounded: "{rounded.lg}"
    padding: 16pt
    iconTile: "44pt, {colors.accent} @ 12%, {rounded.md}, glifo 22pt/600 {colors.accent}"
    haptic: light
  plan-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.headline}"
    rounded: "{rounded.md}"
    padding: 12pt
    border: "1pt {colors.hairline}"
  plan-card-selected:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    rounded: "{rounded.md}"
    border: "1.5pt {colors.accent} @ 70%"
  result-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.result-primary}"
    rounded: "{rounded.lg}"
    padding: 16pt
    label: "{typography.section-label}"
  paywall-card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.title3}"
    rounded: "{rounded.lg}"
    padding: 16pt
  chip:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.subheadline}"
    fontWeight: 600
    rounded: "{rounded.capsule}"
    padding: 14pt 12pt
    haptic: light
  chip-selected:
    backgroundColor: "{colors.accent} @ 12%"
    textColor: "{colors.accent}"
    rounded: "{rounded.capsule}"
    border: "1.5pt {colors.accent}"
    trailing: "checkmark 12pt/700"
  option-chip:
    backgroundColor: "{colors.accent} @ 12%"
    textColor: "{colors.accent}"
    typography: "{typography.subheadline}"
    fontWeight: 600
    rounded: "{rounded.capsule}"
    padding: 8pt 12pt
    haptic: light
  option-chip-selected:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.white}"
    rounded: "{rounded.capsule}"
  color-swatch:
    size: 56pt
    rounded: "{rounded.capsule}"
    label: "{typography.caption}"
  color-swatch-selected:
    size: 56pt
    ring: "3pt {colors.on-surface-high} em 64pt"
  segmented-picker:
    backgroundColor: "segmented do sistema"
    textColor: "{colors.accent}"
    label: "{typography.footnote} / 600, secondary"
  toggle-row:
    backgroundColor: transparente
    textColor: "{colors.on-surface-high}"
    typography: "{typography.body}"
    padding: 4pt 0
    iconTile: "28pt, {colors.accent}, {rounded.sm}, glifo 15pt/600 branco"
  badge:
    backgroundColor: "tint @ 14%"
    textColor: "tint"
    typography: "{typography.caption2}"
    fontWeight: 600
    rounded: "{rounded.capsule}"
    padding: 2pt 4pt
  pro-badge:
    backgroundColor: "linear-gradient(accentColor, accentColor @ 78%)"
    textColor: "{colors.white}"
    typography: "{typography.caption2}"
    fontWeight: 700
    rounded: "{rounded.capsule}"
    padding: 2pt 6pt
  toast:
    backgroundColor: "{colors.accent} | {colors.success-high} | {colors.error-high} | {colors.warning-high}"
    textColor: "{colors.white}"
    typography: "{typography.subheadline}"
    fontWeight: 600
    rounded: "{rounded.capsule}"
    padding: 10pt 12pt
    shadow: "{shadow.subtle}"
    autoDismiss: 2000ms
  progress-bar:
    backgroundColor: "{colors.accent} @ 16%"
    fillColor: "{colors.accent}"
    rounded: "{rounded.capsule}"
    height: 4pt
  empty-state:
    backgroundColor: transparente
    textColor: "{colors.on-surface-high}"
    typography: "{typography.title3}"
    icon: "56pt / 300, tertiary"
    padding: 24pt 0
  error-state:
    backgroundColor: transparente
    textColor: "{colors.on-surface-high}"
    typography: "{typography.title3}"
    icon: "48pt / 300, {colors.error-high}"
    padding: 24pt 0
  loading-state:
    backgroundColor: transparente
    textColor: "secondary"
    typography: "{typography.subheadline}"
    padding: 24pt 0
  text-field:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: 10pt 12pt
    border: "1pt {colors.hairline}"
    label: "{typography.footnote} / 600, secondary"
  text-field-focus:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.md}"
    border: "1.5pt {colors.accent} @ 70%"
  text-field-error:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.md}"
    border: "1.5pt {colors.error-high} @ 70%"
    message: "{typography.footnote} {colors.error-high}"
  number-field:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: 10pt 12pt
    border: "1pt {colors.hairline}"
    keyboard: numberPad
    digits: tabulares
  list-input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: 8pt 10pt
    minHeight: 140pt
    border: "1pt {colors.hairline}"
    meta: "{typography.footnote}, secondary; duplicados {colors.warning-high}; colar {colors.accent}; limpar {colors.error-high}"
  screen:
    backgroundColor: transparente
    textColor: "{colors.on-surface-high}"
    typography: "{typography.large-title}"
    padding: 12pt 16pt 24pt
    contentSpacing: 16pt
  screen-grouped-canvas:
    backgroundColor: "{colors.background-grouped}"
    surfaceLevel: 1
    modifier: "dsGroupedCanvas()"
  screen-bottom-action:
    backgroundColor: "ultraThinMaterial"
    padding: 12pt 16pt
    placement: "safeAreaInset(.bottom)"
  section:
    backgroundColor: transparente
    textColor: "{colors.on-surface-high}"
    typography: "{typography.headline}"
    spacing: 8pt
  settings-section:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.on-surface-high}"
    typography: "{typography.section-label}"
    rounded: "{rounded.md}"
    labelPadding: 0 12pt
  settings-row:
    backgroundColor: transparente
    textColor: "{colors.on-surface-high}"
    typography: "{typography.body}"
    padding: 12pt
    iconTile: "28pt, {colors.accent} (sobrescrevível), {rounded.sm}, glifo 15pt/600 branco"
    divider: "0.5pt {colors.border}, recuo à esquerda 52pt"
    haptic: light
  adaptive-grid:
    minItemWidth: 160pt
    spacing: 12pt
  paged-scroll:
    axis: vertical
    behavior: paging
  atmospheric-background:
    backgroundColor: "linear-gradient(tint @ 20%, tint @ 4%, {colors.background})"
    halo: "elipse tint, blur 90pt, opacidade 32%; elipse secundária accent, opacidade 18%"
  atmospheric-background-subtle:
    backgroundColor: "linear-gradient(tint @ 10%, tint @ 2%, {colors.background})"
    halo: "elipse tint, blur 60pt, opacidade 20%, escala 0.7"
  glass-float:
    backgroundColor: "Liquid Glass regular, tint opcional, interativo"
    fallback: "ultraThinMaterial + borda 0.5pt #FFFFFF @ 14% + {shadow.glass-fallback}"
---

## Visão geral

O DSKit é o chassi visual compartilhado por uma família de apps iOS pequenos e de propósito único — sorteadores de número, sorteadores de nome, conversores, timers, feeds de afirmações. O objetivo deliberadamente **não** é um visual de marca. É uma superfície limpa, calma e com sensação nativa, construída sobre a própria linguagem de design da Apple (Ajustes, Atalhos, Lembretes, Fitness): text styles semânticos do sistema, superfícies de canto contínuo, um único tint de accent que cada app sobrescreve, e um chrome que sai da frente da única ação primária de cada tela.

O pacote é SwiftUI puro (UIKit só para haptics e área de transferência), iOS 17+, zero dependências. Toda cor é um token de asset catalog com variantes clara e escura. Todo papel tipográfico mapeia para um text style do Dynamic Type, então o texto escala com as configurações do usuário. Todo elemento com cara de botão compartilha a mesma micro-interação de pressionar e o mesmo vocabulário de haptics. A identidade de cada app vive em exatamente três controles: `DSTheme` (tint de accent + nome do app), `DSFontFamily` (família de fonte opcional) e um punhado de `.colorset` que o app hospedeiro pode colocar no próprio asset catalog para sobrescrever.

A elevação é quase imperceptível. As superfícies se distinguem por tom (`{colors.surface}` sobre `{colors.background}`) e por uma borda hairline, não por sombra; a sombra mais forte do sistema é 10% de preto. A partir do iOS 26, uma camada Liquid Glass (`{component.glass-float}`, `{component.button-glass-action}`) se soma por cima, com fallbacks graciosos para materials em sistemas mais antigos.

**Características principais:**
- Parecer Apple, não parecer uma marca. Text styles do sistema, cores semânticas de asset catalog, materials do sistema.
- Um tint de accent por app (`{colors.accent}`, padrão `systemIndigo`) carrega todo elemento interativo. Os apps sobrescrevem via `DSTheme.primary`; nada mais muda.
- Duas gramáticas de botão: retângulos arredondados contínuos de largura total em `{rounded.lg}` (14pt) para telas utilitárias, e cápsulas de largura total (`{rounded.capsule}`) para fluxos de onboarding e lifestyle.
- Lavagens (washes) de tint, não preenchimentos, para ênfase secundária: `{colors.accent}` a 12% é o fundo universal de "ação de apoio" (botões secundários, chips, tiles de ícone, anéis do plan-card).
- Dois canvases, dois degraus de superfície: `{colors.surface}` sobre `{colors.background}` por padrão, ou `{colors.surface-elevated}` sobre `{colors.background-grouped}` (o visual dos Ajustes, via `.dsGroupedCanvas()`). Um input dentro de um card sobe um degrau sozinho, então nunca some superfície-sobre-superfície.
- Contorno de repouso é sempre `{colors.hairline}`, um token que já troca de escuro para claro conforme a aparência; sombras param em `{shadow.card}` (6% de preto) e ficam reservadas para `card-elevated` e overlays flutuantes.
- Dynamic Type em tudo. Botões usam `minHeight` em vez de altura fixa; texto de resultado usa `minimumScaleFactor`. O único tipo de tamanho fixo é `{typography.display}`, para palavras-herói.
- Haptics são pontuação: light para toques, medium para a ação primária, warning para destrutivas. Um interruptor global (`.dsHapticsEnabled`) silencia tudo.
- Reduce Motion é respeitado no nível do button style: a escala de pressionar de 0.97 é suprimida em todo o sistema quando está ativo.

## Cores

> **Fonte:** `Sources/DSKit/Tokens/Color+Tokens.swift` e `Resources/Colors.xcassets`. Todo token é um `.colorset` nomeado. Tokens marcados como *sobrescrevível* resolvem primeiro no bundle principal do app hospedeiro, então um app pode redefini-los adicionando um `.colorset` de mesmo nome ao próprio asset catalog.

### Marca e Accent
- **Accent** (`{colors.accent}` — #5856D6 claro / #5E5CE6 escuro, *sobrescrevível*): A única cor interativa. É o `systemIndigo` da Apple. Preenche o botão primário, tinge os tiles de ícone, desenha anéis de foco, o preenchimento da progress bar, a borda do chip selecionado e o toast de `.info`. `DSTheme.primary` usa esse token por padrão e todo componente temável lê `theme.primary`, então um app que faz `.dsTheme(DSTheme(primary: .orange))` recolore o sistema inteiro em uma linha.
- **Accent Secundário** (`{colors.accent-secondary}` — #FF2D55 claro / #FF375F escuro, *sobrescrevível*): O `systemPink` da Apple. Entregue como segundo slot de marca para os apps hospedeiros (halo secundário no `{component.atmospheric-background}`, badges). Nenhum componente do DSKit usa por padrão — existe para que os apps não inventem o próprio.
- **On Accent** (`{colors.on-accent}` — #FFFFFF, *sobrescrevível*): Cor de contraste para texto sobre o accent. Declarada para os apps hospedeiros; os botões preenchidos do DSKit hoje pintam branco literal (ver Lacunas conhecidas).
- **Accent Wash** (`{colors.accent-wash}` — #EFE7FA, igual no escuro): Uma lavagem lavanda clara combinando com o accent indigo padrão. Reservada para washes de herói nos apps hospedeiros; não usada pelos componentes do DSKit, que derivam suas lavagens de `{colors.accent}` a 12–16% de alpha para acompanharem automaticamente um accent re-temado.

### Superfície
- **Background** (`{colors.background}` — #FFFFFF claro / #1A1A1A escuro): O canvas da tela. Pintado pelos previews e pelos apps hospedeiros; a `DSScreen` em si não pinta nada, para que um fundo atmosférico apareça por trás.
- **Background Grouped** (`{colors.background-grouped}` — #F2F2F7 claro / #111111 escuro): O canvas dos Ajustes do iOS. Aplicado por `.dsGroupedCanvas()`, que também sobe o nível de superfície para 1 para que as células usem `{colors.surface-elevated}` — `{colors.surface}` tem tom próximo demais para ler sobre ele.
- **Surface** (`{colors.surface}` — #F0F0F9 claro / #313131 escuro): Todo card, input, chip, grupo de ajustes e painel de resultado quando está direto no canvas (nível 0). Um violeta frio bem tênue no modo claro, para ler como camada distinta sobre o branco; um cinza médio no escuro, para se destacar do canvas quase preto.
- **Surface Elevated** (`{colors.surface-elevated}` — #FFFFFF claro / #3B3B3B escuro): Um degrau acima de `surface`. Usado por qualquer componente de superfície que esteja aninhado dentro de outra superfície (nível ≥ 1) ou sobre o canvas agrupado. No escuro é *mais claro* que `surface`, seguindo a convenção do iOS de que elevação clareia. `Color.surface(level:)` escolhe entre os dois a partir de `dsSurfaceLevel`.

### Texto
- **On Surface High** (`{colors.on-surface-high}` — #101010 claro / #D1D1D1 escuro): Títulos, corpo de texto, resultados, rótulos de chip não selecionado. Quase preto em vez de preto puro; no escuro, um cinza claro suave em vez de branco.
- **On Surface Medium** (`{colors.on-surface-medium}` — #5E5E5E claro / #A3A3A3 escuro): Descrições do feature-card, rádios não selecionados do plan-card, glifos de chip não selecionado. A maioria dos componentes usa os estilos hierárquicos `.secondary` / `.tertiary` do SwiftUI para o mesmo papel; este token é para lugares que precisam de uma cor concreta.
- **On Surface Light** (`{colors.on-surface-light}` — #BCBCBC claro / #535353 escuro): Texto e glifos de menor ênfase. Declarado para os apps hospedeiros; não usado pelos componentes do DSKit hoje.
- **Branco** (`{colors.white}` — #FFFFFF): Branco literal usado como cor de rótulo em botões preenchidos com accent, tiles de ícone, toasts e no badge PRO.

### Hairlines e bordas
- **Border** (`{colors.border}` — #E5E5E5 claro / #414141 escuro): Força total. Usado como divisor de 0.5pt da settings-row.
- **Hairline** (`{colors.hairline}` — #E5E5E5 @ 50% claro / #FFFFFF @ 10% escuro): O contorno de repouso de cards, inputs, list-input e plan cards. No claro é uma linha escura tênue; no escuro é uma linha *clara* tênue, porque uma hairline escura some num canvas escuro (a "borda fantasma") e uma linha clara, iluminada por cima, é o que faz a superfície se destacar. Antes cada componente recalculava isso inline; agora é um colorset com alpha, resolvido pela aparência.

### Status semântico
Cada status traz um par `high` (preenchimento / glifo) e `light` (lavagem). Os pares têm o mesmo hex nos modos claro e escuro.
- **Success** (`{colors.success-high}` #27BAA7 · `{colors.success-light}` #B0F3F5): Toast de sucesso, badges de "teste grátis".
- **Warning** (`{colors.warning-high}` #F1DA10 · `{colors.warning-light}` #FCFBBC): Toast de aviso, contador de duplicados no `{component.list-input}`, badges de "economize 70%", ícones de ajustes tingidos de aviso.
- **Info** (`{colors.info-high}` #54AADF · `{colors.info-light}` #D7E4EC): Declarado para os apps hospedeiros. O toast `.info` usa `{colors.accent}` em vez disso, para que info soe como "o app falando".
- **Error** (`{colors.error-high}` #FF4425 · `{colors.error-light}` #FFB2A3): Toast de erro, ícone do error-state, mensagens de validação, borda de foco em campos inválidos, texto do botão destrutivo (com lavagem de 12% como preenchimento).

### Desabilitado
- **Disabled** (`{colors.disabled}` — #DCDBDC claro / #A4A4A4 escuro) e **On Disabled** (`{colors.on-disabled}` — #BCBCBC claro / #707070 escuro): Declarados para os apps hospedeiros. Os componentes do DSKit expressam o estado desabilitado por opacidade — o rótulo inteiro cai para 50%, ou o preenchimento do botão primário cai para 50% — para que a gramática de forma e cor continue reconhecível.

### Receitas de alpha
O DSKit nunca introduz um hex novo para um tint. Ele deriva lavagens do accent (ou da cor de status) em alphas fixos:

| Alpha | Uso |
|---|---|
| 12% | Preenchimento de botão secundário / destrutivo, pill-secondary, option-chip em repouso, chip-selected, tile de ícone do feature-card |
| 14% | Preenchimento do `{component.badge}` |
| 15% | Preenchimento do `{component.button-icon-tinted}`, badge do feature-card |
| 16% | Trilha do `{component.progress-bar}` |
| 50% | `{colors.hairline}` no modo claro (`{colors.border}` a 50%) |
| 70% | Anel de foco em accent e anel do plan-card selecionado; anel de erro em campos inválidos |
| 78% | Parada final do gradiente do badge PRO |
| 10% | `{colors.hairline}` no modo escuro (branco a 10%) |

### Gradiente de marca
O DSKit tem dois gradientes, ambos funcionais e não decorativos. O `{component.pro-badge}` roda um pequeno diagonal accent → accent @ 78% para a pílula pegar luz. O `{component.atmospheric-background}` pinta uma lavagem de tint no canto superior esquerdo que se dissolve em `{colors.background}`, mais duas elipses fortemente desfocadas (um "halo") para dar profundidade atrás de telas de herói. Cards, botões e texto nunca carregam gradiente.

## Tipografia

### Família de fonte
- **Sistema por padrão**: Todo token de `DSTypography` resolve via `Font.system(_:design:)`, então no aparelho renderiza como SF Pro (Display a partir de 20pt, Text abaixo). O escalonamento por Dynamic Type é automático.
- **Design rounded** para resultados: `{typography.result-primary}` e `{typography.result-secondary}` usam `.rounded` (SF Pro Rounded), para que um vencedor sorteado ou um número convertido pareça amigável e distinto do texto de chrome.
- **Família customizada**: O app hospedeiro define `DSTypography.family = DSFontFamily("Nunito")` uma vez na inicialização. Todo token então resolve via `Font.custom(_:size:relativeTo:)` no tamanho padrão do text style, então o Dynamic Type continua escalando de forma idêntica. O design rounded é substituído pela família nos papéis de resultado. Os pesos resolvem via `Font.weight(_:)`, então a família precisa trazer regular, semibold e bold.

### Hierarquia

| Token | Tamanho | Peso | Line Height | Text Style | Uso |
|---|---|---|---|---|---|
| `{typography.display}` | 44pt (fixo) | 700 | 1.2 | — | Palavras-herói que preenchem a tela (afirmações, respostas de uma palavra). Sem Dynamic Type. |
| `{typography.large-title}` | 34pt | 700 | 1.21 | largeTitle | Título da `DSScreen` |
| `{typography.result-primary}` | 34pt | 700 | 1.21 | largeTitle, rounded | O resultado grande único no `{component.result-card}` |
| `{typography.title}` | 28pt | 600 | 1.21 | title | Reservado; não usado por componentes |
| `{typography.title2}` | 22pt | 600 | 1.27 | title2 | Reservado; não usado por componentes |
| `{typography.result-secondary}` | 22pt | 600 | 1.27 | title2, rounded | Número de resultado secundário |
| `{typography.title3}` | 20pt | 600 | 1.25 | title3 | Títulos de empty/error-state, título do paywall, itens de resultado ranqueado |
| `{typography.headline}` | 17pt | 600 | 1.29 | headline | Todo rótulo de botão, títulos de card, títulos de seção, preço do plano |
| `{typography.body}` | 17pt | 400 | 1.29 | body | Inputs, rows, texto de feature, itens de resultado agrupado |
| `{typography.callout}` | 16pt | 400 | 1.31 | callout | Reservado; não usado por componentes |
| `{typography.subheadline}` | 15pt | 400 | 1.33 | subheadline | Subtítulo de tela, descrições, rótulos de chip (600), texto de toast (600), mensagens de estado |
| `{typography.footnote}` | 13pt | 400 | 1.38 | footnote | Rótulos de input (600), texto de ajuda/erro, subtítulos de ajustes, rodapés de seção, período do plano |
| `{typography.caption}` | 12pt | 400 | 1.33 | caption | Rótulo do result-card, rótulos de swatch, rótulos de preview |
| `{typography.section-label}` | 12pt | 400 | 1.33 | caption | Caixa alta, tracking +0.5pt — olho da settings-section e do result-card |
| `{typography.caption2}` | 11pt | 400 | 1.18 | caption2 | Badges (600 / 700) |

Os line heights são o leading do sistema para cada text style no tamanho de conteúdo padrão (Large); eles escalam com o Dynamic Type.

### Princípios

- **Escada de pesos 400 / 600 / 700, sem 500.** Headline (600) é a voz de todo botão e chip; body (400) é a voz de leitura; 700 é large title, display e badge PRO. Botões secundários e destrutivos usam o mesmo 600 do primário — a hierarquia vem do preenchimento (lavagem a 12% em vez de sólido), não de um peso intermediário. Codificar a mesma coisa duas vezes só deixava o secundário parecendo fraco.
- **Nunca `.system(size:)` para texto.** Só glifos (SF Symbols em tiles de ícone, chevrons, checkmarks, ícones de estado) usam tamanhos fixos em pontos: 22pt em tiles de feature, 17pt em botões de ícone, 15pt em tiles de ajustes, 13pt em chevrons, 12pt em checkmarks de chip, 48–56pt em ilustrações de estado.
- **`{typography.display}` é a única exceção ao Dynamic Type.** Uma palavra-herói que já preenche a tela não pode crescer mais; quem quiser escalonamento usa `{typography.large-title}`.
- **Rótulos de olho são caption em caixa alta com tracking +0.5pt.** É o único letter-spacing positivo do sistema e a única transformação de `textCase`.
- **Dígitos tabulares em tudo que é número.** `DSPlanCard` (preço), `DSNumberField`, `DSResultCard` (nos três layouts) e a linha meta do `DSListInput` usam `.monospacedDigit()`, para que um valor que muda não faça o texto pular de largura e listas numeradas se alinhem.
- **Peso 300 só aparece em ilustrações.** SF Symbols de empty/error-state renderizam em `.light` para lerem como placeholder, não como conteúdo.

### Nota sobre fontes substitutas
Quando o app hospedeiro instala uma família customizada, mantenha a mesma escada de papéis: regular para body, semibold para headline/títulos, bold para large title / display. Famílias humanistas arredondadas (Nunito, Quicksand) combinam bem com os papéis rounded de resultado que substituem. Famílias geométricas com x-height alto podem precisar de line height mais solto no `{typography.body}` por parte do host; o DSKit não expõe override de leading.

## Layout

### Sistema de espaçamento
- **Unidade base:** 4pt, alinhada ao ritmo 4/8pt da Apple. `{spacing.xxs}` 2pt existe para o espaço vertical entre o título de uma row e seu subtítulo.
- **Tokens:** `{spacing.xxs}` 2pt · `{spacing.xs}` 4pt · `{spacing.sm}` 8pt · `{spacing.md}` 12pt · `{spacing.lg}` 16pt · `{spacing.xl}` 24pt · `{spacing.xxl}` 32pt.
- **Margens de tela:** `{spacing.lg}` (16pt) horizontal; `{spacing.md}` (12pt) acima do cabeçalho; `{spacing.xl}` (24pt) abaixo do último conteúdo.
- **Padding de card:** `{spacing.lg}` (16pt) em cards, feature cards, result cards e paywall cards. Superfícies compactas (plan cards, settings rows, inputs) usam `{spacing.md}` (12pt).
- **Padding de botão:** 16pt horizontal; a altura vem de `minHeight` (50pt retangular, 56pt pílula, 44pt ícone).
- **Ritmo de stack:** `{spacing.lg}` entre irmãos no nível da tela, `{spacing.md}` entre cards em lista ou grid, `{spacing.sm}` dentro de uma seção, `{spacing.xs}` entre um rótulo e seu controle.
- **Valores fora da escala** (todos deliberados): 14pt de padding vertical no chip (para ele chegar a ~44pt), 10pt de padding vertical em input (`sm + 2`), 6pt de padding horizontal no badge PRO (`xs + 2`), 52pt de recuo do divisor de ajustes (`md + 28 + md`).

### Grid e container
- **Coluna única** é o padrão. A `DSScreen` é um `ScrollView` vertical com conteúdo alinhado à esquerda esticado a `maxWidth: .infinity`.
- **Grid adaptativo** via `{component.adaptive-grid}`: `LazyVGrid` com colunas `.adaptive(minimum: 160pt)` e calhas de 12pt. Uma coluna em iPhones compactos, duas em iPhones grandes e iPad em retrato, três ou mais em paisagem — sem breakpoints para calcular.
- **Feed paginado** via `{component.paged-scroll}`: cada página tem o tamanho da geometria completa do container e encaixa com `.scrollTargetBehavior(.paging)`. Vertical por padrão (deslize para cima para a próxima).
- **Área de ação inferior**: um `safeAreaInset(edge: .bottom)` na `DSScreen`, para que o CTA primário suba junto com o teclado e o conteúdo rolável se ajuste automaticamente para continuar alcançável.

### Níveis de superfície
Todo componente que pinta uma superfície lê `@Environment(\.dsSurfaceLevel)` e escolhe a cor com `Color.surface(level:)`. Os containers (`DSCard`, `DSSettingsSection`) sobem o nível para o conteúdo via `.dsSurfaceContainer()`, então um `DSTextField` dentro de um `DSCard` renderiza em `{colors.surface-elevated}` sem que ninguém precise pedir. `.dsGroupedCanvas()` pinta `{colors.background-grouped}` e já começa no nível 1 — é o visual dos Ajustes em um modifier. Views customizadas do host entram no mesmo esquema lendo o environment.

### Filosofia de espaço em branco
O conteúdo respira, mas não flutua. Uma tela abre com um large title de 34pt, 4pt, um subtítulo de 15pt, e então 16pt de ar antes do primeiro card. Cards ficam a 12pt entre si para uma lista ler como um grupo; seções ficam a 16pt para os grupos se separarem. Estados de vazio, carregamento e erro têm 24pt de padding vertical e se centralizam, para nunca apertar o cabeçalho. Não existe padding de "seção herói" — o maior espaço único do sistema é 32pt.

## Elevação e profundidade

| Nível | Tratamento | Uso |
|---|---|---|
| Plano | Só mudança de tom: `{colors.surface}` no canvas, `{colors.surface-elevated}` quando aninhado ou em canvas agrupado | Grupos de ajustes, result cards, feature cards, chips |
| Hairline | Borda de 0.75–1pt em `{colors.hairline}` | `card-default`, `card-elevated`, inputs, list-input, plan cards |
| Sutil | `{shadow.subtle}` — 4% preto, blur 6pt, y 2 | `card-default`, `toast` |
| Card | `{shadow.card}` — 6% preto, blur 10pt, y 4 | `card-elevated` (cards de herói / destaque) |
| Flutuante | `{shadow.floating}` — 10% preto, blur 16pt, y 6 | Reservado para overlays flutuantes nos apps hospedeiros |
| Material | `regularMaterial` / `ultraThinMaterial` | `card-material`, `screen-bottom-action`, fallback de glass |
| Liquid Glass | `glassEffect(.regular)` (iOS 26+) | `glass-float`, `button-glass-action`, `GlassGroup` |

**Filosofia de sombra.** Superfícies no estilo Apple dependem muito mais de materials e bordas do que de sombras, então o DSKit trata sombra como desempate, não como ferramenta de hierarquia. O `DSCard.default` traz uma hairline *e* uma sombra de 4% só para que um card nunca fique colado num canvas que por acaso tenha tom parecido. Nada mais na camada utilitária projeta sombra, exceto o toast, que é um elemento flutuante por definição. A sombra de 16% do fallback de glass existe puramente para substituir o Liquid Glass no iOS 17–18.

### Profundidade decorativa
- **Fundo atmosférico** (`{component.atmospheric-background}`): um gradiente de tint mais duas elipses desfocadas (blur de 60–90pt) atrás de uma tela inteira. É aqui que o clima mora; os cards por cima ficam planos.
- **Liquid Glass** (`{component.glass-float}`): no iOS 26 os elementos podem flutuar em vidro de verdade, opcionalmente tingido e interativo, agrupados via `GlassGroup` para que formas de vidro vizinhas se fundam. Em sistemas mais antigos a mesma chamada renderiza `ultraThinMaterial` com uma borda de 0.5pt branco @ 14% e a sombra de fallback.
- **Helpers de borda de scroll e tab bar** (`scrollEdgeHard`, `glassTabBarMinimize`) encaminham para as APIs do iOS 26 e viram no-ops antes disso — pistas de profundidade que não custam nada na plataforma mínima.

## Formas

### Escala de raio de borda

| Token | Valor | Uso |
|---|---|---|
| `{rounded.sm}` | 6pt | Tiles de ícone de 28pt em settings rows e toggle rows |
| `{rounded.md}` | 10pt | Inputs, plan cards, grupos de ajustes, tiles de ícone do feature-card, botões de ícone arredondados |
| `{rounded.lg}` | 14pt | Cards, botões (primário / secundário / destrutivo), feature, result e paywall cards |
| `{rounded.xl}` | 20pt | Reservado para sheets e grandes superfícies de herói nos apps hospedeiros |
| `{rounded.capsule}` | 999pt | Botões pílula, chips, option chips, toasts, badges, progress bar, botões de ícone circulares e swatches |

Todos os retângulos arredondados usam o estilo de canto `.continuous` — o squircle da Apple — nunca cantos circulares. A regra prática: o raio de um elemento cresce com seu padding (tile 6pt → superfície compacta 10pt → card com padding 14pt), e qualquer coisa que deva ler como *token tocável* em vez de *container* é uma cápsula.

### Geometria de iconografia
- Só SF Symbols. O peso do glifo acompanha o peso do texto ao redor: semibold ao lado de rótulos headline, bold em tamanhos minúsculos (checkmark de 12pt, badge), light em tamanhos de ilustração (48–56pt).
- Tiles de ícone vêm em dois tamanhos: 44pt (`{rounded.md}`, lavagem de accent, glifo 22pt) em feature cards, e 28pt (`{rounded.sm}`, accent sólido, glifo branco 15pt) em settings e toggle rows — o idioma dos Ajustes do iOS.
- Controles circulares (botões de ícone, swatches de cor, indicadores de rádio) são círculos de verdade: 44pt, 56pt (64pt com o anel de seleção) e 22pt respectivamente.

## Componentes

### Estrutura de tela

**`screen`** — `DSScreen`. Um `ScrollView` com `VStack` alinhado à esquerda e espaçamento `{spacing.lg}`, com padding de 16pt horizontal, 12pt no topo e 24pt embaixo. Cabeçalho opcional: título em `{typography.large-title}` `{colors.on-surface-high}`, subtítulo em `{typography.subheadline}` secondary, view trailing opcional na baseline do primeiro texto. **Não** pinta fundo, para que um backdrop do host apareça.
- Ação inferior: `{component.screen-bottom-action}` — um `safeAreaInset` na borda inferior, padding 16pt × 12pt, sobre `ultraThinMaterial`. Sobe junto com o teclado.
- Canvas agrupado: `{component.screen-grouped-canvas}` — `.dsGroupedCanvas()` aplicado à tela pinta `{colors.background-grouped}` e começa `dsSurfaceLevel` em 1, então cards e grupos de ajustes viram células `{colors.surface-elevated}`. O visual dos Ajustes em um modifier.

**`section`** — `DSSection`. Título opcional em `{typography.headline}` sobre o conteúdo com espaçamento `{spacing.sm}`. Agrupamento puramente tipográfico; sem superfície.

**`settings-section`** — `DSSettingsSection`. Olho em `{typography.section-label}` (caption em caixa alta, tracking +0.5pt, secondary) com recuo de 12pt; rows empilhadas com espaçamento 0 dentro de um grupo `{colors.surface}` (ou `{colors.surface-elevated}` sob `.dsGroupedCanvas()`) em `{rounded.md}`, que sobe `dsSurfaceLevel` para as rows; rodapé opcional em `{typography.footnote}` secondary com recuo de 12pt. O visual de lista agrupada do iOS.

**`settings-row`** — `DSSettingsRow`. Padding de 12pt. Tile de ícone opcional de 28pt (`{rounded.sm}`, `{colors.accent}` por padrão ou uma cor do chamador, glifo branco 15pt/600), título `{typography.body}` `{colors.on-surface-high}`, subtítulo opcional `{typography.footnote}` secondary com 2pt de espaço, slot trailing (toggle, valor), e um chevron tertiary 13pt/600 só quando existe uma ação. Divisor `{colors.border}` de 0.5pt com recuo de 52pt da borda esquerda; passe `showsDivider: false` na última row. Rows com ação viram um `Button` plain com haptic light; rows sem ação continuam como container passivo para que o controle trailing continue vivo.

**`toggle-row`** — `DSToggleRow`. Mesma anatomia de uma settings row (tile de ícone accent de 28pt, título body, subtítulo footnote) com um `Toggle` trailing tingido de `{colors.accent}`. 4pt de padding vertical; combinado em um único elemento de acessibilidade.

**`adaptive-grid`** / **`paged-scroll`** — ver Layout.

### Botões

Todos os componentes com cara de botão compartilham o `DSPressableButtonStyle`: escala para `{motion.press-scale}` (0.97) com `{motion.snappy}`, suprimida sob Reduce Motion. Todos são de largura total salvo indicação.

**`button-primary`** — `DSPrimaryButton`. A ação dominante, idealmente uma por tela. Preenchimento `{colors.accent}` (primary do tema), rótulo `{typography.headline}` em 600 `{colors.white}`, SF Symbol leading opcional a `{spacing.sm}`, `minHeight` 50pt, 16pt de padding horizontal, `{rounded.lg}` contínuo. Haptic medium.
- Carregando: `{component.button-primary-loading}` — o slot do símbolo vira um `ProgressView` circular branco; o botão se desabilita e adiciona o trait `.updatesFrequently`.
- Desabilitado: `{component.button-primary-disabled}` — o preenchimento cai para 50% de alpha; o rótulo continua branco.

**`button-secondary`** — `DSSecondaryButton`. Ações de apoio (Compartilhar, Copiar, Sortear de novo). Preenchimento `{colors.accent}` @ 12%, rótulo `{typography.headline}` em 600 `{colors.accent}`, mesmo chassi 50pt / 16pt / `{rounded.lg}`. Haptic light. Desabilitado: rótulo inteiro a 50% de opacidade.

**`button-destructive`** — `DSDestructiveButton`. `role: .destructive`; preenchimento `{colors.error-high}` @ 12%, rótulo em 600 `{colors.error-high}`, mesmo chassi. Haptic warning. Combine com um diálogo de confirmação no ponto de chamada.

**`button-pill-primary`** / **`button-pill-secondary`** / **`button-pill-outlined`** — `DSPillButton`. A gramática de onboarding / lifestyle: clip em `Capsule()`, `minHeight` 56pt, rótulo em 600. Primary é accent + branco; secondary é accent @ 12% + texto accent; outlined é fundo transparente, borda accent de 1.5pt e texto accent — o "pill fantasma", para ação de apoio sobre `AtmosphericBackground` ou foto, onde uma lavagem tingida fica suja. Suporta os mesmos estados de loading e disabled do `button-primary`. Haptic medium.

**`button-icon-plain`** / **`button-icon-tinted`** / **`button-icon-filled`** — `DSIconButton`. 44 × 44pt, SF Symbol 17pt/600. Plain: transparente, glifo accent. Tinted (padrão): preenchimento accent @ 15%, glifo accent — estilo toolbar. Filled: preenchimento accent, glifo branco — CTA circular enfatizado. A forma é `Circle` ou `{component.button-icon-rounded}` (`{rounded.md}`). Exige rótulo de acessibilidade. Haptic light.

**`button-glass-action`** — `GlassActionButton`. iOS 26+: button style `.glassProminent` tingido com a cor do chamador (padrão `{colors.accent}`), `.controlSize(.large)`, rótulo `{typography.headline}` em 600, `minHeight` 32pt mais 4pt de padding vertical; o símbolo leading dá um bounce via `dsSymbolFeedback` quando `feedback` incrementa. Abaixo do iOS 26 renderiza `{component.button-primary}`. Haptic light.

### Cards e containers

**`card-default`** — `DSCard()`. Container genérico: 16pt de padding, `{colors.surface}` (ou `{colors.surface-elevated}` se aninhado ou em canvas agrupado), `{rounded.lg}` contínuo, `{colors.hairline}` de 0.75pt, `{shadow.subtle}`. Sobe `dsSurfaceLevel` para o conteúdo. Sempre lê como superfície distinta mesmo quando o canvas tem tom próximo.

**`card-elevated`** — `DSCard(.elevated)`. Igual, com `{shadow.card}` para cards de herói / destaque.

**`card-material`** — `DSCard(.material)`. Preenchimento `regularMaterial`, sem borda, sem sombra — overlays flutuantes e barras de ação sobre conteúdo.

**`feature-card`** — `DSFeatureCard`. Tile de tela inicial: tile de ícone de 44pt em lavagem de accent (`{rounded.md}`, glifo accent 22pt/600) → título `{typography.headline}` `{colors.on-surface-high}` com badge opcional (caption2 bold, cápsula accent @ 15%, texto accent) e glifo de cadeado → descrição `{typography.subheadline}` `{colors.on-surface-medium}` → chevron tertiary 13pt/600 no final. Padding de 16pt sobre `{colors.surface}` em `{rounded.lg}`; sem borda nem sombra (a densidade do tile fornece o affordance). Pressionável; haptic light.

**`result-card`** — `DSResultCard`. Destaca um sorteio / conversão. Todos os layouts usam dígitos tabulares. Olho em `{typography.section-label}` secondary, e então um de três layouts: **single** — `{typography.result-primary}` (34pt rounded bold) com `minimumScaleFactor` 0.5, no máximo duas linhas, legenda opcional em `{typography.subheadline}` secondary; **list** — rows numeradas em `{typography.title3}` (índice em secondary, item em `{colors.on-surface-high}`) com `{spacing.sm}`; **grouped** — títulos de bucket em `{typography.footnote}` 600 secondary sobre itens em `{typography.body}`. Padding de 16pt, `{colors.surface}`, `{rounded.lg}`, elemento de acessibilidade combinado.

**`plan-card`** / **`plan-card-selected`** — `DSPlanCard`. Seletor de plano de paywall: glifo de rádio de 22pt (`{colors.accent}` quando selecionado, `{colors.on-surface-medium}` caso contrário) → título `{typography.headline}` e preço em `headline.monospacedDigit()` na mesma linha → período `{typography.footnote}` secondary mais uma linha opcional de `{component.badge}`. Padding de 12pt, `{colors.surface}` (elevado quando aninhado), `{rounded.md}`. Anel: 1pt `{colors.hairline}` em repouso, 1.5pt `{colors.accent}` @ 70% selecionado, animado com `{motion.selection}`.

**`paywall-card`** — `DSPaywallCard`. Glifo `sparkles` em accent + título `{typography.title3}` + `{component.pro-badge}` no final → lista de recursos (`checkmark.circle.fill` accent, `{typography.body}`) → linha de preço opcional `{typography.footnote}` secondary → `{component.button-primary}` → link de restaurar `{typography.footnote}` secondary centralizado. Padding de 16pt, `{colors.surface}`, `{rounded.lg}`.

### Controles

**`chip`** / **`chip-selected`** — `DSChip`. Cápsula de largura total, padding 12pt × 14pt, emoji leading opcional (18pt) ou SF Symbol (14pt/600), rótulo `{typography.subheadline}` em 600. Repouso: preenchimento `{colors.surface}`, texto `{colors.on-surface-high}`, sem borda. Selecionado: preenchimento accent @ 12%, borda accent de 1.5pt, texto accent e um checkmark 12pt/700 no final para que o estado tenha um sinal além da cor. Listas de onboarding multi-seleção. Haptic light.

**`option-chip`** / **`option-chip-selected`** — `DSOptionChip`. Cápsula compacta de tamanho próprio para grupos de filtro, padding 12pt × 8pt, `{typography.subheadline}` em 600, símbolo opcional a `{spacing.xs}`. Repouso: preenchimento accent @ 12%, texto accent. Selecionado: accent sólido, texto branco. Alterna um `Binding<Bool>`. Haptic light.

**`color-swatch`** / **`color-swatch-selected`** — `DSColorSwatch`. Círculo preenchido de 56pt, rótulo `{typography.caption}` abaixo com `{spacing.xs}`. Selecionado: anel `{colors.on-surface-high}` de 3pt em 64pt, animado com `{motion.selection}`. Bloqueado: `lock.fill` branco 14pt/700 centralizado. Seletores de tema / accent.

**`segmented-picker`** — `DSSegmentedPicker`. `Picker(.segmented)` nativo tingido de `{colors.accent}`, com legenda opcional `{typography.footnote}` 600 secondary acima com `{spacing.xs}`.

**`progress-bar`** — `DSProgressBar`. Trilha em cápsula de 4pt em accent @ 16% com preenchimento em cápsula accent; valor limitado a 0…1 e animado com `{motion.spring}` (desativado sob Reduce Motion). Indicadores de passo de onboarding. Expõe a porcentagem como valor de acessibilidade.

### Inputs e formulários

Todos os inputs compartilham uma única gramática de borda: 1pt `{colors.hairline}` em repouso → 1.5pt `{colors.accent}` @ 70% em foco → 1.5pt `{colors.error-high}` @ 70% em erro, cada transição em `{motion.selection}`. O fundo é `Color.surface(level:)`, então um input dentro de um card sobe para `{colors.surface-elevated}` sozinho. Rótulos ficam acima em `{typography.footnote}` 600 secondary com `{spacing.xs}`; texto de ajuda fica abaixo em `{typography.footnote}` secondary; texto de erro substitui o de ajuda em `{colors.error-high}` com um glifo `exclamationmark.circle.fill`.

**`text-field`** — `DSTextField`. `TextField` plain em `{typography.body}`, padding 12pt × 10pt, `{colors.surface}`, `{rounded.md}`. Botão de limpar opcional no final com `xmark.circle.fill` tertiary (haptic light).

**`number-field`** — `DSNumberField`. Mesmo chassi com `.numberPad`, dígitos tabulares, acessório `Done` no teclado, e um `Binding<Int?>` onde `nil` significa vazio ou inválido. A validação interna mostra "Enter a valid number" no slot de erro; um `errorMessage` externo tem precedência.

**`list-input`** — `DSListInput`. `TextEditor` multilinha (mín. 140pt) com overlay de placeholder e acessório `Done` no teclado, mesma gramática de borda, padding 10pt × 8pt. Abaixo, uma linha meta em `{typography.footnote}`: contagem de itens com `list.bullet` (secondary), contagem de duplicados com `doc.on.doc` em `{colors.warning-high}` quando > 0, e no final `Colar` (`{colors.accent}`) e `Limpar` (`{colors.error-high}`, desabilitado e secondary quando vazio). Limpar chama `onClearRequested` se o app forneceu, para que ele possa confirmar; senão limpa direto. Faz parse por quebra de linha; nunca altera o texto do usuário.

### Feedback

**`empty-state`** — `DSEmptyState`. SF Symbol tertiary 56pt/300 centralizado → título `{typography.title3}` → mensagem `{typography.subheadline}` secondary (16pt de padding lateral) → `{component.button-primary}` opcional com `{spacing.sm}` no topo / 16pt nas laterais. 24pt de padding vertical; elemento de acessibilidade combinado.

**`error-state`** — `DSErrorState`. Mesma pilha com símbolo `{colors.error-high}` 48pt/300 (padrão `exclamationmark.triangle`) e um `{component.button-secondary}` de tentar de novo com `arrow.clockwise` (título padrão "Try again", localizado no DSKit).

**`loading-state`** — `DSLoadingState`. `ProgressView` large com legenda opcional `{typography.subheadline}` secondary, 24pt de padding vertical.

**`toast`** — `DSToast` / `.dsToast(_:)`. Cápsula, padding 12pt × 10pt, `{typography.subheadline}` semibold branco (2 linhas, escala mínima 0.85) ao lado de um glifo semibold branco. Tint por estilo: `.info` `{colors.accent}` (`info.circle.fill`), `.success` `{colors.success-high}` (`checkmark.circle.fill`), `.error` `{colors.error-high}` (`exclamationmark.circle.fill`), `.warning` `{colors.warning-high}` (`exclamationmark.triangle.fill`). `{shadow.subtle}`. O modifier sobrepõe no topo da safe area (16pt nas laterais, 12pt no topo), entra com `{motion.spring}` via move-do-topo + opacidade, e some sozinho após 2s com `{motion.medium}`.

### Monetização

**`badge`** — `DSBadge`. Cápsula, padding 4pt × 2pt, `{typography.caption2}` em 600 num tint do chamador (padrão `{colors.accent}`) sobre esse tint @ 14%. Chamadas de teste grátis / desconto dentro de plan cards.

**`pro-badge`** — `DSProBadge`. Cápsula, padding 6pt × 2pt, `{typography.caption2}` em 700 branco sobre um gradiente do canto superior esquerdo ao inferior direito do `accentColor` do SwiftUI até `accentColor` @ 78%. Texto padrão "PRO" (localizado no DSKit); também usado para "NEW" / "BETA".

### Fundos e glass

**`atmospheric-background`** / **`atmospheric-background-subtle`** — `AtmosphericBackground`. `ZStack` de tela cheia (`ignoresSafeArea`): um `LinearGradient` do canto superior esquerdo ao inferior direito de tint @ 20% (10% no subtle) passando por tint @ 4% (2%) até `{colors.background}`, mais duas elipses desfocadas — o tint primário no canto superior esquerdo (blur 90pt / opacidade 32%, ou 60pt / 20% em escala 0.7 no subtle) e um halo secundário no canto inferior direito na cor `accent` opcional a 55% dessa opacidade. Coloque atrás de uma `DSScreen`, que não pinta nada.

**`glass-float`** — `.glassFloat(tint:interactive:in:)`. iOS 26+: `glassEffect` com vidro `.regular`, tint opcional, `.interactive()` por padrão, em qualquer `Shape`. Fallback: a forma preenchida com o tint ou `ultraThinMaterial`, borda de 0.5pt branco @ 14%, `compositingGroup`, e `{shadow.glass-fallback}`.

**`GlassGroup`** — envolve `GlassEffectContainer(spacing:)` no iOS 26 para que formas de vidro adjacentes se fundam; passa o conteúdo intacto antes disso. `scrollEdgeHard(_:)` e `glassTabBarMinimize()` encaminham para `scrollEdgeEffectStyle(.hard)` e `tabBarMinimizeBehavior(.onScrollDown)` com o mesmo no-op na plataforma mínima.

### Vocabulário de motion e feedback

| Token | Valor | Uso |
|---|---|---|
| `{motion.snappy}` | interactiveSpring 0.28 / 0.88 | Escala de pressionar em botões; trocas de estado de símbolo |
| `{motion.selection}` | easeOut 150ms | Anéis de seleção de chip / plano / swatch, bordas de foco e erro em inputs |
| `{motion.short}` | easeInOut 180ms | Micro transições nos apps hospedeiros |
| `{motion.medium}` | easeInOut 280ms | Saída do toast |
| `{motion.spring}` | spring 0.36 / 0.78 | Entrada do toast, preenchimento da progress bar |
| `{motion.emphasized}` | spring 0.5 / 0.82 | Movimentos de herói, revelações tipo sheet (com parcimônia) |

Os efeitos de SF Symbol se limitam a dois: `dsSymbolFeedback` (um `.bounce` quando um contador muda — "a ação aconteceu") e `dsSymbolStateReplace` (`contentTransition(.symbolEffect(.replace))` para um glifo que muda com o estado). Sem efeitos em loop.

Haptics: `DSHaptics.light` em toques, chips, botões de ícone, rows, colar/limpar; `.medium` em botões primários e pílula; `.warning` em destrutivos; `.success` / `.error` ficam expostos para os apps hospedeiros. Tudo passa por `.dsHapticsEnabled`, então um único toggle de ajustes silencia o pacote.

## Faça e não faça

### Faça
- Roteie toda cor interativa por `theme.primary` (que por padrão é `{colors.accent}`). Re-temar um app tem que ser uma mudança de uma linha em `.dsTheme(...)`.
- Derive lavagens com alpha — accent @ 12% para preenchimentos de apoio, @ 15–16% para tiles e trilhas, @ 70% para anéis de foco — nunca um hex novo.
- Use `{rounded.lg}` (14pt) contínuo para cards com padding e botões retangulares, `{rounded.md}` (10pt) para superfícies compactas e inputs, `{rounded.capsule}` para qualquer coisa que leia como token (chips, toasts, badges, pílulas).
- Defina todo texto por um papel de `DSTypography` para que o Dynamic Type continue funcionando; reserve `{typography.display}` para uma palavra-herói que já preenche a tela.
- Dê aos botões `minHeight` (50 / 56 / 44pt) em vez de altura fixa, e ao texto de resultado `minimumScaleFactor(0.5)`.
- Mantenha a `DSScreen` transparente e pinte o canvas a partir do host — `{colors.background}` chapado, `{component.atmospheric-background}`, ou `.dsGroupedCanvas()` para telas de ajustes.
- Use `{colors.hairline}` para todo contorno de repouso e `Color.surface(level:)` para todo fundo de superfície; leia `dsSurfaceLevel` em views customizadas que pintam superfície.
- Prefira `button-pill-outlined` a `button-pill-secondary` quando o botão estiver sobre foto ou fundo atmosférico.
- Confirme ações destrutivas no ponto de chamada (`DSDestructiveButton`, `DSListInput.onClearRequested`).
- Passe `LocalizedStringKey` para qualquer texto estático para que o String Catalog do host o capture; mantenha conteúdo dinâmico (um nome sorteado) como `String`.
- Envolva glass em `GlassGroup` quando várias formas `glassFloat` ficarem juntas, e deixe os fallbacks embutidos cuidarem do iOS 17–18.

### Não faça
- Não hardcode `.indigo`, `.blue` ou `Color.accentColor` num componente — leia `theme.primary` (a única exceção existente, `{component.pro-badge}`, está listada em Lacunas conhecidas).
- Não adicione sombras mais fortes que `{shadow.card}` a superfícies utilitárias; a hierarquia vem do tom de `{colors.surface}` e de hairlines, sombra é desempate.
- Não introduza uma segunda cor de marca dentro do DSKit; `{colors.accent-secondary}` é um slot para os apps hospedeiros, não um padrão.
- Não use `cornerRadius` circular — todo retângulo arredondado é `.continuous`.
- Não use `.system(size:)` para texto; tamanhos fixos são só para glifos de SF Symbol.
- Não use peso 500. A escada é 400 / 600 / 700; ênfase secundária vem do preenchimento, não do peso.
- Não recalcule `Color.border.opacity(0.5)` inline nem troque de cor por `colorScheme` — o `{colors.hairline}` já faz isso.
- Não coloque `Color.surface` direto num fundo `Color.backgroundGrouped`; use `.dsGroupedCanvas()` para que as células subam para `surface-elevated`.
- Não pinte fundo dentro da `DSScreen` ou do conteúdo de um `DSCard`; superfícies são trabalho do componente, canvas é trabalho do host.
- Não anime com durações ad hoc; escolha entre `{motion.*}`. Não faça loop em efeitos de SF Symbol.
- Não dispare haptics sem a guarda `if: hapticsEnabled`, e não empilhe mais de um por interação.
- Não coloque lógica de sorteio / parse / armazenamento no pacote; o DSKit é só UI. O `DSListInput` expõe `lines` / `itemCount` / `duplicateCount` como conveniências e nada mais.

## Comportamento responsivo

### Plataformas e size classes
O DSKit tem como alvo iOS 17+ em iPhone e iPad. Não há breakpoints de largura; o layout se adapta pelos mecanismos do próprio SwiftUI:

| Contexto | Comportamento |
|---|---|
| Largura compacta (iPhone em retrato) | `DSScreen` em coluna única; `{component.adaptive-grid}` rende 1–2 colunas com mínimo de 160pt |
| Largura regular (iPhone em paisagem, iPad) | Mesmo chassi de tela; o grid cresce para 3+ colunas; cards esticam à largura total a menos que o host limite `maxWidth` |
| Multitarefa no iPad / Stage Manager | O grid recalcula a cada mudança de tamanho; `{component.paged-scroll}` redimensiona as páginas para a nova geometria |
| iOS 26+ | Superfícies Liquid Glass ligam; `scrollEdgeHard` e `glassTabBarMinimize` ficam ativos |

### Dynamic Type
Todo papel exceto `{typography.display}` escala de xSmall até AX5. Botões crescem com o rótulo porque a altura é `minHeight`; rows e cards crescem com o conteúdo; o `DSResultCard` encolhe o resultado único até 50% antes de quebrar para uma segunda linha. Glifos de ícone ficam em tamanho fixo por design, para que tiles e chevrons mantenham as proporções.

### Alvos de toque
- Mínimo de 44 × 44pt. `{component.button-icon-*}` tem exatamente 44pt; o `DSChip` chega a ~44pt via 14pt de padding vertical; botões retangulares têm ≥ 50pt; botões pílula ≥ 56pt.
- `DSSettingsRow` e `DSToggleRow` estendem `contentShape(Rectangle())` por toda a largura, então a row inteira é tocável.
- O `DSColorSwatch` tem 56pt (64pt com o anel).

### Acessibilidade
- Reduce Motion suprime a escala de pressionar no `DSPressableButtonStyle` e a animação de preenchimento do `{component.progress-bar}`.
- Componentes compostos (`feature-card`, `plan-card`, `result-card`, `toggle-row`, `settings-row` com ação, as views de estado, `toast`) combinam os filhos em um único elemento de VoiceOver; estados selecionados adicionam `.isSelected`, carregamento adiciona `.updatesFrequently`.
- O `DSIconButton` exige rótulo de acessibilidade no init. `DSAccessibility.combinedLabel` e `.dsAccessibleCard(label:hint:)` ajudam os apps hospedeiros a fazer o mesmo em cards customizados.
- A seleção de chip carrega um sinal além da cor (a borda mais o checkmark); erros de input carregam glifo mais texto, não só uma borda vermelha.

### Teclado
`DSListInput` e `DSNumberField` instalam um acessório `Done` na toolbar do teclado enquanto estão em foco. A ação inferior da `DSScreen` é um `safeAreaInset`, então o CTA primário sobe acima do teclado em vez de ser coberto.

## Guia de iteração

1. Foque em UM componente por vez. Referencie sua chave YAML (`{component.card-default}`, `{component.list-input}`) e seu tipo Swift (`DSCard`, `DSListInput`).
2. Variantes de estado vivem como entradas separadas (`-selected`, `-focus`, `-error`, `-disabled`, `-loading`, `-subtle`). Só entradas de padrão e de estado — hover não existe no iOS.
3. Use `{token.refs}` e receitas de alpha em tudo; nunca um hex inline. Uma cor nova é um `.colorset` novo com valores claro e escuro mais um token `Color`.
4. Componentes novos leem `@Environment(\.dsTheme)` para o tint e `@Environment(\.dsHapticsEnabled)` antes de disparar haptics, usam `DSPressableButtonStyle` se forem tocáveis, e trazem um `#Preview` no mesmo arquivo.
5. Todo texto passa por um papel de `DSTypography`. Todo canto é `.continuous`. Toda sombra é um preset `DSShadow` aplicado via `.dsShadow(_:)`.
6. Mudanças de API precisam ser aditivas e retrocompatíveis; vários apps consomem este pacote. Deprecie (como com `.microToolsTheme`) em vez de remover.
7. Na dúvida sobre ênfase: mude o tom da superfície ou adicione uma hairline antes de adicionar sombra; adicione uma lavagem antes de adicionar um preenchimento.

## Lacunas conhecidas

- `{colors.on-accent}` está declarado e é sobrescrevível, mas `DSPrimaryButton`, `DSPillButton`, `DSIconButton(.filled)`, `DSOptionChip`, `DSToast`, tiles de ícone e `DSProBadge` pintam `.white` literal. Um app hospedeiro que defina um accent claro e um on-accent escuro não vai vê-lo aplicado dentro do DSKit.
- O `{component.pro-badge}` lê o `Color.accentColor` do SwiftUI (o `.tint` definido por `.dsTheme`) em vez de `theme.primary`; na prática segue o tema, mas por um caminho diferente de todos os outros componentes.
- Vários tokens estão declarados para os apps hospedeiros e não são usados por nenhum componente: `{colors.accent-secondary}`, `{colors.accent-wash}`, `{colors.on-surface-light}`, `{colors.info-*}`, as lavagens `{colors.*-light}`, `{colors.disabled}` / `{colors.on-disabled}`, `{rounded.xl}`, `{shadow.floating}`, `{motion.short}` e `{motion.emphasized}`. Eles definem intenção, não uso atual.
- `dsSurfaceLevel` só distingue nível 0 de "≥ 1"; não existe um terceiro degrau. Uma superfície dentro de uma superfície dentro de outra recebe o mesmo `{colors.surface-elevated}` da camada do meio.
- `DSPillButton.outlined` existe, mas `DSSecondaryButton` (o retangular) não tem variante outlined equivalente.
- Alguns tamanhos ignoram as escalas de propósito (14pt de padding no chip, 10pt de padding em input, tiles de ícone de 28pt / 44pt, hairlines de 0.5pt e 0.75pt). Estão documentados aqui mas não viraram token.
- `DSTypography.family` é um static global sem sincronização; precisa ser definido uma vez antes da primeira renderização. Mudar em tempo de execução não é suportado.
- Os line heights na tabela de tipografia são os padrões do sistema para cada text style; o SwiftUI não expõe override de leading, então uma família customizada os herda.
- Os parâmetros do Liquid Glass (variante de vidro, tint, interatividade) estão documentados por comportamento; blur e refração exatos são definidos pela plataforma no iOS 26 e não viraram token.
- Os previews de tela compostos (`RandomPickerHomePreview`, `NamePickerScreenPreview`, `PaywallScreenPreview`, …) demonstram composições reais, mas são só `#if DEBUG` e não fazem parte da API pública.
