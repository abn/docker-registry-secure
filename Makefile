
REGISTRY	:= alectolytic
NAME		:= secure-registry
VERSION		:= 2.0.1

IMAGE_NAME	:= $(REGISTRY)/$(NAME)
IMAGE		:= $(IMAGE_NAME):$(VERSION)

CONFIG_DIR	:= $(shell pwd)/config
SERVER_NAME := localhost
USERNAME	:= docker
HOST_PORT	:= 443
RUN_EXTRA	:= 
RUN_ARGS := $(RUN_EXTRA) -e SERVER_NAME=$(SERVER_NAME) -p $(HOST_PORT):443

.PHONY: clean all build tag_latest start test start-fg test-fg gencert htpasswd $(CONFIG_DIR)

all: build

$(CONFIG_DIR):
	@mkdir -p $(CONFIG_DIR)
	@chcon -Rt svirt_sandbox_file_t $(CONFIG_DIR)

build:
	@docker build -t $(IMAGE) .

shell: $(CONFIG_DIR)
	@docker run -it $(RUN_ARGS) -v $(CONFIG_DIR):/config --entrypoint bash $(IMAGE)

gencert htpasswd setup: $(CONFIG_DIR)
	@docker run $(RUN_ARGS) -v $(CONFIG_DIR):/config $(IMAGE) $@

start-fg: $(CONFIG_DIR)
	@docker run -it $(RUN_ARGS) -v $(CONFIG_DIR):/config $(IMAGE) start

test-fg help:
	@docker run -it $(RUN_ARGS) $(IMAGE) $@

test:
	@docker run -d $(RUN_ARGS) $(IMAGE) start

start: $(CONFIG_DIR)
	@docker run -d $(RUN_ARGS) -v $(CONFIG_DIR):/config $(IMAGE) start

tag_latest:
	@docker tag -f $(IMAGE) $(IMAGE_NAME):latest

clean:
	rm -rf $(CONFIG_DIR)
	docker rmi $(IMAGE)
