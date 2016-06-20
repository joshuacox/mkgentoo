.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  This is merely a base image for usage read the README file
	@echo ""   0. make auto       - build and run and enter the docker container
	@echo ""   1. make run       - build and run docker container
	@echo ""   2. make build     - build docker container
	@echo ""   3. make clean     - kill and remove docker container
	@echo ""   4. make enter     - execute an interactive bash in docker container
	@echo ""   5. make logs      - follow the logs of docker container

auto: run enter

build: NAME TAG builddocker

# run a plain container
run: build portage rundocker

# run a  container that requires mysql temporarily
temp: MYSQL_PASS rm build mysqltemp runmysqltemp

# run a  container that requires mysql in production with persistent data
# HINT: use the grabmysqldatadir recipe to grab the data directory automatically from the above runmysqltemp
prod: APACHE_DATADIR MYSQL_DATADIR MYSQL_PASS rm build mysqlcid runprod

portage:
	docker create -v /usr/portage --name portage gentoo/portage
	date -I >> portage

stage3:
	docker run --volumes-from portage -it gentoo/stage3-amd64 /bin/bash

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-v $(TMP):/tmp \
	--volumes-from portage \
	--name gentoo \
	-d \
	-it $(TAG)

builddocker:
	/usr/bin/time -v docker build -t `cat TAG` .

kill:
	-@docker kill `cat cid`

rm-image:
	-@docker rm `cat cid`
	-@rm cid

rm: kill rm-image

clean: rm rmportage

rmportage:
	-@docker rm portage
	-@rm portage

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
	docker logs -f `cat cid`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;


rmall: rm
