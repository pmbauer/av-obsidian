#!/usr/bin/env gawk -f

function acopy(a, b) {
    delete b
    for (k in a) {
        b[k] = a[k]
    }
}

BEGIN {
    delete blocks; delete current; delete previous;
    kjv_toc = "index.md"
    OFS=""
}

# collect :::SET K V state
match($0, /^:::SET\s+(\w+)\s+(.*)/, ord) {
    if (length(blocks) > 0 && length(current)==0) {
        acopy(meta, current)
    }
    meta[ord[1]] = ord[2];
}

# begin TOC
match($0, /^:::SET\s+TESTAMENT\s+(.*)/, ord) {
    print "- [[", ord[1], " Testament]]" >> kjv_toc
}

match($0, /^:::SET\s+BOOK\s+(.*)/, ord) {
    if (ord[1] != "END") {
        meta["BOOKCHAPTER"] = ord[1]
        print "  - [[", ord[1], "]]" >> kjv_toc
    }
}

match($0, /^:::SET\s+CHAPTER\s+(.*)/, ord) {
    chapter = meta["BOOKCHAPTER"] " " ord[1]
    print "    - [[", meta["BOOK"], "#", chapter, "]]" >> kjv_toc
    # push a chapter heading into blocks
    blocks[length(blocks)+1]="### " chapter
}
# end TOC

# flush signal, print book
/^:::SET\s+BOOK\s.*/ {
    if (length(blocks) > 0) {
        of = current["BOOK"] ".md";

        testament_tag = current["TESTAMENT"] " Testament"
        book_tag = current["BOOK"]
        gsub(" ", "_", testament_tag)
        gsub(" ", "_", book_tag)

        # metadata block
        print "---" >> of
        print "tags: Bible, KJV, AV, ", testament_tag, ", ", book_tag  >> of
        if (length(previous)!=0) {
            print "previous: [[", previous["BOOK"], "]]" >> of
        }
        if (meta["BOOK"]!="END") {
            print "next: [[", meta["BOOK"], "]]" >> of
        }
        print "---" >> of

        # navigation block
        print "" >> of
        if (length(previous)!=0) {
            printf "%s", "[[" previous["BOOK"] "|<<" previous["BOOK"] "]]" >> of
        }
        printf " " >> of
        if (meta["BOOK"]!="END") {
            printf "%s", "[[" meta["BOOK"] "|" meta["BOOK"] ">>]]" >> of
        }
        printf "\n\n---\n" >> of

        for (i = 1; i <= length(blocks); i++) {
            print "" >> of
            print blocks[i] >> of
        }
        delete blocks

        acopy(current, previous)
        delete current
    }
}

/^:::.*/ { next }

# push a verse
match($0, /^([0-9]+) .*/, ord) {
    verse = ord[1]
    blocks[length(blocks)+1]=$0 " ^" meta["CHAPTER"] "-" verse
    next
}

# push a note
{ blocks[length(blocks)+1]=$0 }
