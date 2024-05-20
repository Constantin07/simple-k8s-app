export NAMESPACE ?= default
export RELEASE ?= hello-kubernetes

# Check for required binaries
EXECUTABLES = git helm kubeconform
K := $(foreach exec,$(EXECUTABLES),\
  $(if $(shell command -v $(exec) 2> /dev/null),some string,$(error "No $(exec) in PATH")))

.PHONY: build template validate lint diff release_notes apply status destroy

GIT_COMMIT_SHORT ?= $(shell git rev-parse --short HEAD)

ifdef VERSION
export TAG=${VERSION}
else ifdef BUILD_NUMBER
export TAG=${BUILD_NUMBER}-${GIT_COMMIT_SHORT}
else
export TAG=${GIT_COMMIT_SHORT}
endif

build:
	$(MAKE) -C dockerfile

template:
	helm template ${RELEASE} ./hello-kubernetes -f values.yaml --set image.tag=${TAG}

validate:
	mkdir -p /tmp/kubeconform
	helm template ${RELEASE} ./hello-kubernetes -f values.yaml --set image.tag=${TAG} | \
	kubeconform -strict -summary -cache /tmp/kubeconform -ignore-missing-schemas -kubernetes-version 1.30.1

validate_k8s:
	@helm template ${RELEASE}-test ./hello-kubernetes -f values.yaml --set image.tag=${TAG} --validate

lint:
	helm lint ./hello-kubernetes -f values.yaml

diff:
	helm diff upgrade --allow-unreleased ${RELEASE} ./hello-kubernetes -f values.yaml --set image.tag=${TAG} \
	--namespace ${NAMESPACE}

release_notes:
	git-chglog | tee -a release_notes.yaml

namespace:
	kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

apply: validate
	helm upgrade ${RELEASE} ./hello-kubernetes -f values.yaml --set image.tag=${TAG} \
	--install --namespace ${NAMESPACE} --wait --timeout=300s

status:
	helm status ${RELEASE}

destroy:
	helm uninstall ${RELEASE} --namespace ${NAMESPACE} || true
