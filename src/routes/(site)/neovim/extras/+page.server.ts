import type { PageServerLoadEvent } from './$types';
import { error } from '@sveltejs/kit';
import type { Post } from '#lib/types/index.ts';

export async function load({ fetch }: PageServerLoadEvent) {
	try {
		const posts: Post[] = await (await fetch('/api/neovim')).json();
		return { posts: posts.filter((p) => p.kind === 'extra') };
	} catch (e) {
		error(404, (e as Error).message);
	}
}
