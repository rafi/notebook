import type { PageLoadEvent } from './$types';
import { error } from '@sveltejs/kit';
import { getPost } from '#lib/posts.ts';

export const prerender = false;
export const ssr = false;
export const csr = true;

export async function load({ params }: PageLoadEvent) {
	try {
		return { post: await getPost(params.slug) };
	} catch {
		error(404, `Could not find ${params.slug}`);
	}
}
