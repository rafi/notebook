import type { PageLoadEvent } from './$types';
import { error } from '@sveltejs/kit';
import { load as loadYaml, type LoadOptions } from 'js-yaml';

import * as config from '#lib/config.js';
import type { Frontmatter } from '#lib/types/index.ts';

export const prerender = false;
export const ssr = false;
export const csr = true;

const reMarkdownImage = /!\[([^\]]+)\]\(\.\/([^)]+)\)/g;

type MarkdownRaw = {
	meta: Frontmatter;
	body: string;
};

export async function load({ params }: PageLoadEvent) {
	// Vite import assset as string
	// https://vitejs.dev/guide/assets.html#importing-asset-as-string
	let source: string;
	try {
		source = (await import(`../../../../../content/blog/${params.slug}.md?raw`))
			.default;
	} catch {
		error(404, `Could not find ${params.slug}`);
	}

	// Prepend base path to images in slides.
	source = source.replace(
		reMarkdownImage,
		`![$1](${config.imageBaseURL}/${config.deploy.gitRef}/content/blog/$2)`
	);

	// TODO: Better way to parse frontmatter?
	// const fileOfUnified = unified()
	// 	.use(remarkParse)
	// 	.use(remarkStringify)
	// 	.use(remarkFrontmatter, ['yaml', 'toml'])
	// 	.use(remarkParseFrontmatter)

	// Split meta and body
	const data = parseYAMLMatter(source, {});

	return {
		slug: params.slug,
		raw: `# ${data.meta.title}\n\n---\n\n` + data.body,
	};
}

/**
 * Parse YAML frontmatter from markdown string
 * @param text - markdown string
 * @param opts - yaml load options
 * @returns Object
 */
function parseYAMLMatter(text: string, opts: LoadOptions) {
	const re = /^(-{3}(?:\n|\r)([\w\W]+?)(?:\n|\r)-{3})?([\w\W]*)*/;
	const results = re.exec(text);

	const data: MarkdownRaw = { meta: {}, body: '' };
	if (results === null) {
		return data;
	}
	if (results.length > 1 && results[2]) {
		const str = results[2];
		if (str.charAt(0) === '{') {
			data.meta = JSON.parse(str);
		} else {
			data.meta = loadYaml(str, opts) as Frontmatter;
		}
	}
	if (results.length > 2 && results[3]) {
		data.body = results[3];
	}
	return data;
}
