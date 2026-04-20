{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}
module LD59.Draw where

import Lib
import Pixi.Types qualified as Pixi
import LD59.World
import Apecs

tileSize :: Int
tileSize = 32

data Art = Art
  { artHeadSprite :: Pixi.Sprite
  , artTailTexture :: Pixi.Texture
  }

newArt :: IO Art
newArt = do
  artHeadSprite <- loadTexture "./h.png" >>= newSprite
  artTailTexture <- loadTexture "./t.png"
  pure Art{..}

syncSnakeArt :: System World ()
syncSnakeArt = pure ()
