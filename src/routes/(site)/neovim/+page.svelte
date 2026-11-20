<script lang="ts">
	import Logo from '#lib/components/neovim/logo.svelte';
	import '#lib/markdown/index.js';

	let { data } = $props();
</script>

<svelte:head>
	<title>rafi/neovim</title>
	<meta name="description" content={data.page.meta.description} />
</svelte:head>

<h1>
	<small>~</small>/neovim config
	<a href="https://github.com/rafi/vim-config" rel="external">
		<img
			class="badge"
			src="https://badgen.net/github/stars/rafi/vim-config"
			alt="GitHub repo stars"
		/>
	</a>
</h1>

<Logo />

<div class="prose">
	<data.page.content />
</div>

<style>
	.badge {
		height: 20px;
	}
</style>
