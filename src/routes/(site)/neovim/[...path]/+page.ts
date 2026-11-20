import type { PageLoadEvent } from './$types';
import { error } from '@sveltejs/kit';
import { getNeovimPage } from '#lib/posts.ts';

export const prerender = 'auto';

export async function load({ params }: PageLoadEvent) {
	try {
		return { post: await getNeovimPage(params.path) };
	} catch {
		error(404, `Could not find neovim/${params.path}`);
	}
}
