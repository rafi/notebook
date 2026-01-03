<script lang="ts">
	import Tree from './tree.svelte';
	import {
		type TableOfContents,
		type TableOfContentsElements,
		type TableOfContentsItem,
		melt,
	} from '@melt-ui/svelte';

	interface Props {
		tree?: TableOfContentsItem[];
		activeHeadingIdxs: number[];
		item: TableOfContentsElements['item'];
		level?: number;
		isActive: TableOfContents['helpers']['isActive'];
	}

	let {
		tree = [],
		activeHeadingIdxs,
		item,
		level = 1,
		isActive
	}: Props = $props();

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
				<div
					class={'list-item text-muted-foreground ' +
						($isActive(heading.id) && 'active ')}
				>
					<a href="#{heading.id}" use:melt={$item(heading.id)} use:hoverAction>
						{@html nodeWithoutSpan}
					</a>
				</div>

				{#if heading.children && heading.children.length}
					<Tree
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
