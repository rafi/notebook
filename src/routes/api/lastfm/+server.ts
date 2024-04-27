import type { RequestEvent } from './$types';
import { json as jsonResponse } from '@sveltejs/kit';

import { LASTFM_API_KEY } from '$env/static/private'
import * as config from '$lib/config';
import type { RecentTracksResponse } from '$lib/components/lastfm';

const lastfmAPI = 'https://ws.audioscrobbler.com/2.0/';
const trackCount = 3;

export async function GET({ setHeaders }: RequestEvent) {
	setHeaders({
		'Access-Control-Allow-Origin': config.url,
	})

	const user = config.social.lastfm;
	const result = await getRecentTracks(user);
	return jsonResponse(result);
}

/**
 * Fetch the recent tracks from Last.fm
 * @param user - The Last.fm username
 * @returns JSON response
 */
async function getRecentTracks(user: string): Promise<RecentTracksResponse> {
	const params = {
		method: 'user.getrecenttracks',
		user: user,
		format: 'json',
		api_key: LASTFM_API_KEY,
		limit: trackCount.toString(),
		extended: '1',
	}
	const urlParams = new URLSearchParams(params);
	const response = await fetch(lastfmAPI + '?' + urlParams.toString());

	if (!response.ok) {
		throw new Error(`Failed to fetch: ${response.status}`);
	}

	return await response.json().then((data) => data?.recenttracks);
}
