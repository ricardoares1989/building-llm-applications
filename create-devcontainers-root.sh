#!/bin/bash

CHAPTERS=("ch01" "ch02" "ch04" "ch05" "ch06")

mkdir -p .devcontainer

for chapter in "${CHAPTERS[@]}"; do
    echo "🔧 Configurando ${chapter}..."

    mkdir -p ".devcontainer/${chapter}"

    # devcontainer.json
    cat > ".devcontainer/${chapter}/devcontainer.json" << 'EOF'
{
  "name": "Python Development - CHAPTER_NAME",
  "image": "mcr.microsoft.com/devcontainers/python:3.11",

  "hostRequirements": {
    "cpus": 8,
    "memory": "32gb"
  },

  "workspaceFolder": "/workspaces/${localWorkspaceFolderBasename}/CHAPTER_NAME",

  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },

  "onCreateCommand": ".devcontainer/CHAPTER_NAME/on-create.sh",
  "postCreateCommand": ".devcontainer/CHAPTER_NAME/post-create.sh",
  "postStartCommand": ".devcontainer/CHAPTER_NAME/post-start.sh",

  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-python.debugpy",
        "charliermarsh.ruff",
        "ms-python.black-formatter",
        "github.copilot",
        "github.copilot-chat",
        "saoudrizwan.claude-dev",
        "continue.continue",
        "eamodio.gitlens",
        "ms-toolsai.jupyter"
      ],
      "settings": {
        "python.defaultInterpreterPath": "${containerWorkspaceFolder}/.venv/bin/python",
        "python.terminal.activateEnvironment": true,
        "editor.formatOnSave": true,
        "[python]": {
          "editor.defaultFormatter": "ms-python.black-formatter"
        }
      }
    }
  },

  "forwardPorts": [8000, 8888],

  "remoteEnv": {
    "PYTHONUNBUFFERED": "1"
  }
}
EOF

    # Reemplazar CHAPTER_NAME
    sed -i "s/CHAPTER_NAME/${chapter}/g" ".devcontainer/${chapter}/devcontainer.json"

    # on-create.sh
    cat > ".devcontainer/${chapter}/on-create.sh" << 'EOF'
#!/bin/bash
set -e
echo "🔧 Instalando uv..."
pip install uv
echo "✅ uv instalado"
EOF

    # post-create.sh
    cat > ".devcontainer/${chapter}/post-create.sh" << 'INNEREOF'
#!/bin/bash
set -e

CHAPTER_DIR="/workspaces/${localWorkspaceFolderBasename}"
CHAPTER_DIR="${CHAPTER_DIR}/CHAPTER_PLACEHOLDER"

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
INNEREOF

    sed -i "s/CHAPTER_PLACEHOLDER/${chapter}/g" ".devcontainer/${chapter}/post-create.sh"

    # post-start.sh
    cat > ".devcontainer/${chapter}/post-start.sh" << 'INNEREOF'
#!/bin/bash
CHAPTER_DIR="/workspaces/${localWorkspaceFolderBasename}/CHAPTER_PLACEHOLDER"
cd "$CHAPTER_DIR"
[ -d ".venv" ] && . .venv/bin/activate && echo "✅ Ambiente activo"
INNEREOF

    sed -i "s/CHAPTER_PLACEHOLDER/${chapter}/g" ".devcontainer/${chapter}/post-start.sh"

    # Permisos
    chmod +x ".devcontainer/${chapter}"/*.sh

    echo "✅ ${chapter} configurado"
done

echo ""
echo "✅ Configuración completa!"
echo ""
echo "Siguiente paso:"
echo "git add .devcontainer/"
echo "git commit -m 'Add working devcontainer configs'"
echo "git push"
