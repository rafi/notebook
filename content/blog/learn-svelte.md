---
title: Learn Svelte
date: '2021-04-08'
published: false
categories: [ svelte ]
search:
  keywords:
    - front-end
    - javascript
    - typescript
---

My notes

## Overview

> Svelte is a tool for building fast web applications. [Svelte has a] crucial
> difference to React, Vue or Angular, Svelte converts your app into ideal
> JavaScript at build time, rather than interpreting your application code at
> run time. This means you don't pay the performance cost of the framework's
> abstractions, and you don't incur a penalty when your app first loads.

## Bootstrap

### Install Svelte and Utilities

```sh
yarn add -D svelte
yarn add -D sirv-cli
yarn add -D rollup rollup-plugin-commonjs rollup-plugin-livereload \
  rollup-plugin-node-resolve rollup-plugin-svelte rollup-plugin-terser
```

```sh
rollup -c             # build
rollup -c -w          # build and watch
sirv public           # start dev server
sirv public --watch   # start dev server and watch
```

## Understanding components

> In Svelte, an application is composed from one or more components.
> A component is a reusable self-contained block of code that encapsulates
> HTML, CSS and JavaScript that belong together, written into a `.svelte` file.

## Simple Component

Inside the curly braces, we can put any JavaScript we want:

`App.svelte`

```html
<script>
let name = 'Bob';
</script>

<h1>Hello {name.toUpperCase()}!</h1>
```

Use shorthand attributes when name and value are the same:

`App.svelte`

```html
<script>
let src = 'https://github.com/sveltejs/sapper-template/raw/master/static/great-success.png';
let name = 'Borat';
</script>

<img {src} alt="{name} dances.">
```

## Styling

Use `<style>` tag as usual. Rules are scoped to the component, and don't leak.

## Nested Components

`App.svelte`

```html
<script>
import Nested from './Nested.svelte';
</script>

<style>
  p {
    color: purple;
    font-family: 'Comic Sans MS', cursive;
    font-size: 2em;
  }
</style>

<p>This is the application root paragraph.</p>
<Nested/>
```

`Nested.svelte`

```html
<p>This is the nested component paragraph.</p>
```

Note: Styles from `App.svelte` don't leak in.

## HTML Tags

Use the special `{@html ...}` tag to disable encoding and sanitization.
:warning: Beware of XSS attacks.

```html
<script>
let string = `this string contains some <strong>HTML!!!</strong>`;
</script>

<p>{@html string}</p>
```

## Data

- Input (Text entered, click, data from server, etc.)
- Output (Print text, change CSS class, etc.)

## Reactivity

```html
<button on:click={myFunction}>Change</button>
```

## References

- Official tutorial https://svelte.dev/tutorial
- API Docs https://svelte.dev/docs
- Examples https://svelte.dev/examples
