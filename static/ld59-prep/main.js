import "./pixi-export.js"

import wasm_init from "./wasm-init.js"
wasm_init({
    onWasmUnsupported: () => {
        console.log("onWasmUnsupported");
    },
    onWasmLoadSuccess: () => {
        console.log("onWasmLoadSuccess");
    },
    onWasmLoadFailed: (error) => {
        console.error('Error loading WASM:', error);
        console.error('Error stack:', error.stack);
    }
});
