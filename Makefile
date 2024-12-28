VERSION=1.0.0
DOWNLOAD_URL=https://github.com/ghostty-org/ghostty/archive/refs/tags/v$(VERSION).tar.gz

v$(VERSION).tar.gz:
	@wget $(DOWNLOAD_URL)

.phony: download
download: v$(VERSION).tar.gz
	@rm -rf ghostty-$(VERSION)/
	@tar xvf v$(VERSION).tar.gz 2>&1 > /dev/null

.phony: build
build: download
	@echo -n "Build ghostty $(VERSION) "
	@cd ghostty-$(VERSION) && zig build -Doptimize=ReleaseFast && cd -

.phony: deb
deb: ghostty-$(VERSION)/zig-out/bin/ghostty
ifeq ($(GITLAB_CI),)
ifeq ($(shell which nfpm),)
	@echo "Need to install nFPM first..."
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
endif
endif
	@echo -n "Package ghostty $(VERSION) "
	@VERSION=$(VERSION) nfpm package --packager deb --target .

.phony: rpm
rpm: ghostty-$(VERSION)/zig-out/bin/ghostty
ifeq ($(GITLAB_CI),)
ifeq ($(shell which nfpm),)
	@echo "Need to install nFPM first..."
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
endif
endif
	@echo -n "Package ghostty $(VERSION) "
	@VERSION=$(VERSION) nfpm package --packager deb --target .


# TODO: run a cleanup task removing go/ only once:
# see https://gist.github.com/APTy/9a9eb218f68bc0b4beb133b89c9def14

.phony: apk
apk: ghostty-$(VERSION)/zig-out/bin/ghostty
ifeq ($(GITLAB_CI),)
ifeq ($(shell which nfpm),)
	@echo "Need to install nFPM first..."
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
endif
endif
	@echo -n "Package ghostty $(VERSION) "
	@VERSION=$(VERSION) nfpm package --packager deb --target .

.phony: clean
clean:
	@rm -rf *.deb *.rpm *.apk *.tar.gz* ghostty-$(VERSION)/

.phony: setup-tools
setup-tools:
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
	@sudo apt install libgtk-4-dev libadwaita-1-dev
