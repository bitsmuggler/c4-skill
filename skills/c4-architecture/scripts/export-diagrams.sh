#!/usr/bin/env bash
#
# Export Structurizr DSL workspace to diagrams and render to images.
# Requires Docker.
#
# Usage:
#   ./export-diagrams.sh <workspace.dsl> [format] [output-dir]
#
# Arguments:
#   workspace.dsl   Path to the Structurizr DSL file (required)
#   format          Export format (default: plantuml/c4plantuml)
#                   Supported: plantuml, plantuml/c4plantuml, mermaid, json
#   output-dir      Output directory for generated files (default: ./diagrams)
#
# Prerequisites:
#   Docker: docker pull structurizr/structurizr
#
# See: https://docs.structurizr.com/export

set -euo pipefail

WORKSPACE="${1:?Usage: export-diagrams.sh <workspace.dsl> [format] [output-dir]}"
FORMAT="${2:-plantuml/c4plantuml}"
OUTPUT_DIR="${3:-./diagrams}"

if [[ ! -f "$WORKSPACE" ]]; then
    echo "Error: Workspace file '$WORKSPACE' not found."
    exit 1
fi

if ! command -v docker &>/dev/null; then
    echo "Error: Docker is not installed."
    echo "Install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! docker info &>/dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

WORKSPACE_ABS="$(cd "$(dirname "$WORKSPACE")" && pwd)/$(basename "$WORKSPACE")"
OUTPUT_ABS="$(cd "$OUTPUT_DIR" && pwd)"

# Step 1: Export DSL to PlantUML/Mermaid
echo "Exporting workspace to $FORMAT..."
docker run --rm \
    -v "$(dirname "$WORKSPACE_ABS"):/usr/local/structurizr" \
    structurizr/structurizr \
    export \
    -workspace "/usr/local/structurizr/$(basename "$WORKSPACE")" \
    -format "$FORMAT" \
    -output "/usr/local/structurizr/$(realpath --relative-to="$(dirname "$WORKSPACE_ABS")" "$OUTPUT_ABS" 2>/dev/null || echo "diagrams")"

# Step 2: Render to PNG if PlantUML format was used
if [[ "$FORMAT" == plantuml* ]]; then
    echo "Rendering PlantUML diagrams to PNG..."
    docker run --rm \
        -v "$OUTPUT_ABS:/data" \
        plantuml/plantuml \
        -tpng "/data/*.puml"
    echo ""
    echo "PNG images rendered."
fi

echo ""
echo "Diagrams exported to: $OUTPUT_DIR/"
ls -la "$OUTPUT_DIR/"
