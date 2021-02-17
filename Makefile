NAME              ?= av-obsidian
VERSION           ?= $(shell git rev-parse --short HEAD)
ARTIFACT          ?= $(NAME)_$(VERSION).tar.gz
export

.DEFAULT_GOAL := build
.PHONY: build test clean

release:
	mkdir release
release/av/*.md: release generate.awk av.input
	cd release; rm -rf av; ../generate.awk ../av.input
release/$(ARTIFACT): release/av/*.md
	cd release; tar czf $(ARTIFACT) av/*.md
build: release/$(ARTIFACT)

test/output:
	mkdir test/output
test: test/output
	test/run.sh

clean:
	rm -rf release/* test/output/*
