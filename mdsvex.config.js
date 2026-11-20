import { anchors } from '@mdsvex/plugin-anchors';
import { emoji } from '@mdsvex/plugin-emoji';
import { tabs } from '@mdsvex/plugin-tabs';
import { toc } from '@mdsvex/plugin-toc';
import { createHighlighter } from 'shiki';
import {
	transformerNotationDiff,
	transformerNotationErrorLevel,
	transformerMetaHighlight,
	transformerMetaWordHighlight,
} from '@shikijs/transformers';

const langAlias = {
	readline: 'shell',
	dosbatch: 'bat',
	Dockerfile: 'dockerfile',
};

// See https://shiki.style/languages
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
	'json5',
	'jsonc',
	'log',
	'lua',
	'make',
	'md',
	'php',
	'powershell',
	'python',
	'rust',
	'shell',
	'sql',
	'ssh-config',
	'svelte',
	'swift',
	'systemd',
	'toml',
	'typescript',
	'viml',
	'yaml',
];

// Shiki's plain-text pseudo languages, always available.
const plainLangs = new Set(['text', 'txt', 'plain', 'plaintext']);

const shiki = await createHighlighter({
	themes: ['github-light', 'github-dark'],
	langs,
	langAlias,
});
const loadedLangs = new Set([
	...shiki.getLoadedLanguages(),
	...Object.keys(langAlias),
]);

/**
 * Highlights fenced code with Shiki, in both themes at once; the site's CSS
 * picks one by `color-scheme` (see layout.css). Inline code and languages
 * Shiki doesn't have render plain.
 * @type {import('mdsvex').Highlighter}
 */
function highlight(code, { lang, meta, inline }) {
	if (inline) return null;
	const id = lang || 'text';
	if (!plainLangs.has(id) && !loadedLangs.has(id)) return null;
	return shiki.codeToHtml(code, {
		lang: id,
		themes: { light: 'github-light', dark: 'github-dark' },
		// Manage the color of the code block ourselves, see layout.css
		defaultColor: false,
		meta: meta ? { __raw: meta } : undefined,
		transformers: [
			transformerNotationDiff(),
			transformerNotationErrorLevel(),
			transformerMetaHighlight(),
			transformerMetaWordHighlight(),
		],
	});
}

/** @type {import('mdsvex').MdsvexOptions} */
export default {
	extensions: ['.md'],
	components: '#lib/markdown/index.js',
	smart_punctuation: true,
	heading_ids: true,
	unwrap_images: true,
	plugins: [
		anchors({ position: 'append', attrs: { class: 'hash-link' } }),
		emoji(),
		// h2-h3 of each post, rendered by the article's TableOfContents
		toc({ min_depth: 2, max_depth: 3 }),
		// Stylesheet is imported once by the article component instead.
		tabs({ css: false }),
	],
	highlight,
};
