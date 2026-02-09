import type { PageLoadEvent } from './$types';
import { getNeovimPage } from '$lib/posts';

export async function load({ params }: PageLoadEvent) {
	return await getNeovimPage(params.slug);
}
