import { json as jsonResponse } from '@sveltejs/kit'
import { getPosts } from '$lib/posts'

// export const prerender = true

export async function GET() {
	const posts = await getPosts('blog')
	return jsonResponse(posts)
}
