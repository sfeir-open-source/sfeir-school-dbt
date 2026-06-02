# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

SFEIR School training materials for **dbt** (data build tool). The repo bundles three distinct deliverables that ship together but are built/served independently:

- `docs/` — RevealJS slide deck (the trainer-facing presentation), published to GitHub Pages.
- `steps/` — MkDocs site of lab exercises (the student-facing workbook). Each lab has a `README.md` (instructions) and a `SOLUTION.md`.
- `tools/` — dbt projects, setup scripts (`etudiant`/`formateur` × `local`/`cloud`/`portable`), shared seed data, and Terraform (`iac/`) used to provision the workshop environment.

There is no application code — content changes (slides + labs) are the typical work.

## Common commands

### Slides (RevealJS, in `docs/`)

```bash
cd docs
npm install           # first time only; uses Node 16 per docs/.nvmrc
npm start             # runs sass watcher + live-server on http://localhost:4242
# or, without Node:
docker-compose up     # same thing, containerised
```

- `npm run sass-once` — one-shot SCSS compile (`scss/slides.scss` → `css/slides.css`).
- `npm run serve` — live-server only, watches `markdown/` and `scripts/`.
- The slide order/structure lives in `docs/scripts/slides.js` (one function per module, composed in `formation()`). Adding a slide means dropping a `.md` into `docs/markdown/<module>/` **and** referencing it in `slides.js`.

### Labs (MkDocs, in `steps/`)

```bash
pip install -r tools/requirements.txt   # installs mkdocs + dbt-postgres
cd steps
mkdocs serve          # preview labs locally
mkdocs build          # static build into steps/site/
```

The lab navigation is declared in `steps/mkdocs.yml` — new labs/modules must be added there to appear in the sidebar.

### Formatting

Prettier governs `*.{json,css,scss,md,js,ts}` (config: `.prettierrc`, `singleQuote: true`, `printWidth: 120`). `.lintstagedrc` runs it on staged files; there's no separate lint script.

## Conventions specific to this repo

### Commit messages (enforced by CONTRIBUTING.md)

Format: `<type>(<scope>): <subject>` — only these are accepted:

- **type**: `docs` | `feat` | `fix` (nothing else — no `chore`, `refactor`, etc.)
- **scope**: `specs` (slides/labs content) or `project` (tooling/config)
- **subject**: imperative, lowercase, no trailing period, ≤100 chars per line

### Lab content pattern

Each lab directory contains both the exercise (`README.md` + skeleton SQL/YAML files) **and** the worked solution (`SOLUTION.md` + completed files) side-by-side. When editing a lab, keep these two in sync — the solution must actually solve the README's task.

### Slide deck composition

`docs/scripts/slides.js` is the single source of truth for what appears in the deck and in what order. Files in `docs/markdown/` that aren't listed there will not be rendered. The theme is the external `sfeir-school-theme` npm package (loaded from `docs/web_modules/`) — do not edit theme files in `web_modules/`; override via `docs/scss/slides.scss`.
