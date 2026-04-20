import "./pixi-export.js"

async function newClip(s) {
    return new Promise((resolve, reject) => {
        console.log("newClip() START");
        var synth = new jfxr.Synth(s);
        synth.run(function(clip) {
            console.log("newClip() DONE!");
            console.log(clip === undefined);
            resolve(clip);
        });
    });
}

window.newClip = newClip;

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
