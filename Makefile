TESTS = $(shell find tests -type f -name test-*)
-COVERAGE_DIR := out/test/

-BIN_MOCHA := ./node_modules/.bin/mocha
-BIN_ISTANBUL := ./node_modules/.bin/istanbul
-BIN_COFFEE := ./node_modules/coffee-script/bin/coffee

#-TESTS = $(shell find tests -type f -name test-*)
-TESTS           := $(sort $(TESTS))

-COVERAGE_TESTS := $(addprefix $(-COVERAGE_DIR),$(-TESTS))
-COVERAGE_TESTS := $(-COVERAGE_TESTS:.coffee=.js)

default: dev

dev: clean
	@$(-BIN_MOCHA) \
		--colors \
		--compilers coffee:coffee-script/register \
		--reporter list \
		--growl \
		$(-TESTS)

test: clean
	@$(-BIN_MOCHA) \
		--compilers coffee:coffee-script/register \
		--reporter tap \
		$(-TESTS)

-pre-test-cov: clean
	@echo 'copy files'
	@mkdir -p $(-COVERAGE_DIR)

	@rsync -av . $(-COVERAGE_DIR) --exclude out --exclude .git --exclude node_modules
	@rsync -av ./node_modules $(-COVERAGE_DIR)
	@$(-BIN_COFFEE) -cb out/test
	@find ./out/test -path ./out/test/node_modules -prune -o -name "*.coffee" -exec rm -rf {} \;

test-cov: -pre-test-cov
	@cd $(-COVERAGE_DIR) && \
		$(-BIN_ISTANBUL) cover ./node_modules/.bin/_mocha -- -u bdd -R tap --compilers coffee:coffee-script/register $(patsubst $(-COVERAGE_DIR)%, %, $(-COVERAGE_TESTS)) && \
	  $(-BIN_ISTANBUL) report html

.-PHONY: default

clean:
	@echo 'clean'
	@-rm -fr out/test
