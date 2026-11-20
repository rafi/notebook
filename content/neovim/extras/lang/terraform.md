---
title: "lang.terraform"
description: "Terraform: language server, tflint, validate linter and fmt formatters"
published: true
generated: true
kind: "extra"
category: "lang"
---

Terraform: language server, tflint, validate linter and fmt formatters

## Enable

Turn it on with `:RafiExtras` (<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>), or add it to `extras` in your `rafi.json`:

```json
{ "extras": ["lang.terraform"] }
```

## Language support

- LSP servers: `terraformls`
- Tools installed with Mason: `tflint`
- Linters: `terraform_validate` _(terraform)_, `terraform_validate` _(tf)_
- Formatters: `packer_fmt` _(hcl)_, `terraform_fmt` _(terraform)_, `terraform_fmt` _(terraform-vars)_, `terraform_fmt` _(tf)_

<details>
<summary>Source</summary>

```lua title="lua/rafi/extras/lang/terraform.lua"
-- Terraform: language server, tflint, validate linter and fmt formatters
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/lang/terraform.lua
require('rafi.util.lang').add({
	servers = { terraformls = true },
	tools = { 'tflint' },
	linters_by_ft = {
		terraform = { 'terraform_validate' },
		tf = { 'terraform_validate' },
	},
	formatters_by_ft = {
		hcl = { 'packer_fmt' },
		terraform = { 'terraform_fmt' },
		tf = { 'terraform_fmt' },
		['terraform-vars'] = { 'terraform_fmt' },
	},
})
```

</details>
