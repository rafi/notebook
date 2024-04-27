<script lang="ts">
	import {
		type TableOfContents,
		type TableOfContentsElements,
		type TableOfContentsItem,
		melt,
	} from '@melt-ui/svelte';

	export let tree: TableOfContentsItem[] = [];
	export let activeHeadingIdxs: number[];
	export let item: TableOfContentsElements['item'];
	export let level = 1;
	export let isActive: TableOfContents['helpers']['isActive'];

	function hoverAction(node: HTMLElement) {
		function handleMouseEnter() {
			node.parentElement?.setAttribute('data-hover', '');
		}

		function handleMouseLeave() {
			node.parentElement?.removeAttribute('data-hover');
		}

		node.addEventListener('mouseenter', handleMouseEnter);
		node.addEventListener('mouseleave', handleMouseLeave);

		return {
			destroy() {
				node.removeEventListener('mouseenter', handleMouseEnter);
				node.removeEventListener('mouseleave', handleMouseLeave);
			},
		};
	}
</script>

<ul class="m-0 list-none">
	{#if tree && tree.length}
		{#each tree as heading, i (i)}
			{@const node = heading.node.innerHTML}
			{@const nodeWithoutSpan = node.replace(/<span.*<\/span>/g, '')}
			<li class="mt-0 {level === 1 && 'parent'}">
				<div class={'list-item text-muted-foreground ' + ($isActive(heading.id) && 'active ')}>
					<a href="#{heading.id}" use:melt={$item(heading.id)} use:hoverAction>
						<!--  eslint-disable-next-line svelte/no-at-html-tags -->
						{@html nodeWithoutSpan}
					</a>
				</div>

				{#if heading.children && heading.children.length}
					<svelte:self
						tree={heading.children}
						level={level + 1}
						{activeHeadingIdxs}
						{isActive}
						{item}
					/>
				{/if}
			</li>
		{/each}
	{/if}
</ul>
