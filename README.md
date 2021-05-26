# av-obsidian
Generates a King James ([Authorized Version](https://en.wikipedia.org/wiki/King_James_Version)) text that is formatted for import into an [Obsidian](https://obsidian.md/) vault.

It uses Obsidian markdown and [LaTeX](https://en.wikipedia.org/wiki/LaTeX) features to approximate the original print as much as possible.

![note italicized words, section headers, and special treatment of YHWH](doc/example.png)

## Features

1. One chapter per note, one verse per line.
1. Navigational links: *Previous/Next* chapter links.
1. _italicized_ words to indicate translation additions
1. _YHWH_ formatted LORD as in the original print
1. original print paragraph markings and chapter notes
1. KJV Cambridge
1. Table of Contents Page: `KJV`

## Usage

1. [Download the current release](https://github.com/pmbauer/av-roam/releases/download/c10dc89/av-roam_c10dc89.tar.gz) and extract locally
2. Copy `av` into your obsidian vault.

## Building
```bash
# builds release artifact
make
make build

# run tests
make test

# clean up
make clean
```
