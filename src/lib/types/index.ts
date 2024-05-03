import type * as config from '$lib/config';

export type ImportedFile = {
	slug: string
	meta: Omit<Post, 'slug'>
	content: string
}

export type Post = Frontmatter & {
	slug: string
}

export type Frontmatter = {
	title?: string
	description?: string
	published?: boolean
	date?: string
	updated?: string
	presentation?: boolean
	categories?: string[]
	search?: {
		keywords?: string[]
	}

	series?: string
	draft?: string
}

export type Fetch = (
	input: RequestInfo | URL,
	init?: RequestInit
) => Promise<Response>

export type Categories = keyof typeof config.categories;
