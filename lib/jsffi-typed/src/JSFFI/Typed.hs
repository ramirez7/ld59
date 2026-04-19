module JSFFI.Typed where

import GHC.Wasm.Prim

newtype JSValOf a = JSValOf JSVal
