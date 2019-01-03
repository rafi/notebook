logo = logo.png

all:
	@echo 'tasks'
	@echo '---'
	@echo 'make install - Install dependencies with yarn'
	@echo 'make start - Run development server locally'
	@echo 'make deploy - Build & deploy distribution assets'
	@echo 'make favicon - Generate favicons from logo'
	@echo 'make lint - Lint markdown and javascript files'

install:
	yarn install

start:
	yarn run dev

build:
	rm -rf ./dist
	yarn run build

deploy: build
	rsync -ah ./dist/* bob:/srv/http/rafi.io/

lint:
	yarn run lint

favicon:
	cd .vuepress/public; \
	convert -resize x16 -gravity center -crop 16x16+0+0 -flatten -colors 256 $(logo) icons/output-16x16.ico; \
	convert -resize x32 -gravity center -crop 32x32+0+0 -flatten -colors 256 $(logo) icons/output-32x32.ico; \
	convert -resize x48 -gravity center -crop 48x48+0+0 -flatten -colors 256 $(logo) icons/output-48x48.ico; \
	convert icons/output-16x16.ico icons/output-32x32.ico icons/output-48x48.ico favicon.ico; \
	convert -resize x152 $(logo) icons/apple-touch-icon-152x152.png; \
	convert -resize x120 $(logo) icons/apple-touch-icon-120x120.png; \
	convert -resize x76  $(logo) icons/apple-touch-icon-76x76.png; \
	convert -resize x60  $(logo) icons/apple-touch-icon-60x60.png; \
	convert -resize x192 $(logo) icons/android-chrome-192x192.png; \
	convert -resize x512 $(logo) icons/android-chrome-512x512.png; \
	convert -resize x144 $(logo) icons/msapplication-icon-144x144.png

.PHONY: all install start build deploy lint favicon
