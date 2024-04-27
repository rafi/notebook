import type { Post } from '$lib/types'

export async function getPosts(dir: string) {
	let posts: Post[] = []
	let paths: Record<string, any> = {}

	switch (dir) {
		case 'blog':
			paths = import.meta.glob('/content/blog/*.md', { eager: true })
			break
		case 'neovim':
			paths = import.meta.glob('/content/neovim/*.md', { eager: true })
			break
		case 'wiki':
			paths = import.meta.glob('/content/wiki/*.md', { eager: true })
			break
		default:
			return posts
	}

	// Find all markdown files in the right content directory.
	for (const path in paths) {
		const file = paths[path]
		let slug = path.split('/').at(-1)?.replace('.md', '')
		if (dir == 'wiki') {
			slug = `/wiki/` + slug
		} else if (dir == 'neovim') {
			slug = `/neovim/` + slug
		}

		if (file && typeof file === 'object' && 'metadata' in file && slug) {
			const metadata = file.metadata as Omit<Post, 'slug'>
			const post = { ...metadata, slug } satisfies Post
			post.published && posts.push(post)
		}
	}

	posts = posts.sort((first, second) =>
		new Date(second.date).getTime() - new Date(first.date).getTime()
	)

	return posts
}
