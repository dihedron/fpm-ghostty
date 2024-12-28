# fpm-ghostty

A simple Makefile to create `.deb` and `.rpm` packages of the ghostty terminal emulator.

## Building a [deb|rpm] package

In order to build the package for the latest version of the ghostty terminal emulator for Ubuntu or Debian based Linux distributions, run the Makefile as follows:

```bash
$> make build deb
```

The `build` command builds the binary; the following `deb` command packages it and all other intergration files as a DEB archive.

To build an RPM package, after having built the binary (see `make build` above) run the following:

```bash
$> make rpm
```

To create an APK package (for Alpine) run:

```bash
$> make apk
```

The makefile will automatically download the sources from GitHub, build the application using the zig compiler and package it.

To clean all packages and downloaded files run `make clean`.

## Prerequisites

In order to create DEB, RPM and APK packages, this project uses [nFPM](https://nfpm.goreleaser.com/); if not available locally, it uses `go install` to install it, so both `make` and `go` must already be available on the packaging machine if you don't want to install nFPM manually.
