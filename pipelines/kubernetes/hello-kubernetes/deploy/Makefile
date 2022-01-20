export NAMESPACE ?= default

# Check for required binaries
EXECUTABLES = git helmfile kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: build template validate lint diff release_notes sync status destroy

GIT_COMMIT_SHORT ?= $(shell git rev-parse --short HEAD)

ifdef BUILD_NUMBER
export TAG=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}
else
export TAG=${GIT_COMMIT_SHORT}
endif

build:
	$(MAKE) -C dockerfile

template:
	helmfile template

validate:
	mkdir -p /tmp/kubeconform
	helmfile template | kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.21.9

lint:
	helmfile lint

diff:
	helmfile diff

release_notes:
	git-chglog | tee -a release_notes.yaml

sync: validate
	helmfile sync

status:
	helmfile status

destroy:
	helmfile destroy
