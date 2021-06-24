#!/bin/bash

cd ${GITHUB_WORKSPACE}

git diff --name-only origin/master | while read inputfile; do
    # Parse filepath
    filename="${inputfile##*/}"                      # Strip longest match of */ from start
    dir="${inputfile:0:${#intputfile} - ${#filename}}" # Substring from 0 thru pos of filename
    base="${filename%.[^.]*}"                       # Strip shortest match of . plus at least one non-dot char from end
    ext="${filename:${#base} + 1}"                  # Substring from len of base thru end
    if [[ -z "$base" && -n "$ext" ]]; then          # If we have an extension and no base, it's really the base
        base=".$ext"
        ext=""
    fi
    # Check if we have an extension, if we do lets compare
    if [ -n "$ext" ]; then
        # Do we have a perl extension?
        if [ -n "$( echo "$ext" | grep -P '^(cgi|pm|pl)$' )" ]; then
            # We do, send it
            echo "$inputfile"
            continue
        fi
    else
        # We don't have an extension, Check for a perl script
        if [ -n "$( file $inputfile | grep Perl )" ]; then
            # We have one, echo the file
            echo "$inputfile"
            continue
        fi
    fi
done | xargs scripts/bin/pt
