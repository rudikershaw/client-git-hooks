.PHONY: all require validate test package clean

all: clean require validate test package

require:
	@echo "Checking the programs required for the build are installed..."
	@shellcheck --version >/dev/null 2>&1 || (echo "ERROR: shellcheck is required."; exit 1)
	@git --version >/dev/null 2>&1 || (echo "ERROR: git is required."; exit 1)
	@printf "All required programs present.\n\n"

validate:
	@echo "Performing basic validation on project files..."
	@find git-hooks/ -type f | xargs shellcheck || (echo "ERROR: shellcheck has detected issues."; exit 1)
	@echo "PASSED: shellcheck found no issues."
	@printf "All validation passed.\n\n"

test:
	@echo "Running tests..."
	@test/test.sh || (echo "ERROR: There were test failures."; exit 1)
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
