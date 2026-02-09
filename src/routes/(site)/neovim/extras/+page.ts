import { error } from '@sveltejs/kit';
import { getNeovimExtrasPage } from '$lib/posts';

export async function load() {
	try {
		const page = await getNeovimExtrasPage('index');
		return {
			content: page.content,
		};
	} catch (e) {
		error(404, (e as Error).message);
	}
}
