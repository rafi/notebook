// Element replacements and directives for mdsvex-compiled posts.
// Relative paths: mdsvex 1.0.1 ignores re-exports through #lib/ imports.
export { default as pre } from '../components/code/block.svelte';
export { default as img } from './Figure.svelte';
export * as directives from './directives.js';
