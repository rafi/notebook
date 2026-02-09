import { error } from '@sveltejs/kit';
import { getNeovimExtrasPage } from '$lib/posts';

export async function load() {
	try {
		return {
			page: (await getNeovimExtrasPage('index')).content.render(),
		}
	} catch (e) {
		error(404, (e as Error).message)
	}
}
