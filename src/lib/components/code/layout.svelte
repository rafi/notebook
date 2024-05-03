<script context="module" lang="ts">
	import codeblock from './block.svelte';
	// import alert from './Alert.svelte';
	// import img from './Image.svelte';

	// export { alert, codeblock, img };
	export { codeblock };
</script>

<script lang="ts">
	// Use the magic props variable to get frontmatter props we haven't exported,
	// and since we're not using them here, this will silence warnings:
	$$restProps;
</script>

<slot />
