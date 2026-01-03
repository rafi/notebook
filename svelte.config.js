import adapter from '@sveltejs/adapter-vercel';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte'
import { mdsvex } from 'mdsvex';
import { preprocessMeltUI, sequence } from '@melt-ui/pp';

import mdsvexOptions from './mdsvex.config.js';

// Add SASS
// https://joshcollinsworth.com/blog/build-static-sveltekit-markdown-blog#adding-sass-to-sveltekit

/** @type {import('@sveltejs/kit').Config} */
const config = {
	extensions: ['.svelte', '.md'],

	preprocess: sequence([
		vitePreprocess(),
		mdsvex(mdsvexOptions),
		preprocessMeltUI(),
	]),

	// https://kit.svelte.dev/docs/adapter-vercel#incremental-static-regeneration
	// https://vercel.com/docs/frameworks/sveltekit#incremental-static-regeneration-isr
	isr: {
		expiration: 60,
	},

	kit: {
		// See https://kit.svelte.dev/docs/adapter-auto
		// Also https://kit.svelte.dev/docs/adapters
		adapter: adapter({
			split: true,
			// Use server-side rendering in Vercel's Node.js 18.x serverless runtime
			runtime: 'nodejs18.x',
		}),

		alias: {
			$components: './src/lib/components',
			$styles: './src/styles',
			$utils: './src/lib/utils',
		},
	},

	// https://github.com/sveltejs/vite-plugin-svelte/blob/main/docs/inspector.md
	// vitePlugin: {
	// 	inspector: {
	// 		toggleKeyCombo: 'meta-shift',
	// 		showToggleButton: 'always',
	// 		toggleButtonPos: 'bottom-right',
	// 	},
	// },
};

export default config;
