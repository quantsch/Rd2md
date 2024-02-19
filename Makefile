test:
	docker build -t rd2md:test --target test -f Dockerfile_dev .
	docker run --rm -it rd2md:test
doc:
	docker build -t rd2md:doc --target document -f Dockerfile_dev .
	docker run --rm -it -v $(PWD):/usr/local/src/package rd2md:doc