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

1. [Download the current release](https://github.com/pmbauer/av-obsidian/releases/download/4c1c0dc/av-obsidian_4c1c0dc.tar.gz) and extract locally
2. Copy `av` into your obsidian vault.

```markdown
### Chapter link
[[Genesis 1]]

### Verse Link
[[Genesis 1#^1]]

### Verse Link With Alias
[[Genesis 1#^4|Genesis 1:4]]

### Verse Transclusion
![[Malachi 4#^5]]
![[Malachi 4#^6]]

### Chapter Transclusion
![[1 John 3#1 John 3]]
```

### Styling
The default Obsidian theme (and most themes) create excess whitespace around transcluded verses.  I use the following CSS in a snippet to make notes with transcluded scriptures look nicer.

```css
.markdown-embed-title { display:none; }
.markdown-preview-view .markdown-embed-content p:first-child { margin: 0 !important;}
.markdown-preview-view .markdown-embed-content p:last-child { margin: 0 !important;}

.markdown-preview-view .markdown-embed, .markdown-embed .markdown-preview-view {
    padding:0px 15px 0px 3px !important;
    margin:0 !important;
    max-height: unset !important;
}

/* the link on the top right corner */
.markdown-embed-link {
    top: 3px !important;
    right: 5px !important;
    padding:0 !important;
    margin:0 !important;
}
```
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
