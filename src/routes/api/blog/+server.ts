import { parseFiles } from '#lib/posts.ts';

/**
 * @type {import('@sveltejs/kit').RequestHandler}
 */
export async function GET() {
	const paths = import.meta.glob('/content/blog/**/*.md', { eager: true });
	const posts = parseFiles(paths);
	return Response.json(posts);
}
