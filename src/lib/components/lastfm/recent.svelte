<script lang="ts">
	import { Hourglass, Music4 } from 'lucide-svelte';

	import type { Track } from './types';
	import imgNowPlaying from './now-playing.gif';
	import imgHeart from './heart.png';
	import * as config from '$lib/config';

	const cache_millis = 60 * 1000;

	type cachedTracks = {
		time: string;
		tracks: Track[];
	};

	/**
	 * Fetches the recent tracks from the last.fm API.
	 */
	export async function loadTracks(): Promise<cachedTracks> {
		let cacheRaw = localStorage.getItem('recent-tracks');
		if (cacheRaw) {
			const cached: cachedTracks = JSON.parse(cacheRaw);
			if (cached.time && Date.now() - Number(cached.time) < cache_millis) {
				return cached;
			}
		}
		let list: cachedTracks = { time: Date.now().toString(), tracks: [] };
		try {
			const response = await fetch('api/lastfm');
			list.tracks = await response.json().then((data) => data.track);
		} catch (e) {
			console.error(e);
		}

		// Store the result in the cache, even if there was an error to avoid
		// hammering the API.
		localStorage.setItem('recent-tracks', JSON.stringify(list));
		return list;
	}
</script>

<ul>
	{#await loadTracks()}
		<li class="loading">
			<Hourglass size="24" class="wait" />
			Loading...
		</li>
	{:then data}
		{#each data.tracks.slice(0, 3) as track, i}
			<li class="{track['@attr']?.nowplaying ? 'now' : ''}{track.loved ? ' loved' : ''}">
				{#if i == 0}
					<a href={track.artist.url + '/' + track.album['#text']}>
						{#if track.image.length > 1}
							<img src={track.image[1]['#text']} class="track" alt={track.album['#text']} />
						{:else}
							N/A
						{/if}
					</a>
				{:else}
					<Music4 size="16" />
				{/if}
				<a href={track.url} class="name">{track.name}</a>
				by <a href={track.artist.url} class="artist">{track.artist.name}</a>
				{#if track.loved == 1}
					<a href="https://www.last.fm/user/{config.social.lastfm}/loved">
						<img src={imgHeart} alt="love" />
					</a>
				{/if}
				{#if track['@attr']?.nowplaying}
					<a href="https://www.last.fm/user/{config.social.lastfm}">
						<img src={imgNowPlaying} class="now-icon" alt="now playing" />
					</a>
				{/if}
			</li>
		{:else}
			<li class="error">
				None? that's weird.
				<p>Probably a mistake on my part…</p>
			</li>
		{/each}
	{/await}
</ul>

<style>
	/* * { outline: 1px solid red; } */

	ul {
		display: flex;
		flex-direction: column;
		list-style-type: none;
		padding-left: 1.5em;
		margin-bottom: 0;
	}

	li {
		flex: 1;
		list-style: none;
		display: flex;
		align-items: center;
		justify-content: flex-start;
	}

	li:nth-child(1) {
		margin-bottom: 0.4em;
	}

	li.error {
		flex-direction: column;
		align-items: flex-start;
		margin: 0;
	}

	li.error p {
		font-size: 0.775rem;
		margin: 0;
	}

	li.loading {
		align-items: flex-start;
		margin: 2em 0 3rem;
	}

	li.now {
		font-size: 1.1rem;
	}

	li img.track {
		width: 64px;
		border-radius: 0.2em;
		vertical-align: middle;
		margin: 2px;
	}

	li a.name {
		margin: 0 0.4rem 0 0.6rem;
	}

	li a.artist {
		margin: 0 0.4rem 0;
	}

	li a {
		color: var(--color-theme-2);
		text-decoration-thickness: 0.01em;
		text-decoration-color: rgba(118, 171, 174, 0.5);
	}
	img.now-icon {
		width: 13px;
		margin-left: 0.5rem;
	}
</style>
