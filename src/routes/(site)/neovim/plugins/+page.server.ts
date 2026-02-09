import { error } from '@sveltejs/kit';
import { getNeovimPluginPage } from '$lib/posts';

export async function load() {
	try {
		return {
			page: (await getNeovimPluginPage('index')).content.render()
		}
	} catch (e) {
		error(404, (e as Error).message)
	}
}
