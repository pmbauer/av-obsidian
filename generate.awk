#!/usr/bin/env gawk -f

function acopy(a, b) {
    delete b
    for (k in a) {
        b[k] = a[k]
    }
}

function target(s) {
    return targetdir s
}

function ensure_exists(path) {
    system("mkdir " path " 2>/dev/null | true")
}

function chapter_link(record, alias) {
    return "[[" target(record["BOOK"]) "/" record["BOOKCHAPTER"] " " record["CHAPTER"] "|" alias "]]"
}


BEGIN {
    OFS=""
    delete blocks; delete current; delete previous;
    targetdir = "av/"
    ensure_exists(targetdir)
    kjv_toc = target("_index.md")

    # print top level TOC front matter
    print "---" >> kjv_toc
    print "tags: index, Bible, KJV" >> kjv_toc
    printf "---\n" >> kjv_toc
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
    print "- [[" ord[1] " Testament]]" >> kjv_toc
}

match($0, /^:::SET\s+BOOK\s+(.*)/, ord) {
    meta["BOOKCHAPTER"] = ord[1]
    print "  - [[" ord[1] "]]" >> kjv_toc
}

match($0, /^:::SET\s+CHAPTER\s+(.*)/, ord) {
    chapter = ord[1]
    if (chapter != "END") {
        if (chapter == "1") {
            book_toc = target(meta["BOOK"]) ".md"
            # print book index header
            testament_tag = meta["TESTAMENT"] " Testament"
            gsub(" ", "_", testament_tag)
            print "---" >> book_toc
            print "title: ", meta["TITLE"] >> book_toc
            print "tags: index, Bible, KJV, ", testament_tag >> book_toc
            printf "---\n\n" >> book_toc
            print "## ", meta["TITLE"] >> book_toc
            printf "\n" >> book_toc
        }
        index_line = "- " chapter_link(meta, meta["BOOKCHAPTER"] " " chapter)
        print "    ", index_line >> kjv_toc
        print index_line >> book_toc
    }
}
# end TOC

# flush signal, print chapter
/^:::SET\s+CHAPTER\s.*/ {
    if (length(blocks) > 0) {
        book_path = target(current["BOOK"])
        ensure_exists("'" book_path "'")
        of = book_path "/" current["BOOKCHAPTER"] " " current["CHAPTER"] ".md";
        testament_tag = current["TESTAMENT"] " Testament"
        gsub(" ", "_", testament_tag)

        # metadata block
        print "---" >> of
        print "tags: Bible, KJV, ", testament_tag >> of
        printf "---\n\n" >> of

        # navigation block
        if (length(previous)!=0) {
            printf "%s ", chapter_link(previous, "<< " previous["BOOKCHAPTER"] " " previous["CHAPTER"]) >> of
        }
        if (meta["CHAPTER"]!="END") {
            if (length(previous)!=0) {
                printf "| " >> of
            }
            printf "%s", chapter_link(meta, meta["BOOKCHAPTER"] " " meta["CHAPTER"] " >>") >> of
        }
        printf "\n\n" >> of

        print "### ", current["BOOKCHAPTER"], " " current["CHAPTER"] >> of

        # chapter and verses
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
    blocks[length(blocks)+1]=$0 " ^" verse
    next
}

# push a note
{ blocks[length(blocks)+1]=$0 }
