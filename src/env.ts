import { defineEnvVars } from '@sveltejs/kit/env';

export const variables = defineEnvVars({
	LASTFM_API_KEY: { static: true },
	VERCEL_GIT_COMMIT_SHA: { static: true },
	VERCEL_GIT_COMMIT_REF: { static: true },
});
