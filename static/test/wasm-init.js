import { WASI } from "https://cdn.jsdelivr.net/npm/@runno/wasi@0.7.0/dist/wasi.js";
const { default: ghc_wasm_jsffi } = await import(`./${window.exe}_ghc_wasm_jsffi.js`);

// Check for WebAssembly support
if ("WebAssembly" in window) {
    const wasi = new WASI({
        stdout: (out) => console.log("[wasm stdout]", out),
        stderr: (out) => console.error("[wasm stderr]", out)
    });

    const jsffiExports = {};

    try {
        console.log('Creating JSFFI imports...');
        const jsffiImports = ghc_wasm_jsffi(jsffiExports);
        console.log('JSFFI imports created:', jsffiImports);

        console.log('Getting WASI import object...');
        const wasiImports = wasi.getImportObject();
        console.log('WASI imports:', Object.keys(wasiImports));

        const importObject = Object.assign(
            { ghc_wasm_jsffi: jsffiImports },
            wasiImports
        );
        console.log('Full import object:', Object.keys(importObject));

        console.log('Fetching and instantiating WASM...');
        const result = await WebAssembly.instantiateStreaming(
            fetch(`./${window.exe}.wasm`),
            importObject
        );

        console.log('WASM instantiated, result:', result);
        console.log('Instance:', result.instance);

        if (!result || !result.instance) {
            throw new Error('Failed to get instance from instantiateStreaming');
        }

        const instance = result.instance;
        console.log('Instance exports:', Object.keys(instance.exports));

        // Fill in the jsffiExports with the instance exports for FFI to work
        Object.assign(jsffiExports, instance.exports);
        console.log('JSFFI exports filled:', Object.keys(jsffiExports));

        // Initialize the reactor module (instead of start)
        // wasi.initialize expects the full result object, not just the instance
        console.log('Initializing WASI...');
        wasi.initialize(result, {
            ghc_wasm_jsffi: ghc_wasm_jsffi(jsffiExports)
        });
        console.log('WASI initialized');

        // Call the exported main function
        if (instance.exports.main) {
            console.log('Calling main...');
            instance.exports.main();
        } else {
            console.log('No main export found in test.wasm.');
            console.log('Available exports:', Object.keys(instance.exports));
        }
        // Update status on success
        const statusDiv = document.querySelector('.status');
        if (statusDiv) {
            statusDiv.innerHTML = '<h2>Status</h2><p>✓ WebAssembly module loaded successfully!</p>';
        }
    } catch (error) {
        console.error('Error loading WASM:', error);
        console.error('Error stack:', error.stack);
        const contentDiv = document.querySelector('.content');
        if (contentDiv) {
            contentDiv.innerHTML += `<div class="error">Error loading WASM: ${error.message}\n${error.stack}</div>`;
        }
    }
} else {
    const contentDiv = document.querySelector('.content');
    if (contentDiv) {
        contentDiv.innerHTML += '<div class="error">This browser does not support WebAssembly.</div>';
    }
}
