{-# LANGUAGE RecordWildCards #-}
module LD59.Init where

import LD59.World
import LD59.Snake
import LD59.Dir
import LD59.Draw
import Pixi.Types qualified as Pixi
import Apecs
import Lib
import Linear.V2
import Data.Foldable (for_)
import LD59.Wave
import Data.Traversable (for)

newFood :: Pixi.Application -> Art -> Wave -> V2 Int -> System World ()
newFood app art tailWave p = do
  tailSprite <- liftIO $ newSprite (artTailTexture art)
  liftIO $ waveSpriteTint tailWave tailSprite
  liftIO $ addChild app tailSprite
  liftIO $ setSpritePos tailSprite p
  newEntity_ $ Food Tail{..} p

initGame :: Pixi.Application -> Art -> System World ()
initGame app art = do
  hardcodedTail <- for [minBound..] $ \tailWave -> do
    tailSprite <- liftIO $ newSprite (artTailTexture art)
    liftIO $ waveSpriteTint tailWave tailSprite
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
  newFood app art TRI (V2 10 10)


cleanupSnakeTail :: System World ()
cleanupSnakeTail = cmapM_ $ \(Snake{..}::Snake) -> for_ snakeTail $ \Tail{..} -> liftIO $ destroySprite tailSprite

cleanupFood :: System World ()
cleanupFood = cmapM $ \Food{..} -> do
  liftIO $ destroySprite (tailSprite foodStuff)
  pure (Nothing :: Maybe Food)
  
