import type { PageLoadEvent } from './$types';
import { getNeovimExtrasPage } from '$lib/posts';

export async function load({ params }: PageLoadEvent) {
	return await getNeovimExtrasPage(params.slug);
}
