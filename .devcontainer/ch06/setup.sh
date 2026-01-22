#!/bin/bash
set -e

# El workspace folder apunta a la carpeta del capítulo
cd /workspaces/${localWorkspaceFolderBasename}/${CHAPTER}

echo "🚀 Configurando ${CHAPTER}..."

# Instalar uv si no existe
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

echo "✅ uv instalado: $(uv --version)"

# Crear venv en la carpeta del capítulo
if [ ! -d ".venv" ]; then
    echo "📦 Creando virtual environment..."
    uv venv
fi

source .venv/bin/activate

# Instalar dependencias
if [ -f "requirements.txt" ]; then
    echo "📥 Instalando dependencias de ${CHAPTER}..."
    uv pip install -r requirements.txt
else
    echo "⚠️  No se encontró requirements.txt en ${CHAPTER}"
fi

echo ""
echo "✅ ${CHAPTER} listo!"
echo "📂 Working directory: $(pwd)"
echo ""
echo "🤖 AI Assistants disponibles:"
echo "  - GitHub Copilot (Tab para autocompletar)"
echo "  - Copilot Chat (Ctrl+I)"
echo "  - Claude/Cline (Sidebar)"
echo "  - Continue (Ctrl+L)"
echo ""
echo "📝 Archivos disponibles:"
ls -la *.py 2>/dev/null || ls -la *.ipynb 2>/dev/null || echo "  (ningún archivo Python/Jupyter)"
