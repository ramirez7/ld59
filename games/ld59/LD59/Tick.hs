{-# LANGUAGE RecordWildCards #-}
module LD59.Tick where

import Apecs
import LD59.World
import LD59.Snake
import Data.Word
import Control.Monad (when)
import Control.Lens
import Linear.V2

tickFrame :: System World ()
tickFrame = modify global (succ @Frame)

snakeSpeed :: Word64
snakeSpeed = 60

worldBounds :: V2 Int
worldBounds = V2 30 30

tickSnake :: System World ()
tickSnake = do
  -- Move Snake
  Frame frame <- get global
  when (frame `mod` snakeSpeed == 0) $ 
    cmap $ \(CurrentDir dir, s::Snake) -> snakeMove dir s
  -- Check for eat
  -- Check for death (tail or edge)
  cmapM_ $ \(s@Snake{..}::Snake) -> do
    let V2 hx hy = snakeHeadPos snakeHead
    let oob = hx < 0 || hy < 0 || hx > worldBounds ^. _x || hy > worldBounds ^. _y
    let onTail = snakeHeadPos snakeHead `elem` snakeLocateTail s
    when (oob || onTail) $ cmap $ \(_::Screen) -> Dead
