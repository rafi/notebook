import type { LayoutServerLoadEvent } from './$types';

// Serve as a static page in production.
export const prerender = true;

export const trailingSlash = 'never';

/** @type {import('./$types').LayoutServerLoad} */
export function load({ url }: LayoutServerLoadEvent) {
	return {
		url: url.pathname,
	};
}
