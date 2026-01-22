#!/bin/bash
# create-devcontainers-root.sh

CHAPTERS=("ch01" "ch02" "ch04" "ch05" "ch06")

# Crear carpeta principal .devcontainer
mkdir -p .devcontainer

for chapter in "${CHAPTERS[@]}"; do
    echo "Configurando ${chapter}..."

    # Crear carpeta para este capítulo dentro de .devcontainer
    mkdir -p ".devcontainer/${chapter}"

    # Crear devcontainer.json
    cat > ".devcontainer/${chapter}/devcontainer.json" << EOF
{
  "name": "Chapter ${chapter#ch} - Python Development",
  "image": "mcr.microsoft.com/devcontainers/python:3.11",

  "hostRequirements": {
    "cpus": 8,
    "memory": "32gb",
    "storage": "32gb"
  },

  "workspaceFolder": "/workspaces/\${localWorkspaceFolderBasename}/${chapter}",

  "postCreateCommand": "bash /workspaces/\${localWorkspaceFolderBasename}/.devcontainer/${chapter}/setup.sh",

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
        "googlecloudtools.cloudcode",
        "eamodio.gitlens",
        "ms-toolsai.jupyter",
        "usernamehw.errorlens",
        "tamasfe.even-better-toml",
        "humao.rest-client"
      ],
      "settings": {
        "python.defaultInterpreterPath": "/workspaces/\${localWorkspaceFolderBasename}/${chapter}/.venv/bin/python",
        "python.terminal.activateEnvironment": true,
        "editor.formatOnSave": true,
        "editor.inlineSuggest.enabled": true,
        "[python]": {
          "editor.defaultFormatter": "ms-python.black-formatter",
          "editor.codeActionsOnSave": {
            "source.organizeImports": "explicit"
          }
        },
        "ruff.enable": true,
        "python.testing.pytestEnabled": true,
        "editor.rulers": [88],
        "files.trimTrailingWhitespace": true,
        "files.insertFinalNewline": true,
        "github.copilot.enable": {
          "*": true,
          "python": true,
          "jupyter": true
        },
        "terminal.integrated.cwd": "/workspaces/\${localWorkspaceFolderBasename}/${chapter}"
      }
    }
  },

  "forwardPorts": [8000, 8888],

  "portsAttributes": {
    "8000": {
      "label": "Application",
      "onAutoForward": "notify"
    },
    "8888": {
      "label": "Jupyter",
      "onAutoForward": "silent"
    }
  },

  "remoteEnv": {
    "PYTHONUNBUFFERED": "1",
    "PYTHONDONTWRITEBYTECODE": "1",
    "UV_CACHE_DIR": "/workspaces/\${localWorkspaceFolderBasename}/${chapter}/.uv-cache",
    "CHAPTER": "${chapter}"
  }
}
EOF

    # Crear setup.sh
    cat > ".devcontainer/${chapter}/setup.sh" << 'INNEREOF'
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
INNEREOF

    chmod +x ".devcontainer/${chapter}/setup.sh"
    echo "✅ ${chapter} configurado"
done

echo ""
echo "✅ Estructura creada en .devcontainer/"
echo ""
echo "📋 Commits necesarios:"
echo "git add .devcontainer/"
echo "git commit -m 'Add devcontainer configs for all chapters'"
echo "git push"
