import { parseFiles, slugFromPath } from '$lib/posts';
import type { Post } from '$lib/types'
import * as config from '$lib/config';
import { formatDate } from '$lib/util/time';

export const prerender = true;

/**
 * @type {import('@sveltejs/kit').RequestHandler}
 */
export async function GET() {
	const paths = import.meta.glob(
		[
			'../../../content/blog/**/*.md',
		],
		{ eager: true }
	)
	const posts = parseFiles(paths)

	const body = xml(posts);
	const headers = {
		'Cache-Control': 'max-age=0, s-maxage=3600',
		'Content-Type': 'application/xml'
	}
	return new Response(body, { headers });
}

const xml = (posts: Post[]) =>
	`<rss version="2.0"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
	xmlns:georss="http://www.georss.org/georss"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
>
	<channel>
		<atom:link href="${config.url}/rss.xml" rel="self" type="application/rss+xml" />
		<title>${config.title}</title>
		<link>${config.url}</link>
		<description>${config.description}</description>
		${posts.map((post) =>
		`<item>
			<guid>${config.url}/${slugFromPath(post.slug)}</guid>
			<title>${post.title ? post.title.replace(/&/, '&amp;') : post.slug}</title>
			<link>${config.url}/${slugFromPath(post.slug)}</link>
			${post.date && '<pubDate>' + formatDate(post.date, 'full') + '</pubDate>'}
			${post.categories ? post.categories.map((name) => `<category>${name}</category>`).join('') : ''}
			<content:encoded><![CDATA[
				<h1><a href="${config.url}/${slugFromPath(post.slug)}">${post.title}</a></h1>
			]]></content:encoded>
		</item>
		`).join('')}
	</channel>
</rss>`;
