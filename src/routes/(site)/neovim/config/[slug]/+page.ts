import type { PageLoadEvent } from './$types';
import { getNeovimConfigPage } from '$lib/posts';

export async function load({ params }: PageLoadEvent) {
	return await getNeovimConfigPage(params.slug);
}
