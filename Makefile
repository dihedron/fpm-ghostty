VERSION=1.0.1
DOWNLOAD_URL=https://github.com/ghostty-org/ghostty/archive/refs/tags/v$(VERSION).tar.gz

v$(VERSION).tar.gz:
	@wget $(DOWNLOAD_URL)

.phony: download
download: v$(VERSION).tar.gz
	@rm -rf ghostty-$(VERSION)/
	@tar xvf v$(VERSION).tar.gz 2>&1 > /dev/null

.phony: build
build: download ghostty-$(VERSION)/zig-out/bin/ghostty
	@echo -n "Build ghostty $(VERSION)"
	@cd ghostty-$(VERSION) && zig build -Doptimize=ReleaseFast && cd -

.phony: deb
deb: build
ifeq ($(GITLAB_CI),)
ifeq ($(shell which nfpm),)
	@echo "Need to install nFPM first..."
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
endif
endif
	@echo -n "Package ghostty $(VERSION) "
	@rm -f zig-out && ln -s ghostty-$(VERSION)/zig-out/ zig-out
	@VERSION=$(VERSION) nfpm package --packager deb --target .
	@rm -f zig-out

.phony: rpm
rpm: build
ifeq ($(GITLAB_CI),)
ifeq ($(shell which nfpm),)
	@echo "Need to install nFPM first..."
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
endif
endif
	@echo -n "Package ghostty $(VERSION) "
	@rm -f zig-out && ln -s ghostty-$(VERSION)/zig-out/ zig-out
	@VERSION=$(VERSION) nfpm package --packager deb --target .
	@rm -f zig-out

# TODO: run a cleanup task removing go/ only once:
# see https://gist.github.com/APTy/9a9eb218f68bc0b4beb133b89c9def14

.phony: apk
apk: build
ifeq ($(GITLAB_CI),)
ifeq ($(shell which nfpm),)
	@echo "Need to install nFPM first..."
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
endif
endif
	@echo -n "Package ghostty $(VERSION) "
	@rm -f zig-out && ln -s ghostty-$(VERSION)/zig-out/ zig-out
	@VERSION=$(VERSION) nfpm package --packager deb --target .
	@rm -f zig-out

.phony: clean
clean:
	@rm -rf *.deb *.rpm *.apk *.tar.gz* ghostty-$(VERSION)/ zig-out/

.phony: setup-tools
setup-tools:
	@go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest
	@sudo apt install libgtk-4-dev libadwaita-1-dev
