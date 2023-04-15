name = docker-k8s-101
title = $(shell cat header.tpl | grep '^title:' | gsed 's/^title: //')
path = rafi.io/slides/$(name)/
url = http://$(path)
theme = league
reveal = reveal-md ./slides.md --title "$(title)" --theme $(theme)
files = $(wildcard .scene*)
output = README.md

all: build

view: generate
	$(reveal)
	@rm ./slides.md

build: generate
	@echo '=> Build static site'
	$(reveal) --static
	@rm ./slides.md

deploy: generate build
	@echo '=> Synchronizing site with server'
	rsync -az --delete _static/* bob:/srv/http/$(path)
	@rm -rf ./_static
	open "$(url)"

generate:
	@echo '=> Compiling README.md'
	@echo '' > $(output)
	@[ -d img ] || mkdir img
	@for f in ${files}; do \
		cat "$$f/README.md" >> $(output); \
		if [ -d "$$f/img" ]; then \
			pushd img >/dev/null; \
			ln -fs ../$$f/img/* .; \
			popd >/dev/null; \
		fi \
	done
	@echo '=> Compiling slides.md'
	@cat $(output) footer.tpl > slides.md
	@echo "`cat header.tpl`\n`cat $(output)`" > $(output)
	@gsed -zi "s%{{\ *URL\ *}}%$(url)%g" slides.md
	@gsed -zi "s%{{\ *URL\ *}}\n%%g" README.md

clean:
	rm -rf ./slides.md ./_static
	find ./img -type l -delete

.PHONY: all view build deploy generate clean
