IMAGE_NAME = mod-auth-openidc-sample-centos7
PORT = 8443

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

s2i-build:
	s2i build . ${IMAGE_NAME}

run:
	docker run -p ${PORT}:${PORT} ${IMAGE_NAME}

shell:
	docker run -it -p ${PORT}:${PORT} ${IMAGE_NAME} /bin/bash

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
