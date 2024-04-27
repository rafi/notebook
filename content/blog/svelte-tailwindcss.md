---
title: Svelte, Tailwind CSS and PostCSS
date: '2021-04-08'
published: false
categories: [ svelte ]
search:
  keywords:
    - tailwind
    - postcss
---

## Setup Rollup

```sh
yarn add -D rollup sirv-cli
yarn add -D rollup-plugin-livereload rollup-plugin-terser
yarn add -D @rollup/plugin-commonjs @rollup/plugin-node-resolve
```

## Setup Svelte

```sh
yarn add -D svelte svelte-preprocess rollup-plugin-svelte
```

## Setup Tailwind CSS and PostCSS

To get the most out of Tailwind, you really should install it as a PostCSS
plugin.

### PostCSS

See [PostCSS 8 compatibility issues].

```sh
yarn add -D postcss@^7 postcss-nesting autoprefixer@^9
yarn add -D postcss-load-config rollup-plugin-postcss@^3
```

Once the rest of your tools have added support for PostCSS 8,

```sh
yarn remove tailwindcss @tailwindcss/postcss7-compat
yarn add -D tailwindcss@latest postcss@latest autoprefixer@latest
```

### Tailwind CSS

```sh
yarn add -D tailwindcss@npm:@tailwindcss/postcss7-compat \
  @tailwindcss/postcss7-compat

# Optional
yarn add @tailwindcss/ui
```

## Initialize

This will create a `tailwind.config.js` file at the root of your project:

```sh
npx tailwindcss init
```

[PostCSS 8 compatibility issues]: https://tailwindcss.com/docs/installation#post-css-7-compatibility-build
