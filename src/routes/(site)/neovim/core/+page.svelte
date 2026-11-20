<script lang="ts">
	import { neovimCommit } from '#lib/posts.ts';
	import ExtrasTable from '#lib/components/neovim/extras-table.svelte';
	import GeneratedFrom from '#lib/components/neovim/generated-from.svelte';

	let { data } = $props();
</script>

<svelte:head>
	<title>rafi/neovim: core plugins</title>
</svelte:head>

<h1><small>~</small>/neovim/core</h1>

<div class="prose">
	<p>
		These plugins always load. Each can be turned off by adding its name to
		<code>disabled</code> in your <code>rafi.json</code>, except
		<code>snacks</code>.
	</p>
</div>

<ExtrasTable posts={data.posts} />

<GeneratedFrom commit={neovimCommit} />
