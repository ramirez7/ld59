repl:
    wasm32-wasi-cabal repl --enable-multi-repl all

build:
    wasm32-wasi-cabal build

generate-ffi:
    fd -I test.wasm dist-newstyle --exec ./generate-jsffi.sh {}

serve: build generate-ffi
    fd -I test.wasm dist-newstyle --exec cp {} .
    python -m http.server 8001
