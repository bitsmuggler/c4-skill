# Structurizr DSL Language Reference

Complete syntax reference for the Structurizr DSL. Official docs: https://docs.structurizr.com/dsl/language

## Workspace (Top-Level)

```
workspace [name] [description] {
    !identifiers hierarchical|flat    // default: flat
    !impliedRelationships true|false

    model { ... }
    views { ... }
    configuration { ... }
}
```

## Model Elements

### People

```
<identifier> = person <name> [description] [tags]
```

### Software Systems

```
<identifier> = softwareSystem <name> [description] [tags] {
    // optional: nest containers, groups, tags, properties
}
```

### Containers (inside a softwareSystem)

```
<identifier> = container <name> [description] [technology] [tags] {
    // optional: nest components, groups, tags, properties
}
```

### Components (inside a container)

```
<identifier> = component <name> [description] [technology] [tags]
```

### Groups

```
group <name> {
    // nest elements inside a named boundary
}
```

## Deployment Model

```
deploymentEnvironment <name> {
    deploymentNode <name> [description] [technology] [instances] [tags] {
        deploymentNode <name> { ... }                    // nested nodes
        infrastructureNode <name> [description] [technology] [tags]
        softwareSystemInstance <identifier> [tags]
        containerInstance <identifier> [tags]
    }
}
```

## Relationships

### Explicit Relationships

```
<source> -> <destination> [description] [technology] [tags]
```

### Implicit Relationships (inside element scope)

```
-> <destination> [description] [technology] [tags]
```

### Examples

```
user -> webApp "Browses" "HTTPS"
webApp -> api "Makes API calls to" "REST/JSON"
api -> db "Reads from and writes to" "JDBC"
```

## Tags and Properties

```
// Single tag
<element> {
    tags "Tag1" "Tag2"
}

// Properties (key-value metadata)
<element> {
    properties {
        "key" "value"
    }
}

// URL
<element> {
    url "https://example.com"
}

// Perspectives
<element> {
    perspectives {
        "Security" "Description of security perspective"
    }
}
```

## Views

### System Landscape (all systems)

```
systemLandscape [key] [description] {
    include *
    autoLayout [tb|bt|lr|rl] [rankSep] [nodeSep]
}
```

### System Context (one system + connections)

```
systemContext <softwareSystem> [key] [description] {
    include *
    autoLayout
}
```

### Container (internal structure of a system)

```
container <softwareSystem> [key] [description] {
    include *
    autoLayout
}
```

### Component (internal structure of a container)

```
component <container> [key] [description] {
    include *
    autoLayout
}
```

### Dynamic (behavioural/sequence)

```
dynamic <scope> [key] [description] {
    <source> -> <destination> [description]
    autoLayout
}
```

### Deployment

```
deployment <scope> <environment> [key] [description] {
    include *
    autoLayout
}
```

### Filtered View

```
filtered <baseViewKey> include|exclude <tags> [key] [description]
```

### Custom View

```
custom [key] [title] [description] {
    include *
    autoLayout
}
```

## View Operations

```
include *                           // all elements in scope
include <identifier>                // specific element
include <expression>                // expression-based

exclude <identifier>                // remove specific element
exclude <expression>                // expression-based removal

autoLayout [tb|bt|lr|rl] [rankSep] [nodeSep]

animation {
    <identifier> [identifier...]    // step 1
    <identifier> [identifier...]    // step 2
}

title "View Title"
description "View description"
```

### Include/Exclude Expressions

```
include "element.tag==Tag"                   // elements with tag
include "element.parent==identifier"         // children of element
include "->identifier->"                     // element + incoming/outgoing
exclude "relationship.tag==Tag"              // relationships with tag
```

## Styles

### Element Styles

```
styles {
    element <tag> {
        shape Box|RoundedBox|Circle|Ellipse|Hexagon|Cylinder|Pipe|Person|Robot|Folder|WebBrowser|MobileDeviceLandscape|MobileDevicePortrait|Component
        icon <file|url>
        width <integer>
        height <integer>
        background <#rrggbb>
        color <#rrggbb>
        colour <#rrggbb>
        stroke <#rrggbb>
        strokeWidth <integer>
        fontSize <integer>
        border solid|dashed|dotted
        opacity <0-100>
        metadata true|false
        description true|false
    }
}
```

### Relationship Styles

```
styles {
    relationship <tag> {
        thickness <integer>
        color <#rrggbb>
        colour <#rrggbb>
        style solid|dashed|dotted
        routing Direct|Orthogonal|Curved
        fontSize <integer>
        width <integer>
        position <0-100>
        opacity <0-100>
    }
}
```

### Theme

```
views {
    theme default
    theme <url>
    themes default <url1> <url2>
}
```

## Advanced Features

### Element References

```
!element <identifier> {
    // modify an existing element
}

!relationship <identifier> {
    // modify an existing relationship
}
```

### Bulk Operations

```
!elements <expression> {
    // apply to matching elements
}

!relationships <expression> {
    // apply to matching relationships
}
```

### Includes

```
!include <file.dsl>          // include DSL fragment
!include <directory>          // include all .dsl files in directory
!include <url>                // include from URL
```

### Documentation & ADRs

```
!docs <path>                  // attach markdown/asciidoc docs
!adrs <path>                  // attach architecture decision records
```

### Scripting

```
!script groovy|kotlin|ruby {
    // JVM scripting
}
```

### Configuration

```
configuration {
    scope landscape|softwaresystem|none
    visibility private|public
    users {
        <username> read|write
    }
}
```

## Common Patterns

### Tagging External Systems

```
model {
    external = softwareSystem "External Service" "Third-party" "External"
}
views {
    styles {
        element "External" {
            background #999999
        }
    }
}
```

### Database Containers

```
db = container "Database" "Stores data" "PostgreSQL" "Database"

// In styles:
element "Database" {
    shape Cylinder
}
```

### Message Queues

```
queue = container "Message Queue" "Async messaging" "RabbitMQ" "Queue"
```
