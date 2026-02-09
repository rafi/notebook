import type { LayoutLoadEvent } from './$types';
import { error } from '@sveltejs/kit';
import type { Post } from '$lib/types';

export async function load({ fetch }: LayoutLoadEvent) {
	try {
		const posts: Promise<Post[]> = (await fetch('/api/neovim/extras')).json()
		return { posts: await posts }
	} catch (e) {
		error(404, (e as Error).message)
	}
}
