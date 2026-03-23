# OpenCode Vibecoding

Un equipo de 22 agentes de IA que convierte tus ideas en aplicaciones listas para produccion. Vos describis lo que queres, ellos planifican, disenan, programan, testean y publican.

**No necesitas saber programar.** El sistema maneja todo el proceso con un pipeline profesional de 5 fases y te pide aprobacion solo en los momentos clave.

Adaptado para **OpenCode** (CLI open-source). Compatible con **Linux**, **macOS** y **Windows**.

> Fork del sistema [claude-vibecoding](https://github.com/Emaleo0522/claude-vibecoding), adaptado para funcionar con OpenCode en vez de Claude Code/Desktop.

---

## Por que OpenCode

| Feature | Claude Code | OpenCode |
|---------|------------|----------|
| Subagentes | Bloqueante (Agent tool) | Async + budget limits + jerarquia |
| Modelos | Solo Claude | 75+ (Claude, GPT, Gemini, local) |
| Slash commands | No | Nativos (`/pipeline`, `/retomar`) |
| Open source | No | Si (MIT) |
| MCP servers | Soportado | Soportado (mismo protocolo) |
| Custom tools | Limitado | JavaScript/TypeScript extensible |

**Lo que funciona igual**: Engram (memoria), context management, DAG State, pipeline de 5 fases, 22 agentes especializados, Return Envelope, proactive saves.

---

## Instalacion

### Opcion 1: Decile a OpenCode que se instale

Abri OpenCode en la carpeta del repo clonado:

```
Instala el sistema vibecoding siguiendo install/linux.sh o install/windows.md
```

### Opcion 2: Instalacion automatica (Linux/macOS)

```bash
git clone https://github.com/Emaleo0522/opencode-vibecoding.git
cd opencode-vibecoding
bash install/linux.sh
```

### Opcion 3: Instalacion manual (Windows)

```bash
git clone https://github.com/Emaleo0522/opencode-vibecoding.git
cd opencode-vibecoding
```

Segui la guia paso a paso en [`install/windows.md`](install/windows.md).

---

## Uso

**Modo normal** — OpenCode responde como siempre.

**Modo pipeline** — Los 22 agentes construyen tu proyecto:

```
/pipeline quiero crear una app de delivery para mi barrio
```

O invocando al orquestador directamente:
```
@orquestador quiero crear una landing page para mi startup
```

### Slash commands

| Comando | Que hace |
|---------|---------|
| `/pipeline [idea]` | Pipeline completo de 5 fases |
| `/retomar [proyecto]` | Retomar proyecto existente |
| `/certificar` | Ejecutar certificacion (Fase 4) |

### Delegacion a agentes

Podes invocar agentes directamente:
```
@frontend-developer implementa el componente de login
@evidence-collector valida la tarea 3
@seo-discovery audita el SEO del proyecto
```

---

## Que puede construir

| Tipo | Ejemplo | Stack tipico |
|------|---------|-------------|
| Landing page | Portfolio, restaurante | Vite + React + Tailwind |
| App web | Dashboard, SaaS | Next.js + Hono + PostgreSQL |
| App mobile | iOS + Android | React Native + Expo |
| Juego browser | Platformer, puzzle | Phaser.js + TypeScript |
| API | REST, GraphQL | Hono + Drizzle + tRPC |

---

## Pipeline

```
Tu idea
  |
  v
FASE 1 — Planificacion
  @project-manager-senior --> tareas con criterios de aceptacion
  |
  v
FASE 2 — Arquitectura
  @ux-architect      --> fundacion CSS, tokens (PRIMERO)
  @ui-designer       --> design system, WCAG AA
  @security-engineer --> threat model, OWASP
  |
  v
FASE 2B — Assets creativos (opcional)
  @brand-agent  --> identidad de marca
  @image-agent  --> hero images
  @logo-agent   --> logos SVG
  @video-agent  --> videos de fondo
  |
  v
FASE 3 — Desarrollo + QA
  @dev-agent --> implementa --> @evidence-collector valida
  (hasta 3 reintentos con feedback especifico)
  |
  v
FASE 4 — Certificacion
  @seo-discovery           --> SEO + AI discovery
  @api-tester              --> OWASP API Top 10
  @performance-benchmarker --> Core Web Vitals
  @reality-checker         --> gate final
  |
  v
FASE 5 — Publicacion (con confirmacion)
  @git      --> commit + push
  @deployer --> deploy a Vercel
```

---

## Los 22 agentes

| Fase | Agente | Que hace |
|:----:|--------|---------|
| 1 | `project-manager-senior` | Convierte tu idea en tareas concretas |
| 2 | `ux-architect` | Base CSS: tokens, layout, tema claro/oscuro |
| 2 | `ui-designer` | Componentes visuales, accesibilidad WCAG AA |
| 2 | `security-engineer` | Amenazas y headers de seguridad |
| 2B | `brand-agent` | Identidad de marca: paleta, tipografia, tono |
| 2B | `image-agent` | Imagenes con IA (Gemini o HuggingFace) |
| 2B | `logo-agent` | Logos SVG vectorizados |
| 2B | `video-agent` | Videos de fondo (o CSS fallback) |
| 3 | `frontend-developer` | React, Tailwind, shadcn/ui |
| 3 | `backend-architect` | APIs, DB, autenticacion |
| 3 | `rapid-prototyper` | MVPs rapidos |
| 3 | `mobile-developer` | React Native + Expo |
| 3 | `game-designer` | Game Design Document |
| 3 | `xr-immersive-developer` | Phaser.js, PixiJS, Three.js |
| 3 | `evidence-collector` | QA visual, screenshots 3 dispositivos |
| 4 | `seo-discovery` | SEO + visibilidad en IAs |
| 4 | `api-tester` | OWASP API Top 10, latencia P95 |
| 4 | `performance-benchmarker` | Core Web Vitals, bundles |
| 4 | `reality-checker` | Auditoria final (default: NEEDS WORK) |
| 5 | `git` | Commit + push a GitHub |
| 5 | `deployer` | Deploy a Vercel |
| * | `orquestador` | Coordina todo, nunca programa |

---

## Memoria y continuidad

El sistema no pierde tu progreso. Podes cerrar OpenCode, apagar la PC, y retomar manana:

```
/retomar mi-proyecto
```

**Como funciona:**
- **Engram**: memoria persistente que sobrevive entre sesiones
- **DAG State**: snapshot del progreso despues de cada tarea completada
- **Boot Sequence**: al iniciar, busca automaticamente proyectos en curso
- **Dual-write**: datos criticos en Engram + disco como respaldo
- **Proactive saves**: descubrimientos importantes se guardan inmediatamente

---

## Multi-modelo

OpenCode permite usar diferentes modelos para diferentes agentes. Por defecto usa Claude Sonnet, pero podes cambiar en `opencode.json`:

```json
{
  "agent": {
    "orquestador": { "model": "anthropic/claude-sonnet-4-5" },
    "frontend-developer": { "model": "anthropic/claude-sonnet-4-5" },
    "git": { "model": "anthropic/claude-haiku-4-5" }
  }
}
```

Modelos soportados: Claude (Opus/Sonnet/Haiku), GPT-4o/5, Gemini, Groq, Mistral, modelos locales via Ollama, y mas.

---

## Assets creativos (Fase 2B)

| Variable | Servicio | Costo |
|----------|----------|-------|
| `GEMINI_API_KEY` | [Google AI Studio](https://aistudio.google.com/apikey) | ~$0.02-0.04/img |
| `HF_TOKEN` | [HuggingFace](https://huggingface.co/settings/tokens) | Gratis |
| `REPLICATE_API_TOKEN` | [Replicate](https://replicate.com/account/api-tokens) | ~$0.05/video |

Opcional. Sin keys, el pipeline salta la Fase 2B.

---

## Servicios

| Servicio | Para que | Config |
|----------|---------|--------|
| **Engram** | Memoria persistente | MCP en opencode.json |
| **Context7** | Docs actualizados | MCP en opencode.json |
| **Vercel CLI** | Deploy | `npm i -g vercel && vercel login` |
| **GitHub CLI** | Git | `gh auth login` |

---

## Estructura del repo

```
opencode.json                   Config principal (agentes + MCPs + commands)
INSTRUCTIONS.md                 Instrucciones del sistema
AGENTS.md                       Instrucciones (formato nativo OpenCode)
agents/
  orquestador.md                Coordinador central
  project-manager-senior.md     Planificacion
  frontend-developer.md         UI web
  backend-architect.md          APIs y DB
  ... (22 agentes total)
  better-auth-reference.md      Guia de autenticacion
install/
  linux.sh                      Instalacion automatica (Linux/macOS)
  windows.md                    Guia paso a paso (Windows)
```

---

## Requisitos

| Plataforma | Necesitas |
|------------|-----------|
| Linux / macOS | OpenCode + Node.js (el script instala todo) |
| Windows | OpenCode (via choco/scoop/npm) + Node.js + Git |

**API Key**: necesitas al menos `ANTHROPIC_API_KEY` para usar Claude como modelo. OpenCode tambien soporta `OPENAI_API_KEY`, `GEMINI_API_KEY`, y modelos locales.

---

## Diferencias con la version Claude Code

| Aspecto | Claude Code version | OpenCode version |
|---------|-------------------|-----------------|
| Delegacion | `Agent tool` (bloqueante) | `@agent-name` (async) |
| Dev server | `preview_start` (Preview MCP) | `npm run dev` (bash) |
| QA visual | Playwright MCP nativo | Playwright CLI (`npx playwright`) |
| Config | `~/.claude/agents/` + `CLAUDE.md` | `~/.config/opencode/` + `AGENTS.md` |
| Modelos | Solo Claude | Multi-modelo |
| Commands | No | `/pipeline`, `/retomar`, `/certificar` |

---

## Creditos

- [claude-vibecoding](https://github.com/Emaleo0522/claude-vibecoding) — sistema original para Claude Code/Desktop
- [gentle-ai](https://github.com/Gentleman-Programming/gentle-ai) — SDD, Engram, context management patterns
- [OpenCode](https://opencode.ai) — CLI open-source para desarrollo con IA
