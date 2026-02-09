# C4 Structurizr Plugin for Claude Code

A Claude Code plugin that analyses software architecture and generates [C4 model](https://c4model.com/) using the [Structurizr DSL](https://docs.structurizr.com/dsl/language).

## Features

- **Architecture analysis** - Scans codebases to identify systems, containers, components, and relationships
- **Structurizr DSL generation** - Produces valid `workspace.dsl` files following C4 model conventions
- **Diagram export** - Exports diagrams to PlantUML, Mermaid, or static HTML via Structurizr vNext, with optional PNG/SVG rendering

## Structure

```
c4-skill/
├── .claude-plugin/
│   └── plugin.json                          # Plugin metadata
├── commands/
│   └── c4.md                                # /c4 slash command
├── skills/
│   └── c4-architecture/
│       ├── SKILL.md                         # Skill definition
│       ├── references/
│       │   └── structurizr-dsl-reference.md # Full DSL syntax reference
│       ├── examples/
│       │   └── example-workspace.dsl        # Sample bookstore workspace
│       └── scripts/
│           └── export-diagrams.sh           # Structurizr vNext export wrapper
├── .gitignore
└── README.md
```

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- [Docker](https://docs.docker.com/get-docker/) installed and running (for diagram export and rendering)

## Installation

### 1. Clone into your Claude config directory

```bash
git clone git@github.com:bitsmuggler/c4-skill.git ~/.claude/c4-skill
```

### 2. Symlink the command

```bash
mkdir -p ~/.claude/commands
ln -s ~/.claude/c4-skill/commands/c4.md ~/.claude/commands/c4.md
```

### 3. Pull the Docker images

```bash
docker pull structurizr/structurizr
docker pull plantuml/plantuml
```

### 4. Restart Claude Code

Restart Claude Code (or open a new VS Code window). The `/c4` command is now available globally across all projects.

## Usage

### Slash Command

```
/c4
```

Invoke the `/c4` command to analyse the current project and generate a C4 model.

### Rendering Diagrams

After generating the `workspace.dsl`, Claude will ask if you want to render diagram images. If you say yes, it exports to PlantUML and renders to PNG - all via Docker.

You can also run the export script manually:

```bash
bash skills/c4-architecture/scripts/export-diagrams.sh workspace.dsl plantuml/c4plantuml ./diagrams
```

## Supported Diagram Types

| Level | View | Description |
|-------|------|-------------|
| 0 | System Landscape | All systems in the enterprise |
| 1 | System Context | One system + its interactions |
| 2 | Container | Internal structure of a system |
| 3 | Component | Internal structure of a container |
| - | Deployment | Infrastructure mapping |
| - | Dynamic | Behavioural/sequence flows |
