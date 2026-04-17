module Main where

import Lib
import GHC.Wasm.Prim
import Pixi.Types qualified as Pixi
import Apecs qualified

-- Export the actual initialization function
foreign export javascript "wasmMain" main :: IO ()

main :: IO ()
main = do
  -- Initialize PIXI application
  app <- newApp
  app <- initAppInTarget app "black" "#canvas-container"
  appendToTarget "#canvas-container" app
  screen <- getProperty "screen" app
  screen_width <- valAsInt <$> getProperty "width" screen
  screen_height <- valAsInt <$> getProperty "height" screen

  setPropertyKey["stage", "eventMode"] app (stringAsVal "static")
  setPropertyKey["stage", "hitArea"] screen
  
  let logo_url = "https://haskell.foundation/assets/images/logos/hf-logo-100-alpha.png"
  logoTexture <- loadTexture logo_url

  -- TODO: addEventListener pointerdown
