import { error } from '@sveltejs/kit';
import { getNeovimConfigPage } from '$lib/posts';

export const prerender = true;

export async function load() {
	try {
		const page = await getNeovimConfigPage('index');
		return {
			content: page.content,
		};
	} catch (e) {
		error(404, (e as Error).message);
	}
}
