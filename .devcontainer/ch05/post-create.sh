#!/bin/bash
set -e

CHAPTER_DIR="/workspaces/${localWorkspaceFolderBasename}"
CHAPTER_DIR="${CHAPTER_DIR}/ch05"

cd "$CHAPTER_DIR"
echo "📂 Working in: $(pwd)"

echo "📦 Creando venv..."
uv venv

echo "📥 Instalando dependencias..."
. .venv/bin/activate
if [ -f "requirements.txt" ]; then
    uv pip install -r requirements.txt
else
    echo "⚠️  No requirements.txt found"
fi

echo "✅ Setup completo!"
