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

tileSize :: Int
tileSize = 32

data Art = Art
  { artHeadTexture :: Pixi.Texture
  , artTailTexture :: Pixi.Texture
  , artBG :: Pixi.Texture
  , artBorderTop :: Pixi.Texture
  , artBorderSide :: Pixi.Texture
  , artHeadSide :: Pixi.Texture
  , artHeadUp :: Pixi.Texture
  , artSaw :: Pixi.Texture
  , artSine :: Pixi.Texture
  , artSquare :: Pixi.Texture
  , artTangent :: Pixi.Texture
  , artTriangle :: Pixi.Texture
  , artSinJfxr :: JfxrDef
  }

waveSpriteArt :: Art -> Wave -> Pixi.Texture
waveSpriteArt Art{..} = \case
  TRI -> artTriangle
  SIN -> artSine
  SQUARE -> artSquare
  SAW -> artSaw
  TAN -> artTangent

newArt ::  IO Art
newArt = do
  artHeadTexture <- loadTexture "./h.png"
  artTailTexture <- loadTexture "./t.png"
  artBG <- loadTexture "./BG.png"
  artBorderTop <- loadTexture "./Border Top.png"
  artBorderSide <- loadTexture "./Border side.png"
  artHeadSide <- loadTexture "./Head side.png"
  artHeadUp <- loadTexture "./Head up.png"
  artSaw <- loadTexture "./Saw.png"
  artSine <- loadTexture "./Sine.png"
  artSquare <- loadTexture "./Square.png"
  artTangent <- loadTexture "./Tangent.png"
  artTriangle <- loadTexture "./Triangle.png"
  artSinJfxr <- fetchJfxrDef "./ld59-sin.jfxr"
  pure Art{..}

fetchJfxrDef :: JSString -> IO JfxrDef
fetchJfxrDef path = fetchText path >>= \js -> case Ae.eitherDecode (fromString (fromJSString js)) of
  Right jd -> pure jd
  Left e -> error e

test :: System World ()
test = cmapM_ $ \CurrentDir{} -> pure ()

setSpritePos :: Pixi.Sprite -> V2 Int -> IO ()
setSpritePos s v2 = do
  let v2Screen = v2 ^* tileSize
  setProperty "x" s (intAsVal $ v2Screen ^. _x)
  setProperty "y" s (intAsVal $ v2Screen ^. _y)   

syncSnakeArt :: System World ()
syncSnakeArt = cmapM_ $ \(s@Snake{..} :: Snake) -> liftIO $ do
  for_ snakeHead $ \Head{..} -> setSpritePos headSprite (snakeHeadPos snakeHead)
  for_ (snakeLocateTail s `zip` toList snakeTail) $ \(tailPos, Tail{..}) -> setSpritePos tailSprite tailPos
    
