BIN ?= ark-blockstore-rook

REPO ?= github.com/heptio/ark-blockstore-rook

BUILD_IMAGE ?= gcr.io/heptio-images/golang:1.9-alpine3.6

# Where to push the docker image.
REGISTRY ?= gcr.io/heptio-images

IMAGE := $(REGISTRY)/$(BIN)

$(BIN): main.go
	docker run --rm -u $(id -u):$(id -g) -v `pwd`:/go/src/$(REPO) -w /go/src/$(REPO) -e CGO_ENABLED=0 $(BUILD_IMAGE) go build -v -o $(BIN)

container: $(BIN)
	sed s/PLUGIN_NAME/$(BIN)/ Dockerfile > .Dockerfile | docker build -t $(IMAGE) -f .Dockerfile .

push: 
	docker push $(IMAGE)
