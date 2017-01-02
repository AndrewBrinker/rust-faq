#!/usr/bin/env bash

FAQ="FAQ.md"

SECTIONS=(
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
)

rm -f "${FAQ}"

for i in "${SECTIONS[@]}"; do
    filename="faq/${i}.md"
    cat "${filename}" >> "${FAQ}"
done

