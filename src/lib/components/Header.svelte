<script lang="ts">
	import { page } from '$app/stores';
	import { fly } from 'svelte/transition';
	import {
		Moon,
		Sun,
		CassetteTape,
		FolderGit2,
		ChevronRight,
	} from 'lucide-svelte';

	import * as config from '$lib/config';
	import { theme, toggleTheme } from '$lib/theme';

	const iconSize = 28;
	let scrollY: number;

	export let url: string | undefined = undefined;
	export let title: string | undefined = undefined;
	export let nav = true;

	$: fixed = scrollY > 0;
	$: pathname = $page.url.pathname;
	$: isBlog =
		!pathname.startsWith('/neovim') &&
		!pathname.startsWith('/wiki') &&
		!['/', '/about'].includes(pathname);
</script>

<svelte:window bind:scrollY />

<div class="wrapper" class:fixed>
	<div class="lhs">
		{#if url}
			<a href={url}>← Back</a>
		{:else}
			<a href={config.url}>
				<ChevronRight /> <span>{config.social.github}</span>
			</a>
		{/if}
	</div>

	{#if nav}
		<nav>
			{#if title}{title}{/if}
			<ul>
				<li aria-current={pathname === '/' ? 'page' : undefined}>
					<a href="/">Work</a>
				</li>
				<li aria-current={pathname === '/about' ? 'page' : undefined}>
					<a href="/about">About</a>
				</li>
				<li aria-current={isBlog ? 'page' : undefined}>
					<a href="/blog">Blog</a>
				</li>
			</ul>
		</nav>
	{/if}

	<div class="rhs">
		<a href={`https://github.com/${config.social.github}`} rel="external">
			<FolderGit2 size={iconSize} />
		</a>

		<a
			href={`https://listenbrainz.org/user/${config.social.listenbrainz}/stats/?range=this_month`}
			rel="external"
		>
			<CassetteTape size={iconSize} />
		</a>

		<button on:click={toggleTheme} aria-label="Toggle theme">
			{#if $theme === 'dark'}
				<div in:fly={{ y: 10 }}>
					<Sun size={iconSize} />
				</div>
			{:else}
				<div in:fly={{ y: -10 }}>
					<Moon size={iconSize} />
				</div>
			{/if}
		</button>
	</div>
</div>

<style>
	/* * { outline: 1px solid red } */

	.wrapper {
		display: flex;
		justify-content: space-between;
		align-items: center;
		width: 100%;

		z-index: 100;
		position: fixed;
		top: 0.4em;
		left: 0;
	}

	.wrapper.fixed {
		top: 0;
		transition: top 0.3s ease;
		box-shadow: 1px 1px 10px #0006;
		-webkit-backdrop-filter: blur(20px);
		backdrop-filter: blur(20px);
	}

	.lhs {
		flex: 1 0 33%;
		width: 3em;
		height: 3em;
		display: flex;
		align-items: center;
		flex-direction: row;
	}

	.rhs {
		flex: 1 0 33%;
		display: flex;
		flex-direction: row;
		justify-content: flex-end;
	}

	.wrapper.fixed .rhs {
		margin-top: 0.2em;
	}

	.lhs a {
		display: flex;
		align-items: center;
		padding-left: 1rem;
	}
	.lhs a,
	.rhs a,
	.rhs button {
		text-decoration: none;
		color: var(--color-text);
		margin-right: 1.7rem;
	}

	@media (max-width: 480px) {
		.lhs {
			flex-shrink: 0.5;
		}
		.lhs a span {
			display: none;
			visibility: hidden;
		}
		.rhs {
			flex-shrink: 0.5;
			justify-content: center;
		}
		.rhs a {
			display: none;
		}
		.rhs button {
			margin-right: 0;
		}
	}

	nav {
		flex: 1 0 34%;
		display: flex;
		justify-content: center;
	}

	ul {
		position: relative;
		padding: 0 2em;
		margin: 0;
		height: 3em;
		display: flex;
		justify-content: center;
		align-items: center;
		list-style: none;
		background: var(--nav-background);
		background-size: contain;

		border-bottom: 1px solid var(--nav-border);
		border-top-left-radius: 30px;
		border-bottom-left-radius: 30px;
		border-top-right-radius: 30px;
		border-bottom-right-radius: 30px;
	}

	.wrapper.fixed ul {
		background: none;
		border: 0;
		transition:
			background-color 0.3s ease,
			color 0.3s ease;
	}

	li {
		position: relative;
		height: 100%;
	}

	li[aria-current='page']::before {
		--size: 6px;
		content: '';
		width: 0;
		height: 0;
		position: absolute;
		top: 0;
		left: calc(50% - var(--size));
		border: var(--size) solid transparent;
		border-top: var(--size) solid var(--color-theme-1);
	}

	nav a {
		display: flex;
		height: 100%;
		align-items: center;
		padding: 0 0.5rem;
		color: var(--color-text);
		font-weight: 700;
		font-size: 0.8rem;
		text-transform: uppercase;
		letter-spacing: 0.1em;
		transition: color 0.2s linear;
		text-decoration: none;
	}

	a:hover {
		color: var(--color-theme-1);
	}

	button {
		padding: 0;
		font-weight: inherit;
		background: none;
		border: none;
		box-shadow: none;
		overflow: hidden;
		cursor: pointer;
	}
	button:hover {
		color: var(--color-theme-1);
	}
</style>
