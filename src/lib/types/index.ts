import type { Component } from 'svelte';
import type { TocHeading } from '@mdsvex/plugin-toc';
import type * as config from '#lib/config.js';

export type ImportedFile = {
	slug: string;
	meta: Omit<Post, 'slug'>;
	content: Component;
	// h2-h3 headings of the post, from @mdsvex/plugin-toc
	toc: TocHeading[];
};

export type Post = Frontmatter & {
	slug: string;
};

export type Frontmatter = {
	title?: string;
	description?: string;
	published?: boolean;
	date?: string;
	updated?: string;
	presentation?: boolean;
	categories?: string[];
	search?: {
		keywords?: string[];
	};

	series?: string;
	draft?: string;
};

export type Fetch = (
	input: RequestInfo | URL,
	init?: RequestInit
) => Promise<Response>;

export type Categories = keyof typeof config.categories;
