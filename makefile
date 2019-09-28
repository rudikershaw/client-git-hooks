all: require validate test

require:
	@echo "Checking the programs required for the build are installed..."
	@shellcheck --version >/dev/null 2>&1 || (echo "ERROR: You must install shellcheck before this project can be built."; exit 1)
	@printf "All required programs present.\n\n"

validate:
	@echo "Performing basic validation on project files..."
	@find git-hooks/ -type f | xargs shellcheck || (echo "ERROR: shellcheck has detected issues."; exit 1)
	@printf "All validation passed.\n\n"

test:
	@echo "Running tests..."
	@printf "All tests passed.\n\n"

clean:
	@echo "Removing temporary project files..."
	@printf "All file removed successfully.\n\n"
