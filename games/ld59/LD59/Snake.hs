{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE NegativeLiterals #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TypeFamilies #-}

module LD59.Snake where

import Data.Map qualified as Map
import Linear.V2
import Data.Foldable (for_, traverse_)
import Control.Lens (view)
import Apecs

data Dir = UP | DOWN | LEFT | RIGHT
  deriving stock (Show)

dirV2 :: Dir -> V2 Int
dirV2 = \case
  UP -> V2 0 -1
  DOWN -> V2 0 1
  LEFT -> V2 -1 0
  RIGHT -> V2 1 0

data SnakeHead h = SnakeHead
  { snakeHeadVal :: h
  , snakeHeadPos :: V2 Int
  } deriving stock (Show)

data SnakeTail t = SnakeTail
  { snakeTailVal :: t
  , snakeTailPos :: V2 Int
  } deriving stock (Show)

data SnakeF h t = Snake
  { snakeHead :: SnakeHead h
  , snakeTail :: [SnakeTail t]
  , snakeNext :: V2 Int
  } deriving stock (Show)



type Snake = SnakeF () ()
instance Component (SnakeF h t) where type Storage (SnakeF h t) = Unique (SnakeF h t)

exampleSnake :: Snake
exampleSnake = Snake
  { snakeHead = SnakeHead () $ V2 3 3
  , snakeTail = SnakeTail () <$> [V2 3 2, V2 2 2, V2 2 1, V2 2 0]
  , snakeNext = V2 1 0
  }

printSnake2D :: SnakeF h t -> IO ()
printSnake2D Snake{..} = do
  let ps = mconcat
        [[(snakeHeadPos snakeHead, 'H')]
        ,(,'T') . snakeTailPos <$> snakeTail
        ,[(snakeNext ,'N')]
        ]
  let pmap = Map.fromList ps
  let maxX = maximum $ fmap (view _x . fst) ps
  let maxY = maximum $ fmap (view _y . fst) ps
  let coords  = fmap (\y -> fmap (\x -> Map.lookup (V2 x y) pmap) [0..maxX]) [0..maxY]

  putStr "  "
  traverse_ (putStr . (++ " ") . show) [0..maxX]
  putStrLn ""
  
  for_ (zip [0..] coords) $ \(rowNo, row) -> do
    putStr (show rowNo ++ " ")
    for_ row $ \c ->
      putStr $ maybe "_ " (:" ") c
    putStrLn ""
