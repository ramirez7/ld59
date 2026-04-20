{-# LANGUAGE RecordWildCards #-}
module LD59.Tick where

import Apecs
import LD59.World
import LD59.Snake
import Data.Word
import Control.Monad (when)
import Control.Lens
import Linear.V2
import Lib

tickFrame :: System World ()
tickFrame = modify global (succ @Frame)

data Rate = Rate
  { ratePeriod :: Word64
  , rateOffset :: Word64
  }
snakeRate :: Rate
snakeRate = Rate 60 0

spawnPeriod :: Rate
spawnPeriod = Rate (5 * 60) 27

worldBounds :: V2 Int
worldBounds = V2 30 30

everyFrame :: Rate -> System World () -> System World ()
everyFrame Rate{..} k = do
  Frame frame <- get global
  when (frame `mod` ratePeriod == rateOffset) k

tickFoodSpawn :: System World ()
tickFoodSpawn = pure ()
  
tickSnake :: System World ()
tickSnake = everyFrame snakeRate $ do
  cmap $ \(CurrentDir dir, s::Snake) -> snakeMove dir s
  -- TODO: Check for eat
  cmapM_ $ \(Food{..}, foodEty) ->
    cmapM_ $ \(s@Snake{..}::Snake, snakeEty) ->
      when (snakeHeadPos snakeHead == foodPos) $ do
        Apecs.set snakeEty $ snakeEat id foodStuff s
        destroy foodEty (Proxy @Food)
  -- Check for death (tail or edge)
  cmapM_ $ \(s@Snake{..}::Snake) -> do
    let V2 hx hy = snakeHeadPos snakeHead
    let oob = hx < 0 || hy < 0 || hx > worldBounds ^. _x || hy > worldBounds ^. _y
    let onTail = snakeHeadPos snakeHead `elem` snakeLocateTail s
    when (oob || onTail) $ cmap $ \(_::Screen) -> Dead

randomFromList :: [a] -> IO a
randomFromList [] = error "randomFromList ERROR: empty list"
randomFromList xs = do
  n <- jsRandom
  pure $ xs !! floor (fromIntegral (length xs) * n)
