<script module>
	export { default as codeblock } from './block.svelte';
</script>

<script lang="ts">
	interface Props {
		children?: import('svelte').Snippet;
		// mdsvex passes each post's frontmatter as props.
		[key: string]: unknown;
	}

	let { children }: Props = $props();
</script>

{@render children?.()}
