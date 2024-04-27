import type * as config from '$lib/config';

export type Post = {
	title: string
	description: string
	slug: string
	published: string
	date: string
	updated: string
	slideshow: boolean
	categories: string[]
	search: {
		keywords: string[]
	}
	series?: string
	draft?: string
}

export type Frontmatter = {
	title?: string
	description?: string
	slug?: string
	published?: string
	category?: string
}

export type Fetch = (
	input: RequestInfo | URL,
	init?: RequestInit
) => Promise<Response>

export type Categories = keyof typeof config.categories;
