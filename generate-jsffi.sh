#!/bin/bash

# Script to generate ghc_wasm_jsffi.js from the compiled wasm file
# Usage: ./generate-jsffi.sh [exe-name]
if [ -z "$1" ]; then
    echo "No exe-name provided"
    echo "Usage: ./generate-jsffi.sh [exe-name]"
    exit 1
fi

EXE="$1"
WASM_FILE=$(fd -I "$EXE".wasm dist-newstyle | head -n1)
OUTPUT_FILE="$EXE"_ghc_wasm_jsffi.js

# Check if wasm32-wasi-ghc is available
if ! command -v wasm32-wasi-ghc &> /dev/null; then
    echo "Error: wasm32-wasi-ghc not found in PATH"
    echo "Please ensure the GHC wasm cross compiler is installed and in your PATH"
    exit 1
fi

# Get the libdir and run post-link.mjs
LIBDIR=$(wasm32-wasi-ghc --print-libdir)
POST_LINK="$LIBDIR/post-link.mjs"

if [ ! -f "$POST_LINK" ]; then
    echo "Error: post-link.mjs not found at $POST_LINK"
    exit 1
fi

echo "Generating $OUTPUT_FILE from $WASM_FILE..."
node "$POST_LINK" -i "$WASM_FILE" -o "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Successfully generated $OUTPUT_FILE"
else
    echo "Error: Failed to generate $OUTPUT_FILE"
    exit 1
fi
