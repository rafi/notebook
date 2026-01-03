import { sveltekit } from '@sveltejs/kit/vite';
import { enhancedImages } from '@sveltejs/enhanced-img';
import { defineConfig, searchForWorkspaceRoot } from 'vite';
import Unfonts from 'unplugin-fonts/vite';

export default defineConfig({
	plugins: [
		enhancedImages(),
		sveltekit(),
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
