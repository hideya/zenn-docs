.PHONY: install preview

install:
	npm install zenn-cli@latest

preview:
	npx zenn preview & \
	open http://localhost:8000

stop-preview:
	lsof -t -i:8000 | xargs -r kill
	# ps -al | grep -F "npm exec zenn preview" | grep -v grep | awk '{print $3}' | xargs -r kill
