# (C) Copyright 2024 Hewlett Packard Enterprise Development LP

SHELL := /bin/bash -o errexit -o pipefail

## help: Output this message and exit.
.PHONY: help
help:
	@grep -h '^## ' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/## //'

# See https://github.com/super-linter/super-linter#run-super-linter-outside-github-actions
## lint: lint with super-linter (version as of Jan 2024)
.PHONY: lint
lint:
	docker run \
		-e ACTIONS_RUNNER_DEBUG=false \
		-e RUN_LOCAL=true \
		-v $(PWD):/tmp/lint \
		ghcr.io/github/super-linter:slim-v4.10.1
