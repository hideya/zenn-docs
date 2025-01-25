.PHONY: install preview

install:
	npm install zenn-cli

preview:
	npx zenn preview & \
	open http://localhost:8000
