# C4 Structurizr Plugin for Claude Code

A Claude Code plugin that analyses software architecture and generates C4 models using the [Structurizr DSL](https://docs.structurizr.com/dsl/language).

## Features

- **Architecture analysis** - Scans codebases to identify systems, containers, components, and relationships
- **Structurizr DSL generation** - Produces valid `workspace.dsl` files following C4 model conventions
- **Diagram export** - Exports diagrams to PlantUML, Mermaid, or static HTML via Structurizr vNext, with optional PNG/SVG rendering

## Structure

```
c4-skill/
├── .claude-plugin/
│   └── marketplace.json                     # Marketplace metadata
├── plugins/
│   └── c4-architecture/
│       ├── .claude-plugin/
│       │   └── plugin.json                  # Plugin metadata
│       ├── commands/
│       │   └── c4.md                        # /c4 slash command
│       └── skills/
│           └── c4-architecture/
│               ├── SKILL.md                 # Skill definition (auto-invoked by Claude)
│               ├── references/
│               │   └── structurizr-dsl-reference.md
│               ├── examples/
│               │   └── example-workspace.dsl
│               └── scripts/
│                   └── export-diagrams.sh
└── README.md
```

## Installation

Symlink the command into your user-level commands directory:

```bash
ln -s /path/to/c4-skill/plugins/c4-architecture/commands/c4.md ~/.claude/commands/c4.md
```

Then restart Claude Code. The `/c4` command will be available globally across all projects.

## Usage

### Slash Command

```
/c4
```

Invoke the `/c4` command to analyse the current project and generate a C4 model.

### Rendering Diagrams

Structurizr vNext exports to PlantUML, Mermaid, or static HTML. To get PNG/SVG images, render the PlantUML/Mermaid output with the respective tool.

**Install Structurizr vNext** (one of):

```bash
# Option 1: Download the WAR from https://docs.structurizr.com/binaries
# Requires Java. Then set:
export STRUCTURIZR_WAR=/path/to/structurizr.war

# Option 2: Docker
docker pull structurizr/structurizr
```

**Install a renderer** (for PNG/SVG output):

```bash
# PlantUML
brew install plantuml

# Or Mermaid CLI
npm install -g @mermaid-js/mermaid-cli
```

**Export and render:**

```bash
# Export to C4-PlantUML, then render to PNG
bash plugins/c4-architecture/skills/c4-architecture/scripts/export-diagrams.sh workspace.dsl plantuml/c4plantuml ./diagrams
plantuml -tpng ./diagrams/*.puml

# Or view interactively
java -jar structurizr.war playground
```

## Supported Diagram Types

| Level | View | Description |
|-------|------|-------------|
| 1 | System Landscape | All systems in the enterprise |
| 1 | System Context | One system + its interactions |
| 2 | Container | Internal structure of a system |
| 3 | Component | Internal structure of a container |
| - | Deployment | Infrastructure mapping |
| - | Dynamic | Behavioural/sequence flows |
