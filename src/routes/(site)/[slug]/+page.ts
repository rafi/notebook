import type { PageLoadEvent } from './$types';
import { getPost } from '$lib/posts';

export const prerender = 'auto'

export async function load({ params }: PageLoadEvent) {
	return await getPost(params.slug);
}
