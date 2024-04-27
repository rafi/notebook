import type { PageServerLoadEvent } from './$types';
import { error } from '@sveltejs/kit';

import type { Post } from '$lib/types';

export async function load({ fetch }: PageServerLoadEvent) {
	try {
		const response = await fetch('api/posts')
		const posts: Post[] = await response.json()
		return { posts }
	} catch (e) {
		error(404, (e as Error).message)
	}
}
