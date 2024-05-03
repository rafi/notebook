import type { LayoutLoadEvent } from './$types';

// Serve as a static page in production.
export const prerender = true;

export const trailingSlash = 'never';

export function load({ url }: LayoutLoadEvent) {
	return {
		url: url.pathname,
	};
}
