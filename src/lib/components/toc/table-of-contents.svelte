<script lang="ts">
	// Post sidebar: @mdsvex/plugin-toc's list of the post's h2-h3 headings,
	// with every section on screen highlighted. Styled in src/styles/toc.css.
	import Toc from '@mdsvex/plugin-toc/Toc.svelte';
	import type { TocHeading } from '@mdsvex/plugin-toc';
	import { highlightVisibleSections } from './highlight.ts';

	interface Props {
		headings: TocHeading[];
	}

	let { headings }: Props = $props();
</script>

<Toc
	{headings}
	min_depth={2}
	max_depth={3}
	{@attach highlightVisibleSections}
/>
