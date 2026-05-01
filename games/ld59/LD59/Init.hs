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
import LD59.Env
import LD59.Art


newFood :: HasEnv => Wave -> V2 Int -> System World ()
newFood tailWave p = openEnv $ \Env{..} -> do
  tailSprite <- liftIO $ newSprite (waveSpriteArt envArt tailWave)
  liftIO $ setSpritePos tailSprite p
  liftIO $ addChild envApp tailSprite
  newEntity_ $ Food Tail{..} p

initGame :: HasEnv => System World ()
initGame = openEnv $ \Env{..} -> do
  initBG
  headSprite <- liftIO $ newSprite (artHeadTexture envArt)
  liftIO $ addChild envApp headSprite
  hardcodedTail <- for [minBound..] $ \tailWave -> do
    tailSprite <- liftIO $ newSprite (waveSpriteArt envArt tailWave)
    liftIO $ addChild envApp tailSprite
    let snakeTailVal = Tail{..}
    let snakeTailDir = RIGHT
    pure SnakeTailSeg{..}
  let initSnake = Snake
        { snakeHead = SnakeHead
          { snakeHeadVal = Head { .. }
          , snakeHeadPos = V2 5 5
          , snakeHeadDir = RIGHT
          }
        , snakeTail = SnakeTail hardcodedTail
        , snakeStomachDir = RIGHT
        }
  newEntity_ (CurrentDir RIGHT, initSnake)
  newEntity_ Dead
  newFood TRI (V2 10 10)

initBG :: HasEnv => System World ()
initBG = openEnv $ \Env{..} -> do
  bgs <- liftIO $ newTilingSprite (artBG envArt) 1000 1000
  liftIO $ setSpritePos bgs (V2 0 0)
  liftIO $ addChild envApp bgs
  Apecs.set global (BG $ Just bgs)

cleanupSnake :: System World ()
cleanupSnake = cmapM_ $ \(Snake{..}::Snake) -> do
  liftIO $ for_ snakeHead  $ \Head{..} -> destroySprite headSprite
  cleanupSnakeTail snakeTail

cleanupSnakeTail :: SnakeTail Tail -> System World ()
cleanupSnakeTail st = liftIO $ for_ st $ \Tail{..} -> destroySprite tailSprite

cleanupFood :: System World ()
cleanupFood = cmapM $ \Food{..} -> do
  liftIO $ destroySprite (tailSprite foodStuff)
  pure (Nothing :: Maybe Food)
  
