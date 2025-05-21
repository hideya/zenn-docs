.PHONY: install preview

install:
	npm install zenn-cli@latest

preview:
	npx zenn preview & \
	open http://localhost:8000
