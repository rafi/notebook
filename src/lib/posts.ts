import type { Post, ImportedFile } from '$lib/types'

/**
 * Convert content file path to slug.
 * @param path - File path.
 */
export function slugFromPath(path: string): string {
	return path.split('/')
		// Remove first folder (content), and for main blog, remove 'blog'.
		.filter((v, i) => v && i > 0 && !(i == 1 && v == 'blog'))
		.join('/')
}

/**
 * Parse Markdown files.
 * @param paths - Imported files from vite's import.meta.glob(...)
 * @param subPath - Optional sub-path to prepend to slug.
 */
export function parseFiles(paths: Record<string, any>, subPath: string = '') {
	let posts: Post[] = []
	for (const path in paths) {
		const file = paths[path]

		// Create a slug from the file path.
		// Remove the first two sub-paths and extension. (xxx/yyy/zzz.md -> zzz)
		let slug = path.split('/')
			.filter((v, i) => v && i > 2)
			.join('/')
			.replace('.md', '')

		if (subPath) {
			slug = `${subPath}/${slug}`
		}

		if (file && typeof file === 'object' && 'metadata' in file && slug) {
			const metadata = file.metadata as Omit<Post, 'slug'>
			const post = { ...metadata, slug } satisfies Post
			post.published && posts.push(post)
		}
	}

	posts = posts.sort((first, second) => {
		if (!first.date || !second.date) return 0
		return new Date(second.date).getTime() - new Date(first.date).getTime()
	})
	return posts
}

function asPost(slug: string, post: any): ImportedFile {
	return {
		slug,
		content: post.default,
		meta: post.metadata as Omit<Post, 'slug'> || {},
	}
}

export async function getPost(slug: string) {
	let post = await import(`../../content/blog/${slug}.md`)
	return asPost(slug, post)
}

export async function getWikiPage(slug: string) {
	let post = await import(`../../content/wiki/${slug}.md`)
	return asPost(slug, post)
}

export async function getNeovimPage(slug: string) {
	let post = await import(`../../content/neovim/${slug}.md`)
	return asPost(slug, post)
}

export async function getNeovimBlogPost(slug: string) {
	let post = await import(`../../content/neovim/blog/${slug}.md`)
	return asPost(slug, post)
}

export async function getNeovimConfigPage(slug: string) {
	let post = await import(`../../content/neovim/config/${slug}.md`)
	return asPost(slug, post)
}

export async function getNeovimPluginPage(slug: string) {
	let post = await import(`../../content/neovim/plugins/${slug}.md`)
	return asPost(slug, post)
}

export async function getNeovimExtrasPage(slug: string) {
	let post: any
	const parts = slug.split('/')
	switch (parts.length) {
		case 1:
			post = await import(`../../content/neovim/extras/${parts[0]}.md`)
			return asPost(slug, post)
		case 2:
			post = await import(`../../content/neovim/extras/${parts[0]}/${parts[1]}.md`)
			return asPost(slug, post)
		case 3:
			post = await import(`../../content/neovim/extras/${parts[0]}/${parts[1]}/${parts[2]}.md`)
			return asPost(slug, post)
		default:
			throw new Error('slug nested too deep')
	}
}
