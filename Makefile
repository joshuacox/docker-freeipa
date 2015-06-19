all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   1. make run       - build and run docker container

build: builddocker

run: data builddocker rundocker

rundocker:
	@docker run --name=docker-freeipa \
	--cidfile="cid" \
	-d \
	--privileged \
	-v /tmp:/tmp \
	-v /var/lb/ipa-data:/data:Z \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-t joshuacox/docker-freeipa
	@docker ps -l

data:
	@mkdir -p /var/lib/ipa-data

builddocker:
	/usr/bin/time -v docker build -t joshuacox/docker-freeipa .

beep:
	@echo "beep"
	@aplay /usr/share/sounds/alsa/Front_Center.wav

kill:
	@docker kill `cat cid`

rm-image:
	@docker rm `cat cid`
	@rm cid

rm: kill rm-image

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
	docker logs -f `cat cid`
