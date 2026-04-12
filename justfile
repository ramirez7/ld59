repl:
    wasm32-wasi-cabal repl --enable-multi-repl all

build:
    wasm32-wasi-cabal build

serve: build
    fd -I test.wasm dist-newstyle --exec cp {} .
    python -m http.server 8001
