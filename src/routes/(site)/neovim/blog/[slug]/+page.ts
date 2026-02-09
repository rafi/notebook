import type { PageLoadEvent } from './$types';
import { getNeovimBlogPost } from '$lib/posts';

export const prerender = 'auto'

export async function load({ params }: PageLoadEvent) {
	return await getNeovimBlogPost(params.slug);
}
