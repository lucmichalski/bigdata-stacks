HUE_TAG := 4.5.0
build:
	cd hue-src && docker build . -t nvtienanh/hue:$(HUE_TAG) -f tools/docker/hue/Dockerfile
push:
	docker push nvtienanh/hue:$(HUE_TAG)
