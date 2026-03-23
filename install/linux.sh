#!/bin/bash
# ============================================================
# OpenCode — Vibecoding Agent System
# 22 agentes + 1 referencia (Better Auth) | Pipeline de 5 fases
# Instalacion automatica para Linux / macOS
# ============================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[X]${NC} $1"; exit 1; }

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  OpenCode — Vibecoding Agent System${NC}"
echo -e "${CYAN}  22 agentes + Better Auth ref${NC}"
echo -e "${CYAN}  Instalacion automatica (Linux/macOS)${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# -- 0. Detectar directorio raiz del repo --
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# -- 1. Verificar dependencias basicas --
for cmd in git curl; do
  command -v $cmd &>/dev/null || error "$cmd no esta instalado. Instalalo primero."
done
info "Dependencias basicas: git, curl"

# -- 2. Instalar Node.js si no esta --
if ! command -v node &>/dev/null; then
  warn "Node.js no encontrado. Instalando via NodeSource (LTS)..."
  if command -v apt-get &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
  elif command -v brew &>/dev/null; then
    brew install node
  else
    error "No se pudo instalar Node.js automaticamente. Instala manualmente desde https://nodejs.org"
  fi
  info "Node.js: $(node --version)"
else
  info "Node.js: $(node --version)"
fi

# -- 3. Instalar OpenCode si no esta --
if ! command -v opencode &>/dev/null; then
  warn "OpenCode no encontrado. Instalando..."
  if command -v brew &>/dev/null; then
    brew install opencode-ai/tap/opencode
  else
    curl -fsSL https://opencode.ai/install | bash
  fi
  info "OpenCode instalado"
else
  info "OpenCode: $(opencode --version 2>/dev/null | head -1 || echo 'instalado')"
fi

# -- 4. Instalar Engram si no esta --
if ! command -v engram &>/dev/null; then
  warn "Engram no encontrado. Instalando..."
  # Try go install first
  if command -v go &>/dev/null; then
    go install github.com/gentleman-programming/engram@latest
    info "Engram instalado via Go"
  else
    # Download binary from GitHub releases
    ENGRAM_URL="https://github.com/Gentleman-Programming/engram/releases/latest/download/engram-linux-amd64"
    mkdir -p ~/bin
    curl -fsSL "$ENGRAM_URL" -o ~/bin/engram
    chmod +x ~/bin/engram
    export PATH="$HOME/bin:$PATH"
    info "Engram instalado en ~/bin/engram"
    warn "Agrega ~/bin a tu PATH si no esta: export PATH=\"\$HOME/bin:\$PATH\""
  fi
else
  info "Engram: instalado"
fi

# -- 5. Instalar Vercel CLI --
if ! command -v vercel &>/dev/null; then
  warn "Vercel CLI no encontrado. Instalando..."
  npm install -g vercel
  info "Vercel CLI instalado"
else
  info "Vercel CLI: $(vercel --version 2>/dev/null | head -1)"
fi

# -- 6. Instalar gh CLI si no esta --
if ! command -v gh &>/dev/null; then
  warn "gh CLI no encontrado. Instalando..."
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -y gh
  elif command -v brew &>/dev/null; then
    brew install gh
  else
    warn "Instala gh CLI manualmente: https://cli.github.com"
  fi
  info "gh CLI instalado"
else
  info "gh CLI: $(gh --version | head -1)"
fi

# -- 7. Pedir datos del usuario --
echo ""
echo "Necesito algunos datos para configurar git y GitHub."
echo ""

read -p "  Tu nombre (aparece en los commits): " GIT_NAME
while [[ -z "$GIT_NAME" ]]; do
  read -p "  Nombre no puede estar vacio: " GIT_NAME
done

read -p "  Tu email de GitHub: " GIT_EMAIL
while [[ -z "$GIT_EMAIL" ]]; do
  read -p "  Email no puede estar vacio: " GIT_EMAIL
done

# -- 8. Configurar git global --
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
info "Git configurado: $GIT_NAME <$GIT_EMAIL>"

# -- 9. Copiar agentes a ~/.config/opencode/agents/ --
OPENCODE_AGENTS="$HOME/.config/opencode/agents"
mkdir -p "$OPENCODE_AGENTS"

cp "$REPO_ROOT/agents/"*.md "$OPENCODE_AGENTS/"

AGENT_COUNT=$(ls "$OPENCODE_AGENTS/"*.md 2>/dev/null | wc -l)
info "Agentes instalados en $OPENCODE_AGENTS ($AGENT_COUNT archivos)"

# -- 10. Copiar opencode.json global --
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"

if [[ -f "$OPENCODE_CONFIG" ]]; then
  cp "$OPENCODE_CONFIG" "$OPENCODE_CONFIG.bak"
  warn "opencode.json existente respaldado en $OPENCODE_CONFIG.bak"
fi
cp "$REPO_ROOT/opencode.json" "$OPENCODE_CONFIG"

# Fix agent prompt paths to use global location
sed -i "s|{file:./agents/|{file:$OPENCODE_AGENTS/|g" "$OPENCODE_CONFIG"

info "opencode.json instalado (22 agentes + Engram MCP)"

# -- 11. Copiar AGENTS.md global --
AGENTS_MD="$HOME/.config/opencode/AGENTS.md"
if [[ -f "$AGENTS_MD" ]]; then
  cp "$AGENTS_MD" "$AGENTS_MD.bak"
  warn "AGENTS.md existente respaldado"
fi
cp "$REPO_ROOT/AGENTS.md" "$AGENTS_MD"
info "AGENTS.md global instalado (instrucciones del sistema)"

# -- 12. Autenticar gh CLI --
echo ""
warn "Necesitas autenticar GitHub CLI."
read -p "  Presiona Enter para continuar (o Ctrl+C para saltar)..."
gh auth login --web -p https || warn "Autenticacion saltada. Correr 'gh auth login' despues."

# -- 13. Autenticar Vercel --
echo ""
warn "Necesitas autenticar Vercel para publicar proyectos."
read -p "  Presiona Enter para continuar (o Ctrl+C para saltar)..."
vercel login || warn "Autenticacion de Vercel saltada. Correr 'vercel login' despues."

# -- Resumen --
echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Instalacion completada${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
info "Git:       $GIT_NAME <$GIT_EMAIL>"
info "OpenCode:  instalado"
info "Engram:    configurado como MCP server"
info "Agentes:   $OPENCODE_AGENTS ($AGENT_COUNT archivos)"
info "Config:    $OPENCODE_CONFIG"
info "AGENTS.md: $AGENTS_MD"
echo ""
echo "Para empezar, abri OpenCode y escribi:"
echo "  /pipeline [tu idea]"
echo ""
echo "O para usar el modo normal, simplemente habla con OpenCode."
echo "Para activar el pipeline manualmente:"
echo "  @orquestador quiero crear [tu idea]"
echo ""
echo "Slash commands disponibles:"
echo "  /pipeline [idea]    — Pipeline completo de 5 fases"
echo "  /retomar [proyecto] — Retomar proyecto existente"
echo "  /certificar         — Ejecutar certificacion (Fase 4)"
echo ""
