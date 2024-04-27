import { writable } from 'svelte/store'
import { browser } from '$app/environment'

type Theme = 'light' | 'dark'

// The theme is actually set in `app.html` to prevent flashing.
const userTheme = browser && document.documentElement.getAttribute('color-scheme')

// Create the store.
export const theme = writable(userTheme ?? 'dark')

// Set a theme.
export function setTheme(newTheme: Theme) {
	theme.set(newTheme)
}

// Update the theme.
export function toggleTheme() {
	theme.update((currentTheme) => {
		const newTheme = currentTheme === 'dark' ? 'light' : 'dark'

		document.documentElement.setAttribute('color-scheme', newTheme)
		localStorage.setItem('color-scheme', newTheme)
		return newTheme
	})
}
