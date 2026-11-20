<script lang="ts">
	import { resolve } from '$app/paths';
	import Logo from '#lib/components/neovim/logo.svelte';
	import '#lib/markdown/index.js';

	let { data } = $props();

	const sections = [
		{
			path: 'neovim/extras',
			title: 'Extras',
			description: 'Opt-in plugins: what each does, its keymaps, enabling it',
		},
		{
			path: 'neovim/core',
			title: 'Core plugins',
			description: 'Plugins that always load, and how to replace them',
		},
		{
			path: 'neovim/keymaps',
			title: 'Keymaps',
			description: 'Keymaps set on every install',
		},
		{
			path: 'neovim/customize',
			title: 'Customize',
			description: 'Your own options, keymaps, plugins and extras',
		},
	] as const;
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

<ul class="cards">
	{#each sections as section (section.path)}
		<li>
			<a href={resolve(section.path)}>
				{section.title}
				<span>{section.description}</span>
			</a>
		</li>
	{/each}
</ul>

<style>
	.badge {
		height: 20px;
	}
</style>
