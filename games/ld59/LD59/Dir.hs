{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE NegativeLiterals #-}
module LD59.Dir where

import Linear.V2

data Dir = UP | DOWN | LEFT | RIGHT
  deriving stock (Show)

dirV2 :: Dir -> V2 Int
dirV2 = \case
  UP -> V2 0 -1
  DOWN -> V2 0 1
  LEFT -> V2 -1 0
  RIGHT -> V2 1 0

