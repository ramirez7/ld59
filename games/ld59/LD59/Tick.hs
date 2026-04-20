module LD59.Tick where

import Apecs
import LD59.World
import LD59.Snake
import Data.Word
import Control.Monad (when)

tickFrame :: System World ()
tickFrame = modify global (succ @Frame)

snakeSpeed :: Word64
snakeSpeed = 60

tickSnake :: System World ()
tickSnake = do
  -- Move Snake
  Frame frame <- get global
  when (frame `mod` snakeSpeed == 0) $ 
    cmap $ \(CurrentDir dir, s::Snake) -> snakeMove dir s
  -- Check for eat
  -- Check for death (tail or edge)
