static_dir := "static"
logo := static_dir + "/img/favicon/favicon.png"
icon_dir := static_dir + "/img/favicon"

[private]
default:
	@just --list --unsorted

run:
	npm run dev

host:
	#!/usr/bin/env bash
	export VERCEL_GIT_COMMIT_REF="$(git rev-parse --abbrev-ref HEAD)"
	export VERCEL_GIT_COMMIT_SHA="$(git rev-parse HEAD)"
	npm run dev -- --host

build:
	npm run build

lint:
	npm run lint

preview:
	npm run preview

logo:
	toilet -f roman -F crop --html 'rafi.' \
		-d "$(brew --prefix figlet)"/share/figlet/fonts

favicon:
	convert -resize x16 -gravity center -crop 16x16+0+0 -flatten -colors 256 {{ logo }} {{ icon_dir }}/output-16x16.ico
	convert -resize x32 -gravity center -crop 32x32+0+0 -flatten -colors 256 {{ logo }} {{ icon_dir }}/output-32x32.ico
	convert -resize x48 -gravity center -crop 48x48+0+0 -flatten -colors 256 {{ logo }} {{ icon_dir }}/output-48x48.ico
	convert {{ icon_dir }}/output-16x16.ico {{ icon_dir }}/output-32x32.ico {{ icon_dir }}/output-48x48.ico {{ static_dir }}/favicon.ico
	convert -resize x152 {{ logo }} {{ icon_dir }}/apple-touch-icon-152x152.png
	convert -resize x120 {{ logo }} {{ icon_dir }}/apple-touch-icon-120x120.png
	convert -resize x76  {{ logo }} {{ icon_dir }}/apple-touch-icon-76x76.png
	convert -resize x60  {{ logo }} {{ icon_dir }}/apple-touch-icon-60x60.png
	convert -resize x192 {{ logo }} {{ icon_dir }}/android-chrome-192x192.png
	convert -resize x512 {{ logo }} {{ icon_dir }}/android-chrome-512x512.png
	convert -resize x144 {{ logo }} {{ icon_dir }}/msapplication-icon-144x144.png
