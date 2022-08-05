
REPO = images.canfar.net

# Change the following parameters for your project or set on the make command line
# e.g.  make dev PROJECT=uvickbos DEVNAME=iraf VERSION=0.1
PROJECT = uvickbos
DEVNAME = iraf
VERSION = 0.1

NAME = $(REPO)/$(PROJECT)/$(DEVNAME)

production: dependencies Dockerfile
	docker build --target deploy -t $(NAME):$(VERSION) -f Dockerfile .

deploy: production
	docker push $(NAME):$(VERSION)

dev: dependencies Dockerfile
	docker build --target test -t $(NAME):$(VERSION) -f Dockerfile .

dependencies: 

init:
	mkdir -p build

.PHONY: clean
clean:
	\rm -rf build
