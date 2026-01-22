#!/bin/bash
CHAPTER_DIR="/workspaces/${localWorkspaceFolderBasename}/ch02"
cd "$CHAPTER_DIR"
[ -d ".venv" ] && . .venv/bin/activate && echo "✅ Ambiente activo"
