CMD=hugo

all: build deploy

.PHONY: watch setup build deploy

watch:
		$(CMD) server -D

build:
		$(CMD) && git commit -m "Public build `date -u`" public/

deploy:
		git push origin main && git subtree push --prefix public origin gh-pages
