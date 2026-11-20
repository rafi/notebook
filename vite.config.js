import adapter from '@sveltejs/adapter-vercel';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { mdsvex } from 'mdsvex';
import { preprocessMeltUI, sequence } from '@melt-ui/pp';
import mdsvexOptions from './mdsvex.config.js';
import { sveltekit } from '@sveltejs/kit/vite';
import { enhancedImages } from '@sveltejs/enhanced-img';
import { defineConfig, searchForWorkspaceRoot } from 'vite';
import Unfonts from 'unplugin-fonts/vite';

export default defineConfig({
	plugins: [
		enhancedImages(),
		sveltekit({
			extensions: ['.svelte', '.md'],
			preprocess: sequence([
				vitePreprocess(),
				// mdsvex 0.x types predate Svelte 5's optional `filename`.
				/** @type {import('svelte/compiler').PreprocessorGroup} */ (mdsvex(mdsvexOptions)),
				preprocessMeltUI(),
			]),
			adapter: adapter({
				split: true,
				// Use server-side rendering in Vercel's Node.js serverless runtime
				// https://vercel.com/docs/functions/runtimes/node-js/node-js-versions
				runtime: 'nodejs24.x'
			}),
		}),

		Unfonts({
			fontsource: {
				families: [
					{
						name: 'Inconsolata Variable',
						weights: [400, 700],
						variable: {
							wght: true,
						},
					},
					{
						name: 'Inconsolata',
						weights: [400],
						styles: ['normal'],
					},
				],
			},
			custom: {
				families: [
					{
						name: 'PureNerdFont',
						src: './node_modules/@azurity/pure-nerd-font/PureNerdFont.woff2',
					},
				],
			}
		}),
	],
	server: {
		fs: {
			allow: [
				// search up for workspace root
				searchForWorkspaceRoot(process.cwd()),
				// Allow serving files from one level up to the project root
				'..',
			],
		},
	},
});
