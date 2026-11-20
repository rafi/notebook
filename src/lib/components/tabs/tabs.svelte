<script lang="ts" module>
	import type { Writable } from 'svelte/store';
	export type TabsContext = Writable<{
		content: any;
		triggers: Map<string, string>;
	}>;
</script>

<script lang="ts">
	import { createTabs } from '@melt-ui/svelte';
	import { setContext } from 'svelte';
	import { writable } from 'svelte/store';
	import { fade } from 'svelte/transition';
	import { linear } from 'svelte/easing';
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();

	const {
		elements: { root, list, content, trigger },
		states: { value },
	} = createTabs();

	const ctx = setContext<TabsContext>(
		'tabs',
		writable({
			content,
			triggers: new Map(),
		})
	);
</script>

<div class="tabs-wrapper" {...$root} use:root>
	<div class="tabs">
		<ul class="tabs-list" {...$list} use:list>
			{#each $ctx.triggers.entries() as [id, title]}
				<li class="tabs-item">
					<button
						class="tabs-button"
						class:is-selected={$value === id}
						{...$trigger(id)}
						use:trigger
					>
						{title}
					</button>
				</li>
			{/each}
		</ul>
	</div>
	{#key $value}
		<div class="tab-view" in:fade={{ easing: linear, duration: 100 }}>
			{@render children?.()}
		</div>
	{/key}
</div>

<style>
	.tabs-wrapper {
		margin-block-end: 2rem;
		display: block;
		background-color: var(--nav-background);
		border: solid 0.0625rem var(--border-color);
		padding: 1rem 1.5rem;
		border-radius: 1rem;
	}

	.tabs {
		display: flex;
		position: relative;
	}

	.tabs-list {
		display: flex;
		list-style: none;
		gap: 1rem;
		margin: 1rem 0 0;
		overflow: auto;
		-ms-overflow-style: none;
		scrollbar-width: none;
	}

	.tabs-item {
		list-style: none;
	}

	.tabs-button:is(:global(.is-selected)) {
		color: var(--muted-foreground);
	}

	.tabs-button {
		cursor: pointer;
		position: relative;
		display: flex;
		align-items: center;
		padding-inline: 0.25rem;
		padding-block: 0.4375rem;
		-webkit-user-select: none;
		user-select: none;
		border-style: solid;
		border-color: #444444;
		border-width: 0.01rem 0.01rem 0 0;
		border-radius: 0.425rem 0.425rem 0 0;
		background-clip: padding-box;
		padding: 0.5rem 1rem 0.5rem 1rem;

		color: hsl(240 9% 34%);
		background-color: var(--color-bg-1);
	}

	.tab-view {
		width: 100%;
		min-height: 100px;
		overflow: hidden;
		height: auto;
	}
</style>
