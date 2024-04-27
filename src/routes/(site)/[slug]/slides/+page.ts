import type { PageLoadEvent } from './$types';
import { error } from '@sveltejs/kit';
import jsYaml from 'js-yaml';

import * as config from '$lib/config';
import type { Frontmatter } from '$lib/types';

export const ssr = false
export const csr = true

const reMarkdownImage = /!\[([^\]]+)\]\(\.\/([^)]+)\)/g;

type MarkdownRaw = {
	meta: Frontmatter
	body: string
}

export async function load({ params }: PageLoadEvent) {
	// Vite import assset as string
	// https://vitejs.dev/guide/assets.html#importing-asset-as-string
	let raw = await import(`../../../../../content/blog/${params.slug}.md?raw`)

	// Prepend base path to images in slides.
	raw = raw.default.replace(
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
	const data = parseYAMLMatter(raw, {})
	raw = `# ${data.meta.title}\n\n---\n\n` + data.body;

	try {
		return {
			slug: params.slug,
			raw: raw,
		}
	} catch (e) {
		error(404, `Could not find ${params.slug}`)
	}
}

function parseYAMLMatter(text: string, opts: jsYaml.LoadOptions) {
	const re = /^(-{3}(?:\n|\r)([\w\W]+?)(?:\n|\r)-{3})?([\w\W]*)*/
	let results = re.exec(text)

	let data: MarkdownRaw = { meta: {}, body: '' }
	if (results === null) {
		return data
	}
	if (results.length > 1 && results[2]) {
		const str = results[2]
		if (str.charAt(0) === '{') {
			data.meta = JSON.parse(str);
		} else {
			data.meta = jsYaml.load(str, opts) as Frontmatter;
		}
	}
	if (results.length > 2 && results[3]) {
		data.body = results[3];
	}
	return data;
};
