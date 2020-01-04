.PHONY: all require validate test package clean

all: clean validate test package

validate:
	@echo "Performing basic validation on project..."
	@[ ! -z "${BUILD}" ] || (echo "ERROR: Do not run the make file manually!\\n Use 'docker build ./' instead."; exit 1)
	@find git-hooks/ -type f | xargs shellcheck || (echo "ERROR: shellcheck has detected issues."; exit 1)
	@echo "PASSED: shellcheck found no issues."
	@printf "All validation passed.\n\n"

test:
	@echo "Running tests..."
	@test/test.sh || (echo "ERROR: There were test failures."; exit 1)
	@test/integration-test.sh || (echo "ERROR: There were integration test failures."; exit 1)
	@printf "All tests passed.\n\n"

package:
	@echo "Packaging hooks into target/git-hooks.zip"
	@mkdir target
	@zip -r target/git-hooks.zip git-hooks
	@echo "Packaging complete.\n"

clean:
	@echo "Removing temporary project files..."
	@rm -Rf target/
	@printf "All file removed successfully.\n\n"
