#!/bin/bash
# Wrapper — detecta SO y ejecuta el script correcto
set -e

OS=$(uname -s)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$OS" in
  Linux*|Darwin*)
    echo "Detectado: $OS"
    bash "$SCRIPT_DIR/install/linux.sh"
    ;;
  MINGW*|CYGWIN*|MSYS*)
    echo "Detectado: Windows (Git Bash)"
    echo "Segui las instrucciones en install/windows.md"
    echo "O abri OpenCode en esta carpeta y decile: 'Instalate el sistema de este repo'"
    ;;
  *)
    echo "SO no reconocido: $OS"
    echo "Proba con: bash install/linux.sh"
    ;;
esac
