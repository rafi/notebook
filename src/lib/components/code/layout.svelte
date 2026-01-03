<script module>
	import codeblock from './block.svelte';

	export { codeblock };
</script>

<script lang="ts">
	interface Props {
		children?: import('svelte').Snippet;
		[key: string]: any
	}

	let { children, ...rest }: Props = $props();
	// Use the magic props variable to get frontmatter props we haven't exported,
	// and since we're not using them here, this will silence warnings:
	rest;
</script>

{@render children?.()}
