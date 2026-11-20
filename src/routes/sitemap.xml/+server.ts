import { parseFiles, slugFromPath } from '#lib/posts.ts';
import type { Post } from '#lib/types/index.ts'
import * as config from '#lib/config.js';
import { formatDate } from '#lib/util/time.ts';

export const prerender = true

/**
 * @type {import('@sveltejs/kit').RequestHandler}
 */
export async function GET() {
	const paths = import.meta.glob('../../../content/blog/**/*.md', { eager: true })
	const posts = parseFiles(paths)

	const pages = ['about', 'blog']

	function parsePostDate(post: Post) {
		let date;
		if (post.updated) {
			date = formatDate(post.updated, 'full');
		} else if (post.date) {
			date = formatDate(post.date, 'full')
		} else {
			return ''
		}
		return '<lastmod>' + date + '</lastmod>'
	}

	const sitemap =
		`<?xml version="1.0" encoding="UTF-8" ?>
<urlset
	xmlns="https://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:xhtml="https://www.w3.org/1999/xhtml"
	xmlns:mobile="https://www.google.com/schemas/sitemap-mobile/1.0"
	xmlns:news="https://www.google.com/schemas/sitemap-news/0.9"
	xmlns:image="https://www.google.com/schemas/sitemap-image/1.1"
	xmlns:video="https://www.google.com/schemas/sitemap-video/1.1"
>
${pages.map((page) => `	<url>
		<loc>${config.url}/${page}</loc>
	</url>
`).join('')}
${posts.map((post: Post) => `	<url>
		<loc>${config.url}/${slugFromPath(post.slug)}</loc>
		${parsePostDate(post)}
	</url>
`).join('')}
</urlset>`;

	const headers = {
		'Cache-Control': 'max-age=0, s-maxage=3600',
		'Content-Type': 'application/xml'
	}
	return new Response(sitemap, { headers })
}
