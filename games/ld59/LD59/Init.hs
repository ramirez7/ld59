{-# LANGUAGE RecordWildCards #-}
module LD59.Init where

import LD59.World
import LD59.Snake
import LD59.Dir
import LD59.Draw
import Pixi.Types qualified as Pixi
import Apecs
import Control.Monad (replicateM)
import Lib
import Linear.V2
import Data.Foldable (for_)

newFood :: Pixi.Application -> Art -> V2 Int -> System World ()
newFood app art p = do
  tailSprite <- liftIO $ newSprite (artTailTexture art)
  liftIO $ addChild app tailSprite
  liftIO $ setSpritePos tailSprite p
  newEntity_ $ Food Tail{..} (V2 10 10)

initGame :: Pixi.Application -> Art -> System World ()
initGame app art = do
  hardcodedTail <- replicateM 5 $ do
    tailSprite <- liftIO $ newSprite (artTailTexture art)
    liftIO $ addChild app tailSprite
    let snakeTailVal = Tail{..}
    let snakeTailDir = RIGHT
    pure SnakeTailSeg{..}
  let initSnake = Snake
        { snakeHead = SnakeHead
          { snakeHeadVal = Head { headSprite = artHeadSprite art }
          , snakeHeadPos = V2 5 5
          , snakeHeadDir = RIGHT
          }
        , snakeTail = SnakeTail hardcodedTail
        , snakeStomachDir = RIGHT
        }
  newEntity_ (CurrentDir RIGHT, initSnake)
  newEntity_ Dead
  newFood app art (V2 10 10)


cleanupSnakeTail :: System World ()
cleanupSnakeTail = cmapM_ $ \(Snake{..}::Snake) -> for_ snakeTail $ \Tail{..} -> liftIO $ destroySprite tailSprite
  
