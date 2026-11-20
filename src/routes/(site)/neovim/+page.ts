import { error } from '@sveltejs/kit';
import { getNeovimPage } from '#lib/posts.ts';

export async function load() {
	try {
		return { page: await getNeovimPage('index') };
	} catch {
		error(404, 'Could not find the neovim page');
	}
}
