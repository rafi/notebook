import { json as jsonResponse } from '@sveltejs/kit';
import { parseFiles } from '$lib/posts';

/**
 * @type {import('@sveltejs/kit').RequestHandler}
 */
export async function GET() {
	const paths = import.meta.glob('/content/neovim/blog/**/*.md', { eager: true })
	const posts = parseFiles(paths, 'neovim')
	return jsonResponse(posts)
}
