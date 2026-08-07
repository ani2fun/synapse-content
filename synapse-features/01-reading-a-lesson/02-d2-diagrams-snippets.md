---
title: "D2 diagrams snippets"
summary: "A quick tour of D2 Syntax snippets a Synapse lesson can render."
---

# D2 diagram snippets

A cheat sheet of [D2](https://d2lang.com), one feature per snippet. Every figure below is drawn
from the `d2` fence printed above it — nothing here is a screenshot. Synapse renders them on the
server and sends the finished SVG with the page, so they are already there when it loads. Click
**Enlarge** on any diagram to pan and zoom.

## D2 diagrams

### Hello World

The whole language in one line. Naming a shape declares it, and `->` connects two of them.

```bash
hello -> world
```

```d2
hello -> world
```

### Labels

A `key: value` pair sets a shape's label; a connection takes its label after its own colon.

```bash
x: I'm a Mac
y: And I'm a PC
x -> y: gazoontite
```

```d2
x: I'm a Mac
y: And I'm a PC
x -> y: gazoontite
```

### Declaring a shape

Identifiers are liberal — camelCase, snake_case, spaces, apostrophes and hyphens all name a shape.

```bash
imAShape
im_a_shape
im a shape
i'm a shape
a-shape
```

```d2
imAShape
im_a_shape
im a shape
i'm a shape
a-shape
```

### Customize shape type

`shape` picks the figure that gets drawn. Set it inline, through a dotted path, or in a block.

```bash
donut: { shape: circle }
database.shape: cylinder
you: {
  shape: person
}
```

```d2
donut: { shape: circle }
database.shape: cylinder
you: {
  shape: person
}
```

## Connections and containers

### Connections

Chains and bidirectional arrows both work, and a connection can carry its own label and arrowheads.

```bash
dogs -> cats -> mice: chase
replica 1 <-> replica 2
a -> b: To err is human, to moo bovine {
  source-arrowhead: 1
  target-arrowhead: * {
    shape: diamond
  }
}
```

```d2
dogs -> cats -> mice: chase
replica 1 <-> replica 2
a -> b: To err is human, to moo bovine {
  source-arrowhead: 1
  target-arrowhead: * {
    shape: diamond
  }
}
```

### Containers

Nest with a block or with a dotted path — either way the parent is declared on the way in.

```bash
good chips: {
  doritos
  ruffles
}
bad chips.lays
bad chips.pringles

chocolate.chip.cookies
```

```d2
good chips: {
  doritos
  ruffles
}
bad chips.lays
bad chips.pringles

chocolate.chip.cookies
```

## Text, code, and images

### Markdown text

A `|md … |` block string renders real Markdown inside a shape.

```bash
explanation: |md
  # I can do headers

  - lists
  - lists

  And other normal markdown stuff
|
```

```d2
explanation: |md
  # I can do headers

  - lists
  - lists

  And other normal markdown stuff
|
```

### Latex

`|latex … |` typesets an equation.

```bash
plankton -> formula: will steal
formula: {
  equation: |latex
    \lim_{h \rightarrow 0 } \frac{f(x+h)-f(x)}{h}
  |
}
```

```d2
plankton -> formula: will steal
formula: {
  equation: |latex
    \lim_{h \rightarrow 0 } \frac{f(x+h)-f(x)}{h}
  |
}
```

### Code blocks

Tag the block string with a language — `|go`, `|python`, `|rust` — for a syntax-highlighted listing.

```bash
explanation: |go
  awsSession := From(c.Request.Context())
  client := s3.New(awsSession)

  ctx, cancelFn := context.WithTimeout(c.Request.Context(), AWS_TIMEOUT)
  defer cancelFn()
|
```

```d2
explanation: |go
  awsSession := From(c.Request.Context())
  client := s3.New(awsSession)

  ctx, cancelFn := context.WithTimeout(c.Request.Context(), AWS_TIMEOUT)
  defer cancelFn()
|
```

### Icons and images

`icon` hangs an image on a shape; adding `shape: image` makes the image the entire shape.

```bash
my network: {
  icon: https://icons.d2lang.com/infra/019-network.svg
}
github: {
  shape: image
  icon: https://icons.d2lang.com/dev/github.svg
}
```

```d2
my network: {
  icon: https://icons.d2lang.com/infra/019-network.svg
}
github: {
  shape: image
  icon: https://icons.d2lang.com/dev/github.svg
}
```

## Diagram kinds

### Sequence diagrams

`shape: sequence_diagram` at the root reads the connections in order as messages. `\n` breaks a
label across lines.

```bash
shape: sequence_diagram
alice -> bob: What does it mean\nto be well-adjusted?
bob -> alice: The ability to play bridge or\ngolf as if they were games.
```

```d2
shape: sequence_diagram
alice -> bob: What does it mean\nto be well-adjusted?
bob -> alice: The ability to play bridge or\ngolf as if they were games.
```

### SQL tables

`shape: sql_table` turns a shape's keys into typed rows, and a connection between two rows draws
the foreign key.

```bash
costumes: {
  shape: sql_table
  id: int {constraint: primary_key}
  silliness: int
  monster: int
  last_updated: timestamp
}

monsters: {
  shape: sql_table
  id: int {constraint: primary_key}
  movie: string
  weight: int
  last_updated: timestamp
}

costumes.monster -> monsters.id
```

```d2
costumes: {
  shape: sql_table
  id: int {constraint: primary_key}
  silliness: int
  monster: int
  last_updated: timestamp
}

monsters: {
  shape: sql_table
  id: int {constraint: primary_key}
  movie: string
  weight: int
  last_updated: timestamp
}

costumes.monster -> monsters.id
```

### UML class

`shape: class` reads a leading `+` or `-` as visibility. A `#` starts a comment, so escape it or
wrap the key in quotes when you need one in a name.

```bash
D2 Parser: {
  shape: class

  +reader: io.RuneReader
  # Default visibility is + so no need to specify.
  readerPos: d2ast.Position

  # Private field.
  -lookahead: "[]rune"

  # Escape the # to prevent being parsed as comment
  \#lookaheadPos: d2ast.Position
  # Or just wrap in quotes
  "#peekn(n int)": (s string, eof bool)

  +peek(): (r rune, eof bool)
  rewind()
  commit()
}
```

```d2
D2 Parser: {
  shape: class

  +reader: io.RuneReader
  # Default visibility is + so no need to specify.
  readerPos: d2ast.Position

  # Private field.
  -lookahead: "[]rune"

  # Escape the # to prevent being parsed as comment
  \#lookaheadPos: d2ast.Position
  # Or just wrap in quotes
  "#peekn(n int)": (s string, eof bool)

  +peek(): (r rune, eof bool)
  rewind()
  commit()
}
```

### Grid diagrams

`grid-rows` (or `grid-columns`) lays the children out as a grid instead of routing connections
between them.

```bash
grid-rows: 2
Executive
Legislative
Judicial
The American Government.width: 400
```

```d2
grid-rows: 2
Executive
Legislative
Judicial
The American Government.width: 400
```

## Layout

### Layout direction

`direction` sets the flow: `up`, `down`, `left` or `right`.

```bash
direction: right
x -> y -> z: onwards!
```

```d2
direction: right
x -> y -> z: onwards!
```

### Diagram title

A `shape: text` placed with `near` gives the diagram a heading.

```bash
title: Hello Friends {
  near: top-center
  shape: text
  style: {
    font-size: 29
    bold: true
    underline: true
  }
}
x -> y
```

```d2
title: Hello Friends {
  near: top-center
  shape: text
  style: {
    font-size: 29
    bold: true
    underline: true
  }
}
x -> y
```

## Styling

### Styling

`style` on a shape or a connection sets stroke, fill, opacity, dashes, shadow and 3d.

```bash
x: {
  style: {
    stroke: "#53C0D8"
    stroke-width: 5
    shadow: true
  }
}

y: {
  style: {
    opacity: 0.6
    fill: red
    3d: true
    stroke: black
  }
}

x -> y: {
  style: {
    stroke: green
    opacity: 0.5
    stroke-width: 2
    stroke-dash: 5
  }
}
```

```d2
x: {
  style: {
    stroke: "#53C0D8"
    stroke-width: 5
    shadow: true
  }
}

y: {
  style: {
    opacity: 0.6
    fill: red
    3d: true
    stroke: black
  }
}

x -> y: {
  style: {
    stroke: green
    opacity: 0.5
    stroke-width: 2
    stroke-dash: 5
  }
}
```

### Root styles

`style` at the root styles the diagram's own frame — including a double border and a fill pattern.

```bash
style: {
  fill: Beige
  stroke: DarkBlue
  stroke-width: 8
  double-border: true
  fill-pattern: lines
}

report: |md
  # Report card

  - Computer science: B
  - Diagram making: A+
|
```

```d2
style: {
  fill: Beige
  stroke: DarkBlue
  stroke-width: 8
  double-border: true
  fill-pattern: lines
}

report: |md
  # Report card

  - Computer science: B
  - Diagram making: A+
|
```

### Classes

Declare a reusable bundle of keys under `classes`, then apply it with `.class`.

```bash
classes: {
  shiny orb: {
    label: ""
    shape: circle
    width: 40
    style: {
      fill: yellow
      shadow: true
    }
  }
}

x.class: shiny orb
y.class: shiny orb
z.class: shiny orb
```

```d2
classes: {
  shiny orb: {
    label: ""
    shape: circle
    width: 40
    style: {
      fill: yellow
      shadow: true
    }
  }
}

x.class: shiny orb
y.class: shiny orb
z.class: shiny orb
```

### Globs

`*` applies a key to every shape at that level — connections included.

```bash
x
y
z

*.style.fill: yellow
x -> *
```

```d2
x
y
z

*.style.fill: yellow
x -> *
```

### Variables

`vars` holds values you interpolate with `${…}`. A nested value needs its full path.

```bash
vars: {
  name: Joe
  colors: {
    primary: "#065535"
  }
}

customer: ${name}
customer.style.fill: ${colors.primary}
```

```d2
vars: {
  name: Joe
  colors: {
    primary: "#065535"
  }
}

customer: ${name}
customer.style.fill: ${colors.primary}
```

## Interactivity

### Tooltips

`tooltip` shows text on hover.

```bash
x: { tooltip: Total abstinence is easier than perfect moderation }
y: { tooltip: I can't make my satellite dish PAYMENTS! }
x -> y
```

```d2
x: { tooltip: Total abstinence is easier than perfect moderation }
y: { tooltip: I can't make my satellite dish PAYMENTS! }
x -> y
```

### Links

`link` makes a shape clickable.

```bash
x: I'm a Mac {
  link: https://apple.com
}
y: And I'm a PC {
  link: https://microsoft.com
}
x -> y: gazoontite
```

```d2
x: I'm a Mac {
  link: https://apple.com
}
y: And I'm a PC {
  link: https://microsoft.com
}
x -> y: gazoontite
```
