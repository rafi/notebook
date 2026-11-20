<script lang="ts">
	// Replaces `img` in mdsvex-compiled posts: each image becomes a figure,
	// captioned by its Markdown title. mdsvex passes an enhanced-img picture
	// object for images it optimised, and a plain URL otherwise (SVG, remote).
	import type { Picture } from '@sveltejs/enhanced-img';

	interface Props {
		src: string | Picture;
		alt?: string;
		title?: string;
	}

	let { src, alt = '', title = '' }: Props = $props();

	// Titles are plain text; drop Markdown emphasis markers written in them.
	let caption = $derived(title.replace(/[*_]/g, '').trim());
</script>

<figure class="rehype-figure">
	{#if typeof src === 'string'}
		<img {src} {alt} class="post-img" />
	{:else}
		<enhanced:img {src} {alt} class="post-img" />
	{/if}
	{#if caption}
		<figcaption>{caption}</figcaption>
	{/if}
</figure>
