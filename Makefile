test: build
	docker run --rm -it rd2md:latest \
		R -e "devtools::test()"
doc: build
	docker run --rm -it -v $(PWD):/usr/local/src/package rd2md:latest \
		R -e "devtools::document()"
doc-test-cases: build
	docker run --rm -it -v $(PWD):/usr/local/src/package rd2md:latest \
		R -e "roxygen2::roxygenize('tests/testthat/testdoc', roclets='rd')"

r-cmd-check: build
	docker run --rm -it rd2md:latest \
		R -e "devtools::check()"

build:
	docker build -t rd2md:latest -f Dockerfile_dev .
