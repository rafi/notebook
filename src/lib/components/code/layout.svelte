<script context="module">
	import codeblock from './block.svelte';

	export { codeblock };
</script>

<script lang="ts">
	// Use the magic props variable to get frontmatter props we haven't exported,
	// and since we're not using them here, this will silence warnings:
	$$restProps;
</script>

<slot />
