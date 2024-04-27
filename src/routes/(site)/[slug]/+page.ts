import type { PageLoadEvent } from './$types';
import { error } from '@sveltejs/kit';

export const csr = true

export async function load({ params }: PageLoadEvent) {
	try {
		const post = await import(`../../../../content/blog/${params.slug}.md`)

		return {
			slug: params.slug,
			meta: post.metadata,
			content: post.default,
		}
	} catch (e) {
		error(404, `Could not find ${params.slug}`)
	}
}
