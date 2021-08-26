CMD=hugo

all: build deploy

.PHONY: watch setup build deploy

watch:
		$(CMD) server -D

setup:
		git submodule init && git submodule update

build:
		$(CMD) && git ci -m "Public build `date -u`" public/

deploy:
		git push origin main && git subtree push --prefix public origin gh-pages
