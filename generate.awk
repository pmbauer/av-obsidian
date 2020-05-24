#!/usr/bin/env gawk -f

function acopy(a, b) {
    delete b
    for (k in a) {
        b[k] = a[k]
    }
}

BEGIN {
    delete verses; delete current; delete previous;
    kjv_toc = "KJV.md"
    OFS=""
}

# collect :::SET K V state
match($0, /^:::SET\s+(\w+)\s+(.*)/, ord) {
    if (length(verses) > 0 && length(current)==0) {
        acopy(meta, current)
    }
    meta[ord[1]] = ord[2];
}

# begin TOC
match($0, /^:::SET\s+TESTAMENT\s+(.*)/, ord) {
    print "- [[", ord[1], " Testament]]" >> kjv_toc
}

match($0, /^:::SET\s+BOOK\s+(.*)/, ord) {
    meta["BOOKCHAPTER"] = ord[1]
    print "  - [[", ord[1], "]]" >> kjv_toc
}

match($0, /^:::SET\s+CHAPTER\s+(.*)/, ord) {
    if (ord[1] != "END") {
        print "    - [[", meta["BOOKCHAPTER"], " ", ord[1], "]]" >> kjv_toc
    }
}
# end TOC

# flush signal, print chapter
/^:::SET\s+CHAPTER\s.*/ {
    if (length(verses) > 0) {
        of = current["BOOKCHAPTER"] " " current["CHAPTER"] ".md";
        if (length(previous)!=0) {
            print "- Previous:: [[", previous["BOOKCHAPTER"], " ", previous["CHAPTER"], "]]" >> of
        }
        if (meta["CHAPTER"]!="END") {
            print "- Next:: [[", meta["BOOKCHAPTER"], " ", meta["CHAPTER"], "]]" >> of
        }
        print "- Tags:: #Bible #KJV #[[", current["BOOK"], "]]" >> of
        for (i = 1; i <= length(verses); i++) {
            print "- ", verses[i] >> of
        }
        delete verses

        acopy(current, previous)
        delete current
    }
}

/^:::.*/ { next }

# push a verse
{ verses[length(verses)+1]=$0 }
