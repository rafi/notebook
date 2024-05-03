import type { PageServerLoadEvent } from './$types';
import { error } from '@sveltejs/kit';

export async function load({ fetch }: PageServerLoadEvent) {
	try {
		const response = await fetch('api/blog')
		return { posts: response.json() }
	} catch (e) {
		error(404, (e as Error).message)
	}
}
