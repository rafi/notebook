import { escapeSvelte } from 'mdsvex';
import { defineMDSveXConfig as defineConfig } from 'mdsvex';
import { getHighlighter } from 'shiki';
import { visit } from 'unist-util-visit';
import toCamel from 'just-camel-case';
import { h } from 'hastscript';
import {
	transformerNotationDiff,
	transformerNotationErrorLevel,
	transformerMetaHighlight,
	transformerMetaWordHighlight,
} from '@shikijs/transformers';

// Remark / Rehype plugins
import remarkToc from 'remark-toc';
import rehypeSlug from 'rehype-slug';
import rehypeRewrite from 'rehype-rewrite';
import remarkAdmonitions from 'remark-admonitions';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';

// import { rehypeGithubAlerts } from 'rehype-github-alerts'; // WORKS!
// import remarkAlerts from 'remark-alerts'; // bad
// import { remarkAlert } from 'remark-github-blockquote-alert'; // bad
// import remarkGitHubAlerts from 'remark-github-beta-blockquote-admonitions'; // bad
// import remarkGithubAlerts from 'remark-github-alerts'; // bad

// See https://mdsvex.pngwn.io/docs#use-it
/** @type {import('mdsvex').MdsvexOptions} */
export default defineConfig({
	extensions: ['.md'],
	smartypants: true,
	layout: './src/lib/components/code/layout.svelte',
	remarkPlugins: [
		remarkAdmonitions,
		relativeImages,
		// See https://github.com/remarkjs/remark-toc#api
		[remarkToc, { tight: true, maxDepth: 4 }],
	],
	rehypePlugins: [
		[rehypeRewrite, {
			rewrite: (node) => {
				if (node.type == 'element' && node.tagName == 'img') {
					if (!node.properties.src.endsWith('Svg}')) {
						node.tagName = 'enhanced:img';
					}
					// node.properties['sizes'] = '';
					node.properties['class'] = `post-img ${node.properties['class'] ?? ''}`.trimEnd();
				}
			}
		}],
		rehypeFigure,
		rehypeSlug,
		[rehypeAutolinkHeadings, {
			behavior: 'append',
			properties: { className: 'hash-link' },
		}],
	],
	highlight: {
		highlighter: async (code, lang = 'text', meta) => {
			const highlighter = await getHighlighter({
				// See https://shiki.matsu.io/themes
				themes: ['nord', 'min-light'],
				// See https://shiki.matsu.io/languages
				langs: langs,
				langAlias: langAlias,
			})
			await highlighter.loadLanguage(...langs)
			const html = highlighter.codeToHtml(code, {
				lang,
				themes: {
					light: 'min-light',
					dark: 'nord',
				},
				meta: meta ? { __raw: meta } : undefined,
				// Manage the color of the code block ourselves, see layout.css
				defaultColor: false,
				transformers: [
					transformerNotationDiff(),
					transformerNotationErrorLevel(),
					transformerMetaHighlight(),
					transformerMetaWordHighlight(),
				],
			})

			// Match attribute-like strings, and feed them into props
			// for example: `src="adfjkl;" hello yourmom='sorry'`
			const attrMatch = meta?.matchAll(/(?:\w+)(?:="[^"]*"|='[^']*')?(?:\s|$)/g) ?? [];

			let attr = [...attrMatch].join('');
			if (lang) attr += ` lang="${lang}"`;

			// Wrap the html with custom component `codeblock`
			return `<Components.codeblock ${attr}>{@html \`${escapeSvelte(html)}\` }</Components.codeblock>`;
		}
	},
})

const langAlias = {
	readline: 'shell',
	dosbatch: 'bat',
	Dockerfile: 'dockerfile',
}

// See https://shiki.matsu.io/languages
const langs = [
	'applescript',
	'bash',
	'bat',
	'c',
	'cpp',
	'csharp',
	'css',
	'diff',
	'dockerfile',
	'go',
	'html',
	'ini',
	'java',
	'javascript',
	'json',
	'log',
	'lua',
	'make',
	'md',
	'php',
	'powershell',
	'python',
	'rust',
	'shell',
	'svelte',
	'swift',
	'toml',
	'typescript',
	'yaml',
]

// This is a modified version of the relative-images plugin from mdsvex.
// Original: https://github.com/mattjennings/mdsvex-relative-images
// See also: https://github.com/n1kk/rehype-mdsvex-image-autoimport/blob/master/index.ts
const RE_SCRIPT_START =
	/<script(?:\s+?[a-zA-z]+(=(?:["']){0,1}[a-zA-Z0-9]+(?:["']){0,1}){0,1})*\s*?>/;
const RE_SRC = /src\s*=\s*"(.+?)"/;

function relativeImages() {
	return function transformer(tree) {
		const urls = new Map();
		const url_count = new Map();

		// Replace relative URLs with module imports.
		function transformUrl(url) {
			url = decodeURIComponent(url)

			if (url.startsWith('.')) {
				// Filenames can start with digits, prepend underscore to guarantee
				// valid module name.
				let camel = `_${toCamel(url)}`;
				const count = url_count.get(camel);
				const dupe = urls.get(url);

				if (count && !dupe) {
					url_count.set(camel, count + 1);
					camel = `${camel}_${count}`;
				} else if (!dupe) {
					url_count.set(camel, 1);
				}

				urls.set(url, {
					path: url,
					id: camel,
				});

				return `{${camel}}`;
			}
			return url;
		}

		// Transform URLs in images.
		visit(tree, ['image', 'definition'], (node) => {
			node.url = transformUrl(node.url);
		});

		// Transform src in html nodes.
		visit(tree, 'html', (node) => {
			// only run on img or video elements. this is a cheap way to check it,
			// eventually we should integrate it into the RE_SRC regex.
			const isSupportedElement = node.value && node.value.match(/img|video/);

			if (isSupportedElement) {
				const [, url] = node.value.match(RE_SRC) ?? [];
				if (url) {
					const transformed = transformUrl(url);
					node.value = node.value.replace(`"${url}"`, transformed);
				}
			}
		});

		// Inject script imports with relative assets.
		// See https://github.com/JonasKruckenberg/imagetools/blob/main/docs/directives.md
		let scripts = '';
		const urlParams = {
			'enhanced': true,
			'w': '200;400;700',
			'withoutEnlargement': true,
			'withoutReduction': true,
		};
		const imageParams = new URLSearchParams(urlParams);
		urls.forEach((x) => {
			scripts += `import ${x.id} from "${x.path}`
			if (!x.path.endsWith('.svg')) {
				scripts += `?${imageParams}`
			}
			scripts += '";\n';
		});

		let is_script = false;

		visit(tree, 'html', (node) => {
			if (RE_SCRIPT_START.test(node.value)) {
				is_script = true;
				node.value = node.value.replace(RE_SCRIPT_START, (script) => {
					return `${script}\n${scripts}`;
				});
			}
		});

		if (!is_script) {
			tree.children.push({
				type: 'html',
				value: `<script>\n${scripts}</script>`,
			});
		}
	};
}

// Convert images wrapped in <p> tags to <figure> tags, and add caption.
// Reference: https://github.com/josestg/rehype-figure
function rehypeFigure(option) {
	const className = (option && option.className) || 'rehype-figure'
	const imgTagName = (option && option.imgTagName) || 'enhanced:img'

	function buildFigure({ properties }) {
		const figure = h('figure', { class: className }, [
			h(imgTagName, { ...properties }),
			properties.title && properties.title.trim().length > 0
				? h('figcaption', properties.title)
				: '',
		])
		return figure
	}

	return function(tree) {
		visit(tree, { tagName: 'p' }, (node, index) => {

			const images = node.children
				.filter((n) => n.tagName === imgTagName)
				.map((img) => buildFigure(img))

			if (images.length === 0) return

			tree.children[index] =
				images.length === 1
					? images[0]
					: (tree.children[index] = h(
						'div',
						{ class: `${className}-container` },
						images
					))
		})
	}
}
