# Markdownception
### A Beginner's Guide to Markdown — Written in Markdown

> Markdown is a lightweight way to format plain text. You write simple
> symbols alongside your words and they become formatted when rendered.
> This document is itself written in markdown — everything you see here
> is produced by the syntax described below.

---

## What Markdown Is

Markdown is a plain text file with the extension `.md`. You write it in
any text editor. When a platform like GitHub, Notion, or Obsidian renders
it, the symbols become formatting. When you read the raw file, the symbols
are still readable as plain text — nothing is hidden.

This makes it ideal for documentation, wikis, notes, and readme files.
It's also version control friendly — because it's plain text, Git can
track every change line by line.

---

## Headings

Use the `#` symbol to create headings. More hashes means smaller heading.

```
# Heading 1 — the largest, used for page titles
## Heading 2 — section headings
### Heading 3 — subsection headings
#### Heading 4 — smaller still, used sparingly
```

Renders as:

# Heading 1
## Heading 2
### Heading 3
#### Heading 4

---

## Paragraphs and Line Breaks

Plain text with a blank line between paragraphs creates separate paragraphs.

```
This is the first paragraph. It can be as long as you like.

This is the second paragraph. The blank line between them is what
separates them when rendered.
```

A single line break in the source file does not create a new paragraph —
you need the blank line.

---

## Emphasis

```
*italic text* or _italic text_
**bold text** or __bold text__
***bold and italic*** or ___bold and italic___
~~strikethrough~~
```

Renders as:

*italic* — *italic text*
**bold** — **bold text**
***bold italic*** — ***bold and italic***
~~strikethrough~~ — ~~strikethrough~~

---

## Lists

### Unordered Lists
Use `-`, `*`, or `+` followed by a space:

```
- First item
- Second item
- Third item
  - Indented sub item (two spaces before the dash)
  - Another sub item
```

Renders as:
- First item
- Second item
- Third item
  - Indented sub item
  - Another sub item

### Ordered Lists
Use numbers followed by a period:

```
1. First step
2. Second step
3. Third step
```

The actual numbers don't matter — markdown renumbers automatically.
Writing `1. 1. 1.` renders as 1, 2, 3.

### Task Lists
Use `- [ ]` for an unchecked box and `- [x]` for a checked box:

```
- [x] This task is done
- [ ] This task is not done yet
- [ ] Neither is this one
```

Renders as checkboxes — the format used throughout the dev plan.

---

## Links

```
[Link text](https://url.com)
[GitHub](https://github.com)
```

The text in square brackets is what the reader sees. The URL in
parentheses is where clicking takes them.

### Linking to Other Documents
```
[Design Pillars](design_pillars.md)
[Dev Plan](dev_plan_v2.md)
```

Relative links work in GitHub wikis and Obsidian — essential for the
wiki index table of contents.

---

## Images

```
![Alt text](path/to/image.png)
![Alt text](https://url.com/image.png)
```

The exclamation mark before the square bracket is what makes it an image
rather than a link. Alt text describes the image for accessibility.

---

## Code

### Inline Code
Wrap in single backticks for inline code — used for function names,
file names, and short commands:

```
Use `get_parent()` to reference the parent node.
Save the file as `player.gd`.
```

Renders as: Use `get_parent()` to reference the parent node.

### Code Blocks
Wrap in triple backticks for multi-line code. Optionally specify the
language after the opening backticks for syntax highlighting:

````
```gdscript
func _ready():
    var direction = Vector2.ZERO
    sig_dash_started.emit(direction)
```
````

Renders as a formatted code block with syntax highlighting on platforms
that support it.

---

## Blockquotes

Use `>` at the start of a line:

```
> This is a blockquote. Used for notes, callouts, and quoted text.
> It can span multiple lines.
>
> A blank `>` line creates a paragraph break within the quote.
```

Renders as:

> This is a blockquote. Used for notes, callouts, and quoted text.
> It can span multiple lines.
>
> A blank `>` line creates a paragraph break within the quote.

---

## Horizontal Rules

Three or more dashes, asterisks, or underscores on their own line:

```
---
```

Creates a horizontal dividing line. Used to separate sections.

---

## Tables

```
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Cell     | Cell     | Cell     |
| Cell     | Cell     | Cell     |
```

The dashes in the second row define the header separator. Column width
in the source doesn't matter — markdown handles alignment.

Alignment can be specified with colons in the separator row:

```
| Left     | Center   | Right    |
|:---------|:--------:|---------:|
| aligned  | aligned  | aligned  |
```

---

## Escaping Symbols

If you want to display a markdown symbol as plain text rather than
letting it format, put a backslash before it:

```
\*this will not be italic\*
\# this will not be a heading
```

---

## Front Matter

Some platforms support YAML front matter at the very top of a markdown
file — metadata enclosed between triple dashes:

```
---
title: My Document
date: 2026-02-23
tags: godot, gamedev
---
```

GitHub doesn't render this as content — it reads it as metadata.
Obsidian uses it for tagging and filtering. Worth knowing it exists.

---

## Quick Reference Card

| Element        | Syntax                          |
|:---------------|:--------------------------------|
| Heading 1      | `# Heading`                     |
| Heading 2      | `## Heading`                    |
| Bold           | `**bold**`                      |
| Italic         | `*italic*`                      |
| Strikethrough  | `~~text~~`                      |
| Unordered list | `- item`                        |
| Ordered list   | `1. item`                       |
| Task list      | `- [ ] task` / `- [x] done`    |
| Link           | `[text](url)`                   |
| Image          | `![alt](path)`                  |
| Inline code    | `` `code` ``                    |
| Code block     | ` ```language `                 |
| Blockquote     | `> text`                        |
| Horizontal rule| `---`                           |
| Table          | `\| col \| col \|`              |
| Escape symbol  | `\*`                            |

---

## Where to Practice

**GitHub** — any `.md` file in a repository renders automatically.
Create a scratch file called `test.md` and push it to see how it renders.

**Obsidian** — a local markdown editor with live preview. Free and worth
knowing about for note taking alongside development.

**Dillinger.io** — a browser based markdown editor with live preview.
No install required. Good for quick testing.

---

*This document is itself written in markdown — markdownception complete.*
