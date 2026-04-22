{-# LANGUAGE MultilineStrings #-}
module LD59.Jfxr.JSFFI where

import GHC.Wasm.Prim

newtype Clip = Clip JSVal

foreign import javascript safe "newClip($1)"
  newClip :: JSString -> IO Clip

newtype AudioContext = AudioContext JSVal
foreign import javascript unsafe "new AudioContext()"
  newAudioContext :: IO AudioContext

foreign import javascript unsafe
  """
  let context = $1
  let clip = $2
  var buffer = context.createBuffer(1, clip.array.length, clip.sampleRate);
  buffer.getChannelData(0).set(clip.toFloat32Array());
  context.resume().then(function() {
    var source = context.createBufferSource();
    source.buffer = buffer;
    // NOTE: You have to connect here! The jfxr example doesn't do this.
    source.connect(context.destination);
    source.start(0);
  });
  """
  playClip :: AudioContext -> Clip -> IO ()
