import type { PageLoadEvent } from './$types';
import { error } from '@sveltejs/kit';

import { getNeovimPage } from '$lib/posts';

export async function load({ fetch }: PageLoadEvent) {
	try {
		const response = fetch('/api/neovim/blog');
		const page = await getNeovimPage('index');
		return {
			posts: response.then((r) => r.json()),
			content: page.content,
		};
	} catch (e) {
		error(404, (e as Error).message);
	}
}
