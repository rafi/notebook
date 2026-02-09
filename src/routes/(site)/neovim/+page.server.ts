import type { PageServerLoadEvent } from './$types';
import { error } from '@sveltejs/kit';

import { getNeovimPage } from '$lib/posts';

export async function load({ fetch }: PageServerLoadEvent) {
	try {
		const response = fetch('api/neovim/blog')
		const page = await getNeovimPage('index')
		return {
			posts: (await response).json(),
			page: page.content.render(),
		}
	} catch (e) {
		error(404, (e as Error).message)
	}
}
