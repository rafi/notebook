import { error } from '@sveltejs/kit';
import { getNeovimConfigPage } from '$lib/posts';

export const prerender = true;

export async function load() {
	try {
		return {
			page: (await getNeovimConfigPage('index')).content.render(),
		}
	} catch (e) {
		error(404, (e as Error).message)
	}
}
