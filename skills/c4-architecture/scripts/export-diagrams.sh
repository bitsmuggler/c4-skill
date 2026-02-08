#!/usr/bin/env bash
#
# Export Structurizr DSL workspace to diagrams using Structurizr vNext.
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
# Prerequisites (one of):
#   - Structurizr WAR:  Download from https://docs.structurizr.com/binaries
#   - Docker:           docker pull structurizr/structurizr
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

mkdir -p "$OUTPUT_DIR"

# Locate the Structurizr WAR file (check common locations)
find_war() {
    local candidates=(
        "./structurizr.war"
        "./structurizr-*.war"
        "$HOME/structurizr.war"
        "$HOME/structurizr-*.war"
    )
    for pattern in "${candidates[@]}"; do
        # shellcheck disable=SC2086
        for f in $pattern; do
            if [[ -f "$f" ]]; then
                echo "$f"
                return 0
            fi
        done
    done
    return 1
}

# Try WAR file first, fall back to Docker
STRUCTURIZR_WAR="${STRUCTURIZR_WAR:-}"

if [[ -n "$STRUCTURIZR_WAR" && -f "$STRUCTURIZR_WAR" ]]; then
    echo "Using Structurizr WAR at $STRUCTURIZR_WAR..."
    java -jar "$STRUCTURIZR_WAR" export \
        -workspace "$WORKSPACE" \
        -format "$FORMAT" \
        -output "$OUTPUT_DIR"

elif STRUCTURIZR_WAR="$(find_war)"; then
    echo "Found Structurizr WAR at $STRUCTURIZR_WAR..."
    java -jar "$STRUCTURIZR_WAR" export \
        -workspace "$WORKSPACE" \
        -format "$FORMAT" \
        -output "$OUTPUT_DIR"

elif command -v docker &>/dev/null; then
    echo "No WAR file found, using Docker (structurizr/structurizr)..."
    WORKSPACE_ABS="$(cd "$(dirname "$WORKSPACE")" && pwd)/$(basename "$WORKSPACE")"
    OUTPUT_ABS="$(mkdir -p "$OUTPUT_DIR" && cd "$OUTPUT_DIR" && pwd)"

    docker run --rm \
        -v "$(dirname "$WORKSPACE_ABS"):/usr/local/structurizr" \
        -v "$OUTPUT_ABS:/usr/local/structurizr/output" \
        structurizr/structurizr \
        export \
        -workspace "/usr/local/structurizr/$(basename "$WORKSPACE")" \
        -format "$FORMAT" \
        -output "/usr/local/structurizr/output"
else
    echo "Error: No Structurizr binary found."
    echo ""
    echo "Install one of:"
    echo "  1. Download the WAR from https://docs.structurizr.com/binaries"
    echo "     Then: export STRUCTURIZR_WAR=/path/to/structurizr.war"
    echo "  2. Docker: docker pull structurizr/structurizr"
    exit 1
fi

echo ""
echo "Diagrams exported to: $OUTPUT_DIR/"
ls -la "$OUTPUT_DIR/"
