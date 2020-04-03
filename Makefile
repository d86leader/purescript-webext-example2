.PHONY: build link output/Main/index.js

build: output/Main/index.js

link: build/content_script.js build/button_script.js

build/content_script.js: output/Main/index.js
	npx spago bundle-app -m ContentScript -t $@
build/button_script.js: output/Main/index.js
	npx spago bundle-app -m ButtonScript -t $@

output/Main/index.js: | node_modules
	npx spago build

node_modules:
	npm install
