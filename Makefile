.PHONY: install preview

install:
	npm install zenn-cli@latest

preview:
	npx zenn preview & \
	open http://localhost:8000

stop-preview:
	kill $(lsof -t -i:8000)
	# ps -al | grep -F "npm exec zenn preview" | grep -v grep | awk '{print $3}' | xargs -r kill
