<script lang="ts">
	import { untrack } from 'svelte';
	import { createTableOfContents } from '@melt-ui/svelte';
	import Tree from './tree.svelte';

	interface Props {
		selector?: string;
	}

	let { selector = '.prose' }: Props = $props();

	const {
		elements: { item },
		states: { headingsTree, activeHeadingIdxs },
		helpers: { isActive },
	} = createTableOfContents({
		// The builder reads the selector once; later prop changes don't apply.
		selector: untrack(() => selector),
		exclude: ['h1', 'h4', 'h5', 'h6'],
		activeType: 'all',
		scrollOffset: 80,
	});
</script>

<div class="toc">
	<nav>
		{#key $headingsTree}
			<Tree
				tree={$headingsTree}
				activeHeadingIdxs={$activeHeadingIdxs}
				{item}
				{isActive}
			/>
		{/key}
	</nav>
</div>

<style>
	@media (max-width: 1000px) {
		.toc {
			display: none;
			visibility: hidden;
			max-height: 0;
		}
	}
</style>
