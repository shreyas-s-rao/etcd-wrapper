#########################################
# Tools                                 #
#########################################

#TOOLS_DIR := hack/tools
include hack/tools.mk

BIN_DIR := bin

.PHONY: add-license-headers
add-license-headers: $(GO_ADD_LICENSE)
	@./hack/add_license_headers.sh ${YEAR}

.PHONY: build-local
build-local:
	.ci/build
	#go build -o bin/etcd-wrapper

.PHONY: clean
clean:
	rm -rf $(BIN_DIR)/

#-count=1 needed so that test results are not cached
.PHONY: test
test:
	@./hack/test.sh

.PHONY: revendor
revendor:
	@env GO111MODULE=on go mod tidy
	@env GO111MODULE=on go mod vendor

.PHONY: check
check: $(GOLANGCI_LINT)
	@./hack/check.sh --golangci-lint-config=./.golangci.yaml ./internal/...