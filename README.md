# RAFI.IO

> Personal website

## Overview

Throughout the years, I've had many iterations of my personal website. However,
I didn't contribute any real worthy reading material to it, I enjoyed keeping up
with front-end technologies and evolution of static-site-generators (SSG).

Jekyll, GitBook, Hugo, Gatsby, mdBook, GitBook, VuePress, NextJS, Docusaurus,
and (finally) [SvelteKit].

I've come to enjoy the simplicity of [Svelte] and "No Batteries
Included" approach of [SvelteKit]. It's a great fit for my character, I like to
tinker and configure things to my liking.
It's like [Arch Linux], but for web. :)

## Tech Stack

- [SvelteKit] and [TypeScript] languages.
- [MDsveX], [remark], [rehype], and [Shiki].
- [MeltUI], [Lucide], and [Inconsolata] font.
- [Custom CSS](./src/styles/).

## Deployment

Site uses [Vercel](https://vercel.com) for deployment and hosting, powered by
SvelteKit's
[@sveltejs/adapter-vercel](https://www.npmjs.com/package/@sveltejs/adapter-vercel).

See
[kit.svelte.dev/docs/adapter-vercel](https://kit.svelte.dev/docs/adapter-vercel)
for more information regarding the adapter.

## Development

Use [`package.json`](./package.json) scripts or [`justfile`](./justfile)
targets.

| Command           | Description                      |
| ----------------- | -------------------------------- |
| `pnpm dev`        | Run dev server                   |
| `pnpm dev --open` | Run dev server and open browser  |
| `pnpm dev --host` | Expose dev server on the network |
| `pnpm build`      | Build the site                   |
| `pnpm preview`    | Preview production build         |
| `pnpm lint`       | Lint the code                    |
| `pnpm format`     | Format the code                  |

## Copyright

(c) 2024 [Rafael Bodill](https://rafi.io), unless otherwise stated.

[Svelte]: https://svelte.dev/
[SvelteKit]: https://kit.svelte.dev/
[TypeScript]: https://www.typescriptlang.org/
[MDsveX]: https://github.com/pngwn/mdsvex
[MeltUI]: https://github.com/melt-ui/melt-ui
[Lucide]: https://github.com/lucide-icons/lucide
[Inconsolata]: https://levien.com/type/myfonts/inconsolata.html
[Shiki]: https://github.com/shikijs/shiki
[remark]: https://github.com/remarkjs/remark
[rehype]: https://github.com/rehypejs/rehype
[Arch Linux]: https://archlinux.org/
