#!/bin/bash

show_help() {
    echo "Usage: $0 [OPTIONS] search_string filename"
    echo "Options:"
    echo "  -n        Show line numbers with output lines"
    echo "  -v        Invert match (show lines that do not match)"
    echo "  --help    Show this help message"
}

if [[ $# -lt 2 ]]; then
    echo "Error: Not enough arguments."
    show_help
    exit 1
fi

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

options=""
search=""
file=""

if [[ "$1" == -* ]]; then
    options="$1"
    search="$2"
    file="$3"
else
    search="$1"
    file="$2"
fi

if [[ -z "$search" || -z "$file" ]]; then
    echo "Error: Missing search string or filename."
    show_help
    exit 1
fi

if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

linenumber=0
while IFS= read -r line; do
    linenumber=$((linenumber + 1))
    if echo "$line" | grep -iq "$search"; then
        match=true
    else
        match=false
    fi

    if [[ "$options" == *v* ]]; then
        match=$(! $match && echo true || echo false)
    fi

    if [[ "$match" == true ]]; then
        if [[ "$options" == *n* ]]; then
            echo "${linenumber}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
