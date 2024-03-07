test: build
	docker run --rm rd2md:latest \
		R -e "devtools::test()"
doc: build
	docker run --rm -v $(PWD):/usr/local/src/package rd2md:latest \
		R -e "devtools::document()"
doc-test-cases: build
	docker run --rm -v $(PWD):/usr/local/src/package rd2md:latest \
		R -e "roxygen2::roxygenize('tests/testthat/testdoc', roclets='rd')"

r-cmd-check: build
	docker run --rm rd2md:latest \
		R -e "devtools::check()"

build:
	docker build -t rd2md:latest -f Dockerfile_dev .
