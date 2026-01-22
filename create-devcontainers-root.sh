#!/bin/bash
# create-devcontainers-simple.sh

CHAPTERS=("ch01" "ch02" "ch04" "ch05" "ch06")

# Configuración por capítulo
declare -A CHAPTER_CPUS
declare -A CHAPTER_MEMORY

# Notebooks ligeros
CHAPTER_CPUS["ch01"]=2
CHAPTER_MEMORY["ch01"]="4gb"
CHAPTER_CPUS["ch02"]=2
CHAPTER_MEMORY["ch02"]="4gb"
CHAPTER_CPUS["ch06"]=2
CHAPTER_MEMORY["ch06"]="4gb"

# APIs/LangChain
CHAPTER_CPUS["ch04"]=4
CHAPTER_MEMORY["ch04"]="8gb"
CHAPTER_CPUS["ch05"]=4
CHAPTER_MEMORY["ch05"]="8gb"

mkdir -p .devcontainer

for chapter in "${CHAPTERS[@]}"; do
    echo "🔧 Configurando ${chapter} (${CHAPTER_CPUS[$chapter]}-core, ${CHAPTER_MEMORY[$chapter]})..."

    mkdir -p ".devcontainer/${chapter}"

    cat > ".devcontainer/${chapter}/devcontainer.json" << EOF
{
  "name": "Chapter ${chapter#ch} - Python Development",
  "image": "mcr.microsoft.com/devcontainers/python:3.11",

  "hostRequirements": {
    "cpus": ${CHAPTER_CPUS[$chapter]},
    "memory": "${CHAPTER_MEMORY[$chapter]}",
    "storage": "32gb"
  },

  "workspaceFolder": "/workspaces/\${localWorkspaceFolderBasename}/${chapter}",

  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },

  "postCreateCommand": "bash -c 'pip install uv && cd /workspaces/\${localWorkspaceFolderBasename}/${chapter} && uv venv && source .venv/bin/activate && uv pip install -r requirements.txt && echo \"✅ ${chapter} setup completo!\"'",

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
        "ms-toolsai.jupyter",
        "usernamehw.errorlens",
        "tamasfe.even-better-toml",
        "humao.rest-client"
      ],
      "settings": {
        "python.defaultInterpreterPath": "\${containerWorkspaceFolder}/.venv/bin/python",
        "python.terminal.activateEnvironment": true,
        "python.terminal.activateEnvInCurrentTerminal": true,
        "editor.formatOnSave": true,
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
        "terminal.integrated.cwd": "\${containerWorkspaceFolder}"
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
    "UV_CACHE_DIR": "\${containerWorkspaceFolder}/.uv-cache"
  }
}
EOF

    echo "✅ ${chapter} configurado"
done

echo ""
echo "✅ Configuración completa!"
echo ""
echo "📊 Recursos asignados:"
echo "  ch01, ch02, ch06: 2-core, 4GB"
echo "  ch04, ch05: 4-core, 8GB"
echo ""
echo "Siguiente paso:"
echo "git add .devcontainer/"
echo "git commit -m 'Add simplified devcontainer configs'"
echo "git push"
