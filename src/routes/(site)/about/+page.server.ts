import { VERCEL_GIT_COMMIT_SHA, VERCEL_GIT_COMMIT_REF } from '$app/env/private';

export function load() {
	return {
		gitSHA: VERCEL_GIT_COMMIT_SHA,
		gitRef: VERCEL_GIT_COMMIT_REF,
	};
}
