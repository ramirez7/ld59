{-# LANGUAGE RecordWildCards #-}
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

tileSize :: Int
tileSize = 32

data Art = Art
  { artHeadSprite :: Pixi.Sprite
  , artTailTexture :: Pixi.Texture
  }

newArt ::  IO Art
newArt = do
  artHeadSprite <- loadTexture "./h.png" >>= newSprite
  artTailTexture <- loadTexture "./t.png"
  pure Art{..}


test :: System World ()
test = cmapM_ $ \CurrentDir{} -> pure ()

syncSnakeArt :: System World ()
syncSnakeArt = cmapM_ $ \(Snake{..} :: Snake) -> liftIO $ do
  for_ snakeHead $ \Head{..} -> do
    setProperty "x" headSprite (intAsVal $ snakeHeadPos snakeHead ^. _x)
    setProperty "y" headSprite (intAsVal $ snakeHeadPos snakeHead ^. _y)   
