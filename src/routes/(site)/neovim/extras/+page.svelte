<script lang="ts">
	import { neovimCommit } from '#lib/posts.ts';
	import ExtrasTable from '#lib/components/neovim/extras-table.svelte';
	import GeneratedFrom from '#lib/components/neovim/generated-from.svelte';

	let { data } = $props();
</script>

<svelte:head>
	<title>rafi/neovim: extras</title>
</svelte:head>

<h1><small>~</small>/neovim/extras</h1>

<div class="prose">
	<p>
		Extras are opt-in plugins. Toggle them with <code>:RafiExtras</code>
		(<kbd>Space</kbd><kbd>m</kbd><kbd>x</kbd>) or in your
		<code>rafi.json</code>. The ones marked ✓ are enabled on a fresh install.
	</p>
</div>

<ExtrasTable posts={data.posts} filterable />

<GeneratedFrom commit={neovimCommit} />
