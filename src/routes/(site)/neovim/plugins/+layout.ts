import type { LayoutLoadEvent } from './$types';
import { error } from '@sveltejs/kit';

export async function load({ fetch }: LayoutLoadEvent) {
	try {
		return { posts: (await fetch('/api/neovim/plugins')).json() }
	} catch (e) {
		error(404, (e as Error).message)
	}
}
