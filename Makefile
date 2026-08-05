.PHONY: build install test clean

build:
	idris2 --clean bcrypt.ipkg
	idris2 --build bcrypt.ipkg

install:
	idris2 --install bcrypt.ipkg

test:
	idris2 --clean bcrypt.ipkg
	idris2 --build bcrypt.ipkg
	idris2 --install bcrypt.ipkg
	cd test && \
		idris2 --build test.ipkg && \
		./build/exec/bcrypt-test

clean:
	idris2 --clean bcrypt.ipkg
	cd test && idris2 --clean test.ipkg
