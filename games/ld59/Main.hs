{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Control.Monad (when)
import GHC.Wasm.Prim
import Pixi.Types qualified as Pixi
import Apecs
import PrepECS
import Data.Function (on)
import Safe (maximumMay, minimumByMay)
import Data.Foldable (for_)

-- Export the actual initialization function
foreign export javascript "wasmMain" main :: IO ()

maxLogos :: Int
maxLogos = 10

main :: IO ()
main = do
  -- Initialize PIXI application
  app <- newApp
  app <- initAppInTarget app "black" "#canvas-container"
  appendToTarget "#canvas-container" app
  screen <- getProperty "screen" app
  screen_width <- valAsInt <$> getProperty "width" screen
  screen_height <- valAsInt <$> getProperty "height" screen

  setPropertyKey ["stage", "eventMode"] app (stringAsVal "static")
  setPropertyKey ["stage", "hitArea"] app screen
  appStage <- getProperty "stage" app
  
  let logo_url = "https://haskell.foundation/assets/images/logos/hf-logo-100-alpha.png"
  logoTexture <- loadTexture logo_url
  world <- initWorld
  let click = \(event::JSVal) -> Apecs.runWith world $ do
        liftIO $ consoleLogVal (stringAsVal "HIHIHI")
        x <- liftIO $ getPropertyKey ["global", "x"] event
        y <- liftIO $ getPropertyKey ["global", "y"] event
        sprite <- liftIO $ newSprite logoTexture
        liftIO $ do
          setProperty "eventMode" sprite (stringAsVal "none")
          setSpriteAnchor sprite 0.5
          setProperty "x" sprite x
          setProperty "y" sprite y
          addChild app sprite

        logoEtys <- cfold (\ls l@(Logo{}, _::Entity) -> l : ls) []
        let ns = fmap (\(Logo{..}, _) -> logoSeq) logoEtys
        let n' = maybe 0 succ $ maximumMay ns
        _ <- newEntity Logo {logoSeq = n', logoSprite = sprite}
        when (length logoEtys > maxLogos - 1) $
          for_ (minimumByMay (compare `on` logoSeq . fst) logoEtys) $ \(Logo{..}, ety) -> do
            liftIO $ destroySprite logoSprite
            destroy ety (Proxy @Logo)
        pure ()
  addEventListener "pointerdown" appStage =<< jsFuncFromHs_ click
