import type { PageLoadEvent } from './$types';
import { getWikiPage } from '$lib/posts';

export async function load({ params }: PageLoadEvent) {
	return await getWikiPage(params.slug);
}
