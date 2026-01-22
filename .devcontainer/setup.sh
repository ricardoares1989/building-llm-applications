#!/bin/bash
set -e

echo "🚀 Configurando ambiente Python con uv..."

# Instalar uv
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.cargo/bin:$PATH"

echo "✅ uv instalado: $(uv --version)"

# Crear virtual environment si no existe
if [ ! -d ".venv" ]; then
    echo "📦 Creando virtual environment..."
    uv venv
fi

# Activar virtual environment
source .venv/bin/activate

# Instalar dependencias
if [ -f "pyproject.toml" ]; then
    echo "📥 Instalando dependencias desde pyproject.toml..."
    uv sync
elif [ -f "requirements.txt" ]; then
    echo "📥 Instalando dependencias desde requirements.txt..."
    uv pip install -r requirements.txt
else
    echo "⚠️  No se encontró pyproject.toml ni requirements.txt"
    echo "💡 Creando proyecto nuevo con uv..."
    uv init
fi

echo "✅ Ambiente Python listo!"
echo ""
echo "📝 Comandos útiles:"
echo "  uv add <paquete>      - Agregar dependencia"
echo "  uv run python main.py - Ejecutar script"
echo "  uv run pytest         - Ejecutar tests"
