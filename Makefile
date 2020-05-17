# Vigie Makefile --------------------------------------------------------------------------

.CNTR_REGISTRY  = "vincoll"
.CNTR_REGISTRY_DEV  = "vincoll"

.GO_VERSION		= 1.14.2

.DATE           = $(shell date -u '+%Y-%m-%d_%H:%M_UTC')
.COMMIT         = $(shell git rev-parse --short HEAD)
.VIGIE_VERSION 	= $(shell ./build/scripts/vfromchangelog.sh)
.LDFLAGS    	= -ldflags "-X github.com/vincoll/vigie/cmd/vigie/version.LdVersion=$(.VIGIE_VERSION) \
							-X github.com/vincoll/vigie/cmd/vigie/version.LdBuildDate=$(.DATE) \
							-X github.com/vincoll/vigie/cmd/vigie/version.LdGitCommit=$(.COMMIT)"

.ROOT_DIR = $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# CONTINUOUS INTEGRATION (CI) -------------------------------------------------------------

ci-docker-all: ci-docker-testtarget ci-docker-backend

ci-docker-debug:
	@echo "> Create Vigie CI Debug Container"
	@docker-compose --file build/ci/DC_vigie.yml up --detach --force-recreate --quiet-pull

ci-docker-testtarget:
	@echo "> Create Vigie CI Tests Target Containers"
	@docker-compose --file build/ci/DC_vigie_testtarget.yml up --detach --force-recreate --quiet-pull

ci-docker-backend:
	@echo "> Create Vigie CI Backend Containers"
	@docker-compose --file build/ci/DC_vigie_backend.yml up --detach
	@sleep 2
	@docker exec -t VIGIE-CI_influxdb2 influx setup --force --bucket=vigie --org=vigieci --retention=6 --username=vigie --password=vigie.dev --token influxvigieci >/dev/null 2>&1

ci-docker-clean:
	@echo "> Delete Vigie All CI Containers"
	@docker-compose --file build/ci/DC_vigie_testtarget.yml rm --stop --force
	@docker-compose --file build/ci/DC_vigie_backend.yml rm --stop --force

# BUILD -----------------------------------------------------------------------------------

# Build the binary with your own Go env
# Output is ./bin/vigie
build-go-binary:
	GOMODULE111=on CGO_ENABLED=0 go build $(.LDFLAGS) -o ./bin/vigie
	sudo setcap cap_net_raw,cap_net_bind_service=+ep ./bin/vigie
	./bin/vigie version

# Build the binary with a Golang container
# Output is ./bin/vigie
build-go-binary-docker: test
	DOCKER_BUILDKIT=1 docker build --build-arg GO_VERSION=$(.GO_VERSION) --build-arg VIGIE_VERSION=$(.VIGIE_VERSION) --build-arg COMMIT=$(.COMMIT) --build-arg DATE=$(.DATE) \
	 			 --file "./build/release/Dockerfile.buildgobinary" --no-cache --pull \
	 			 --tag vigie:build-$(.VIGIE_VERSION) .
	@docker create -ti --name vigie_build-$(.VIGIE_VERSION) vigie:build-$(.VIGIE_VERSION) sh
	@docker cp vigie_build-$(.VIGIE_VERSION):/bin/vigie $(.ROOT_DIR)/bin
	@docker rm -f vigie_build-$(.VIGIE_VERSION)
	@docker rmi vigie:build-$(.VIGIE_VERSION)
	sudo setcap cap_net_raw,cap_net_bind_service=+ep ./bin/vigie
	./bin/vigie version

# Build Vigie docker image
# Output is a docker image vigie:$(.VIGIE_VERSION)
build-docker-image-local:
	@DOCKER_BUILDKIT=1 docker build --build-arg GO_VERSION=$(.GO_VERSION) --build-arg VIGIE_VERSION=$(.VIGIE_VERSION) --build-arg COMMIT=$(.COMMIT) --build-arg DATE=$(.DATE) \
				  --file "./build/release/Dockerfile.release" --no-cache --pull \
				  --tag vigie:$(.VIGIE_VERSION) .
	@docker run --tty vigie:$(.VIGIE_VERSION) version

buildx-docker-image-local:
	@DOCKER_BUILDKIT=1 docker buildx build \
					--platform=linux/arm,linux/arm64,linux/amd64 \
					--build-arg GO_VERSION=$(.GO_VERSION) --build-arg VIGIE_VERSION=$(.VIGIE_VERSION) --build-arg COMMIT=$(.COMMIT) --build-arg DATE=$(.DATE) \
				 	--file "./build/release/Dockerfile.release" --no-cache --pull \
				  	--tag vigie:$(.VIGIE_VERSION) .

# PUBLISH ---------------------------------------------------------------------------------

# Goreleaser (https://goreleaser.com/)
# Build Go binaries, Create Github Packages, Create Docker Images

publish-dry-goreleaser:
	goreleaser --snapshot --skip-publish --rm-dist

publish-full-goreleaser:
	goreleaser --rm-dist

publish-docker-release-push: build-docker-image-local
	docker tag vigie:$(.VIGIE_VERSION) $(.CNTR_REGISTRY)/vigie:$(.VIGIE_VERSION)
	docker tag vigie:$(.VIGIE_VERSION) $(.CNTR_REGISTRY)/vigie:latest
	docker push $(.CNTR_REGISTRY)/vigie:$(.VIGIE_VERSION)
	docker push $(.CNTR_REGISTRY)/vigie:latest

publish-docker-dev-push: build-docker-image-local
	@docker tag vigie:$(.VIGIE_VERSION) $(.CNTR_REGISTRY)/vigie:dev
	docker push $(.CNTR_REGISTRY_DEV)/vigie:dev

publish-docker-current-push: build-docker-image-local
	docker tag vigie:$(.VIGIE_VERSION) $(.CNTR_REGISTRY)/vigie:$(.VIGIE_VERSION)
	docker push $(.CNTR_REGISTRY_DEV)/vigie:$(.VIGIE_VERSION)

# RUN -------------------------------------------------------------------------------------

run-vigie-dev: build-go-binary
	@rm -rf ./bin/test
	@cp -rf ./dev/test ./bin
	@cp -rf ./dev/var ./bin
	@(cd ./bin ; ./vigie run --config ../dev/config/vigieconf_dev.toml)

run-vigie-container-dev-demo: build-docker-image-local
	@docker run --mount type=bind,source=$(.ROOT_DIR)/dev/config/,target=/app/config/ vigie:$(.VIGIE_VERSION) run --config /app/config/vigieconf_demo_DEV.toml

run-vigie-container-prod-demo: build-docker-image-local
	@docker run --mount type=bind,source=$(.ROOT_DIR)/dev/config/,target=/app/config/ vigie:$(.VIGIE_VERSION) run --config /app/config/vigieconf_demo_PROD.toml

# DEBUG -----------------------------------------------------------------------------------

debug-vigie-image:
	@docker run -ti --entrypoint sh vigie:$(.VIGIE_VERSION)

# PROFILING -------------------------------------------------------------------------------

pprof-mem:
	@go tool pprof http://127.0.0.1:6680/debug/pprof/heap

pprof-mem-inuse:
	@go tool pprof -inuse_space http://127.0.0.1:6680/debug/pprof/heap

pprof-mem-alloc:
	@go tool pprof -alloc_space http://127.0.0.1:6680/debug/pprof/heap

pprof-cpu:
	@wget http://127.0.0.1:6680/debug/pprof/profile?seconds=30

pprof-trace:
	@wget http://127.0.0.1:6680/debug/pprof/trace?seconds=5

pprof-goroutine:
	@go tool pprof http://127.0.0.1:6680/debug/pprof/goroutine?seconds=30

# TEST ------------------------------------------------------------------------------------

test:
	 go test ./... --cover

lint:
	golint -set_exit_status ./...


# DOCS ------------------------------------------------------------------------------------

# Build documentation site
docs-generate:
	make -C ./docs docs

## Serve the documentation site localy
docs-serve:
	make -C ./docs docs-serve