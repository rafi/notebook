---
title: "lang.docker"
description: "Docker: Dockerfile and compose language servers, hadolint linter"
published: true
generated: true
kind: "extra"
category: "lang"
---

Docker: Dockerfile and compose language servers, hadolint linter

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.docker"] }
```

## Language support

- LSP servers: `docker_compose_language_service`, `dockerls`
- Tools installed with Mason: `hadolint`
- Linters: `hadolint` _(dockerfile)_

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/docker.lua"
-- Docker: Dockerfile and compose language servers, hadolint linter
-- Tree-sitter parser installed on demand by arborist.
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/docker.lua
require('rafi.util.lang').add({
	servers = { dockerls = true, docker_compose_language_service = true },
	tools = { 'hadolint' },
	linters_by_ft = { dockerfile = { 'hadolint' } },
})
```

</details>
