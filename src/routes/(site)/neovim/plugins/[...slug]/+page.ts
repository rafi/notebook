import type { PageLoadEvent } from './$types';
import { getNeovimPluginPage } from '$lib/posts';

export async function load({ params }: PageLoadEvent) {
	const page = await getNeovimPluginPage(params.slug);
	return { page }
}
