<script lang="ts">
	import { getContext } from 'svelte';
	import type { TabsContext } from './tabs.svelte';

	interface Props {
		value: string;
		label: string;
		children?: import('svelte').Snippet;
	}

	let { value, label, children }: Props = $props();
	export const selected: boolean = false;

	const ctx = getContext<TabsContext>('tabs');

	const { content } = $ctx;

	ctx.update((n) => {
		n.triggers.set(value, label);
		return n;
	});
</script>

<div {...$content(value)} use:content>
	{@render children?.()}
</div>

<style>
	div {
		box-sizing: border-box;
		border-block-start: solid 0.0625rem hsl(0 0% 100% / 0.06);
		padding-block-start: 1rem;
		width: 100%;
	}
</style>
