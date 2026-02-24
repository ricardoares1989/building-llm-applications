#!/bin/bash
CHAPTER_DIR="/workspaces/${localWorkspaceFolderBasename}/ch04"
cd "$CHAPTER_DIR"
[ -d ".venv" ] && . .venv/bin/activate && echo "✅ Ambiente activo"
