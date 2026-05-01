{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE StrictData #-}
{-# LANGUAGE OverloadedStrings #-}

module LD59.Draw where

import Lib
import Pixi.Types qualified as Pixi
import LD59.World
import LD59.Snake
import Data.Foldable
import Apecs
import Control.Lens
import Linear.V2
import Linear.Vector ((^*))
import LD59.Wave
import LD59.Jfxr.Types
import LD59.Jfxr.JSFFI
import GHC.Wasm.Prim
import Data.Aeson qualified as Ae
import Data.String (fromString)
import LD59.Art
import LD59.Env
import LD59.Dir

tileSize :: Int
tileSize = 32

test :: System World ()
test = cmapM_ $ \CurrentDir{} -> pure ()

setSpritePos :: Pixi.Sprite -> V2 Int -> IO ()
setSpritePos s v2 = do
  let v2Screen = v2 ^* tileSize
  setProperty "x" s (intAsVal $ v2Screen ^. _x)
  setProperty "y" s (intAsVal $ v2Screen ^. _y)   

setSpriteTexture :: Pixi.Sprite -> Pixi.Texture -> IO ()
setSpriteTexture s t = setProperty "texture" s t

syncSnakeArt :: HasEnv => System World ()
syncSnakeArt = openEnv $ \Env{..} -> cmapM_ $ \(s@Snake{..} :: Snake) -> liftIO $ do
  for_ snakeHead $ \Head{..} -> do
    let headTex = case snakeHeadDir snakeHead of
          UP -> artHeadUp envArt
          DOWN -> artHeadUp envArt
          LEFT -> artHeadSide envArt
          RIGHT -> artHeadSide envArt
    setSpriteTexture headSprite headTex
    setSpritePos headSprite (snakeHeadPos snakeHead)
  for_ (snakeLocateTail s `zip` toList snakeTail) $ \(tailPos, Tail{..}) -> setSpritePos tailSprite tailPos
    
