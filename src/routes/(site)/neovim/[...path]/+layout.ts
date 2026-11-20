import type { LayoutLoadEvent } from './$types';
import { error } from '@sveltejs/kit';
import type { Post } from '#lib/types/index.ts';

export async function load({ fetch }: LayoutLoadEvent) {
	try {
		const posts: Promise<Post[]> = (await fetch('/api/neovim')).json();
		return { posts };
	} catch (e) {
		error(404, (e as Error).message);
	}
}
