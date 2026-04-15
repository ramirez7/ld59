repl exe:
    wasm32-wasi-cabal repl --enable-multi-repl lib:test exe:{{exe}}

build exe:
    wasm32-wasi-cabal build exe:{{exe}}

generate-ffi exe:
    ./generate-jsffi.sh {{exe}}

bundle exe: (build exe) (generate-ffi exe)
    mkdir -p ./bundles/{{exe}}
    mv {{exe}}_ghc_wasm_jsffi.js ./bundles/{{exe}}/
    fd -I {{exe}}.wasm dist-newstyle --exec cp {} ./bundles/{{exe}}/
    cp static/{{exe}}/* ./bundles/{{exe}}/

serve exe: (bundle exe)
    python -m http.server 8001 --directory ./bundles/{{exe}}

gild:
    cabal-gild --io=test.cabal
