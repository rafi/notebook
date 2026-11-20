import type { RequestHandler } from './$types';
import { parseFiles } from '#lib/posts.ts';

/**
 * Generated neovim docs pages of core plugins and extras, slugs like
 * 'neovim/extras/ui/deadcolumn'.
 */
export const GET: RequestHandler = async () => {
	const paths = import.meta.glob(
		['/content/neovim/core/*.md', '/content/neovim/extras/*/*.md'],
		{ eager: true }
	);
	return Response.json(parseFiles(paths, 'neovim'));
};
