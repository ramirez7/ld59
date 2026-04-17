import "./pixi-export.js"

const audio_context = new AudioContext();
const master = audio_context.createGain();
master.gain.value = 0.9;
master.connect(audio_context.destination);

window.blip = (freq = 440, ms = 80, vol = 0.2) => {
    const oscillator = audio_context.createOscillator();
    const gain = audio_context.createGain();
    oscillator.type = "square";
    oscillator.frequency.setValueAtTime(freq, audio_context.currentTime);

    const t0 = audio_context.currentTime;
    const attack = 0.002;
    const release = Math.max(0.01, ms / 1000 - attack);
    gain.gain.setValueAtTime(0, t0);
    gain.gain.linearRampToValueAtTime(vol, t0 + attack);
    gain.gain.exponentialRampToValueAtTime(0.0001, t0 + attack + release);

    oscillator.connect(gain).connect(master);
    oscillator.start(t0);
    oscillator.stop(t0 + attack + release + 0.02);
}

import wasm_init from "./wasm-init.js"
wasm_init();
