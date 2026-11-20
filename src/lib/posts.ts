import type { Component } from 'svelte';
import type { TocHeading } from '@mdsvex/plugin-toc';
import type { Post, ImportedFile } from '#lib/types/index.ts';

/** Shape of a Markdown module compiled by mdsvex. */
type MarkdownModule = {
	default: Component;
	metadata?: Omit<Post, 'slug'>;
	// Data mdsvex plugins leave per document; @mdsvex/plugin-toc's headings.
	plugin_data?: { toc?: { headings: TocHeading[] } };
};

/**
 * Convert content file path to slug.
 * @param path - File path.
 */
export function slugFromPath(path: string): string {
	return (
		path
			.split('/')
			// Remove first folder (content), and for main blog, remove 'blog'.
			.filter((v, i) => v && i > 0 && !(i == 1 && v == 'blog'))
			.join('/')
	);
}

/**
 * Parse Markdown files.
 * @param paths - Imported files from vite's import.meta.glob(...)
 * @param subPath - Optional sub-path to prepend to slug.
 */
export function parseFiles(
	paths: Record<string, unknown>,
	subPath: string = ''
) {
	let posts: Post[] = [];
	for (const path in paths) {
		const file = paths[path];

		// Create a slug from the file path.
		// Remove the first two sub-paths and extension. (xxx/yyy/zzz.md -> zzz)
		let slug = path
			.split('/')
			.filter((v, i) => v && i > 2)
			.join('/')
			.replace('.md', '');

		if (subPath) {
			slug = `${subPath}/${slug}`;
		}

		if (file && typeof file === 'object' && 'metadata' in file && slug) {
			const metadata = file.metadata as Omit<Post, 'slug'>;
			const post = { ...metadata, slug } satisfies Post;
			if (post.published) posts.push(post);
		}
	}

	posts = posts.sort((first, second) => {
		if (!first.date || !second.date) return 0;
		return new Date(second.date).getTime() - new Date(first.date).getTime();
	});
	return posts;
}

function asPost(slug: string, post: MarkdownModule): ImportedFile {
	return {
		slug,
		content: post.default,
		meta: post.metadata || {},
		toc: post.plugin_data?.toc?.headings ?? [],
	};
}

export async function getPost(slug: string) {
	const post = await import(`../../content/blog/${slug}.md`);
	return asPost(slug, post);
}
