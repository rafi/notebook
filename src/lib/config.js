import { dev } from '$app/environment'

export const title = '~rafi'
export const name = 'Rafael Bodill'
export const description = `${name}'s personal web corner`
export const url = dev ? 'http://localhost:5173' : 'https://rafi.io'
export const sinceYear = 2013
export const image = `${url}/img/logo.png`
export const imageBaseURL = 'https://raw.githubusercontent.com/rafi/notebook'

export const social = {
	email: 'justrafi',
	github: 'rafi',
	dotfiles: '.config',
	twitter: 'rafib',
	youtube: 'justRafib',
	lastfm: 'rafib',
	listenbrainz: 'rafib',
}

export let deploy = {
	gitRef: 'master',
	gitSHA: ''
};

export const categories = {
	general: 'General',
	design: 'Design',
	music: 'Music',
	programming: 'Programming',

	css: 'CSS',
	go: 'Go',
	javascript: 'JavaScript',
	python: 'Python',
	typescript: 'TypeScript',

	containers: 'Containers',
	git: 'Git',
	kubernetes: 'Kubernetes',
	linux: 'Linux',

	react: 'React',
	svelte: 'Svelte',
	sveltekit: 'SvelteKit',
}
