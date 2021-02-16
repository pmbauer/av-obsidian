NAME              ?= av-obsidian
VERSION           ?= $(shell git rev-parse --short HEAD)
ARTIFACT          ?= $(NAME)_$(VERSION).tar.gz
export

.DEFAULT_GOAL := build
.PHONY: build test clean

release:
	mkdir release
release/*.md: release
	cd release; ../generate.awk ../av.input
release/$(ARTIFACT): release/*.md
	cd release; tar czf $(ARTIFACT) */*.md
build: release/$(ARTIFACT)

test/output:
	mkdir test/output
test: test/output
	test/run.sh

clean:
	rm -rf release/* test/output/*
