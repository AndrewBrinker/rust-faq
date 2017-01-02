#!/usr/bin/env bash

FAQ="FAQ.md"

SECTIONS=(
    header
    intro
    table-of-contents
    project
    performance
    syntax
    numerics
    strings
    collections
    ownership
    lifetimes
    generics
    input-output
    error-handling
    concurrency
    macros
    debugging
    low-level
    cross-platform
    modules-and-crates
    libraries
    design-patterns
    other-languages
    documentation
    links
)

rm -f "${FAQ}"

for i in "${SECTIONS[@]}"; do
    file="faq/${i}.md"
    echo "Copying ${file}"
    cat "${file}" >> "${FAQ}"
done

