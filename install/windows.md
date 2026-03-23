# Instalacion en Windows — OpenCode

Guia paso a paso para instalar el sistema vibecoding con OpenCode en Windows.

---

## Lo que vas a instalar

- **22 agentes especializados + 1 referencia**: orquestador, PM, arquitectos, devs, QA, SEO, creativos, etc.
- **AGENTS.md global**: instrucciones del sistema para coordinar el pipeline
- **MCPs**: Engram (memoria persistente), Context7 (docs actualizados)
- **Node.js + npm**: para correr proyectos
- **Git + GitHub CLI**: para guardar y publicar codigo
- **Vercel CLI**: para publicar en internet

Tiempo estimado: 20-30 minutos.

---

## Paso 1: Instalar OpenCode

**Opcion A — Chocolatey** (si lo tenes):
```cmd
choco install opencode
```

**Opcion B — Scoop** (si lo tenes):
```cmd
scoop install opencode
```

**Opcion C — npm** (si tenes Node.js):
```bash
npm install -g opencode
```

**Opcion D — Go** (si tenes Go):
```bash
go install github.com/opencode-ai/opencode@latest
```

Verificar: `opencode --version`

---

## Paso 2: Instalar Node.js

1. Ir a [nodejs.org](https://nodejs.org)
2. Descargar la version **LTS**
3. Instalar con opciones por defecto
4. Verificar en terminal: `node --version` y `npm --version`

---

## Paso 3: Instalar Git para Windows

1. Ir a [git-scm.com/download/win](https://git-scm.com/download/win)
2. Descargar e instalar (opciones por defecto)
3. Verificar: `git --version`

---

## Paso 4: Instalar GitHub CLI

1. Ir a [cli.github.com](https://cli.github.com)
2. Descargar e instalar
3. Autenticarte:
   ```bash
   gh auth login
   ```
   Elegir: **GitHub.com** → **HTTPS** → **Login with a web browser**

---

## Paso 5: Instalar Vercel CLI

```bash
npm install -g vercel
vercel login
```

---

## Paso 6: Instalar Engram (memoria persistente)

1. Ir a [github.com/Gentleman-Programming/engram/releases](https://github.com/Gentleman-Programming/engram/releases)
2. Descargar `engram-windows-amd64.exe`
3. Crear carpeta y mover:
   ```bash
   mkdir -p ~/bin
   mv ~/Downloads/engram-windows-amd64.exe ~/bin/engram.exe
   ```

---

## Paso 7: Configurar git

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
git config --global init.defaultBranch main
```

---

## Paso 8: Copiar los 22 agentes

Desde la carpeta donde clonaste este repo:

```bash
# Crear carpeta de agentes
mkdir -p ~/.config/opencode/agents

# Copiar agentes
cp agents/*.md ~/.config/opencode/agents/

# Verificar
ls ~/.config/opencode/agents/ | wc -l
# Debe dar 23 (22 agentes + better-auth-reference.md)
```

---

## Paso 9: Instalar configuracion global

```bash
# Copiar opencode.json
cp opencode.json ~/.config/opencode/opencode.json

# Copiar instrucciones globales
cp AGENTS.md ~/.config/opencode/AGENTS.md
```

**Importante**: editar `~/.config/opencode/opencode.json` y actualizar las rutas de los agentes:
```bash
# Reemplazar rutas relativas por absolutas
sed -i "s|{file:./agents/|{file:$HOME/.config/opencode/agents/|g" ~/.config/opencode/opencode.json
```

Si `sed` no funciona en Windows, abri el archivo con un editor y reemplaza todas las ocurrencias de `{file:./agents/` por `{file:C:/Users/TU_USUARIO/.config/opencode/agents/`.

---

## Paso 10: Configurar Engram en opencode.json

Editar `~/.config/opencode/opencode.json` y verificar que la seccion MCP tenga la ruta correcta a Engram:

```json
"mcp": {
  "engram": {
    "type": "local",
    "command": ["C:\\Users\\TU_USUARIO\\bin\\engram.exe", "mcp", "--tools=agent"],
    "enabled": true
  }
}
```

---

## Paso 11: Verificar la instalacion

```bash
# OpenCode instalado
opencode --version

# Agentes (deben ser 23)
ls ~/.config/opencode/agents/*.md | wc -l

# Herramientas
git --version
node --version
gh --version
vercel --version
```

En OpenCode, escribi `@orquestador hola` — si responde describiendo el pipeline de 5 fases, todo funciona.

---

## Listo! Primer uso

**Modo normal** — simplemente habla con OpenCode.

**Modo pipeline** (proyecto completo):
```
/pipeline quiero crear una app de lista de tareas
```

O invocando directamente al orquestador:
```
@orquestador quiero crear una landing page para mi estudio de yoga
```

Slash commands disponibles:
```
/pipeline [idea]    — Pipeline completo de 5 fases
/retomar [proyecto] — Retomar proyecto existente
/certificar         — Ejecutar certificacion (Fase 4)
```

---

## Problemas frecuentes

**OpenCode no reconoce los agentes**
→ Verificar que `opencode.json` tiene las rutas correctas a los archivos .md

**Engram no conecta**
→ Verificar ruta al binario en la seccion `mcp` de `opencode.json`

**`@orquestador` no responde**
→ Verificar que el agente tiene `"mode": "primary"` en opencode.json

**Modelo no disponible**
→ Configurar `ANTHROPIC_API_KEY` como variable de entorno. OpenCode soporta Claude, GPT, Gemini y otros.
