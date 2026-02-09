import { error } from '@sveltejs/kit';
import { getNeovimPluginPage } from '$lib/posts';

export async function load() {
	try {
		const page = await getNeovimPluginPage('index');
		return {
			content: page.content,
		};
	} catch (e) {
		error(404, (e as Error).message);
	}
}
